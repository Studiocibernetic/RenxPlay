-- =====================================================
-- RENXPLAY DATABASE DUMP
-- Backup completo do banco de dados RenxPlay
-- Data: 2024-12-19
-- Versão: 1.0.0
-- =====================================================

-- Configurações do dump
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

-- =====================================================
-- ESTRUTURA DO BANCO
-- =====================================================

-- Criar banco se não existir
CREATE DATABASE IF NOT EXISTS `u111823599_RenxplayGames` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `u111823599_RenxplayGames`;

-- =====================================================
-- TABELA USERS
-- =====================================================

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('USER','ADMIN','SUPER_ADMIN','DEV') NOT NULL DEFAULT 'USER',
  `status` enum('active','inactive','banned') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  `created_by` int(11) NULL DEFAULT NULL,
  `avatar` varchar(255) NULL DEFAULT NULL,
  `bio` text NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_status` (`status`),
  KEY `idx_created_by` (`created_by`),
  CONSTRAINT `fk_users_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABELA GAMES
-- =====================================================

DROP TABLE IF EXISTS `games`;
CREATE TABLE `games` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `cover_image` varchar(255) NOT NULL,
  `language` varchar(50) DEFAULT 'English',
  `languages_multi` text NULL DEFAULT NULL COMMENT 'JSON array of supported languages',
  `version` varchar(50) DEFAULT 'v1.0',
  `engine` enum('REN\'PY','UNITY','RPG_MAKER','OTHER') NOT NULL DEFAULT 'REN\'PY',
  `tags` text NULL DEFAULT NULL,
  `download_url` varchar(500) NULL DEFAULT NULL,
  `download_url_windows` varchar(500) NULL DEFAULT NULL,
  `download_url_android` varchar(500) NULL DEFAULT NULL,
  `download_url_linux` varchar(500) NULL DEFAULT NULL,
  `download_url_mac` varchar(500) NULL DEFAULT NULL,
  `censored` tinyint(1) NOT NULL DEFAULT 0,
  `os_windows` tinyint(1) NOT NULL DEFAULT 1,
  `os_android` tinyint(1) NOT NULL DEFAULT 0,
  `os_linux` tinyint(1) NOT NULL DEFAULT 0,
  `os_mac` tinyint(1) NOT NULL DEFAULT 0,
  `posted_by` int(11) NOT NULL,
  `developer_name` varchar(255) NULL DEFAULT NULL,
  `updated_at_custom` date NULL DEFAULT NULL,
  `released_at_custom` date NULL DEFAULT NULL,
  `patreon_url` varchar(500) NULL DEFAULT NULL,
  `discord_url` varchar(500) NULL DEFAULT NULL,
  `subscribestar_url` varchar(500) NULL DEFAULT NULL,
  `itch_url` varchar(500) NULL DEFAULT NULL,
  `kofi_url` varchar(500) NULL DEFAULT NULL,
  `bmc_url` varchar(500) NULL DEFAULT NULL,
  `steam_url` varchar(500) NULL DEFAULT NULL,
  `screenshots` text NULL DEFAULT NULL COMMENT 'JSON array of screenshot filenames',
  `downloads_count` int(11) NOT NULL DEFAULT 0,
  `views_count` int(11) NOT NULL DEFAULT 0,
  `status` enum('draft','published','hidden','deleted') NOT NULL DEFAULT 'published',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `idx_posted_by` (`posted_by`),
  KEY `idx_status` (`status`),
  KEY `idx_engine` (`engine`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_downloads_count` (`downloads_count`),
  CONSTRAINT `fk_games_posted_by` FOREIGN KEY (`posted_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABELA COMMENTS
-- =====================================================

DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `comment` text NOT NULL,
  `parent_id` int(11) NULL DEFAULT NULL COMMENT 'Para comentários aninhados',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `edited_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `likes_count` int(11) NOT NULL DEFAULT 0,
  `dislikes_count` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_deleted_at` (`deleted_at`),
  CONSTRAINT `fk_comments_game_id` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_comments_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_comments_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABELA CATEGORIES
-- =====================================================

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text NULL DEFAULT NULL,
  `icon` varchar(50) NULL DEFAULT NULL,
  `color` varchar(7) NULL DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABELA GAME_CATEGORIES
-- =====================================================

DROP TABLE IF EXISTS `game_categories`;
CREATE TABLE `game_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `game_category` (`game_id`, `category_id`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_category_id` (`category_id`),
  CONSTRAINT `fk_game_categories_game_id` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_game_categories_category_id` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABELA DOWNLOADS
-- =====================================================

DROP TABLE IF EXISTS `downloads`;
CREATE TABLE `downloads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) NOT NULL,
  `user_id` int(11) NULL DEFAULT NULL COMMENT 'NULL para downloads anônimos',
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text NULL DEFAULT NULL,
  `platform` varchar(50) NULL DEFAULT NULL COMMENT 'windows, android, linux, mac',
  `download_url` varchar(500) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_ip_address` (`ip_address`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_downloads_game_id` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_downloads_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABELA VIEWS
