-- Schema do banco de dados em português (MySQL 8+)
-- Charset e engine modernos, nomes de tabelas e colunas em PT-BR
-- Observação: ajuste o nome do banco conforme necessário fora deste arquivo

SET NAMES utf8mb4;
SET time_zone = '+00:00';

-- Tabela de usuários
DROP TABLE IF EXISTS comentarios;
DROP TABLE IF EXISTS jogos;
DROP TABLE IF EXISTS usuarios;

CREATE TABLE usuarios (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nome_usuario VARCHAR(50) NOT NULL,
  email VARCHAR(255) NOT NULL,
  senha_hash VARCHAR(255) NOT NULL,
  papel ENUM('DEV','SUPER_ADMIN','ADMIN','USER') NOT NULL DEFAULT 'USER',
  criado_por INT UNSIGNED NULL,
  status ENUM('active','inactive','banned') NOT NULL DEFAULT 'active',
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_usuarios_nome (nome_usuario),
  UNIQUE KEY uq_usuarios_email (email),
  KEY idx_usuarios_criado_por (criado_por)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Auto-relacionamento (criador do usuário)
ALTER TABLE usuarios
  ADD CONSTRAINT fk_usuarios_criado_por
  FOREIGN KEY (criado_por) REFERENCES usuarios(id)
  ON DELETE SET NULL ON UPDATE CASCADE;

-- Tabela de jogos
CREATE TABLE jogos (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  titulo VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL,
  descricao TEXT NOT NULL,
  imagem_capa VARCHAR(255) NOT NULL,
  idioma VARCHAR(50) DEFAULT NULL,
  versao VARCHAR(50) DEFAULT NULL,
  motor VARCHAR(20) DEFAULT NULL,
  tags VARCHAR(255) DEFAULT NULL,
  url_download VARCHAR(500) DEFAULT NULL,
  url_download_windows VARCHAR(500) DEFAULT NULL,
  url_download_android VARCHAR(500) DEFAULT NULL,
  url_download_linux VARCHAR(500) DEFAULT NULL,
  url_download_mac VARCHAR(500) DEFAULT NULL,
  censurado TINYINT(1) NOT NULL DEFAULT 0,
  so_windows TINYINT(1) NOT NULL DEFAULT 0,
  so_android TINYINT(1) NOT NULL DEFAULT 0,
  so_linux TINYINT(1) NOT NULL DEFAULT 0,
  so_mac TINYINT(1) NOT NULL DEFAULT 0,
  publicado_por INT UNSIGNED NOT NULL,
  nome_desenvolvedor VARCHAR(255) DEFAULT NULL,
  idiomas_multiplos TEXT DEFAULT NULL,
  atualizado_em_personalizado DATE DEFAULT NULL,
  lancado_em_personalizado DATE DEFAULT NULL,
  url_patreon VARCHAR(255) DEFAULT NULL,
  url_discord VARCHAR(255) DEFAULT NULL,
  url_subscribestar VARCHAR(255) DEFAULT NULL,
  url_itch VARCHAR(255) DEFAULT NULL,
  url_kofi VARCHAR(255) DEFAULT NULL,
  url_bmc VARCHAR(255) DEFAULT NULL,
  url_steam VARCHAR(255) DEFAULT NULL,
  capturas TEXT DEFAULT NULL,
  downloads_total INT UNSIGNED NOT NULL DEFAULT 0,
  categoria VARCHAR(100) DEFAULT NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_jogos_slug (slug),
  KEY idx_jogos_publicado_por (publicado_por),
  KEY idx_jogos_titulo (titulo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE jogos
  ADD CONSTRAINT fk_jogos_publicado_por
  FOREIGN KEY (publicado_por) REFERENCES usuarios(id)
  ON DELETE CASCADE ON UPDATE CASCADE;

-- Tabela de comentários
CREATE TABLE comentarios (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  jogo_id INT UNSIGNED NOT NULL,
  usuario_id INT UNSIGNED NOT NULL,
  comentario TEXT NOT NULL,
  pai_id INT UNSIGNED DEFAULT NULL,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  editado_em DATETIME DEFAULT NULL,
  excluido_em DATETIME DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_comentarios_jogo (jogo_id),
  KEY idx_comentarios_usuario (usuario_id),
  KEY idx_comentarios_pai (pai_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE comentarios
  ADD CONSTRAINT fk_comentarios_jogo
  FOREIGN KEY (jogo_id) REFERENCES jogos(id)
  ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_comentarios_usuario
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
  ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_comentarios_pai
  FOREIGN KEY (pai_id) REFERENCES comentarios(id)
  ON DELETE SET NULL ON UPDATE CASCADE;

-- Dados mínimos opcionais (remova se não desejar seeds)
-- INSERT INTO usuarios (nome_usuario, email, senha_hash, papel) VALUES ('admin', 'admin@example.com', '$2y$10$hash...', 'ADMIN');

