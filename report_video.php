<?php
// report_video.php
require 'config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: index.php');
    exit;
}

$idVideo = isset($_POST['id_video']) ? (int)$_POST['id_video'] : 0;
$motivo  = isset($_POST['motivo']) ? trim($_POST['motivo']) : '';
$idUsuario = $USUARIO_DEMO_ID; // usuario que reporta

if ($idVideo <= 0 || $motivo === '') {
    die('Datos inválidos para el reporte.');
}

try {
    $pdo->beginTransaction();

    // 1. Insertar reporte (sobre un video, comentario NULL)
    $sqlReporte = "
        INSERT INTO reportes (id_usuario, id_video, id_comentario, motivo, detalle, fecha_reporte, estado)
        VALUES (:id_usuario, :id_video, NULL, :motivo, NULL, NOW(), 'abierto')
    ";
    $stmt1 = $pdo->prepare($sqlReporte);
    $stmt1->execute([
        ':id_usuario' => $idUsuario,
        ':id_video'   => $idVideo,
        ':motivo'     => $motivo,
    ]);

    // 2. Marcar el video como 'reportado'
    $sqlUpdate = "
        UPDATE videos
        SET estado_video = 'reportado'
        WHERE id_video = :id_video
    ";
    $stmt2 = $pdo->prepare($sqlUpdate);
    $stmt2->execute([':id_video' => $idVideo]);

    $pdo->commit();
    $mensaje = 'Reporte registrado y estado del video actualizado dentro de una misma transacción.';

} catch (PDOException $e) {
    $pdo->rollBack();
    $mensaje = 'Error en la transacción de reporte: ' . $e->getMessage();
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Reporte de video</title>
</head>
<body>
  <p><?= htmlspecialchars($mensaje) ?></p>
  <p><a href="index.php">Volver al feed</a></p>
</body>
</html>