-- =====================================================

DROP TABLE IF EXISTS `views`;
CREATE TABLE `views` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) NOT NULL,
  `user_id` int(11) NULL DEFAULT NULL COMMENT 'NULL para visualizações anônimas',
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_ip_address` (`ip_address`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_views_game_id` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_views_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABELA RATINGS
-- =====================================================

DROP TABLE IF EXISTS `ratings`;
CREATE TABLE `ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` tinyint(1) NOT NULL COMMENT '1-5 stars',
  `review` text NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `game_user_rating` (`game_id`, `user_id`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_rating` (`rating`),
  CONSTRAINT `fk_ratings_game_id` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ratings_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABELA FAVORITES
-- =====================================================

DROP TABLE IF EXISTS `favorites`;
CREATE TABLE `favorites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `game_user_favorite` (`game_id`, `user_id`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_favorites_game_id` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_favorites_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABELA SESSIONS
-- =====================================================

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` varchar(128) NOT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text NULL DEFAULT NULL,
  `data` text NULL DEFAULT NULL,
  `last_activity` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_last_activity` (`last_activity`),
  CONSTRAINT `fk_sessions_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABELA SETTINGS
-- =====================================================

DROP TABLE IF EXISTS `settings`;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(100) NOT NULL,
  `value` text NULL DEFAULT NULL,
  `type` enum('string','integer','boolean','json') NOT NULL DEFAULT 'string',
  `description` text NULL DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`),
  KEY `idx_is_public` (`is_public`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABELA LOGS
-- =====================================================

DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level` enum('debug','info','warning','error','critical') NOT NULL DEFAULT 'info',
  `message` text NOT NULL,
  `context` text NULL DEFAULT NULL COMMENT 'JSON context data',
  `user_id` int(11) NULL DEFAULT NULL,
  `ip_address` varchar(45) NULL DEFAULT NULL,
  `user_agent` text NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_level` (`level`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- ÍNDICES ADICIONAIS
-- =====================================================

-- Índices para busca de jogos
CREATE INDEX `idx_games_title_search` ON `games` (`title`);
CREATE INDEX `idx_games_description_search` ON `games` (`description`(255));
CREATE INDEX `idx_games_tags_search` ON `games` (`tags`(255));

-- Índices para estatísticas
CREATE INDEX `idx_games_stats` ON `games` (`status`, `created_at`, `downloads_count`);

-- Índices para comentários
CREATE INDEX `idx_comments_active` ON `comments` (`game_id`, `deleted_at`);

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Trigger para atualizar contador de downloads
DELIMITER $$
CREATE TRIGGER `update_game_downloads_count` 
AFTER INSERT ON `downloads`
FOR EACH ROW
BEGIN
    UPDATE `games` 
    SET `downloads_count` = `downloads_count` + 1 
    WHERE `id` = NEW.game_id;
END$$
DELIMITER ;

-- Trigger para atualizar contador de visualizações
DELIMITER $$
CREATE TRIGGER `update_game_views_count` 
AFTER INSERT ON `views`
FOR EACH ROW
BEGIN
    UPDATE `games` 
    SET `views_count` = `views_count` + 1 
    WHERE `id` = NEW.game_id;
END$$
DELIMITER ;

-- =====================================================
-- VIEWS
-- =====================================================

-- View para estatísticas de jogos
CREATE VIEW `game_stats` AS
SELECT 
    g.id,
    g.title,
    g.slug,
    g.downloads_count,
    g.views_count,
    g.created_at,
    u.username as author,
    AVG(r.rating) as avg_rating,
    COUNT(r.id) as total_ratings,
    COUNT(f.id) as total_favorites,
    COUNT(c.id) as total_comments
FROM `games` g
LEFT JOIN `users` u ON g.posted_by = u.id
LEFT JOIN `ratings` r ON g.id = r.game_id
LEFT JOIN `favorites` f ON g.id = f.game_id
LEFT JOIN `comments` c ON g.id = c.game_id AND c.deleted_at IS NULL
WHERE g.status = 'published'
GROUP BY g.id;

-- View para usuários com estatísticas
CREATE VIEW `user_stats` AS
SELECT 
    u.id,
    u.username,
    u.email,
    u.role,
    u.status,
    u.created_at,
    COUNT(DISTINCT g.id) as total_games,
    COUNT(DISTINCT c.id) as total_comments,
    COUNT(DISTINCT r.id) as total_ratings,
    COUNT(DISTINCT f.id) as total_favorites
FROM `users` u
LEFT JOIN `games` g ON u.id = g.posted_by AND g.status = 'published'
LEFT JOIN `comments` c ON u.id = c.user_id AND c.deleted_at IS NULL
LEFT JOIN `ratings` r ON u.id = r.user_id
LEFT JOIN `favorites` f ON u.id = f.user_id
GROUP BY u.id;

-- =====================================================
-- PROCEDURES
-- =====================================================

-- Procedure para limpar sessões expiradas
DELIMITER $$
CREATE PROCEDURE `cleanup_expired_sessions`()
BEGIN
    DELETE FROM `sessions` 
    WHERE `last_activity` < DATE_SUB(NOW(), INTERVAL 30 DAY);
END$$
DELIMITER ;

-- Procedure para limpar logs antigos
DELIMITER $$
CREATE PROCEDURE `cleanup_old_logs`()
BEGIN
    DELETE FROM `logs` 
    WHERE `created_at` < DATE_SUB(NOW(), INTERVAL 90 DAY);
END$$
DELIMITER ;

-- =====================================================
-- DADOS DE EXEMPLO (OPCIONAL)
-- =====================================================

-- Inserir dados de exemplo apenas se as tabelas estiverem vazias
-- Usuários administrativos
INSERT IGNORE INTO `users` (`id`, `username`, `email`, `password`, `role`, `status`, `created_at`, `bio`) VALUES
(1, 'admin', 'admin@renxplay.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'DEV', 'active', NOW(), 'Administrador principal do sistema RenxPlay'),
(2, 'superadmin', 'superadmin@renxplay.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'SUPER_ADMIN', 'active', NOW(), 'Super Administrador do sistema'),
(3, 'moderator', 'moderator@renxplay.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ADMIN', 'active', NOW(), 'Moderador de conteúdo'),
(4, 'testuser', 'test@renxplay.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'USER', 'active', NOW(), 'Usuário de teste');

-- Categorias padrão
INSERT IGNORE INTO `categories` (`id`, `name`, `slug`, `description`, `icon`, `color`, `sort_order`, `is_active`) VALUES
(1, 'Visual Novel', 'visual-novel', 'Jogos de romance e narrativa visual', 'fas fa-book', '#FF6B6B', 1, 1),
(2, 'RPG', 'rpg', 'Jogos de interpretação de personagens', 'fas fa-dice-d20', '#4ECDC4', 2, 1),
(3, 'Simulação', 'simulacao', 'Jogos de simulação de vida', 'fas fa-home', '#45B7D1', 3, 1),
(4, 'Aventura', 'aventura', 'Jogos de aventura e exploração', 'fas fa-map', '#96CEB4', 4, 1),
(5, 'Estratégia', 'estrategia', 'Jogos de estratégia e tática', 'fas fa-chess', '#FFEAA7', 5, 1),
(6, 'Ação', 'acao', 'Jogos de ação e combate', 'fas fa-fist-raised', '#DDA0DD', 6, 1),
(7, 'Puzzle', 'puzzle', 'Jogos de quebra-cabeça e lógica', 'fas fa-puzzle-piece', '#98D8C8', 7, 1),
(8, 'Horror', 'horror', 'Jogos de terror e suspense', 'fas fa-skull', '#2C3E50', 8, 1);

-- Configurações do sistema
INSERT IGNORE INTO `settings` (`key`, `value`, `type`, `description`, `is_public`) VALUES
('site_name', 'RenxPlay', 'string', 'Nome do site', 1),
('site_description', 'A melhor plataforma de jogos adultos', 'string', 'Descrição do site', 1),
('site_keywords', 'jogos,adultos,visual novel,renpy', 'string', 'Palavras-chave do site', 1),
('posts_per_page', '10', 'integer', 'Número de jogos por página', 1),
('max_upload_size', '10485760', 'integer', 'Tamanho máximo de upload em bytes', 0),
('max_screenshots', '30', 'integer', 'Número máximo de screenshots por jogo', 0),
('min_password_length', '6', 'integer', 'Comprimento mínimo da senha', 0),
('allow_registration', 'true', 'boolean', 'Permitir registro de novos usuários', 1),
('require_email_verification', 'false', 'boolean', 'Exigir verificação de email', 0),
('maintenance_mode', 'false', 'boolean', 'Modo de manutenção', 0),
('theme_default', 'light', 'string', 'Tema padrão do site', 1),
('language_default', 'pt-BR', 'string', 'Idioma padrão do site', 1),
('timezone_default', 'America/Sao_Paulo', 'string', 'Fuso horário padrão', 1),
('contact_email', 'contato@renxplay.com', 'string', 'Email de contato', 1),
('social_discord', 'https://discord.gg/renxplay', 'string', 'Link do Discord', 1),
('social_twitter', 'https://twitter.com/renxplay', 'string', 'Link do Twitter', 1),
('social_youtube', 'https://youtube.com/renxplay', 'string', 'Link do YouTube', 1),
('analytics_google', '', 'string', 'ID do Google Analytics', 0),
('ads_enabled', 'false', 'boolean', 'Habilitar anúncios', 0),
('cache_enabled', 'true', 'boolean', 'Habilitar cache', 0),
('cache_duration', '3600', 'integer', 'Duração do cache em segundos', 0);

-- =====================================================
-- CONFIGURAÇÕES FINAIS
-- =====================================================

-- Configurações de charset e collation
ALTER DATABASE `u111823599_RenxplayGames` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Configurações de timezone
SET time_zone = '+00:00';

-- Finalizar transação
COMMIT;

-- =====================================================
-- INSTRUÇÕES DE RESTAURAÇÃO
-- =====================================================

/*
INSTRUÇÕES PARA RESTAURAÇÃO DO BANCO DE DADOS

1. BACKUP COMPLETO:
   Este arquivo contém a estrutura completa do banco de dados RenxPlay
   incluindo todas as tabelas, índices, triggers, views e procedures.

2. COMO RESTAURAR:
   mysql -u csmods -pzcbm -h 127.0.0.1 < dump.sql

3. VERIFICAÇÃO:
   Após a restauração, verifique se todas as tabelas foram criadas:
   SHOW TABLES;

4. DADOS INICIAIS:
   O arquivo inclui dados de exemplo básicos para funcionamento inicial.
   Para dados completos, execute também o arquivo seed.sql.

5. CONFIGURAÇÕES:
   - Banco: u111823599_RenxplayGames
   - Usuário: csmods
   - Senha: zcbm
   - Host: 127.0.0.1

6. ESTRUTURA INCLUÍDA:
   - 11 tabelas principais
   - Índices otimizados para performance
   - Triggers para contadores automáticos
   - Views para consultas complexas
   - Procedures para manutenção
   - Chaves estrangeiras para integridade

7. MANUTENÇÃO:
   - Execute cleanup_expired_sessions() mensalmente
   - Execute cleanup_old_logs() trimestralmente
   - Monitore o crescimento das tabelas de logs

8. SEGURANÇA:
   - Altere as senhas padrão após a instalação
   - Configure as URLs de exemplo
   - Ajuste as configurações conforme necessário
   - Mantenha backups regulares

9. PERFORMANCE:
   - Os índices foram otimizados para as consultas mais comuns
   - Use as views para estatísticas complexas
   - Monitore a performance das consultas

10. SUPORTE:
    - Consulte a documentação do projeto
    - Verifique os logs do sistema
    - Mantenha o banco atualizado
*/
