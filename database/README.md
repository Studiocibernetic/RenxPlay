# RenxPlay Database

Esta pasta contém todos os arquivos relacionados ao banco de dados do sistema RenxPlay.

## 📁 Arquivos Disponíveis

### 🏗️ `schema.sql`
**Estrutura completa do banco de dados**
- Contém todas as tabelas, índices, triggers, views e procedures
- Usado para criar o banco do zero em um novo servidor
- Inclui todas as funcionalidades do sistema

### 🌱 `seed.sql`
**Dados iniciais para instalação**
- Usuários administrativos padrão
- Categorias de jogos
- Jogos de exemplo
- Configurações do sistema
- Dados de teste

### 💾 `dump.sql`
**Backup completo do banco**
- Estrutura + dados de exemplo
- Usado para restaurar o banco em outro servidor
- Inclui todas as correções e otimizações

### 🔧 `fixes.sql`
**Correções e melhorias**
- Corrige problemas identificados no banco atual
- Adiciona colunas faltantes
- Cria tabelas ausentes
- Otimiza performance
- Melhora segurança

## 🚀 Como Usar

### Instalação Completa (Novo Servidor)

```bash
# 1. Criar estrutura do banco
mysql -u csmods -pzcbm -h 127.0.0.1 < schema.sql

# 2. Adicionar dados iniciais
mysql -u csmods -pzcbm -h 127.0.0.1 < seed.sql
```

### Restauração Rápida

```bash
# Restaurar backup completo
mysql -u csmods -pzcbm -h 127.0.0.1 < dump.sql
```

### Correção de Problemas

```bash
# Aplicar correções no banco existente
mysql -u csmods -pzcbm -h 127.0.0.1 < fixes.sql
```

## 📊 Estrutura do Banco

### Tabelas Principais

| Tabela | Descrição | Funcionalidade |
|--------|-----------|----------------|
| `users` | Usuários do sistema | Autenticação e autorização |
| `games` | Catálogo de jogos | CRUD de jogos |
| `comments` | Sistema de comentários | Comentários hierárquicos |
| `categories` | Categorias de jogos | Organização de conteúdo |
| `downloads` | Log de downloads | Estatísticas |
| `views` | Log de visualizações | Estatísticas |
| `ratings` | Sistema de avaliações | Avaliações 1-5 estrelas |
| `favorites` | Sistema de favoritos | Lista de favoritos |
| `sessions` | Gerenciamento de sessões | Controle de sessões |
| `settings` | Configurações do sistema | Configurações globais |
| `logs` | Sistema de logs | Logs de atividades |

### Relacionamentos

- `users` → `games` (1:N) - Um usuário pode ter vários jogos
- `games` → `comments` (1:N) - Um jogo pode ter vários comentários
- `users` → `comments` (1:N) - Um usuário pode fazer vários comentários
- `games` → `categories` (N:N) - Jogos podem ter várias categorias
- `games` → `downloads` (1:N) - Um jogo pode ter vários downloads
- `games` → `views` (1:N) - Um jogo pode ter várias visualizações
- `games` → `ratings` (1:N) - Um jogo pode ter várias avaliações
- `games` → `favorites` (1:N) - Um jogo pode ser favorito de vários usuários

## 🔐 Usuários Padrão

| Usuário | Senha | Role | Descrição |
|---------|-------|------|-----------|
| `admin` | `password` | DEV | Acesso total ao sistema |
| `superadmin` | `password` | SUPER_ADMIN | Gerenciamento de admins |
| `moderator` | `password` | ADMIN | Gerenciamento de conteúdo |
| `testuser` | `password` | USER | Usuário de teste |

**⚠️ IMPORTANTE:** Altere as senhas padrão após a instalação!

## ⚙️ Configurações

### Banco de Dados
- **Host:** 127.0.0.1
- **Database:** u111823599_RenxplayGames
- **User:** csmods
- **Password:** zcbm
- **Charset:** utf8mb4
- **Collation:** utf8mb4_unicode_ci

### Configurações do Sistema
- **Posts por página:** 10
- **Tamanho máximo de upload:** 10MB
- **Máximo de screenshots:** 30
- **Comprimento mínimo da senha:** 6 caracteres

## 🛠️ Manutenção

### Procedures de Limpeza

```sql
-- Limpar sessões expiradas (executar mensalmente)
CALL cleanup_expired_sessions();

-- Limpar logs antigos (executar trimestralmente)
CALL cleanup_old_logs();
```

### Views Úteis

```sql
-- Estatísticas de jogos
SELECT * FROM game_stats;

-- Estatísticas de usuários
SELECT * FROM user_stats;
```

## 🔍 Verificações

### Verificar Estrutura
```sql
-- Verificar tabelas
SHOW TABLES;

-- Verificar estrutura da tabela games
DESCRIBE games;

-- Verificar índices
SHOW INDEX FROM games;
```

### Verificar Integridade
```sql
-- Verificar chaves estrangeiras
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE REFERENCED_TABLE_SCHEMA = 'u111823599_RenxplayGames';
```

## 📈 Performance

### Índices Criados
- Busca por título de jogos
- Busca por descrição
- Busca por tags
- Filtros por status
- Filtros por engine
- Ordenação por data
- Ordenação por downloads

### Otimizações
- Triggers para contadores automáticos
- Views para consultas complexas
- Procedures para manutenção
- Índices compostos para consultas frequentes

## 🚨 Problemas Comuns

### Erro de Conexão
```bash
# Verificar se o MySQL está rodando
systemctl status mysql

# Verificar credenciais
mysql -u csmods -pzcbm -h 127.0.0.1 -e "SELECT 1"
```

### Colunas Faltantes
```bash
# Aplicar correções
mysql -u csmods -pzcbm -h 127.0.0.1 < fixes.sql
```

### Performance Lenta
```sql
-- Otimizar tabelas
OPTIMIZE TABLE games, users, comments;

-- Verificar índices
SHOW INDEX FROM games;
```

## 📞 Suporte

Para problemas ou dúvidas:
1. Verifique os logs do sistema
2. Consulte a documentação do projeto
3. Execute as verificações de integridade
4. Aplique as correções necessárias

## 📝 Changelog

### v1.0.0 (2024-12-19)
- ✅ Estrutura completa do banco
- ✅ Sistema de usuários com hierarquia
- ✅ CRUD completo de jogos
- ✅ Sistema de comentários
- ✅ Logs de downloads e visualizações
- ✅ Sistema de avaliações e favoritos
- ✅ Categorização de jogos
- ✅ Configurações do sistema
- ✅ Triggers e procedures
- ✅ Views otimizadas
- ✅ Índices de performance
- ✅ Correções de problemas
- ✅ Dados de exemplo
- ✅ Documentação completa
