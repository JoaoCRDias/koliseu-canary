# Sistema de Mining Refatorado

Sistema modular de mineração com recompensas baseadas em níveis de habilidade.

## Estrutura do Sistema

```
data-canary/scripts/systems/mining/
├── config.lua          # Configurações centralizadas do sistema
├── rewards.lua         # Sistema de recompensas por tier/level
├── core.lua           # Lógica principal de mineração
├── init.lua           # Inicialização e API pública
└── README.md          # Esta documentação
```

## Arquitetura

### 1. **config.lua**

Centraliza todas as configurações do sistema de mining:

- Action IDs que identificam spots de mineração
- Chances base de sucesso
- Ganho de skill tries
- Mensagens do sistema
- Efeitos visuais

### 2. **rewards.lua**

Sistema de recompensas organizado em **5 tiers** baseados no nível de mining skill:

| Tier | Nível | Nome         | Descrição                                     |
| ---- | ----- | ------------ | --------------------------------------------- |
| 1    | 0-20  | Novice       | Recompensas básicas (moedas e gemas pequenas) |
| 2    | 21-40 | Intermediate | Tier 1 + gemas melhores e cristais básicos    |
| 3    | 41-60 | Advanced     | Tier 1 & 2 + gemas raras e itens especiais    |
| 4    | 61-80 | Expert       | Tier 1-3 + cristais raros e itens elementais  |
| 5    | 81+   | Master       | Todos os tiers + itens lendários              |

#### Sistema de Pesos

Diferente do sistema antigo que normalizava tudo para 100%, o novo sistema usa **pesos relativos**:

```lua
rewards = {
    { weight = 100, itemId = 3035, minCount = 1, maxCount = 2 },  -- Muito comum
    { weight = 50, itemId = 3026, minCount = 1, maxCount = 1 },   -- Comum
    { weight = 10, itemId = 3028, minCount = 1, maxCount = 1 },   -- Incomum
    { weight = 1, itemId = 62464, minCount = 1, maxCount = 1, rare = true }, -- Muito raro
}
```

**Vantagens:**

- Não precisa somar 100%
- Fácil adicionar novos itens sem recalcular
- Balanceamento intuitivo (peso maior = mais comum)
- Sistema calcula automaticamente as probabilidades

### 3. **core.lua**

Implementa a lógica principal:

- Validação de spots de mineração
- Cálculo de chance de sucesso
- Distribuição de skill tries
- Gerenciamento de recompensas
- Broadcast de itens raros

### 4. **init.lua**

Ponto de entrada do sistema:

- Carrega todos os módulos
- Inicializa na ordem correta
- Exporta API pública

## Progressão de Recompensas

### Como Funciona

1. Jogador usa pick em um spot de mineração (Action ID configurado)
2. Sistema identifica o tier baseado no mining skill do jogador
3. Sorteia uma recompensa da pool do tier atual
4. Itens raros ativam broadcast server-wide

### Exemplo de Progressão

**Level 10 (Tier 1):**

- Platinum coins (muito comum)
- Gemas pequenas (comum)

**Level 30 (Tier 2):**

- Todos os itens do Tier 1
- Gemas melhores (violet, red, yellow, green gems)
- Cristais básicos

**Level 50 (Tier 3):**

- Todos os itens dos Tiers 1 e 2
- Itens especiais (gold nugget, rift fragment)
- Quantidade aumentada de platinum coins

**Level 70 (Tier 4):**

- Todos os itens dos Tiers 1-3
- Cristais raros (amber with dragonfly)
- Itens elementais (eldritch equipment)

**Level 90+ (Tier 5):**

- Todas as recompensas anteriores
- Itens lendários (core, reflect potion, tier upgrader)
- Máximas quantidades de todos os itens

## API Pública

```lua
local Mining = dofile("data-koliseu/scripts/systems/mining/init.lua")

-- Tentar minerar um alvo
Mining:attemptMining(player, target, toPosition)

-- Obter informações do tier do jogador
local tier = Mining:getPlayerTier(player)
print(tier.name) -- "Novice", "Intermediate", etc.

-- Verificar se jogador pode receber um item específico
local canGet = Mining:canPlayerGetReward(player, 62464) -- tier upgrader

-- Obter informações de todos os tiers
local tiers = Mining:getAllTiers()
for _, tier in ipairs(tiers) do
    print(string.format("%s (Level %d-%d): %d rewards",
        tier.name, tier.minLevel, tier.maxLevel, tier.rewardCount))
end

-- Obter informações de um tier específico
local expertTier = Mining:getTierInfo(4)
```

## Como Adicionar Novas Recompensas

### 1. Identificar o Tier Apropriado

Escolha o tier baseado no nível mínimo desejado para o item:

- Itens comuns → Tier 1 (Level 0+)
- Itens intermediários → Tier 2 (Level 21+)
- Itens avançados → Tier 3 (Level 41+)
- Itens raros → Tier 4 (Level 61+)
- Itens lendários → Tier 5 (Level 81+)

