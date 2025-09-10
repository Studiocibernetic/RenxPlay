-- Schema for Renxplay application
-- MySQL 8.0+ with utf8mb4

SET NAMES utf8mb4;
SET time_zone = '+00:00';

-- If you want to create the database explicitly, uncomment and adjust:
-- CREATE DATABASE IF NOT EXISTS `u111823599_RenxplayGames` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE `u111823599_RenxplayGames`;

-- =========================
-- Users
-- =========================
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `role` ENUM('USER','ADMIN','SUPER_ADMIN','DEV') NOT NULL DEFAULT 'USER',
  `status` ENUM('active','inactive','banned') NOT NULL DEFAULT 'active',
  `created_by` INT UNSIGNED DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_users_username` (`username`),
  UNIQUE KEY `uniq_users_email` (`email`),
  KEY `idx_users_role` (`role`),
  KEY `idx_users_status` (`status`),
  KEY `idx_users_created_by` (`created_by`),
  CONSTRAINT `fk_users_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Games
-- =========================
CREATE TABLE IF NOT EXISTS `games` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `slug` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `cover_image` VARCHAR(255) NOT NULL,
  `language` VARCHAR(50) DEFAULT NULL,
  `version` VARCHAR(50) DEFAULT NULL,
  `engine` VARCHAR(50) DEFAULT NULL,
  `tags` VARCHAR(255) DEFAULT NULL,
  `category` VARCHAR(100) DEFAULT NULL,
  `download_url` VARCHAR(255) DEFAULT NULL,
  `download_url_windows` VARCHAR(255) DEFAULT NULL,
  `download_url_android` VARCHAR(255) DEFAULT NULL,
  `download_url_linux` VARCHAR(255) DEFAULT NULL,
  `download_url_mac` VARCHAR(255) DEFAULT NULL,
  `censored` TINYINT(1) NOT NULL DEFAULT 0,
  `os_windows` TINYINT(1) NOT NULL DEFAULT 0,
  `os_android` TINYINT(1) NOT NULL DEFAULT 0,
  `os_linux` TINYINT(1) NOT NULL DEFAULT 0,
  `os_mac` TINYINT(1) NOT NULL DEFAULT 0,
  `downloads_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `posted_by` INT UNSIGNED NOT NULL,
  `developer_name` VARCHAR(255) DEFAULT NULL,
  `languages_multi` TEXT DEFAULT NULL,
  `updated_at_custom` DATE DEFAULT NULL,
  `released_at_custom` DATE DEFAULT NULL,
  `patreon_url` VARCHAR(255) DEFAULT NULL,
  `discord_url` VARCHAR(255) DEFAULT NULL,
  `subscribestar_url` VARCHAR(255) DEFAULT NULL,
  `itch_url` VARCHAR(255) DEFAULT NULL,
  `kofi_url` VARCHAR(255) DEFAULT NULL,
  `bmc_url` VARCHAR(255) DEFAULT NULL,
  `steam_url` VARCHAR(255) DEFAULT NULL,
  `screenshots` TEXT DEFAULT NULL,
  `status` ENUM('draft','published','archived') NOT NULL DEFAULT 'published',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_games_slug` (`slug`),
  KEY `idx_games_created_at` (`created_at`),
  KEY `idx_games_status` (`status`),
  KEY `idx_games_posted_by` (`posted_by`),
  CONSTRAINT `fk_games_posted_by` FOREIGN KEY (`posted_by`) REFERENCES `users`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- Comments
-- =========================
CREATE TABLE IF NOT EXISTS `comments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `game_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `comment` TEXT NOT NULL,
  `parent_id` INT UNSIGNED DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `edited_at` DATETIME DEFAULT NULL,
  `deleted_at` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_comments_game_id` (`game_id`),
  KEY `idx_comments_user_id` (`user_id`),
  KEY `idx_comments_parent_id` (`parent_id`),
  KEY `idx_comments_deleted_at` (`deleted_at`),
  CONSTRAINT `fk_comments_game` FOREIGN KEY (`game_id`) REFERENCES `games`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_comments_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_comments_parent` FOREIGN KEY (`parent_id`) REFERENCES `comments`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

