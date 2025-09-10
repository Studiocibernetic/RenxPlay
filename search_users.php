<?php
require 'config.php';
requireLogin();

$ME = $_SESSION['user']['id'];
$MYROLE = $_SESSION['user']['papel'];

// ====== VERIFICAÇÃO DE PERMISSÕES ======
if (!in_array($MYROLE, ['DEV', 'SUPER_ADMIN'])) {
    http_response_code(403);
    echo json_encode(['error' => 'Acesso negado']);
    exit;
}

$q = trim($_GET['q'] ?? '');
$role = trim($_GET['role'] ?? '');

$sql = "SELECT id, nome_usuario, email, papel FROM usuarios WHERE 1 ";
$params = [];

// ====== FILTRO POR PAPEL (hierarquia) ======
if ($MYROLE === 'DEV') {
    // DEV vê todos os usuários (incluindo ele mesmo)
    // Sem restrições adicionais
} elseif ($MYROLE === 'SUPER_ADMIN') {
    // SUPER_ADMIN vê apenas:
    // - ADMINs que ele criou
    // - Outros SUPER_ADMINs (mas NÃO ele mesmo)
    $sql .= "AND ((papel = 'ADMIN' AND criado_por = ?) OR (papel = 'SUPER_ADMIN' AND id != ?)) ";
    $params[] = $ME;
    $params[] = $ME;  // Exclui ele mesmo
}

// ====== FILTRO POR BUSCA ======
if ($q !== '') {
    $sql .= "AND (nome_usuario LIKE ? OR email LIKE ?) ";
    $params[] = "%$q%";
    $params[] = "%$q%";
}

// ====== FILTRO POR CARGO ======
if ($role !== '' && in_array($role, ['DEV','SUPER_ADMIN','ADMIN','USER'])) {
    $sql .= "AND papel = ? ";
    $params[] = $role;
}

$sql .= "ORDER BY created_at DESC LIMIT 15";

$stmt = $pdo->prepare($sql);
$stmt->execute($params);

header('Content-Type: application/json; charset=utf-8');
// Harmonizar chaves para a interface (script.js usa username/email/role)
$users = $stmt->fetchAll(PDO::FETCH_ASSOC);
foreach ($users as &$u) {
    $u['username'] = $u['nome_usuario'] ?? $u['username'] ?? '';
    $u['role'] = $u['papel'] ?? $u['role'] ?? '';
}
unset($u);
echo json_encode($users);
?>
