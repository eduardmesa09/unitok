-- 04_trigger_notificaciones.sql
-- Trigger que crea una notificación cuando alguien da like a un video

USE unitok;

DROP TRIGGER IF EXISTS trg_like_video_notificacion;

DELIMITER $$

CREATE TRIGGER trg_like_video_notificacion
AFTER INSERT ON reacciones_video
FOR EACH ROW
BEGIN
  IF NEW.tipo_reaccion = 'like' THEN
    INSERT INTO notificaciones (id_usuario, tipo, mensaje, fecha_creacion, leida, id_referencia)
    SELECT
      v.id_autor,
      'nuevo_like',
      CONCAT('Tu video "', v.titulo, '" recibió un nuevo like.'),
      NOW(),
      FALSE,
      NEW.id_video
    FROM videos v
    WHERE v.id_video = NEW.id_video;
  END IF;
END$$

DELIMITER ;
