Renxplay - Site de Jogos (PT-BR)

Este projeto utiliza PHP (backend) e HTML/CSS/JavaScript (frontend). O esquema do banco está em `database/schema.sql` e foi traduzido e padronizado para português, com views de compatibilidade para manter os arquivos PHP atuais funcionando sem alterações disruptivas.

Requisitos
- PHP 8.1+
- MySQL 8+
- Extensões: PDO MySQL, GD (opcional), Imagick (opcional)

Configuração
1. Crie o banco de dados no MySQL (ex.: `CREATE DATABASE renxplay CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`).
2. Ajuste as constantes em `config.php` (`DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASS`).
3. Importe o arquivo `database/schema.sql` no banco criado.
4. Garanta que a pasta `uploads/` tenha permissão de escrita pelo PHP.

Esquema do Banco
- Tabelas em português: `usuarios`, `jogos`, `comentarios`.
- Views de compatibilidade: `users`, `games`, `comments` (mantêm nomes de colunas esperados pelo código atual).

Login/Admin
- A criação de usuários é feita pela tela de registro (`auth.php?action=register`).
- Atribua papéis diretamente na tabela `usuarios.papel` se necessário: `DEV`, `SUPER_ADMIN`, `ADMIN`, `USER`.

Uploads
- Capas: `uploads/covers/`
- Capturas: `uploads/screenshots/`

Dicas
- Para usar AVIF, configure GD/Imagick com suporte. O código gera fallback quando possível.
- Tema claro/escuro controlado pelo `localStorage` (script.js).

Segurança
- CSRF básico em formulários sensíveis.
- Políticas de segurança por headers em `config.php`.

Licença
Uso interno do proprietário do projeto.
