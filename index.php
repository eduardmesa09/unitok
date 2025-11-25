<?php
// index.php
require 'config.php';

// 1. Obtener información del usuario "logueado" (demo)
$stmtUser = $pdo->prepare("SELECT username FROM usuarios WHERE id_usuario = :id");
$stmtUser->execute([':id' => $USUARIO_DEMO_ID]);
$loggedUser    = $stmtUser->fetch();
$loggedName    = $loggedUser ? $loggedUser['username'] : ('usuario_' . $USUARIO_DEMO_ID);

// 2. Consulta: feed de videos públicos, likes y si el usuario actual ya dio like
$sql = "
SELECT
  v.id_video,
  v.titulo,
  v.descripcion,
  v.fecha_publicacion,
  v.duracion_segundos,
  u.username AS autor,
  COALESCE(COUNT(rv.id_reacciones_video), 0) AS likes,
  COALESCE(SUM(rv.id_usuario = :idUsuario), 0) AS liked_by_user
FROM videos v
JOIN usuarios u ON v.id_autor = u.id_usuario
LEFT JOIN reacciones_video rv ON rv.id_video = v.id_video
WHERE v.visibilidad = 'publico'
  AND v.estado_video = 'normal'
GROUP BY v.id_video
ORDER BY v.fecha_publicacion DESC;
";

$stmt = $pdo->prepare($sql);
$stmt->execute([':idUsuario' => $USUARIO_DEMO_ID]);
$videos = $stmt->fetchAll();
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>UniTok Demo - Feed público</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: #f5f5f5;
      margin: 0;
      padding: 0;
    }
    header {
      background: #111827;
      color: #ffffff;
      padding: 1rem 2rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    header h1 {
      margin: 0;
      font-size: 1.4rem;
    }
    header .user-info {
      font-size: 0.9rem;
      text-align: right;
    }
    header a {
      color: #93c5fd;
      text-decoration: none;
      margin-left: 1rem;
    }
    main {
      padding: 1.5rem 2rem;
      max-width: 900px;
      margin: 0 auto;
    }
    .video-card {
      background: #ffffff;
      border-radius: 8px;
      padding: 1rem 1.2rem;
      margin-bottom: 1rem;
      box-shadow: 0 2px 4px rgba(0,0,0,0.08);
    }
    .video-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 1rem;
    }
    .video-title {
      font-weight: bold;
      font-size: 1.1rem;
      margin: 0;
    }
    .video-meta {
      font-size: 0.85rem;
      color: #6b7280;
    }
    .video-body {
      margin-top: 0.5rem;
      font-size: 0.95rem;
    }
    .video-actions {
      margin-top: 0.75rem;
      display: flex;
      gap: 1rem;
      align-items: center;
      flex-wrap: wrap;
    }
    form.inline {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      margin: 0;
    }
    button {
      border: none;
      color: white;
      padding: 0.35rem 0.7rem;
      border-radius: 4px;
      font-size: 0.85rem;
      cursor: pointer;
    }
    button.report {
      background: #b91c1c;
    }
    textarea {
      font-size: 0.8rem;
      padding: 0.3rem;
      resize: vertical;
      min-height: 40px;
    }
    .likes-tag {
      background: #e5e7eb;
      border-radius: 999px;
      padding: 0.2rem 0.6rem;
      font-size: 0.8rem;
      display: inline-flex;
      align-items: center;
      gap: 0.3rem;
    }
    .likes-count {
      font-weight: bold;
    }
    .heart-button {
      background: transparent;
      border: none;
      font-size: 1.4rem;
      cursor: pointer;
      padding: 0;
      line-height: 1;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }
    .heart-button.not-liked {
      color: #d1d5db; /* gris clarito */
    }
    .heart-button.liked {
      color: #ef4444; /* rojo */
    }
    nav a {
      margin-left: 0.75rem;
    }
  </style>
