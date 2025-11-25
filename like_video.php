<?php
// like_video.php
require 'config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: index.php');
    exit;
}

$idVideo = isset($_POST['id_video']) ? (int)$_POST['id_video'] : 0;
$idUsuario = $USUARIO_DEMO_ID; // usuario "logueado" de la demo

if ($idVideo <= 0) {
    die('Video inválido.');
}

try {
    // Evitar like duplicado gracias al UNIQUE (id_usuario, id_video)
    $sql = "INSERT INTO reacciones_video (id_usuario, id_video, tipo_reaccion, fecha_reaccion)
            VALUES (:id_usuario, :id_video, 'like', NOW())";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        ':id_usuario' => $idUsuario,
        ':id_video'   => $idVideo,
    ]);

    $mensaje = 'Like registrado correctamente. Se disparó el trigger de notificación.';

} catch (PDOException $e) {
    // Si rompe por UNIQUE, asumimos que ya dio like
    if ($e->getCode() === '23000') { // violación de constraint
        $mensaje = 'Ya habías dado like a este video.';
    } else {
        $mensaje = 'Error al registrar el like: ' . $e->getMessage();
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Like a video</title>
</head>
<body>
  <p><?= htmlspecialchars($mensaje) ?></p>
  <p><a href="index.php">Volver al feed</a> | <a href="notificaciones.php">Ver notificaciones</a></p>
</body>
</html>
