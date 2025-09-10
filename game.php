<?php
require 'config.php';

date_default_timezone_set('America/Sao_Paulo');

function canModerateComments(int $postOwnerId): bool {
    return isLoggedIn() && (
        $_SESSION['user']['papel'] === 'DEV'
        || $_SESSION['user']['papel'] === 'SUPER_ADMIN'
        || $_SESSION['user']['id'] === $postOwnerId
    );
}

$gameSlug = $_GET['slug'] ?? ($_GET['game'] ?? null);
if (!$gameSlug) {
    header('Location: index.php');
    exit;
}

$stmt = $pdo->prepare("SELECT g.*, u.nome_usuario AS author FROM jogos g JOIN usuarios u ON g.publicado_por=u.id WHERE g.slug = ?");
$stmt->execute([$gameSlug]);
$game = $stmt->fetch();

if (!$game) {
    header('Location: index.php');
    exit;
}

$gameId = (int)$game['id'];
$postOwner = (int)$game['publicado_por'];

if (isLoggedIn() && isset($_POST['action'])) {
    $gameIdPost = (int)($_POST['game_id'] ?? 0);
    if ($gameIdPost < 1) {
        header('Location: index.php');
        exit;
    }

    $owner = $pdo->prepare("SELECT publicado_por FROM jogos WHERE id = ?");
    $owner->execute([$gameIdPost]);
    $postOwner = (int)$owner->fetchColumn();

    if (!$postOwner) {
        header('Location: index.php');
        exit;
    }

    if ($_POST['action'] === 'comment' && !empty($_POST['comment'])) {
        $pdo->prepare("INSERT INTO comentarios (jogo_id, usuario_id, comentario, pai_id, criado_em) VALUES (?,?,?,?,NOW())")
            ->execute([
                $gameIdPost,
                $_SESSION['user']['id'],
                trim($_POST['comment']),
                !empty($_POST['parent_id']) ? (int)$_POST['parent_id'] : null
            ]);
    } elseif ($_POST['action'] === 'edit_comment' && !empty($_POST['comment_id']) && !empty($_POST['comment'])) {
        $c = $pdo->prepare("SELECT * FROM comentarios WHERE id=?");
        $c->execute([(int)$_POST['comment_id']]);
        $comment = $c->fetch();
        if ($comment && ($comment['usuario_id'] === $_SESSION['user']['id'] || canModerateComments($postOwner))) {
            $pdo->prepare("UPDATE comentarios SET comentario=?, editado_em=NOW() WHERE id=?")
                ->execute([trim($_POST['comment']), (int)$_POST['comment_id']]);
        }
    } elseif ($_POST['action'] === 'delete_comment' && !empty($_POST['comment_id'])) {
        $c = $pdo->prepare("SELECT * FROM comentarios WHERE id=?");
        $c->execute([(int)$_POST['comment_id']]);
        $comment = $c->fetch();
        if ($comment && ($comment['usuario_id'] === $_SESSION['user']['id'] || canModerateComments($postOwner))) {
            $pdo->prepare("UPDATE comentarios SET excluido_em=NOW() WHERE id=?")
                ->execute([(int)$_POST['comment_id']]);
        }
    }

    header("Location: game.php?slug={$gameSlug}#comments");
    exit;
}

if (isset($_GET['download']) && isLoggedIn()) {
    $pdo->prepare("UPDATE jogos SET downloads_total = downloads_total + 1 WHERE id = ?")
        ->execute([ $_GET['download'] ]);
    echo "<script>window.close();</script>";
    exit;
}

$cTotal = $pdo->prepare("SELECT COUNT(*) FROM comentarios WHERE jogo_id=? AND excluido_em IS NULL");
$cTotal->execute([$gameId]);
$totalComments = (int)$cTotal->fetchColumn();

renderHeader($game['titulo']);
?>

<!-- Botão voltar -->
<div class="container" style="padding-top: 1rem;">
    <a href="index.php" class="btn btn-outline btn-sm">
        <i class="fas fa-arrow-left"></i>
        Voltar para a lista
    </a>
</div>