### 2. Adicionar no rewards.lua

```lua
{
    minLevel = 41,
    maxLevel = 60,
    name = "Advanced",
    rewards = {
        -- Recompensas existentes...

        -- Nova recompensa
        {
            weight = 15,              -- Peso relativo (maior = mais comum)
            itemId = 12345,           -- ID do item
            minCount = 1,             -- Quantidade mínima
            maxCount = 3,             -- Quantidade máxima
            rare = true               -- (Opcional) Ativa broadcast
        },
    }
}
```

### 3. Ajustar Balanceamento

- **Itens comuns:** weight = 50-100
- **Itens incomuns:** weight = 20-50
- **Itens raros:** weight = 5-20
- **Itens muito raros:** weight = 1-5
- **Itens lendários:** weight = 0.1-1

## Configuração no Servidor

### config.lua (arquivo principal do servidor)

```lua
-- Mining System
miningActionId = 5001                    -- Action ID dos spots de mineração
miningBaseSuccessChance = 10             -- Chance base de sucesso (%)
miningChancePerLevel = 0.5               -- Aumento por nível de mining
miningTriesPerAttempt = 100              -- Skill tries por tentativa
miningAttackSpeedTries = 10              -- Attack speed tries (0 para desabilitar)
```

### Marcar Spots de Mineração

No editor de mapa, adicione Action ID `5001` (ou o configurado) nos tiles/items de mineração.

## Migração do Sistema Antigo

### O que mudou:

1. **Código modularizado:** Lógica separada em múltiplos arquivos
2. **Sistema de tiers:** Recompensas desbloqueadas por nível
3. **Pesos relativos:** Não precisa mais somar 100%
4. **API pública:** Fácil integração com outros sistemas

### Compatibilidade

O sistema novo é **100% compatível** com a configuração existente:

- Usa as mesmas config keys
- Mesmos Action IDs
- Mesma lógica de skill tries
- Mesmas mensagens (customizáveis)

### Diferenças de Comportamento

- **Antes:** Todas as recompensas disponíveis desde level 0
- **Agora:** Recompensas progressivas baseadas no nível de mining
- **Antes:** Sistema normalizava tudo para 100%
- **Agora:** Pesos relativos calculados automaticamente

## Testes

### Testar Sistema

1. Iniciar o servidor
2. Criar personagem de teste
3. Usar comando `/attr mining 50` para definir nível de mining
4. Usar pick em um spot com Action ID configurado
5. Verificar logs do servidor para mensagens de inicialização:
   ```
   [MINING CORE] Mining system initialized successfully
   [MINING REWARDS] Tier 'Novice' (Level 0-20): 8 rewards, total weight: X
   [MINING REWARDS] Tier 'Intermediate' (Level 21-40): 16 rewards, total weight: Y
   ...
   ```

### Verificar Tiers

```lua
-- No game, usar /lua para testar
local Mining = dofile("data-canary/scripts/systems/mining/init.lua")
local tier = Mining:getPlayerTier(player)
print(tier.name, tier.minLevel, tier.maxLevel)
```

## Solução de Problemas

### Sistema não carrega

- Verificar se todos os arquivos estão no diretório correto
- Verificar logs do servidor para erros de sintaxe Lua
- Confirmar que config.lua tem `miningActionId` configurado

### Recompensas não aparecem

- Verificar se o Action ID do spot está correto
- Confirmar que o tier tem recompensas configuradas
- Verificar se os item IDs existem no items.xml

### Balanceamento

- Ajustar pesos no rewards.lua
- Modificar `miningChancePerLevel` para progressão mais rápida/lenta
- Ajustar faixas de nível dos tiers

## Exemplos de Uso Avançado

### Sistema de Quest com Mining

```lua
-- Verificar se jogador pode obter item raro
local canGetCore = Mining:canPlayerGetReward(player, 37110)
if canGetCore then
    player:sendTextMessage(MESSAGE_INFO_DESCR, "You are skilled enough to find cores!")
else
    local tier = Mining:getPlayerTier(player)
    player:sendTextMessage(MESSAGE_INFO_DESCR,
        string.format("You need Master tier (81+). Current: %s (%d)",
            tier.name, player:getSkillLevel(SKILL_MINING)))
end
```

### Custom Drop Rates por Evento

```lua
-- Em eventos especiais, pode-se modificar os pesos temporariamente
local rewards = Mining:getRewards()
for _, tier in ipairs(rewards.tiers) do
    for _, reward in ipairs(tier.rewards) do
        if reward.rare then
            reward.weight = reward.weight * 2  -- Dobrar chance de raros
        end
    end
end
```

## Créditos

Sistema desenvolvido para o servidor Baiak Turbo.
Baseado no sistema original de mining do Canary OTServer.

## Licença

Este código segue a mesma licença do Canary OTServer.
