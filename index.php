<?php
//index.php
require 'config.php';

// Usuario demo "logueado"
$stmtUser = $pdo->prepare("SELECT id_usuario, username FROM usuarios WHERE id_usuario = :id");
$stmtUser->execute([':id' => $USUARIO_DEMO_ID]);
$loggedUser = $stmtUser->fetch();
$loggedName = $loggedUser ? $loggedUser['username'] : ('usuario_' . $USUARIO_DEMO_ID);

// 1) Traer IDs de videos para navegar 1 por 1 (estilo TikTok)
$idsStmt = $pdo->query("
  SELECT id_video
  FROM videos
  WHERE visibilidad = 'publico'
    AND estado_video = 'normal'
  ORDER BY fecha_publicacion DESC, id_video DESC
");
$videoIds = $idsStmt->fetchAll(PDO::FETCH_COLUMN);

$total = count($videoIds);
$page  = isset($_GET['p']) ? (int)$_GET['p'] : 0;
if ($page < 0) $page = 0;
if ($page > $total - 1) $page = max(0, $total - 1);

$currentId = $total > 0 ? (int)$videoIds[$page] : null;

// 2) Traer el video actual + likes + si el user ya dio like + si sigue al autor
$video = null;
if ($currentId !== null) {
  $sql = "
    SELECT
      v.id_video,
      v.titulo,
      v.descripcion,
      v.url_archivo,
      v.fecha_publicacion,
      v.duracion_segundos,
      u.id_usuario AS id_autor,
      u.username AS autor,

      -- likes totales
      (SELECT COUNT(*)
       FROM reacciones_video rv
       WHERE rv.id_video = v.id_video) AS likes,

      -- ¿el usuario demo ya dio like?
      EXISTS(
        SELECT 1 FROM reacciones_video rv2
        WHERE rv2.id_video = v.id_video
          AND rv2.id_usuario = :idUsuario_like
      ) AS liked_by_user,

      -- ¿el usuario demo sigue al autor?
      EXISTS(
        SELECT 1 FROM seguimientos s
        WHERE s.id_seguidor = :idUsuario_follow
          AND s.id_seguido  = u.id_usuario
          AND s.estado = 'activo'
      ) AS following_author

    FROM videos v
    JOIN usuarios u ON u.id_usuario = v.id_autor
    WHERE v.id_video = :idVideo
    LIMIT 1;
  ";
  $stmt = $pdo->prepare($sql);
  $stmt->execute([
    ':idUsuario_like' => $USUARIO_DEMO_ID,
    ':idUsuario_follow' => $USUARIO_DEMO_ID,
    ':idVideo'   => $currentId
  ]);
  $video = $stmt->fetch();
}

$prevPage = max(0, $page - 1);
$nextPage = min(max(0, $total - 1), $page + 1);

// helpers
function h($s) { return htmlspecialchars((string)$s); }
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>UniTok Demo</title>
  <style>
    :root{
      --bg:#0b0b0f;
      --card:#111827;
      --muted:#9ca3af;
      --white:#fff;
      --red:#ef4444;
      --grayHeart:#e5e7eb;
      --blue:#2563eb;
      --danger:#b91c1c;
    }

    body{
      margin:0;
      background:#ffffff;
      color:#111827;
      font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
      min-height:100vh;
      display:flex;
      flex-direction:column;
    }

    header{
     height: 54px;
     padding: 0 18px;
     display:flex;
     justify-content:space-between;
     align-items:center;

  /* estilo barra (como tu screenshot) */
    background: linear-gradient(180deg, #0b1b2d 0%, #0a1626 100%);
    color:#eaf2ff;

  border-bottom: 1px solid rgba(255,255,255,0.10);
  box-shadow: 0 6px 16px rgba(2, 6, 23, 0.35);

  /* quitar el estilo anterior */
  backdrop-filter: none;
}

    header .left{
     display:flex;
     flex-direction:column;
     gap:2px;
    }

    header .brand{
     font-weight:700;
     letter-spacing:0.2px;
    }

    header .sub{
     color: rgba(234,242,255,0.75);
     font-size:0.85rem;
    }

    header .right{
     text-align:right;
     font-size:0.9rem;
     color: rgba(234,242,255,0.85);
    }

    header a{
     color:#93c5fd;
     text-decoration:none;
     margin-left:12px;
     font-size:0.9rem;
     font-weight:600;
    }

    header a:hover{
      color:#bfdbfe;
      text-decoration:underline;
    }

    main{
      flex:1;
      display:flex;
      justify-content:center;
      padding:18px;
    }

    /* “Pantalla” tipo TikTok */
    .stage{
      position:relative;
      width:min(420px, 95vw);
      aspect-ratio: 9 / 16; /* vertical */
      border-radius:18px;
      overflow:hidden;
      background:#000;
      box-shadow: 0 18px 50px rgba(0,0,0,0.45);
      border:1px solid rgba(255,255,255,0.08);
    }

    .video-wrap{
      position:absolute;
      inset:0;
      display:flex;
      align-items:center;
      justify-content:center;
      background:#000;
    }

    video{
      width:100%;
      height:100%;
      object-fit:cover;
      background:#000;
    }

    /* Overlay superior: corazón + seguir */
    .overlay-top{
      position:absolute;
      top:12px;
      right:12px;
      display:flex;
      gap:10px;
      align-items:center;
      z-index:4;
    }

    .pill{
      display:inline-flex;
      align-items:center;
      gap:8px;
      padding:8px 10px;
      background:rgba(17,24,39,0.65);
      border:1px solid rgba(255,255,255,0.12);
      border-radius:999px;
      backdrop-filter: blur(8px);
    }

    .heart-btn{
      width:42px;
      height:42px;
      border-radius:999px;
      border:1px solid rgba(255,255,255,0.15);
      background:rgba(17,24,39,0.65);
      backdrop-filter: blur(8px);
      cursor:pointer;
      display:flex;
      align-items:center;
      justify-content:center;
      font-size:20px;
      line-height:1;
    }
    .heart-btn.liked{ color: var(--red); }
    .heart-btn.not-liked{ color: var(--grayHeart); }

    .follow-btn{
      border:none;
      cursor:pointer;
      font-weight:700;
      padding:10px 12px;
      border-radius:999px;
      background:var(--blue);
      color:var(--white);
    }
    .follow-btn.following{
      background:rgba(255,255,255,0.14);
      border:1px solid rgba(255,255,255,0.2);
    }
    .follow-btn:disabled{
      opacity:0.5;
      cursor:not-allowed;
    }

    /* Texto del video abajo tipo TikTok */
    .overlay-bottom{
      position:absolute;
      left:0; right:0; bottom:0;
      padding:14px 14px 12px 14px;
      z-index:3;
      background: linear-gradient(to top, rgba(0,0,0,0.78), rgba(0,0,0,0.12), rgba(0,0,0,0));
    }

    .stage{ color:#fff; }

    .meta{
      display:flex;
      flex-direction:column;
      gap:6px;
      margin-bottom:10px;
    }
    .author{
      font-weight:800;
    }
    .desc{
      color:rgba(255,255,255,0.88);
      font-size:0.95rem;
      line-height:1.25rem;
      max-height: 2.5rem;
      overflow:hidden;
    }
    .tiny{
      color:var(--muted);
      font-size:0.85rem;
    }

    /* Reporte debajo del video (pero dentro del overlay bottom) */
    .report-box{
      display:flex;
      gap:10px;
      align-items:stretch;
      margin-top:10px;
    }
    textarea{
      flex:1;
      border-radius:10px;
      border:1px solid rgba(255,255,255,0.16);
      background:rgba(17,24,39,0.55);
      color:var(--white);
      padding:10px;
      resize:vertical;
      min-height:42px;
      font-size:0.9rem;
      outline:none;
    }
    .report-btn{
      border:none;
      border-radius:10px;
      background:var(--danger);
      color:var(--white);
      font-weight:800;
      padding:10px 12px;
      cursor:pointer;
      min-width:96px;
    }

    /* Flechas laterales */
    .nav-arrow{
     position:absolute;
     top:50%;
     transform:translateY(-50%);
     z-index:6;
     width:44px;
     height:44px;
     border-radius:999px;
     display:flex;
     align-items:center;
     justify-content:center;
     text-decoration:none;
     color:white;
     font-size:26px;
     background:rgba(17,24,39,0.55);
     border:1px solid rgba(255,255,255,0.15);
     backdrop-filter: blur(8px);
    }

    .nav-arrow.left{ left:10px; }
    .nav-arrow.right{ right:10px; }

    @media (max-width: 520px){
      .nav-arrow.left{ left: 8px; }
      .nav-arrow.right{ right: 8px; }
    }

    .likes-chip{
      display:inline-flex;
      align-items:center;
      gap:8px;
      padding:7px 10px;
      border-radius:999px;
      background:rgba(17,24,39,0.65);
      border:1px solid rgba(255,255,255,0.12);
      backdrop-filter: blur(8px);
      font-size:0.9rem;
    }

    .empty{
      width:min(520px, 95vw);
      color:var(--muted);
      text-align:center;
      padding:50px 18px;
      background:rgba(255,255,255,0.04);
      border:1px solid rgba(255,255,255,0.08);
      border-radius:14px;
    }
  </style>
</head>
<body>
<header>
  <div class="left">
    <div class="brand">UniTok – Demo</div>
    <div class="sub">1 video a la vez · Like (trigger) · Follow (trigger) · Report (transacción)</div>
  </div>
  <div class="right">
    Conectado como: <strong>@<?= h($loggedName) ?></strong> (id <?= (int)$USUARIO_DEMO_ID ?>)
    <div style="margin-top:6px;">
      <a href="notification_like.php">Notificaciones</a>
    </div>
  </div>
</header>

<main>
  <?php if (!$video): ?>
    <div class="empty">
      <h2 style="color:white; margin-top:0;">No hay videos para mostrar</h2>
      <p>Revisa que existan videos en estado <code>normal</code> y visibilidad <code>publico</code>.</p>
    </div>
  <?php else: ?>
    <section class="stage">
      <?php if ($page > 0): ?>
	 <a class="nav-arrow left" href="index.php?p=<?= $prevPage ?>" title="Anterior">‹</a>
      <?php endif; ?>

      <?php if ($page < $total - 1): ?>
        <a class="nav-arrow right" href="index.php?p=<?= $nextPage ?>" title="Siguiente">›</a>
      <?php endif; ?>
      <div class="video-wrap">
        <!-- Video (puede que algunas URLs externas no permitan reproducción por CORS; igual sirve como demo visual) -->
        <video id="player" muted loop playsinline controls>
          <source src="<?= h($video['url_archivo']) ?>" type="video/mp4">
          Tu navegador no soporta video HTML5.
        </video>
      </div>

      <!-- Overlay top: corazón + seguir -->
      <div class="overlay-top">
        <button
          type="button"
          class="heart-btn <?= ((int)$video['liked_by_user'] ? 'liked' : 'not-liked') ?>"
          data-video-id="<?= (int)$video['id_video'] ?>"
          data-liked="<?= ((int)$video['liked_by_user'] ? '1' : '0') ?>"
          title="<?= ((int)$video['liked_by_user'] ? 'Quitar like' : 'Dar like') ?>"
        >&#10084;</button>

        <?php
          $isOwnVideo = ((int)$video['id_autor'] === (int)$USUARIO_DEMO_ID);
          $following  = ((int)$video['following_author'] > 0);
        ?>
        <button
          type="button"
          class="follow-btn <?= $following ? 'following' : '' ?>"
          data-target-user-id="<?= (int)$video['id_autor'] ?>"
          data-following="<?= $following ? '1' : '0' ?>"
          <?= $isOwnVideo ? 'disabled' : '' ?>
          title="<?= $isOwnVideo ? 'No puedes seguirte a ti mismo' : ($following ? 'Dejar de seguir' : 'Seguir') ?>"
        >
          <?= $isOwnVideo ? 'Tu video' : ($following ? 'Siguiendo' : 'Seguir') ?>
        </button>
      </div>

      <!-- Overlay bottom: info + reporte -->
      <div class="overlay-bottom">
        <div class="meta">
          <div class="author">@<?= h($video['autor']) ?></div>
          <div class="desc"><?= nl2br(h($video['descripcion'])) ?></div>
          <div class="tiny">
            <?= h($video['fecha_publicacion']) ?> · <?= (int)$video['duracion_segundos'] ?>s
          </div>

          <div class="likes-chip">
            <span>❤️</span>
            <span>Likes:</span>
            <strong id="likesCount"><?= (int)$video['likes'] ?></strong>
          </div>
        </div>

        <form class="report-box" action="report_video.php" method="post">
          <input type="hidden" name="id_video" value="<?= (int)$video['id_video'] ?>">
          <textarea name="motivo" placeholder="Motivo del reporte (obligatorio)" required></textarea>
          <button class="report-btn" type="submit">Reportar</button>
        </form>
      </div>
    </section>
  <?php endif; ?>
</main>

<script>
// Intento suave de autoplay (en algunos navegadores se bloquea si no hay interacción)
const player = document.getElementById('player');
if (player) { player.play().catch(()=>{}); }

// Toggle Like via AJAX (usa tu toggle_like.php)
const heart = document.querySelector('.heart-btn');
if (heart) {
  heart.addEventListener('click', () => {
    const videoId = heart.dataset.videoId;
    const formData = new URLSearchParams();
    formData.append('id_video', videoId);

    fetch('toggle_like.php', {
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: formData.toString()
    })
    .then(r => r.json())
    .then(data => {
      if (!data.success) { alert(data.message || 'Error en like'); return; }

      const liked = !!data.liked;
      heart.dataset.liked = liked ? '1' : '0';
      heart.classList.toggle('liked', liked);
      heart.classList.toggle('not-liked', !liked);
      heart.title = liked ? 'Quitar like' : 'Dar like';

      if (typeof data.likes !== 'undefined') {
        document.getElementById('likesCount').textContent = data.likes;
      }
    })
    .catch(() => alert('Error de comunicación con el servidor.'));
  });
}

// Toggle Follow via AJAX (nuevo endpoint toggle_follow.php)
const followBtn = document.querySelector('.follow-btn');
if (followBtn && !followBtn.disabled) {
  followBtn.addEventListener('click', () => {
    const targetUserId = followBtn.dataset.targetUserId;
    const formData = new URLSearchParams();
    formData.append('id_seguido', targetUserId);

    fetch('toggle_follow.php', {
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: formData.toString()
    })
    .then(r => r.json())
    .then(data => {
      if (!data.success) { alert(data.message || 'Error en follow'); return; }

      const following = !!data.following;
      followBtn.dataset.following = following ? '1' : '0';
      followBtn.classList.toggle('following', following);
      followBtn.textContent = following ? 'Siguiendo' : 'Seguir';
      followBtn.title = following ? 'Dejar de seguir' : 'Seguir';
    })
    .catch(() => alert('Error de comunicación con el servidor.'));
  });
}
</script>
</body>
</html>
