-- 02_datos_iniciales.sql
-- Datos mínimos para arrancar la demo de UniTok

USE unitok;

-- =========================
-- USUARIOS
-- =========================
INSERT INTO usuarios
(username, email, password_hash, nombre, apellido, fecha_registro, fecha_nacimiento, es_creador, estado_cuenta)
VALUES
('laura_dev',  'laura@example.com',  'hash1', 'Laura',  'Rairan',  NOW(), '2005-03-10', TRUE,  'activa'),
('juan_coder', 'juan@example.com',   'hash2', 'Juan',   'Pérez',   NOW(), '2004-08-21', TRUE,  'activa'),
('maria_view', 'maria@example.com',  'hash3', 'María',  'Gómez',   NOW(), '2005-12-01', FALSE, 'activa');

-- IDs esperados:
-- 1 = laura_dev, 2 = juan_coder, 3 = maria_view

-- =========================
-- VIDEOS
-- =========================
INSERT INTO videos
(id_autor, titulo, descripcion, url_archivo, fecha_publicacion, visibilidad, duracion_segundos, es_educativo, estado_video)
VALUES
(1, 'Introducción a SQL',       'Curso rápido de SQL para principiantes', 'https://cdn.unitok/videos/sql_intro.mp4',  NOW(), 'publico',         60, TRUE,  'normal'),
(1, 'Triggers en MySQL',        'Ejemplo práctico de trigger para auditoría', 'https://cdn.unitok/videos/triggers.mp4', NOW(), 'publico',         45, TRUE,  'normal'),
(2, 'Vida de un developer',     'Vlog sobre el día a día de un programador', 'https://cdn.unitok/videos/devday.mp4',    NOW(), 'solo_seguidores', 30, FALSE, 'normal'),
(3, 'Tips para exámenes',       'Consejos para estudiar bases de datos',      'https://cdn.unitok/videos/exams_tips.mp4',NOW(), 'publico',         50, TRUE,  'normal');

-- IDs de video esperados: 1,2,3,4

-- =========================
-- COMENTARIOS
-- =========================
INSERT INTO comentarios
(id_video, id_autor, id_padre, texto, fecha_creacion, estado_comentario)
VALUES
(1, 2, NULL, 'Muy claro el video, gracias!',         NOW(), 'normal'),  -- id 1
(1, 1, 1,    '¡Gracias Juan! Me alegra que te sirva', NOW(), 'normal'),  -- id 2 (respuesta a 1)
(3, 3, NULL, 'Me identifiqué full con este vlog.',   NOW(), 'normal'),  -- id 3
(4, 1, NULL, 'Justo lo que necesitaba para el parcial.', NOW(), 'normal'); -- id 4

-- =========================
-- SEGUIMIENTOS
-- =========================
-- laura sigue a juan y maría; juan sigue a laura
INSERT INTO seguimientos
(id_seguidor, id_seguido, fecha_seguimiento, estado)
VALUES
(1, 2, NOW(), 'activo'),
(1, 3, NOW(), 'activo'),
(2, 1, NOW(), 'activo');

-- =========================
-- REACCIONES A VIDEOS
-- =========================
INSERT INTO reacciones_video
(id_usuario, id_video, tipo_reaccion, fecha_reaccion)
VALUES
(2, 1, 'like',    NOW()),  -- Juan da like al video de SQL
(3, 1, 'like',    NOW()),  -- María da like al video de SQL
(1, 3, 'dislike', NOW());  -- Laura da dislike en broma al vlog de Juan

-- =========================
-- REACCIONES A COMENTARIOS
-- =========================
INSERT INTO reacciones_comentario
(id_usuario, id_comentario, tipo_reaccion, fecha_reaccion)
VALUES
(1, 1, 'like', NOW()),   -- Laura da like al comentario de Juan
(2, 2, 'like', NOW());   -- Juan da like a la respuesta de Laura

-- =========================
-- HASHTAGS
-- =========================
INSERT INTO hashtags (texto)
VALUES
('#sql'),
('#mysql'),
('#developerlife'),
('#examenes'),
('#basesdedatos');

-- IDs: 1=#sql, 2=#mysql, 3=#developerlife, 4=#examenes, 5=#basesdedatos

-- =========================
-- VIDEOS_HASHTAGS
-- =========================
INSERT INTO videos_hashtags (id_video, id_hashtag)
VALUES
(1, 1), -- video 1 -> #sql
(1, 2), -- video 1 -> #mysql
(2, 1), -- video 2 -> #sql
(4, 4), -- video 4 -> #examenes
(4, 5); -- video 4 -> #basesdedatos

-- =========================
-- PLAYLISTS
-- =========================
INSERT INTO playlists
(id_usuario, nombre, descripcion, es_publica, fecha_creacion)
VALUES
(1, 'Favoritos de SQL',   'Videos de SQL para repasar antes del parcial', TRUE,  NOW()),
(3, 'Motivación dev',     'Videos para recordar por qué amo programar',    TRUE,  NOW());

-- IDs playlist: 1 (Laura), 2 (María)

-- =========================
-- PLAYLISTS_VIDEOS
-- =========================
INSERT INTO playlists_videos
(id_playlist, id_video, orden)
VALUES
(1, 1, 1), -- Favoritos de SQL: Introducción a SQL
(1, 2, 2), -- Favoritos de SQL: Triggers
(2, 3, 1), -- Motivación dev: vlog
(2, 4, 2); -- Motivación dev: tips exámenes

-- =========================
-- REPORTES
-- =========================
-- Un reporte a un video y uno a un comentario
INSERT INTO reportes
(id_usuario, id_video, id_comentario, motivo, detalle, fecha_reporte, estado)
VALUES
(3, 3, NULL, 'Contenido sensible', 'El video muestra algo que podría ser molesto', NOW(), 'abierto'),
(2, NULL, 1, 'Comentario fuera de tema', 'No aporta al contenido del video', NOW(), 'en_revision');

-- =========================
-- NOTIFICACIONES
-- =========================
INSERT INTO notificaciones
(id_usuario, tipo, mensaje, fecha_creacion, leida, id_referencia)
VALUES
(1, 'nuevo_seguidor',   'Juan (@juan_coder) ahora te sigue.',         NOW(), FALSE, 2),  -- ref: id_usuario seguidor
(1, 'nuevo_like',       'Tu video "Introducción a SQL" recibió un like.', NOW(), FALSE, 1), -- ref: id_video
(2, 'nuevo_comentario', 'Laura comentó tu video "Vida de un developer".', NOW(), FALSE, 3), -- ref lógica
(3, 'video_reportado',  'Tu video "Vida de un developer" fue reportado.', NOW(), FALSE, 3),
(3, 'estado_reporte',   'Tu reporte ha pasado a estado "en revisión".',   NOW(), FALSE, 2);
