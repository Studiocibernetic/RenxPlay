/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.0.2-MariaDB, for Android (aarch64)
--
-- Host: localhost    Database: u111823599_RenxplayGames
-- ------------------------------------------------------
-- Server version	12.0.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `color` varchar(7) DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `categories` VALUES
(1,'Visual Novel','visual-novel','Jogos de romance e narrativa visual','fas fa-book','#FF6B6B',1,1,'2025-09-07 03:46:28'),
(2,'RPG','rpg','Jogos de interpretação de personagens','fas fa-dice-d20','#4ECDC4',2,1,'2025-09-07 03:46:28'),
(3,'Simulação','simulacao','Jogos de simulação de vida','fas fa-home','#45B7D1',3,1,'2025-09-07 03:46:28'),
(4,'Aventura','aventura','Jogos de aventura e exploração','fas fa-map','#96CEB4',4,1,'2025-09-07 03:46:28'),
(5,'Estratégia','estrategia','Jogos de estratégia e tática','fas fa-chess','#FFEAA7',5,1,'2025-09-07 03:46:28'),
(6,'Ação','acao','Jogos de ação e combate','fas fa-fist-raised','#DDA0DD',6,1,'2025-09-07 03:46:28'),
(7,'Puzzle','puzzle','Jogos de quebra-cabeça e lógica','fas fa-puzzle-piece','#98D8C8',7,1,'2025-09-07 03:46:28'),
(8,'Horror','horror','Jogos de terror e suspense','fas fa-skull','#2C3E50',8,1,'2025-09-07 03:46:28');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `comment` text NOT NULL,
  `parent_id` int(11) DEFAULT NULL COMMENT 'Para comentários aninhados',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
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
  KEY `idx_comments_active` (`game_id`,`deleted_at`),
  KEY `idx_comments_game_id` (`game_id`),
  KEY `idx_comments_user_id` (`user_id`),
  KEY `idx_comments_parent_id` (`parent_id`),
  KEY `idx_comments_created_at` (`created_at`),
  KEY `idx_comments_deleted_at` (`deleted_at`),
  CONSTRAINT `fk_comments_game_id` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_comments_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_comments_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `downloads`
--

DROP TABLE IF EXISTS `downloads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `downloads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL COMMENT 'NULL para downloads anônimos',
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `platform` varchar(50) DEFAULT NULL COMMENT 'windows, android, linux, mac',
  `download_url` varchar(500) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_ip_address` (`ip_address`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_downloads_game_id` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_downloads_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `downloads`
--

LOCK TABLES `downloads` WRITE;
/*!40000 ALTER TABLE `downloads` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `downloads` ENABLE KEYS */;
UNLOCK TABLES;
commit;

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;

-- /*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_game_downloads_count` 
-- AFTER INSERT ON `downloads`
-- FOR EACH ROW
-- BEGIN
--     UPDATE `games` 
--     SET `downloads_count` = `downloads_count` + 1 
--     WHERE `id` = NEW.game_id;
-- END */;;

DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `game_user_favorite` (`game_id`,`user_id`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_favorites_game_id` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_favorites_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `favorites` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `game_categories`
--

DROP TABLE IF EXISTS `game_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `game_category` (`game_id`,`category_id`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_category_id` (`category_id`),
  CONSTRAINT `fk_game_categories_category_id` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_game_categories_game_id` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_categories`
--

LOCK TABLES `game_categories` WRITE;
/*!40000 ALTER TABLE `game_categories` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `game_categories` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Temporary table structure for view `game_stats`
--

DROP TABLE IF EXISTS `game_stats`;
/*!50001 DROP VIEW IF EXISTS `game_stats`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;

-- /*!50001 CREATE VIEW `game_stats` AS SELECT
--  1 AS `id`,
--  1 AS `title`,
--  1 AS `slug`,
--  1 AS `downloads_count`,
--  1 AS `views_count`,
--  1 AS `created_at`,
--  1 AS `author`,
--  1 AS `avg_rating`,
--  1 AS `total_ratings`,
--  1 AS `total_favorites`,
--  1 AS `total_comments` */;

SET character_set_client = @saved_cs_client;

--
-- Table structure for table `games`
--

DROP TABLE IF EXISTS `games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `games` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `cover_image` varchar(255) NOT NULL,
  `language` varchar(50) DEFAULT 'English',
  `languages_multi` text DEFAULT NULL COMMENT 'JSON array of supported languages',
  `version` varchar(50) DEFAULT 'v1.0',
  `engine` enum('REN''PY','UNITY','RPG_MAKER','OTHER') NOT NULL DEFAULT 'REN''PY',
  `tags` text DEFAULT NULL,
  `download_url` varchar(500) DEFAULT NULL,
  `download_url_windows` varchar(500) DEFAULT NULL,
  `download_url_android` varchar(500) DEFAULT NULL,
  `download_url_linux` varchar(500) DEFAULT NULL,
  `download_url_mac` varchar(500) DEFAULT NULL,
  `censored` tinyint(1) NOT NULL DEFAULT 0,
  `os_windows` tinyint(1) NOT NULL DEFAULT 1,
  `os_android` tinyint(1) NOT NULL DEFAULT 0,
  `os_linux` tinyint(1) NOT NULL DEFAULT 0,
  `os_mac` tinyint(1) NOT NULL DEFAULT 0,
  `posted_by` int(11) NOT NULL,
  `developer_name` varchar(255) DEFAULT NULL,
  `updated_at_custom` date DEFAULT NULL,
  `released_at_custom` date DEFAULT NULL,
  `patreon_url` varchar(500) DEFAULT NULL,
  `discord_url` varchar(500) DEFAULT NULL,
  `subscribestar_url` varchar(500) DEFAULT NULL,
  `itch_url` varchar(500) DEFAULT NULL,
  `kofi_url` varchar(500) DEFAULT NULL,
  `bmc_url` varchar(500) DEFAULT NULL,
  `steam_url` varchar(500) DEFAULT NULL,
  `screenshots` text DEFAULT NULL COMMENT 'JSON array of screenshot filenames',
  `downloads_count` int(11) NOT NULL DEFAULT 0,
  `views_count` int(11) NOT NULL DEFAULT 0,
  `status` enum('draft','published','hidden','deleted') NOT NULL DEFAULT 'published',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `idx_posted_by` (`posted_by`),
  KEY `idx_status` (`status`),
  KEY `idx_engine` (`engine`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_downloads_count` (`downloads_count`),
  KEY `idx_games_title_search` (`title`),
  KEY `idx_games_description_search` (`description`(255)),
  KEY `idx_games_tags_search` (`tags`(255)),
  KEY `idx_games_stats` (`status`,`created_at`,`downloads_count`),
  KEY `idx_games_status` (`status`),
  KEY `idx_games_engine` (`engine`),
  KEY `idx_games_created_at` (`created_at`),
  KEY `idx_games_downloads_count` (`downloads_count`),
  KEY `idx_games_posted_by` (`posted_by`),
  CONSTRAINT `fk_games_posted_by` FOREIGN KEY (`posted_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `games`
--

LOCK TABLES `games` WRITE;
/*!40000 ALTER TABLE `games` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `games` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level` enum('debug','info','warning','error','critical') NOT NULL DEFAULT 'info',
  `message` text NOT NULL,
  `context` text DEFAULT NULL COMMENT 'JSON context data',
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_level` (`level`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `ratings`
--

DROP TABLE IF EXISTS `ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` tinyint(1) NOT NULL COMMENT '1-5 stars',
  `review` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `game_user_rating` (`game_id`,`user_id`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_rating` (`rating`),
  CONSTRAINT `fk_ratings_game_id` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ratings_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ratings`
--

LOCK TABLES `ratings` WRITE;
/*!40000 ALTER TABLE `ratings` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `ratings` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(128) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `data` text DEFAULT NULL,
  `last_activity` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_last_activity` (`last_activity`),
  CONSTRAINT `fk_sessions_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(100) NOT NULL,
  `value` text DEFAULT NULL,
  `type` enum('string','integer','boolean','json') NOT NULL DEFAULT 'string',
  `description` text DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`),
  KEY `idx_is_public` (`is_public`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `settings` VALUES
(1,'site_name','RenxPlay','string','Nome do site',1,'2025-09-07 03:46:28',NULL),
(2,'site_description','A melhor plataforma de jogos adultos','string','Descrição do site',1,'2025-09-07 03:46:28',NULL),
(3,'site_keywords','jogos,adultos,visual novel,renpy','string','Palavras-chave do site',1,'2025-09-07 03:46:28',NULL),
(4,'posts_per_page','10','integer','Número de jogos por página',1,'2025-09-07 03:46:28',NULL),
(5,'max_upload_size','10485760','integer','Tamanho máximo de upload em bytes',0,'2025-09-07 03:46:28',NULL),
(6,'max_screenshots','30','integer','Número máximo de screenshots por jogo',0,'2025-09-07 03:46:28',NULL),
(7,'min_password_length','6','integer','Comprimento mínimo da senha',0,'2025-09-07 03:46:28',NULL),
(8,'allow_registration','true','boolean','Permitir registro de novos usuários',1,'2025-09-07 03:46:28',NULL),
(9,'require_email_verification','false','boolean','Exigir verificação de email',0,'2025-09-07 03:46:28',NULL),
(10,'maintenance_mode','false','boolean','Modo de manutenção',0,'2025-09-07 03:46:28',NULL),
(11,'theme_default','light','string','Tema padrão do site',1,'2025-09-07 03:46:28',NULL),
(12,'language_default','pt-BR','string','Idioma padrão do site',1,'2025-09-07 03:46:28',NULL),
(13,'timezone_default','America/Sao_Paulo','string','Fuso horário padrão',1,'2025-09-07 03:46:28',NULL),
(14,'contact_email','contato@renxplay.com','string','Email de contato',1,'2025-09-07 03:46:28',NULL),
(15,'social_discord','https://discord.gg/renxplay','string','Link do Discord',1,'2025-09-07 03:46:28',NULL),
(16,'social_twitter','https://twitter.com/renxplay','string','Link do Twitter',1,'2025-09-07 03:46:28',NULL),
(17,'social_youtube','https://youtube.com/renxplay','string','Link do YouTube',1,'2025-09-07 03:46:28',NULL),
(18,'analytics_google','','string','ID do Google Analytics',0,'2025-09-07 03:46:28',NULL),
(19,'ads_enabled','false','boolean','Habilitar anúncios',0,'2025-09-07 03:46:28',NULL),
(20,'cache_enabled','true','boolean','Habilitar cache',0,'2025-09-07 03:46:28',NULL),
(21,'cache_duration','3600','integer','Duração do cache em segundos',0,'2025-09-07 03:46:28',NULL);
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Temporary table structure for view `user_stats`
--

DROP TABLE IF EXISTS `user_stats`;
/*!50001 DROP VIEW IF EXISTS `user_stats`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;

-- /*!50001 CREATE VIEW `user_stats` AS SELECT
--  1 AS `id`,
--  1 AS `username`,
--  1 AS `email`,
--  1 AS `role`,
--  1 AS `status`,
--  1 AS `created_at`,
--  1 AS `total_games`,
--  1 AS `total_comments`,
--  1 AS `total_ratings`,
--  1 AS `total_favorites` */;

SET character_set_client = @saved_cs_client;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('USER','ADMIN','SUPER_ADMIN','DEV') NOT NULL DEFAULT 'USER',
  `status` enum('active','inactive','banned') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_status` (`status`),
  KEY `idx_created_by` (`created_by`),
  KEY `idx_users_role` (`role`),
  KEY `idx_users_status` (`status`),
  KEY `idx_users_created_by` (`created_by`),
  CONSTRAINT `fk_users_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `users` VALUES
(1,'admin','admin@renxplay.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','DEV','active','2025-09-07 03:46:28',NULL,NULL,NULL,NULL,'Administrador principal do sistema RenxPlay'),
(2,'superadmin','superadmin@renxplay.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','SUPER_ADMIN','active','2025-09-07 03:46:28',NULL,NULL,NULL,NULL,'Super Administrador do sistema'),
(3,'moderator','moderator@renxplay.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','ADMIN','active','2025-09-07 03:46:28',NULL,NULL,NULL,NULL,'Moderador de conteúdo'),
(4,'testuser','test@renxplay.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','USER','active','2025-09-07 03:46:28',NULL,NULL,NULL,NULL,'Usuário de teste');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `views`
--

DROP TABLE IF EXISTS `views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `views` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL COMMENT 'NULL para visualizações anônimas',
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_game_id` (`game_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_ip_address` (`ip_address`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_views_game_id` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_views_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `views`
--

LOCK TABLES `views` WRITE;
/*!40000 ALTER TABLE `views` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `views` ENABLE KEYS */;
UNLOCK TABLES;
commit;

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;

DELIMITER ;;

-- /*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_game_views_count` 
-- AFTER INSERT ON `views`
-- FOR EACH ROW
-- BEGIN
--     UPDATE `games` 
--     SET `views_count` = `views_count` + 1 
--     WHERE `id` = NEW.game_id;
-- END */;;

DELIMITER ;

/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `game_stats`
--

-- /*!50001 DROP VIEW IF EXISTS `game_stats`*/;
-- /*!50001 SET @saved_cs_client          = @@character_set_client */ ;
-- /*!50001 SET @saved_cs_results         = @@character_set_results */ ;
-- /*!50001 SET @saved_col_connection     = @@collation_connection */ ;
-- /*!50001 SET character_set_client      = utf8mb4 */ ;
-- /*!50001 SET character_set_results     = utf8mb4 */ ;
-- /*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */ ;
-- /*!50001 CREATE ALGORITHM=UNDEFINED */ ;
-- /*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */ ;
-- /*!50001 VIEW `game_stats` AS select 
--     `g`.`id` AS `id`,
--     `g`.`title` AS `title`,
--     `g`.`slug` AS `slug`,
--     `g`.`downloads_count` AS `downloads_count`,
--     `g`.`views_count` AS `views_count`,
--     `g`.`created_at` AS `created_at`,
--     `u`.`username` AS `author`,
--     avg(`r`.`rating`) AS `avg_rating`,
--     count(`r`.`id`) AS `total_ratings`,
--     count(`f`.`id`) AS `total_favorites`,
--     count(`c`.`id`) AS `total_comments`
-- from ((((`games` `g` 
--     left join `users` `u` on(`g`.`posted_by` = `u`.`id`))
--     left join `ratings` `r` on(`g`.`id` = `r`.`game_id`))
--     left join `favorites` `f` on(`g`.`id` = `f`.`game_id`))
--     left join `comments` `c` on(`g`.`id` = `c`.`game_id` and `c`.`deleted_at` is null))
-- where `g`.`status` = 'published'
-- group by `g`.`id`) */ ;
-- /*!50001 SET character_set_client      = @saved_cs_client */ ;
-- /*!50001 SET character_set_results     = @saved_cs_results */ ;
-- /*!50001 SET collation_connection      = @saved_col_connection */ ;

--
-- Final view structure for view `user_stats`
--

-- /*!50001 DROP VIEW IF EXISTS `user_stats`*/ ;
-- /*!50001 SET @saved_cs_client          = @@character_set_client */ ;
-- /*!50001 SET @saved_cs_results         = @@character_set_results */ ;
-- /*!50001 SET @saved_col_connection     = @@collation_connection */ ;
-- /*!50001 SET character_set_client      = utf8mb4 */ ;
-- /*!50001 SET character_set_results     = utf8mb4 */ ;
-- /*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */ ;
-- /*!50001 CREATE ALGORITHM=UNDEFINED */ ;
-- /*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */ ;
-- /*!50001 VIEW `user_stats` AS select 
--     `u`.`id` AS `id`,
--     `u`.`username` AS `username`,
--     `u`.`email` AS `email`,
--     `u`.`role` AS `role`,
--     `u`.`status` AS `status`,
--     `u`.`created_at` AS `created_at`,
--     count(distinct `g`.`id`) AS `total_games`,
--     count(distinct `c`.`id`) AS `total_comments`,
--     count(distinct `r`.`id`) AS `total_ratings`,
--     count(distinct `f`.`id`) AS `total_favorites`
-- from ((((`users` `u` 
--     left join `games` `g` on(`u`.`id` = `g`.`posted_by` and `g`.`status` = 'published'))
--     left join `comments` `c` on(`u`.`id` = `c`.`user_id` and `c`.`deleted_at` is null))
--     left join `ratings` `r` on(`u`.`id` = `r`.`user_id`))
--     left join `favorites` `f` on(`u`.`id` = `f`.`user_id`))
-- group by `u`.`id`) */ ;
-- /*!50001 SET character_set_client      = @saved_cs_client */ ;
-- /*!50001 SET character_set_results     = @saved_cs_results */ ;
-- /*!50001 SET collation_connection      = @saved_col_connection */ ;
-- /*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */ ;

-- /*!40101 SET SQL_MODE=@OLD_SQL_MODE */ ;
-- /*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */ ;
-- /*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */ ;
-- /*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */ ;
-- /*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */ ;
-- /*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */ ;
-- /*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */ ;

-- Dump completed on 2025-09-07 11:21:54
