# Battle Pass - Database Migrations

## 1. Modify table structure (remove end_date, use release_date)

```sql
-- Remove old columns and add release_date
ALTER TABLE `battlepass_seasons`
    DROP COLUMN IF EXISTS `start_date`,
    DROP COLUMN IF EXISTS `end_date`,
    ADD COLUMN IF NOT EXISTS `release_date` BIGINT NOT NULL DEFAULT 0;

-- Update release_date to current timestamp if needed
UPDATE `battlepass_seasons` SET `release_date` = UNIX_TIMESTAMP() WHERE `release_date` = 0;
```

## 2. Insert Season 1

```sql
INSERT INTO `battlepass_seasons` (`id`, `name`, `release_date`, `active`, `mount_id`)
VALUES (1, 'Relic Hunter - Season 1', UNIX_TIMESTAMP(), 1, 255)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);
```

## 3. Drop unused rewards table (if exists)

```sql
DROP TABLE IF EXISTS `battlepass_rewards`;
```

## Full migration (run all at once)

```sql
-- Step 1: Modify table structure
ALTER TABLE `battlepass_seasons`
    DROP COLUMN IF EXISTS `start_date`,
    DROP COLUMN IF EXISTS `end_date`,
    ADD COLUMN IF NOT EXISTS `release_date` BIGINT NOT NULL DEFAULT 0;

UPDATE `battlepass_seasons` SET `release_date` = UNIX_TIMESTAMP() WHERE `release_date` = 0;

-- Step 2: Insert Season 1
INSERT INTO `battlepass_seasons` (`id`, `name`, `release_date`, `active`, `mount_id`)
VALUES (1, 'Relic Hunter - Season 1', UNIX_TIMESTAMP(), 1, 255)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Step 3: Drop unused rewards table
DROP TABLE IF EXISTS `battlepass_rewards`;
```

## Season 2: Cosmic Wolfes

```sql
-- Deactivate Season 1
UPDATE `battlepass_seasons` SET `active` = 0 WHERE `id` = 1;

-- Insert Season 2
INSERT INTO `battlepass_seasons` (`id`, `name`, `release_date`, `active`, `mount_id`)
VALUES (2, 'Cosmic Wolfes - Season 2', UNIX_TIMESTAMP(), 1, NULL)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `active` = 1;
```
