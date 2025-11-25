<?php
// notification_like.php
require 'config.php';

$idUsuario = $USUARIO_DEMO_ID;

$sql = "
SELECT id_notificacion, tipo, mensaje, fecha_creacion, leida, id_referencia
FROM notificaciones
WHERE id_usuario = :id_usuario
ORDER BY fecha_creacion DESC;
";
$stmt = $pdo->prepare($sql);
$stmt->execute([':id_usuario' => $idUsuario]);
$notificaciones = $stmt->fetchAll();
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Notificaciones - UniTok</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f3f4f6; margin:0; padding:0; }
    header { background:#111827; color:#fff; padding:1rem 2rem; display:flex; justify-content:space-between; }
    header a { color:#93c5fd; text-decoration:none; margin-left:1rem; }
    main { max-width:800px; margin:1.5rem auto; background:#fff; padding:1.5rem; border-radius:8px; }
    .notif { border-bottom:1px solid #e5e7eb; padding:0.5rem 0; }
    .notif:last-child { border-bottom:none; }
    .notif-tipo { font-size:0.8rem; color:#6b7280; }
    .notif-fecha { font-size:0.8rem; color:#9ca3af; }
  </style>
</head>
<body>
<header>
  <div>Notificaciones de la demo (trigger)</div>
  <nav>
    <a href="index.php">Volver al feed</a>
  </nav>
</header>
<main>
  <h2>Notificaciones para el usuario demo (id <?= (int)$idUsuario ?>)</h2>
  <?php if (empty($notificaciones)): ?>
    <p>No hay notificaciones aún. Prueba dar like a algún video.</p>
  <?php else: ?>
    <?php foreach ($notificaciones as $n): ?>
      <div class="notif">
        <div class="notif-tipo"><?= htmlspecialchars($n['tipo']) ?></div>
        <div><?= nl2br(htmlspecialchars($n['mensaje'])) ?></div>
        <div class="notif-fecha"><?= htmlspecialchars($n['fecha_creacion']) ?></div>
      </div>
    <?php endforeach; ?>
  <?php endif; ?>
</main>
</body>
</html>
