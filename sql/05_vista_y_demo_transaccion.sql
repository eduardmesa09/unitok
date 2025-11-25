-- 05_vista_y_demo_transaccion.sql
-- Vista para la consulta recurrente del feed público

USE unitok;

DROP VIEW IF EXISTS vista_feed_publico;

CREATE VIEW vista_feed_publico AS
SELECT
  v.id_video,
  v.titulo,
  v.descripcion,
  v.fecha_publicacion,
  v.duracion_segundos,
  v.es_educativo,
  u.username AS autor,
  COALESCE(COUNT(rv.id_reacciones_video), 0) AS likes
FROM videos v
JOIN usuarios u ON v.id_autor = u.id_usuario
LEFT JOIN reacciones_video rv ON rv.id_video = v.id_video
WHERE v.visibilidad = 'publico'
  AND v.estado_video = 'normal'
GROUP BY v.id_video, v.titulo, v.descripcion, v.fecha_publicacion,
         v.duracion_segundos, v.es_educativo, u.username
ORDER BY v.fecha_publicacion DESC;
