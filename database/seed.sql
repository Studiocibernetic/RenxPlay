-- =====================================================
-- RENXPLAY DATABASE SEED
-- Dados iniciais para instalação do sistema
-- =====================================================

-- Configurações do banco
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

-- =====================================================
-- USUÁRIOS ADMINISTRATIVOS INICIAIS
-- =====================================================

-- Usuário Developer (acesso total)
INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `status`, `created_at`, `bio`) VALUES
(1, 'admin', 'admin@renxplay.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'DEV', 'active', NOW(), 'Administrador principal do sistema RenxPlay');

-- Usuário Super Admin (gerenciamento de admins)
INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `status`, `created_at`, `created_by`, `bio`) VALUES
(2, 'superadmin', 'superadmin@renxplay.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'SUPER_ADMIN', 'active', NOW(), 1, 'Super Administrador do sistema');

-- Usuário Admin (gerenciamento de conteúdo)
INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `status`, `created_at`, `created_by`, `bio`) VALUES
(3, 'moderator', 'moderator@renxplay.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ADMIN', 'active', NOW(), 2, 'Moderador de conteúdo');

-- Usuário de teste
INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `status`, `created_at`, `bio`) VALUES
(4, 'testuser', 'test@renxplay.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'USER', 'active', NOW(), 'Usuário de teste');

-- =====================================================
-- CATEGORIAS DE JOGOS
-- =====================================================

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `icon`, `color`, `sort_order`, `is_active`) VALUES
(1, 'Visual Novel', 'visual-novel', 'Jogos de romance e narrativa visual', 'fas fa-book', '#FF6B6B', 1, 1),
(2, 'RPG', 'rpg', 'Jogos de interpretação de personagens', 'fas fa-dice-d20', '#4ECDC4', 2, 1),
(3, 'Simulação', 'simulacao', 'Jogos de simulação de vida', 'fas fa-home', '#45B7D1', 3, 1),
(4, 'Aventura', 'aventura', 'Jogos de aventura e exploração', 'fas fa-map', '#96CEB4', 4, 1),
(5, 'Estratégia', 'estrategia', 'Jogos de estratégia e tática', 'fas fa-chess', '#FFEAA7', 5, 1),
(6, 'Ação', 'acao', 'Jogos de ação e combate', 'fas fa-fist-raised', '#DDA0DD', 6, 1),
(7, 'Puzzle', 'puzzle', 'Jogos de quebra-cabeça e lógica', 'fas fa-puzzle-piece', '#98D8C8', 7, 1),
(8, 'Horror', 'horror', 'Jogos de terror e suspense', 'fas fa-skull', '#2C3E50', 8, 1);

-- =====================================================
-- JOGOS DE EXEMPLO
-- =====================================================

-- Jogo de exemplo 1
INSERT INTO `games` (`id`, `title`, `slug`, `description`, `cover_image`, `language`, `languages_multi`, `version`, `engine`, `tags`, `download_url`, `download_url_windows`, `download_url_android`, `censored`, `os_windows`, `os_android`, `os_linux`, `os_mac`, `posted_by`, `developer_name`, `released_at_custom`, `patreon_url`, `discord_url`, `itch_url`, `screenshots`, `downloads_count`, `views_count`, `status`, `created_at`) VALUES
(1, 'Exemplo Visual Novel', 'exemplo-visual-novel', 'Uma visual novel de exemplo para demonstrar as funcionalidades do sistema. Este jogo apresenta uma história envolvente com múltiplas escolhas e finais diferentes.', 'exemplo_cover.jpg', 'Portuguese', '["Portuguese", "English"]', 'v1.0', 'RENPY', 'Adult,Visual Novel,Romance', 'https://example.com/download', 'https://example.com/windows', 'https://example.com/android', 0, 1, 1, 0, 0, 1, 'Desenvolvedor Exemplo', '2024-01-15', 'https://patreon.com/exemplo', 'https://discord.gg/exemplo', 'https://exemplo.itch.io/game', '["screenshot1.jpg", "screenshot2.jpg"]', 150, 500, 'published', NOW());

