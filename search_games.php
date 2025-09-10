<?php
require 'config.php';
header('Content-Type: application/json');

$q = $_GET['q'] ?? '';
if (strlen($q) < 2) {
    echo json_encode([]);
    exit;
}

$stmt = $pdo->prepare("SELECT slug, titulo, imagem_capa, categoria, downloads_total FROM jogos WHERE titulo LIKE ? LIMIT 8");
$stmt->execute(['%' . $q . '%']);
// Adaptar as chaves esperadas no frontend (index.js embutido)
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
foreach ($rows as &$r) {
    // manter compatibilidade onde esperado
    $r['title'] = $r['titulo'] ?? $r['title'] ?? '';
}
unset($r);
echo json_encode($rows);
?>
