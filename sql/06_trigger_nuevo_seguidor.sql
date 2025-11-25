-- 06_trigger_nuevo_seguidor.sql
-- Trigger que crea una notificación cuando alguien te sigue

USE unitok;


DELIMITER $$

CREATE TRIGGER trg_nuevo_seguidor_notificacion
AFTER INSERT ON seguimientos
FOR EACH ROW
BEGIN
  IF NEW.estado = 'activo' THEN
    INSERT INTO notificaciones (id_usuario, tipo, mensaje, fecha_creacion, leida, id_referencia)
    SELECT
      NEW.id_seguido,
      'nuevo_seguidor',
      CONCAT('@', u.username, ' empezó a seguirte.'),
      NOW(),
      FALSE,
      NEW.id_seguidor
    FROM usuarios u
    WHERE u.id_usuario = NEW.id_seguidor;
  END IF;
END$$

DELIMITER ;