</head>
<body>
<header>
  <div>
    <h1>UniTok – Demo Bases de Datos</h1>
    <div style="font-size: 0.85rem;">Consulta: feed público + likes + trigger</div>
  </div>
  <div class="user-info">
    <div>Conectado como: <strong>@<?= htmlspecialchars($loggedName) ?></strong></div>
    <div style="font-size: 0.8rem;">(id_usuario = <?= (int)$USUARIO_DEMO_ID ?>)</div>
    <nav>
      <a href="notification_like.php">Ver notificaciones</a>
    </nav>
  </div>
</header>
<main>
  <h2>Videos públicos</h2>

  <?php if (empty($videos)): ?>
    <p>No hay videos públicos cargados.</p>
  <?php else: ?>
    <?php foreach ($videos as $video): ?>
      <?php
        $likedByUser = ((int)$video['liked_by_user'] > 0);
        $videoId     = (int)$video['id_video'];
      ?>
      <article class="video-card">
        <div class="video-header">
          <div>
            <h3 class="video-title">
              <?= htmlspecialchars($video['titulo']) ?>
            </h3>
            <div class="video-meta">
              Autor: @<?= htmlspecialchars($video['autor']) ?> ·
              Duración: <?= (int)$video['duracion_segundos'] ?>s ·
              Publicado: <?= htmlspecialchars($video['fecha_publicacion']) ?>
            </div>
          </div>
          <div>
            <div class="likes-tag">
              <button
                type="button"
                class="heart-button <?= $likedByUser ? 'liked' : 'not-liked' ?>"
                data-video-id="<?= $videoId ?>"
                data-liked="<?= $likedByUser ? '1' : '0' ?>"
                title="<?= $likedByUser ? 'Quitar like' : 'Dar like' ?>"
              >
                &#10084;
              </button>
              <span>Likes: <span class="likes-count" data-video-id="<?= $videoId ?>"><?= (int)$video['likes'] ?></span></span>
            </div>
          </div>
        </div>
        <div class="video-body">
          <?= nl2br(htmlspecialchars($video['descripcion'])) ?>
        </div>

        <div class="video-actions">
          <!-- Formulario: reportar video (usa transacción en report_video.php) -->
          <form class="inline" action="report_video.php" method="post">
            <input type="hidden" name="id_video" value="<?= $videoId ?>">
            <textarea name="motivo" placeholder="Motivo del reporte" required></textarea>
            <button type="submit" class="report">Reportar</button>
          </form>
        </div>
      </article>
    <?php endforeach; ?>
  <?php endif; ?>
</main>

<script>
// JS para hacer toggle del corazón (like/unlike) vía AJAX
document.addEventListener('DOMContentLoaded', () => {
  const hearts = document.querySelectorAll('.heart-button');

  hearts.forEach((btn) => {
    btn.addEventListener('click', () => {
      const videoId = btn.dataset.videoId;
      const formData = new URLSearchParams();
      formData.append('id_video', videoId);

      fetch('toggle_like.php', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData.toString(),
      })
      .then(response => response.json())
      .then(data => {
        if (!data.success) {
          alert(data.message || 'Error al procesar la reacción.');
          return;
        }

        // Actualizar estado visual del corazón
        const liked = data.liked ? true : false;
        btn.dataset.liked = liked ? '1' : '0';
        btn.classList.toggle('liked', liked);
        btn.classList.toggle('not-liked', !liked);
        btn.title = liked ? 'Quitar like' : 'Dar like';

        // Actualizar contador de likes
        if (typeof data.likes !== 'undefined') {
          const spanLikes = document.querySelector(
            '.likes-count[data-video-id="' + videoId + '"]'
          );
          if (spanLikes) {
            spanLikes.textContent = data.likes;
          }
        }
      })
      .catch(err => {
        console.error(err);
        alert('Error de comunicación con el servidor.');
      });
    });
  });
});
</script>
</body>
</html>
