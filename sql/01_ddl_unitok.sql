-- 01_ddl_unitok.sql
-- DDL principal del proyecto UniTok

CREATE DATABASE IF NOT EXISTS unitok
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE unitok;

-- Borrar tablas en orden seguro (hijas → padres)
DROP TABLE IF EXISTS notificaciones;
DROP TABLE IF EXISTS reportes;
DROP TABLE IF EXISTS playlists_videos;
DROP TABLE IF EXISTS playlists;
DROP TABLE IF EXISTS videos_hashtags;
DROP TABLE IF EXISTS hashtags;
DROP TABLE IF EXISTS reacciones_comentario;
DROP TABLE IF EXISTS reacciones_video;
DROP TABLE IF EXISTS seguimientos;
DROP TABLE IF EXISTS comentarios;
DROP TABLE IF EXISTS videos;
DROP TABLE IF EXISTS usuarios;

-- =====================================
-- Tabla: usuarios
-- =====================================
CREATE TABLE usuarios (
  id_usuario       INT NOT NULL AUTO_INCREMENT,
  username         VARCHAR(50)  NOT NULL,
  email            VARCHAR(255) NOT NULL,
  password_hash    VARCHAR(255) NOT NULL,
  nombre           VARCHAR(50)  NOT NULL,
  apellido         VARCHAR(50)  NOT NULL,
  fecha_registro   DATETIME     NOT NULL,
  fecha_nacimiento DATE         NULL,
  es_creador       BOOLEAN      NOT NULL DEFAULT FALSE,
  estado_cuenta    ENUM('activa','suspendida','bloqueada')
                   NOT NULL DEFAULT 'activa'
                   COMMENT 'activa | suspendida | bloqueada',
  CONSTRAINT pk_usuarios PRIMARY KEY (id_usuario),
  CONSTRAINT uq_usuarios_username UNIQUE (username),
  CONSTRAINT uq_usuarios_email    UNIQUE (email),
  CONSTRAINT chk_usuarios_fechas CHECK (
    fecha_nacimiento IS NULL
    OR fecha_nacimiento <= fecha_registro
  )
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='Usuarios registrados en la plataforma.';

-- =====================================
-- Tabla: videos
-- =====================================
CREATE TABLE videos (
  id_video          INT NOT NULL AUTO_INCREMENT,
  id_autor          INT NOT NULL,
  titulo            VARCHAR(150) NOT NULL,
  descripcion       TEXT NULL,
  url_archivo       TEXT NOT NULL,
  fecha_publicacion DATETIME NOT NULL,
  visibilidad       ENUM('publico','solo_seguidores','privado')
                    NOT NULL DEFAULT 'publico'
                    COMMENT 'publico | solo_seguidores | privado',
  duracion_segundos INT NOT NULL,
  es_educativo      BOOLEAN NOT NULL DEFAULT FALSE,
  estado_video      ENUM('normal','reportado','eliminado')
                    NOT NULL DEFAULT 'normal'
                    COMMENT 'normal | reportado | eliminado',
  CONSTRAINT pk_videos PRIMARY KEY (id_video),
  CONSTRAINT chk_videos_duracion CHECK (
    duracion_segundos > 0 AND duracion_segundos <= 600
  )
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='Videos cortos subidos por los usuarios.';

-- =====================================
-- Tabla: comentarios
-- =====================================
CREATE TABLE comentarios (
  id_comentario     INT NOT NULL AUTO_INCREMENT,
  id_video          INT NOT NULL,
  id_autor          INT NOT NULL,
  id_padre          INT NULL,
  texto             TEXT NOT NULL,
  fecha_creacion    DATETIME NOT NULL,
  estado_comentario ENUM('normal','oculto','eliminado')
                    NOT NULL
                    COMMENT 'normal | oculto | eliminado',
  CONSTRAINT pk_comentarios PRIMARY KEY (id_comentario)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='Comentarios sobre videos, con soporte para respuestas (anidados).';

-- =====================================
-- Tabla: seguimientos (follow)
-- =====================================
CREATE TABLE seguimientos (
  id_seguimiento    INT NOT NULL AUTO_INCREMENT,
  id_seguidor       INT NOT NULL,
  id_seguido        INT NOT NULL,
  fecha_seguimiento DATETIME NOT NULL,
  estado            ENUM('activo','bloqueado')
                    NOT NULL
                    COMMENT 'activo | bloqueado',
  CONSTRAINT pk_seguimientos PRIMARY KEY (id_seguimiento),
  CONSTRAINT uq_seguimientos_par UNIQUE (id_seguidor, id_seguido),
  CONSTRAINT chk_seguimientos_distintos CHECK (id_seguidor <> id_seguido)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='Relación de seguimiento entre usuarios.';

-- =====================================
-- Tabla: reacciones_video
-- =====================================
CREATE TABLE reacciones_video (
  id_reacciones_video INT NOT NULL AUTO_INCREMENT,
  id_usuario          INT NOT NULL,
  id_video            INT NOT NULL,
  tipo_reaccion       ENUM('like','dislike')
                      NOT NULL
                      COMMENT 'like | dislike',
  fecha_reaccion      DATETIME NOT NULL,
  CONSTRAINT pk_reacciones_video PRIMARY KEY (id_reacciones_video),
  CONSTRAINT uq_reacciones_video UNIQUE (id_usuario, id_video)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='Reacciones de usuarios a videos.';

-- =====================================
-- Tabla: reacciones_comentario
-- =====================================
CREATE TABLE reacciones_comentario (
  id_reacciones_comentario INT NOT NULL AUTO_INCREMENT,
  id_usuario               INT NOT NULL,
  id_comentario            INT NOT NULL,
  tipo_reaccion            ENUM('like','dislike')
                           NOT NULL
                           COMMENT 'like | dislike',
  fecha_reaccion           DATETIME NOT NULL,
  CONSTRAINT pk_reacciones_com PRIMARY KEY (id_reacciones_comentario),
  CONSTRAINT uq_reacciones_com UNIQUE (id_usuario, id_comentario)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='Reacciones de usuarios a comentarios.';

-- =====================================
-- Tabla: hashtags
-- =====================================
CREATE TABLE hashtags (
  id_hashtag INT NOT NULL AUTO_INCREMENT,
  texto      VARCHAR(100) NOT NULL,
  CONSTRAINT pk_hashtags PRIMARY KEY (id_hashtag),
  CONSTRAINT uq_hashtags_texto UNIQUE (texto)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='Etiquetas (hashtags) asociadas a los videos.';

-- =====================================
-- Tabla: videos_hashtags (N:M)
-- =====================================
CREATE TABLE videos_hashtags (
  id_videos_hashtag INT NOT NULL AUTO_INCREMENT,
  id_video          INT NOT NULL,
  id_hashtag        INT NOT NULL,
  CONSTRAINT pk_videos_hashtags PRIMARY KEY (id_videos_hashtag),
  CONSTRAINT uq_videos_hashtags UNIQUE (id_video, id_hashtag)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='Tabla puente N:M entre videos y hashtags.';

-- =====================================
-- Tabla: playlists
-- =====================================
CREATE TABLE playlists (
  id_playlist    INT NOT NULL AUTO_INCREMENT,
  id_usuario     INT NOT NULL,
  nombre         VARCHAR(150) NOT NULL,
  descripcion    TEXT NULL,
  es_publica     BOOLEAN NOT NULL DEFAULT TRUE,
  fecha_creacion DATETIME NOT NULL,
  CONSTRAINT pk_playlists PRIMARY KEY (id_playlist)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='Listas de reproducción creadas por los usuarios.';

-- =====================================
-- Tabla: playlists_videos (N:M + orden)
-- =====================================
CREATE TABLE playlists_videos (
  id_playlist_video INT NOT NULL AUTO_INCREMENT,
  id_playlist       INT NOT NULL,
  id_video          INT NOT NULL,
  orden             INT NOT NULL COMMENT 'Posición del video dentro de la playlist.',
  CONSTRAINT pk_playlists_videos PRIMARY KEY (id_playlist_video),
  CONSTRAINT uq_playlists_videos UNIQUE (id_playlist, id_video),
  CONSTRAINT chk_playlists_videos_orden CHECK (orden > 0)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='Tabla puente N:M entre playlists y videos, con orden.';

-- =====================================
-- Tabla: reportes
-- =====================================
CREATE TABLE reportes (
  id_reporte     INT NOT NULL AUTO_INCREMENT,
  id_usuario     INT NOT NULL COMMENT 'Id del usuario que reporta.',
  id_video       INT NULL,
  id_comentario  INT NULL,
  motivo         TEXT NOT NULL,
  detalle        TEXT NULL,
  fecha_reporte  DATETIME NOT NULL,
  estado         ENUM('abierto','en_revision','cerrado')
                 NOT NULL
                 COMMENT 'abierto | en_revision | cerrado',
  CONSTRAINT pk_reportes PRIMARY KEY (id_reporte),
  -- XOR: o video o comentario, pero no ambos ni ninguno
  CONSTRAINT chk_reportes_objeto CHECK (
    (id_video IS NOT NULL AND id_comentario IS NULL)
    OR
    (id_video IS NULL AND id_comentario IS NOT NULL)
  )
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='Reportes de contenido (video o comentario) realizados por los usuarios.';

-- =====================================
-- Tabla: notificaciones
-- =====================================
CREATE TABLE notificaciones (
  id_notificacion INT NOT NULL AUTO_INCREMENT,
  id_usuario      INT NOT NULL,
  tipo            ENUM('nuevo_seguidor','nuevo_like','nuevo_comentario','video_reportado','estado_reporte')
                  NOT NULL
                  COMMENT 'nuevo_seguidor | nuevo_like | nuevo_comentario | video_reportado | estado_reporte',
  mensaje         TEXT NOT NULL,
  fecha_creacion  DATETIME NOT NULL,
  leida           BOOLEAN NOT NULL DEFAULT FALSE,
  id_referencia   INT NULL
                  COMMENT 'Identificador lógico para enlazar con videos, comentarios o reportes según el tipo.',
  CONSTRAINT pk_notificaciones PRIMARY KEY (id_notificacion)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COMMENT='Notificaciones enviadas a los usuarios.';

-- =====================================
-- FOREIGN KEYS
-- =====================================

-- videos → usuarios
ALTER TABLE videos
  ADD CONSTRAINT fk_videos_autor
  FOREIGN KEY (id_autor)
  REFERENCES usuarios(id_usuario)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

-- comentarios → videos, usuarios, comentarios (padre)
ALTER TABLE comentarios
  ADD CONSTRAINT fk_comentarios_video
  FOREIGN KEY (id_video)
  REFERENCES videos(id_video)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

ALTER TABLE comentarios
  ADD CONSTRAINT fk_comentarios_autor
  FOREIGN KEY (id_autor)
  REFERENCES usuarios(id_usuario)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

ALTER TABLE comentarios
  ADD CONSTRAINT fk_comentarios_padre
  FOREIGN KEY (id_padre)
  REFERENCES comentarios(id_comentario)
  ON UPDATE CASCADE
  ON DELETE SET NULL;

-- seguimientos → usuarios
ALTER TABLE seguimientos
  ADD CONSTRAINT fk_seguimientos_seguidor
  FOREIGN KEY (id_seguidor)
  REFERENCES usuarios(id_usuario)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

ALTER TABLE seguimientos
  ADD CONSTRAINT fk_seguimientos_seguido
  FOREIGN KEY (id_seguido)
  REFERENCES usuarios(id_usuario)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

-- reacciones_video → usuarios, videos
ALTER TABLE reacciones_video
  ADD CONSTRAINT fk_reac_video_usuario
  FOREIGN KEY (id_usuario)
  REFERENCES usuarios(id_usuario)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

ALTER TABLE reacciones_video
  ADD CONSTRAINT fk_reac_video_video
  FOREIGN KEY (id_video)
  REFERENCES videos(id_video)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

-- reacciones_comentario → usuarios, comentarios
ALTER TABLE reacciones_comentario
  ADD CONSTRAINT fk_reac_com_usuario
  FOREIGN KEY (id_usuario)
  REFERENCES usuarios(id_usuario)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

ALTER TABLE reacciones_comentario
  ADD CONSTRAINT fk_reac_com_comentario
  FOREIGN KEY (id_comentario)
  REFERENCES comentarios(id_comentario)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

-- videos_hashtags → videos, hashtags
ALTER TABLE videos_hashtags
  ADD CONSTRAINT fk_vh_video
  FOREIGN KEY (id_video)
  REFERENCES videos(id_video)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

ALTER TABLE videos_hashtags
  ADD CONSTRAINT fk_vh_hashtag
  FOREIGN KEY (id_hashtag)
  REFERENCES hashtags(id_hashtag)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

-- playlists → usuarios
ALTER TABLE playlists
  ADD CONSTRAINT fk_playlists_usuario
  FOREIGN KEY (id_usuario)
  REFERENCES usuarios(id_usuario)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

-- playlists_videos → playlists, videos
ALTER TABLE playlists_videos
  ADD CONSTRAINT fk_plv_playlist
  FOREIGN KEY (id_playlist)
  REFERENCES playlists(id_playlist)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

ALTER TABLE playlists_videos
  ADD CONSTRAINT fk_plv_video
  FOREIGN KEY (id_video)
  REFERENCES videos(id_video)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

-- reportes → usuarios, videos, comentarios
ALTER TABLE reportes
  ADD CONSTRAINT fk_reportes_usuario
  FOREIGN KEY (id_usuario)
  REFERENCES usuarios(id_usuario)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

ALTER TABLE reportes
  ADD CONSTRAINT fk_reportes_video
  FOREIGN KEY (id_video)
  REFERENCES videos(id_video)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

ALTER TABLE reportes
  ADD CONSTRAINT fk_reportes_comentario
  FOREIGN KEY (id_comentario)
  REFERENCES comentarios(id_comentario)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

-- notificaciones → usuarios
ALTER TABLE notificaciones
  ADD CONSTRAINT fk_notificaciones_usuario
  FOREIGN KEY (id_usuario)
  REFERENCES usuarios(id_usuario)
  ON UPDATE CASCADE
  ON DELETE CASCADE;