-- Jogo de exemplo 2
INSERT INTO `games` (`id`, `title`, `slug`, `description`, `cover_image`, `language`, `languages_multi`, `version`, `engine`, `tags`, `download_url`, `download_url_windows`, `censored`, `os_windows`, `os_android`, `os_linux`, `os_mac`, `posted_by`, `developer_name`, `released_at_custom`, `steam_url`, `downloads_count`, `views_count`, `status`, `created_at`) VALUES
(2, 'RPG de Fantasia', 'rpg-fantasia', 'Um RPG de fantasia épico com sistema de combate por turnos, exploração de dungeons e desenvolvimento de personagens. Mergulhe em um mundo mágico repleto de aventuras.', 'rpg_cover.jpg', 'English', '["English", "Portuguese"]', 'v2.1', 'UNITY', 'RPG,Fantasy,Adventure', 'https://example.com/rpg-download', 'https://example.com/rpg-windows', 0, 1, 0, 1, 1, 2, 'Fantasy Studios', '2024-02-20', 'https://store.steampowered.com/app/exemplo', 75, 300, 'published', NOW());

-- Jogo de exemplo 3
INSERT INTO `games` (`id`, `title`, `slug`, `description`, `cover_image`, `language`, `languages_multi`, `version`, `engine`, `tags`, `download_url`, `download_url_windows`, `download_url_android`, `censored`, `os_windows`, `os_android`, `os_linux`, `os_mac`, `posted_by`, `developer_name`, `released_at_custom`, `kofi_url`, `downloads_count`, `views_count`, `status`, `created_at`) VALUES
(3, 'Simulação de Vida', 'simulacao-vida', 'Uma simulação de vida realista onde você pode criar e gerenciar sua própria família, construir uma casa, trabalhar e viver experiências únicas.', 'sim_cover.jpg', 'Portuguese', '["Portuguese"]', 'v1.5', 'RENPY', 'Simulation,Life,Management', 'https://example.com/sim-download', 'https://example.com/sim-windows', 'https://example.com/sim-android', 0, 1, 1, 0, 0, 3, 'Life Games', '2024-03-10', 'https://ko-fi.com/simulacao', 200, 800, 'published', NOW());

-- =====================================================
-- RELACIONAMENTOS JOGOS-CATEGORIAS
-- =====================================================

INSERT INTO `game_categories` (`game_id`, `category_id`) VALUES
(1, 1), -- Visual Novel
(1, 4), -- Aventura
(2, 2), -- RPG
(2, 4), -- Aventura
(3, 3), -- Simulação
(3, 4); -- Aventura

-- =====================================================
-- COMENTÁRIOS DE EXEMPLO
-- =====================================================

INSERT INTO `comments` (`game_id`, `user_id`, `comment`, `created_at`) VALUES
(1, 4, 'Excelente visual novel! A história é muito envolvente e os personagens são bem desenvolvidos.', NOW()),
(1, 2, 'Ótimo jogo para quem gosta do gênero. Recomendo!', NOW()),
(2, 4, 'O sistema de combate é muito bom e a exploração é divertida.', NOW()),
(3, 1, 'Simulação muito realista e detalhada. Parabéns aos desenvolvedores!', NOW());

-- =====================================================
-- AVALIAÇÕES DE EXEMPLO
-- =====================================================

INSERT INTO `ratings` (`game_id`, `user_id`, `rating`, `review`, `created_at`) VALUES
(1, 4, 5, 'Perfeito! História emocionante e gráficos lindos.', NOW()),
(1, 2, 4, 'Muito bom, só faltou mais conteúdo.', NOW()),
(2, 4, 5, 'RPG incrível com muitas horas de diversão.', NOW()),
(3, 1, 4, 'Simulação detalhada e realista.', NOW());

-- =====================================================
-- FAVORITOS DE EXEMPLO
-- =====================================================

INSERT INTO `favorites` (`game_id`, `user_id`, `created_at`) VALUES
(1, 4, NOW()),
(2, 4, NOW()),
(3, 1, NOW()),
(3, 2, NOW());

-- =====================================================
-- CONFIGURAÇÕES DO SISTEMA
-- =====================================================

INSERT INTO `settings` (`key`, `value`, `type`, `description`, `is_public`) VALUES
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
-- LOGS INICIAIS
-- =====================================================

INSERT INTO `logs` (`level`, `message`, `context`, `user_id`, `ip_address`, `created_at`) VALUES
('info', 'Sistema inicializado com sucesso', '{"version": "1.0.0", "environment": "production"}', 1, '127.0.0.1', NOW()),
('info', 'Usuários administrativos criados', '{"admin_count": 3, "user_count": 1}', 1, '127.0.0.1', NOW()),
('info', 'Categorias de jogos criadas', '{"category_count": 8}', 1, '127.0.0.1', NOW()),
('info', 'Jogos de exemplo adicionados', '{"game_count": 3}', 1, '127.0.0.1', NOW()),
('info', 'Configurações do sistema definidas', '{"settings_count": 21}', 1, '127.0.0.1', NOW());

