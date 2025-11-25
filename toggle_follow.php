<?php
//toggle_flow.php
require 'config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  echo json_encode(['success' => false, 'message' => 'Método no permitido']);
  exit;
}

$idSeguido  = isset($_POST['id_seguido']) ? (int)$_POST['id_seguido'] : 0;
$idSeguidor = $USUARIO_DEMO_ID;

if ($idSeguido <= 0) {
  echo json_encode(['success' => false, 'message' => 'Usuario objetivo inválido']);
  exit;
}

// Regla de negocio: no te puedes seguir a ti mismo
if ($idSeguido === $idSeguidor) {
  echo json_encode(['success' => false, 'message' => 'No puedes seguirte a ti mismo']);
  exit;
}

try {
  $pdo->beginTransaction();

  // ¿ya existe follow activo?
  $sqlSel = "
    SELECT id_seguimiento
    FROM seguimientos
    WHERE id_seguidor = :seguidor
      AND id_seguido  = :seguido
      AND estado = 'activo'
    FOR UPDATE
  ";
  $stmt = $pdo->prepare($sqlSel);
  $stmt->execute([':seguidor' => $idSeguidor, ':seguido' => $idSeguido]);
  $row = $stmt->fetch();

  if ($row) {
    // UNFOLLOW: borramos relación (simple para demo)
    $sqlDel = "DELETE FROM seguimientos WHERE id_seguimiento = :id";
    $del = $pdo->prepare($sqlDel);
    $del->execute([':id' => $row['id_seguimiento']]);
    $following = false;
  } else {
    // FOLLOW: insert (aquí se dispara el trigger de nuevo seguidor)
    // UNIQUE (id_seguidor,id_seguido) evita duplicados si existiera otra fila
    $sqlIns = "
      INSERT INTO seguimientos (id_seguidor, id_seguido, fecha_seguimiento, estado)
      VALUES (:seguidor, :seguido, NOW(), 'activo')
    ";
    $ins = $pdo->prepare($sqlIns);
    $ins->execute([':seguidor' => $idSeguidor, ':seguido' => $idSeguido]);
    $following = true;
  }

  $pdo->commit();

  echo json_encode([
    'success'   => true,
    'following' => $following,
  ]);
} catch (PDOException $e) {
  $pdo->rollBack();

  // Si falla por CHECK/UNIQUE, devolvemos mensaje entendible
  if ($e->getCode() === '23000') {
    echo json_encode(['success' => false, 'message' => 'Restricción de integridad: no se pudo seguir (UNIQUE/CHECK/FK).']);
  } else {
    echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
  }
}