<!-- Detalhes do jogo -->
<div class="game-detail">
    <div class="game-header">
        <div class="game-image">
            <?= renderImageTag('uploads/covers/' . $game['imagem_capa'], $game['titulo']) ?>
        </div>

        <div class="game-info">
            <h1><?= htmlspecialchars($game['titulo']) ?></h1>

            <div class="game-badges">
                <span class="badge"><?= htmlspecialchars(html_entity_decode($game['motor'] ?? "REN'PY")) ?></span>
                <span class="badge"><?= htmlspecialchars($game['versao'] ?? 'v1.0') ?></span>
                <span class="badge"><?= htmlspecialchars($game['author']) ?></span>
            </div>

            <div class="card-rating" style="margin-bottom: .75rem;">
                <i class="fas fa-star"></i>
                <span>4.5</span>
            </div>

            <div style="margin-bottom: .75rem;">
                <?php $langs = !empty($game['idiomas_multiplos']) ? json_decode($game['idiomas_multiplos'], true) : []; ?>
                <p><strong>Idiomas:</strong>
                    <?php if ($langs): ?>
                        <?= htmlspecialchars(implode(', ', $langs)) ?>
                    <?php else: ?>
                        <?= htmlspecialchars($game['idioma'] ?? 'Português') ?>
                    <?php endif; ?>
                </p>
                <?php if (!empty($game['nome_desenvolvedor'])): ?>
                    <p><strong>Desenvolvedor:</strong> <?= htmlspecialchars($game['nome_desenvolvedor']) ?></p>
                <?php endif; ?>
                <p><strong>Censurado:</strong> <?= !empty($game['censurado']) ? 'Sim' : 'Não' ?></p>
                <?php if (!empty($game['lancado_em_personalizado'])): ?>
                    <p><strong>Lançamento:</strong> <?= date('d/m/Y', strtotime($game['lancado_em_personalizado'])) ?></p>
                <?php else: ?>
                    <p><strong>Lançamento:</strong> <?= date('d/m/Y', strtotime($game['criado_em'])) ?></p>
                <?php endif; ?>
                <?php if (!empty($game['atualizado_em_personalizado'])): ?>
                    <p><strong>Atualização:</strong> <?= date('d/m/Y', strtotime($game['atualizado_em_personalizado'])) ?></p>
                <?php endif; ?>
            </div>

            <?php if (!empty($game['url_patreon']) || !empty($game['url_discord']) || !empty($game['url_subscribestar']) || !empty($game['url_itch']) || !empty($game['url_kofi']) || !empty($game['url_bmc']) || !empty($game['url_steam'])): ?>
            <div class="download-section" style="margin-top:.5rem;">
                <div class="creator-links">
                    <?php if (!empty($game['url_patreon'])): ?><a class="btn btn-outline" target="_blank" href="<?= htmlspecialchars($game['url_patreon']) ?>"><i class="fab fa-patreon"></i> Patreon</a><?php endif; ?>
                    <?php if (!empty($game['url_discord'])): ?><a class="btn btn-outline" target="_blank" href="<?= htmlspecialchars($game['url_discord']) ?>"><i class="fab fa-discord"></i> Discord</a><?php endif; ?>
                    <?php if (!empty($game['url_subscribestar'])): ?><a class="btn btn-outline" target="_blank" href="<?= htmlspecialchars($game['url_subscribestar']) ?>"><i class="fas fa-star"></i> SubscribeStar</a><?php endif; ?>
                    <?php if (!empty($game['url_itch'])): ?><a class="btn btn-outline" target="_blank" href="<?= htmlspecialchars($game['url_itch']) ?>"><i class="fas fa-gamepad"></i> itch.io</a><?php endif; ?>
                    <?php if (!empty($game['url_kofi'])): ?><a class="btn btn-outline" target="_blank" href="<?= htmlspecialchars($game['url_kofi']) ?>"><i class="fas fa-mug-hot"></i> Ko-fi</a><?php endif; ?>
                    <?php if (!empty($game['url_bmc'])): ?><a class="btn btn-outline" target="_blank" href="<?= htmlspecialchars($game['url_bmc']) ?>"><i class="fas fa-coffee"></i> Buy Me a Coffee</a><?php endif; ?>
                    <?php if (!empty($game['url_steam'])): ?><a class="btn btn-outline" target="_blank" href="<?= htmlspecialchars($game['url_steam']) ?>"><i class="fab fa-steam"></i> Steam</a><?php endif; ?>
                </div>
            </div>
            <?php endif; ?>
        </div>
    </div>

    <?php if (isLoggedIn()): ?>
        <div class="download-section">
            <h3><i class="fas fa-download"></i> Selecionar plataforma:</h3>
            <div class="download-buttons">
                <?php if (!empty($game['url_download_windows'])): ?>
                    <a href="<?= htmlspecialchars($game['url_download_windows']) ?>" target="_blank" class="btn btn-download">
                        <i class="fab fa-windows"></i>
                        Windows
                    </a>
                <?php endif; ?>

                <?php if (!empty($game['url_download_android'])): ?>
                    <a href="<?= htmlspecialchars($game['url_download_android']) ?>" target="_blank" class="btn btn-download">
                        <i class="fab fa-android"></i>
                        Android
                    </a>
                <?php endif; ?>

                <?php if (!empty($game['url_download'])): ?>
                    <a href="<?= htmlspecialchars($game['url_download']) ?>" target="_blank" class="btn btn-secondary">
                        <i class="fas fa-download"></i>
                        Download geral
                    </a>
                <?php endif; ?>
            </div>
        </div>
    <?php else: ?>
        <div class="download-section">
            <p style="text-align: center; color: hsl(var(--muted-foreground));">
                <i class="fas fa-lock"></i>
                <a href="auth.php" style="color: hsl(var(--primary));">Faça login</a> para fazer download
            </p>
        </div>
    <?php endif; ?>

    <?php if (!empty($game['capturas'])): ?>
        <div class="card" style="margin: 1rem 0;">
            <div class="card-content">
                <?= displayScreenshots($game['capturas'], $game['titulo'], $game['id'], false) ?>
            </div>
        </div>
    <?php endif; ?>

    <!-- Tags -->
    <?php if (!empty($game['tags'])): ?>
        <div class="card" style="margin-bottom: 1rem;">
            <div class="card-content">
                <h3 style="margin-bottom: 0.75rem;">
                    <i class="fas fa-tags"></i>
                    Tags
                </h3>
                <div class="card-tags">
                    <?php 
                    $tags = explode(',', $game['tags']);
                    foreach ($tags as $tag): 
                        $tag = trim($tag);
                        if ($tag):
                    ?>
                        <span class="tag"><?= htmlspecialchars($tag) ?></span>
                    <?php 
                        endif;
                    endforeach; 
                    ?>
                </div>
            </div>
        </div>
    <?php endif; ?>

    <!-- Descrição -->
    <div class="card" style="margin-bottom: 1rem;">
        <div class="card-content">
            <h3 style="margin-bottom: 0.75rem;">
                <i class="fas fa-info-circle"></i>
                Descrição
            </h3>
            <p><?= nl2br(htmlspecialchars($game['descricao'])) ?></p>
        </div>
    </div>
</div>

<?php renderFooter(); ?>