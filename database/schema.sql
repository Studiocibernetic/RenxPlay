-- =====================================================
-- RENXPLAY DATABASE SCHEMA
-- Estrutura completa do banco de dados RenxPlay
-- =====================================================

-- Configurações do banco
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

-- =====================================================
-- TABELA USERS - Sistema de usuários e autenticação
-- =====================================================
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
-- TABELA GAMES - Catálogo de jogos
-- =====================================================
CREATE TABLE `games` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `cover_image` varchar(255) NOT NULL,
  `language` varchar(50) DEFAULT 'English',
  `languages_multi` text NULL DEFAULT NULL COMMENT 'JSON array of supported languages',
  `version` varchar(50) DEFAULT 'v1.0',
  `engine` enum('RENPY','UNITY','UNREAL','RPGM','OUTROS','HTML') NOT NULL DEFAULT 'RENPY',
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
-- TABELA COMMENTS - Sistema de comentários
-- =====================================================
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
-- TABELA CATEGORIES - Categorias de jogos
-- =====================================================
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
-- TABELA GAME_CATEGORIES - Relacionamento jogos-categorias
-- =====================================================
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
-- TABELA DOWNLOADS - Log de downloads
-- =====================================================
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
-- TABELA VIEWS - Log de visualizações
-- =====================================================
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
-- TABELA RATINGS - Sistema de avaliações
-- =====================================================
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
-- TABELA FAVORITES - Sistema de favoritos
-- =====================================================
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
-- TABELA SESSIONS - Gerenciamento de sessões
-- =====================================================
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
-- TABELA SETTINGS - Configurações do sistema
-- =====================================================
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
-- TABELA LOGS - Sistema de logs
-- =====================================================
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
-- ÍNDICES ADICIONAIS PARA PERFORMANCE
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
-- TRIGGERS PARA MANTER CONSISTÊNCIA
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

-- Trigger para atualizar contador de comentários
DELIMITER $$
CREATE TRIGGER `update_game_comments_count` 
AFTER INSERT ON `comments`
FOR EACH ROW
BEGIN
    UPDATE `games` 
    SET `comments_count` = (
        SELECT COUNT(*) 
        FROM `comments` 
        WHERE `game_id` = NEW.game_id 
        AND `deleted_at` IS NULL
    ) 
    WHERE `id` = NEW.game_id;
END$$
DELIMITER ;

-- =====================================================
-- VIEWS PARA CONSULTAS COMUNS
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
-- PROCEDURES PARA OPERAÇÕES COMUNS
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
-- CONFIGURAÇÕES FINAIS
-- =====================================================

-- Configurações de charset e collation
ALTER DATABASE `u111823599_RenxplayGames` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Configurações de timezone
SET time_zone = '+00:00';

-- Finalizar transação
COMMIT;

-- =====================================================
-- NOTAS DE IMPLEMENTAÇÃO
-- =====================================================

/*
ESTRUTURA DO BANCO DE DADOS RENXPLAY

Este schema foi criado baseado na análise completa dos arquivos PHP do projeto.
Inclui todas as tabelas necessárias para o funcionamento do sistema:

1. USERS - Sistema de usuários com hierarquia de roles
2. GAMES - Catálogo principal de jogos com todas as funcionalidades
3. COMMENTS - Sistema de comentários com suporte a aninhamento
4. CATEGORIES - Categorização de jogos
5. DOWNLOADS - Log de downloads para estatísticas
6. VIEWS - Log de visualizações
7. RATINGS - Sistema de avaliações
8. FAVORITES - Sistema de favoritos
9. SESSIONS - Gerenciamento de sessões
10. SETTINGS - Configurações do sistema
11. LOGS - Sistema de logs

FUNCIONALIDADES IMPLEMENTADAS:
- Sistema completo de autenticação e autorização
- CRUD completo de jogos com upload de imagens
- Sistema de comentários hierárquico
- Logs de downloads e visualizações
- Sistema de avaliações e favoritos
- Categorização de jogos
- Configurações do sistema
- Triggers para manter consistência dos dados
- Views para consultas otimizadas
- Procedures para manutenção

MELHORIAS IMPLEMENTADAS:
- Índices otimizados para performance
- Chaves estrangeiras para integridade
- Triggers para contadores automáticos
- Views para consultas complexas
- Procedures para manutenção
- Sistema de logs completo
- Configurações flexíveis
*/
