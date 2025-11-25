<?php
// toggle_like.php
require 'config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode([
        'success' => false,
        'message' => 'Método no permitido',
    ]);
    exit;
}

$idVideo = isset($_POST['id_video']) ? (int)$_POST['id_video'] : 0;
$idUsuario = $USUARIO_DEMO_ID;

if ($idVideo <= 0) {
    echo json_encode([
        'success' => false,
        'message' => 'Video inválido',
    ]);
    exit;
}

try {
    // Empezamos transacción por seguridad (lectura + escritura)
    $pdo->beginTransaction();

    // 1. ¿Ya existe like de este usuario a este video?
    $sqlSelect = "
        SELECT id_reacciones_video
        FROM reacciones_video
        WHERE id_usuario = :id_usuario
          AND id_video   = :id_video
        FOR UPDATE
    ";
    $stmt = $pdo->prepare($sqlSelect);
    $stmt->execute([
        ':id_usuario' => $idUsuario,
        ':id_video'   => $idVideo,
    ]);
    $row = $stmt->fetch();

    if ($row) {
        // Ya existía → hacer UNLIKE (eliminar reacción)
        $sqlDelete = "
            DELETE FROM reacciones_video
            WHERE id_reacciones_video = :id
        ";
        $stmtDel = $pdo->prepare($sqlDelete);
        $stmtDel->execute([':id' => $row['id_reacciones_video']]);
        $liked = false;
    } else {
        // No existía → hacer LIKE (insertar reacción)
        $sqlInsert = "
            INSERT INTO reacciones_video (id_usuario, id_video, tipo_reaccion, fecha_reaccion)
            VALUES (:id_usuario, :id_video, 'like', NOW())
        ";
        $stmtIns = $pdo->prepare($sqlInsert);
        $stmtIns->execute([
            ':id_usuario' => $idUsuario,
            ':id_video'   => $idVideo,
        ]);
        $liked = true;
        // Aquí se dispara el trigger trg_like_video_notificacion
    }

    // 2. Contar likes actualizados para ese video
    $sqlCount = "
        SELECT COUNT(*) AS total
        FROM reacciones_video
        WHERE id_video = :id_video
    ";
    $stmtCount = $pdo->prepare($sqlCount);
    $stmtCount->execute([':id_video' => $idVideo]);
    $likesRow = $stmtCount->fetch();
    $likes = $likesRow ? (int)$likesRow['total'] : 0;

    $pdo->commit();

    echo json_encode([
        'success' => true,
        'liked'   => $liked,
        'likes'   => $likes,
    ]);
} catch (PDOException $e) {
    $pdo->rollBack();
    echo json_encode([
        'success' => false,
        'message' => 'Error en toggle_like: ' . $e->getMessage(),
    ]);
}
