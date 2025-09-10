-- Esquema do banco de dados em Português (MySQL 8+)
-- Codificação: UTF8MB4

-- Tabela de usuários
CREATE TABLE IF NOT EXISTS usuarios (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nome_usuario VARCHAR(80) NOT NULL UNIQUE,
  email VARCHAR(190) NOT NULL UNIQUE,
  senha_hash VARCHAR(255) NOT NULL,
  papel ENUM('DEV','SUPER_ADMIN','ADMIN','USER') NOT NULL DEFAULT 'USER',
  status ENUM('ativo','inativo','banido') NOT NULL DEFAULT 'ativo',
  criado_por BIGINT UNSIGNED NULL,
  criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_papel (papel),
  KEY idx_status (status),
  CONSTRAINT fk_usuarios_criado_por FOREIGN KEY (criado_por) REFERENCES usuarios(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela de jogos
CREATE TABLE IF NOT EXISTS jogos (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  titulo VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,
  descricao MEDIUMTEXT NOT NULL,
  imagem_capa VARCHAR(255) NOT NULL,
  idioma VARCHAR(60) NULL,
  idiomas_multiplos JSON NULL,
  versao VARCHAR(60) NOT NULL DEFAULT 'v1.0',
  motor ENUM('REN\'PY','UNITY','RPG_MAKER','OTHER') NOT NULL DEFAULT 'REN\'PY',
  tags VARCHAR(255) NULL,
  url_download VARCHAR(255) NULL,
  url_download_windows VARCHAR(255) NULL,
  url_download_android VARCHAR(255) NULL,
  url_download_linux VARCHAR(255) NULL,
  url_download_mac VARCHAR(255) NULL,
  censurado TINYINT(1) NOT NULL DEFAULT 0,
  so_windows TINYINT(1) NOT NULL DEFAULT 1,
  so_android TINYINT(1) NOT NULL DEFAULT 0,
  so_linux TINYINT(1) NOT NULL DEFAULT 0,
  so_mac TINYINT(1) NOT NULL DEFAULT 0,
  publicado_por BIGINT UNSIGNED NOT NULL,
  desenvolvedor_nome VARCHAR(255) NULL,
  atualizado_em_personalizado DATE NULL,
  lancado_em_personalizado DATE NULL,
  url_patreon VARCHAR(255) NULL,
  url_discord VARCHAR(255) NULL,
  url_subscribestar VARCHAR(255) NULL,
  url_itch VARCHAR(255) NULL,
  url_kofi VARCHAR(255) NULL,
  url_bmc VARCHAR(255) NULL,
  url_steam VARCHAR(255) NULL,
  capturas JSON NULL,
  categoria VARCHAR(120) NULL,
  downloads_total INT UNSIGNED NOT NULL DEFAULT 0,
  status ENUM('rascunho','publicado','oculto') NOT NULL DEFAULT 'publicado',
  criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_publicado_por (publicado_por),
  KEY idx_status (status),
  KEY idx_criado_em (criado_em),
  FULLTEXT KEY ft_titulo_descricao (titulo, descricao),
  CONSTRAINT fk_jogos_publicado_por FOREIGN KEY (publicado_por) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela de comentários
CREATE TABLE IF NOT EXISTS comentarios (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  jogo_id BIGINT UNSIGNED NOT NULL,
  usuario_id BIGINT UNSIGNED NOT NULL,
  comentario TEXT NOT NULL,
  comentario_pai_id BIGINT UNSIGNED NULL,
  criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  editado_em TIMESTAMP NULL DEFAULT NULL,
  excluido_em TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_jogo_id (jogo_id),
  KEY idx_usuario_id (usuario_id),
  KEY idx_pai (comentario_pai_id),
  CONSTRAINT fk_comentarios_jogo FOREIGN KEY (jogo_id) REFERENCES jogos(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_comentarios_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_comentarios_pai FOREIGN KEY (comentario_pai_id) REFERENCES comentarios(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Views de compatibilidade (mantém o site funcionando enquanto o código migra)
DROP VIEW IF EXISTS users;
CREATE ALGORITHM=MERGE VIEW users AS
SELECT 
  u.id,
  u.nome_usuario AS username,
  u.email,
  u.senha_hash AS password,
  u.papel AS role,
  CASE u.status 
    WHEN 'ativo' THEN 'active'
    WHEN 'inativo' THEN 'inactive'
    WHEN 'banido' THEN 'banned'
    ELSE 'active'
  END AS status,
  u.criado_por AS created_by,
  u.criado_em AS created_at,
  u.atualizado_em AS updated_at
FROM usuarios u;

DROP VIEW IF EXISTS games;
CREATE ALGORITHM=MERGE VIEW games AS
SELECT 
  g.id,
  g.titulo AS title,
  g.slug,
  g.descricao AS description,
  g.imagem_capa AS cover_image,
  g.idioma AS language,
  g.idiomas_multiplos AS languages_multi,
  g.versao AS version,
  g.motor AS engine,
  g.tags,
  g.url_download,
  g.url_download_windows,
  g.url_download_android,
  g.url_download_linux,
  g.url_download_mac,
  g.censurado AS censored,
  g.so_windows AS os_windows,
  g.so_android AS os_android,
  g.so_linux AS os_linux,
  g.so_mac AS os_mac,
  g.publicado_por AS posted_by,
  g.desenvolvedor_nome AS developer_name,
  g.idiomas_multiplos AS languages_multi_dup, -- compat placeholder (não usada diretamente)
  g.atualizado_em_personalizado AS updated_at_custom,
  g.lancado_em_personalizado AS released_at_custom,
  g.url_patreon AS patreon_url,
  g.url_discord AS discord_url,
  g.url_subscribestar AS subscribestar_url,
  g.url_itch AS itch_url,
  g.url_kofi AS kofi_url,
  g.url_bmc AS bmc_url,
  g.url_steam AS steam_url,
  g.capturas AS screenshots,
  g.categoria AS category,
  g.downloads_total AS downloads_count,
  CASE g.status 
    WHEN 'publicado' THEN 'published'
    WHEN 'rascunho' THEN 'draft'
    WHEN 'oculto' THEN 'hidden'
    ELSE 'published'
  END AS status,
  g.criado_em AS created_at,
  g.atualizado_em AS updated_at
FROM jogos g;

DROP VIEW IF EXISTS comments;
CREATE ALGORITHM=MERGE VIEW comments AS
SELECT 
  c.id,
  c.jogo_id AS game_id,
  c.usuario_id AS user_id,
  c.comentario AS comment,
  c.comentario_pai_id AS parent_id,
  c.criado_em AS created_at,
  c.editado_em AS edited_at,
  c.excluido_em AS deleted_at
FROM comentarios c;

-- Observação: ajuste o arquivo config.php para apontar para este esquema em produção.