-- =====================================================
-- DADOS DE TESTE ADICIONAIS
-- =====================================================

-- Downloads de exemplo
INSERT INTO `downloads` (`game_id`, `user_id`, `ip_address`, `user_agent`, `platform`, `download_url`, `created_at`) VALUES
(1, 4, '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 'windows', 'https://example.com/windows', NOW()),
(1, NULL, '192.168.1.101', 'Mozilla/5.0 (Android 10; Mobile; rv:68.0) Gecko/68.0 Firefox/68.0', 'android', 'https://example.com/android', NOW()),
(2, 4, '192.168.1.102', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36', 'linux', 'https://example.com/rpg-windows', NOW()),
(3, 1, '192.168.1.103', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36', 'mac', 'https://example.com/sim-windows', NOW());

-- Visualizações de exemplo
INSERT INTO `views` (`game_id`, `user_id`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 4, '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', NOW()),
(1, NULL, '192.168.1.101', 'Mozilla/5.0 (Android 10; Mobile; rv:68.0) Gecko/68.0 Firefox/68.0', NOW()),
(2, 4, '192.168.1.102', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36', NOW()),
(3, 1, '192.168.1.103', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36', NOW());

-- =====================================================
-- ATUALIZAÇÃO DE CONTADORES
-- =====================================================

-- Atualizar contadores de downloads
UPDATE `games` SET `downloads_count` = (
    SELECT COUNT(*) FROM `downloads` WHERE `game_id` = `games`.`id`
);

-- Atualizar contadores de visualizações
UPDATE `games` SET `views_count` = (
    SELECT COUNT(*) FROM `views` WHERE `game_id` = `games`.`id`
);

-- =====================================================
-- CONFIGURAÇÕES FINAIS
-- =====================================================

-- Resetar auto_increment para os próximos registros
ALTER TABLE `users` AUTO_INCREMENT = 5;
ALTER TABLE `categories` AUTO_INCREMENT = 9;
ALTER TABLE `games` AUTO_INCREMENT = 4;
ALTER TABLE `comments` AUTO_INCREMENT = 5;
ALTER TABLE `ratings` AUTO_INCREMENT = 5;
ALTER TABLE `favorites` AUTO_INCREMENT = 5;
ALTER TABLE `settings` AUTO_INCREMENT = 22;
ALTER TABLE `logs` AUTO_INCREMENT = 6;
ALTER TABLE `downloads` AUTO_INCREMENT = 5;
ALTER TABLE `views` AUTO_INCREMENT = 5;

-- Finalizar transação
COMMIT;

-- =====================================================
-- NOTAS DE IMPLEMENTAÇÃO
-- =====================================================

/*
DADOS INICIAIS RENXPLAY

Este arquivo contém todos os dados necessários para uma instalação inicial
do sistema RenxPlay, incluindo:

USUÁRIOS ADMINISTRATIVOS:
- admin (DEV) - Acesso total ao sistema
- superadmin (SUPER_ADMIN) - Gerenciamento de admins
- moderator (ADMIN) - Gerenciamento de conteúdo
- testuser (USER) - Usuário de teste

CATEGORIAS:
- Visual Novel, RPG, Simulação, Aventura, Estratégia, Ação, Puzzle, Horror

JOGOS DE EXEMPLO:
- 3 jogos completos com todas as funcionalidades
- Screenshots, links de download, informações do desenvolvedor
- Relacionamentos com categorias

CONTEÚDO DE EXEMPLO:
- Comentários, avaliações e favoritos
- Logs de downloads e visualizações
- Configurações do sistema

CONFIGURAÇÕES:
- 21 configurações padrão do sistema
- Valores otimizados para produção
- Configurações de segurança e performance

SENHAS PADRÃO:
Todas as senhas são: "password" (hash: $2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi)

IMPORTANTE:
- Altere as senhas padrão após a instalação
- Configure as URLs de exemplo para seus próprios links
- Ajuste as configurações conforme necessário
- Os arquivos de imagem devem ser colocados nas pastas uploads/ correspondentes
*/
