# Automacao de backups do banco de dados

## Visao geral

O servidor usa `mysqldump` para gerar backups do banco de dados em `database_backup/<data>/`.
Os backups sao disparados em dois momentos:

1. **Na inicializacao do servidor** (antes de abrir para jogadores) - backup sincrono.
2. **Durante cada `save_interval`** (periodico, ex: a cada 2 horas) - backup assincrono com compressao gzip.

Um comando externo configuravel pode ser executado apos cada backup para enviar o arquivo para armazenamento remoto (ex: Google Cloud Storage).

Backups locais com mais de 7 dias sao automaticamente removidos pelo servidor.

---

## Tutorial: como ativar e testar

### Passo 1 - Verificar pre-requisitos

O `mysqldump` precisa estar instalado no servidor. Teste com:

```bash
mysqldump --version
```

Se nao estiver instalado:

```bash
# Ubuntu/Debian
sudo apt install mysql-client

# CentOS/RHEL
sudo yum install mysql
```

### Passo 2 - Ativar no config.lua

Abra o `config.lua` e altere:

```lua
mysqlDatabaseBackup = true
```

Se voce quiser usar upload automatico para Google Cloud Storage (opcional):

```lua
mysqlDatabaseBackupUploadCommand = "python3 scripts/upload_backup.py --gcs-bucket koliseu-backups --gcs-prefix prod/mysql --gcs-credentials /opt/keys/koliseu-gcs.json"
```

Se nao quiser upload remoto, deixe vazio:

```lua
mysqlDatabaseBackupUploadCommand = ""
```

### Passo 3 - Verificar permissoes do MySQL

O usuario configurado no `config.lua` (`mysqlUser` / `mysqlPass`) precisa ter permissao de `SELECT` e `LOCK TABLES` no banco para o `mysqldump` funcionar. Teste manualmente:

```bash
mysqldump -u koliseuot -p koliseuserver > /dev/null
```

Se funcionar sem erros, esta pronto.

### Passo 4 - Garantir que o save_interval esta ativo

Para backups periodicos (alem do backup na inicializacao), confirme no `config.lua`:

```lua
toggleSaveInterval = true
saveIntervalType = "hour"
saveIntervalTime = 2
```

Isso faz o servidor salvar e fazer backup a cada 2 horas.

### Passo 5 - Iniciar o servidor e testar

1. Inicie o servidor normalmente
2. No log de inicializacao, voce deve ver uma mensagem de backup bem-sucedido
3. Verifique se o arquivo foi criado:

```bash
ls -la database_backup/
```

Deve existir uma pasta com a data de hoje contendo o arquivo `.sql.gz`.

4. Apos o proximo `save_interval`, um novo arquivo `.sql.gz` sera criado na mesma pasta.

### Passo 6 - Testar manualmente via Lua (opcional)

Voce pode forcar um backup a qualquer momento usando a funcao Lua global:

```lua
backupDatabase(true, false)  -- compress=true, async=false (sincrono)
```

Parametros da funcao `backupDatabase(compress, async)`:
- `compress` (boolean, default: true) - se `true`, comprime o arquivo com gzip (.sql.gz)
- `async` (boolean, default: true) - se `true`, roda em thread separada sem travar o servidor

Um mutex atomico impede que dois backups rodem ao mesmo tempo; chamadas concorrentes retornam `false`.

---

## Como funciona internamente

### Fluxo na inicializacao (C++)

1. Antes de abrir para jogadores, `canary_server.cpp` chama `g_database().createDatabaseBackup(true)` se `mysqlDatabaseBackup=true`
2. Isso garante um backup limpo do banco ANTES do servidor aceitar conexoes

### Fluxo periodico (save_interval)

1. O evento `save_interval.lua` roda no intervalo configurado
2. Chama `saveServer()` para salvar os dados
3. Se `mysqlDatabaseBackup` estiver ativo, chama `backupDatabase()` (com compressao, assincrono)
4. Um mutex atomico impede que dois backups rodem ao mesmo tempo

### Fluxo do backup (C++)

1. Cria o diretorio `database_backup/YYYY-MM-DD/`
2. Gera um arquivo temporario `database_backup.cnf` com as credenciais MySQL
3. Executa `mysqldump --defaults-extra-file=database_backup.cnf <banco> > backup.sql`
4. Remove o arquivo de credenciais temporario
5. Se `compress=true`, comprime com gzip nivel 9 e remove o `.sql` original
6. Se `mysqlDatabaseBackupUploadCommand` estiver configurado, executa o comando com o caminho do arquivo
7. Remove backups locais (.gz) com mais de 7 dias

---

## Upload remoto (opcional - Google Cloud Storage)

### Pre-requisitos

```bash
pip install google-cloud-storage
```

### Configuracao

1. Crie uma conta de servico no Google Cloud com permissao `Storage Object Admin` no bucket
2. Baixe o JSON de credenciais e coloque no servidor (ex: `/opt/keys/koliseu-gcs.json`)
3. Configure no `config.lua`:

```lua
mysqlDatabaseBackupUploadCommand = "python3 scripts/upload_backup.py --gcs-bucket koliseu-backups --gcs-prefix prod/mysql --gcs-credentials /opt/keys/koliseu-gcs.json"
```

### Testar o upload manualmente

```bash
python3 scripts/upload_backup.py \
  --gcs-bucket koliseu-backups \
  --gcs-prefix prod/mysql \
  --gcs-credentials /opt/keys/koliseu-gcs.json \
  database_backup/2026-01-27/backup_10-30-00.sql.gz
```

### Argumentos do script

| Argumento | Descricao |
|---|---|
| `backup_file` | Caminho do arquivo (preenchido automaticamente pelo servidor) |
| `--gcs-bucket` | Nome do bucket GCS (obrigatorio) |
| `--gcs-prefix` | Prefixo/pasta dentro do bucket (padrao: `database-backups`) |
| `--gcs-credentials` | Caminho do JSON da conta de servico |
| `--gcs-storage-class` | Classe de armazenamento: STANDARD, NEARLINE, COLDLINE (padrao: STANDARD) |
| `--gcs-kms-key` | Chave KMS para criptografia (opcional) |
| `--delete-local` | Remove o arquivo local apos upload bem-sucedido |
| `--log-level` | Nivel de log: DEBUG, INFO, WARNING, ERROR (padrao: INFO) |

---

## Observacoes

- O servidor limpa automaticamente backups locais (.gz) com mais de 7 dias
- Se voce usar outro servico de upload (S3, SCP, rsync, etc.), basta alterar `mysqlDatabaseBackupUploadCommand` para apontar para seu script. O servidor so precisa que o comando retorne codigo `0` em caso de sucesso
- Sempre teste o comando de upload manualmente antes de ativar em producao
- O backup na inicializacao e **sincrono** (o servidor espera terminar antes de abrir). Isso e intencional para garantir a integridade do backup
- Os backups periodicos sao **assincronos** para nao travar o servidor durante o jogo
