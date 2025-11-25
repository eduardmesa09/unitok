-- 03_datos_extra_videos.sql
-- Más usuarios y muchos videos adicionales para que el feed se vea lleno

USE unitok;

-- Más usuarios (id_usuario = 4 .. 15)
INSERT INTO usuarios
(username, email, password_hash, nombre, apellido, fecha_registro, fecha_nacimiento, es_creador, estado_cuenta)
VALUES
('data_girl',     'data_girl@example.com',     'hash4',  'Ana',      'Ramírez',   NOW(), '2005-02-14', TRUE,  'activa'),
('sql_master',    'sql_master@example.com',    'hash5',  'Carlos',   'López',    NOW(), '2004-11-02', TRUE,  'activa'),
('noob_coder',    'noob_coder@example.com',    'hash6',  'Diego',    'Martínez', NOW(), '2005-06-28', FALSE, 'activa'),
('backend_nerd',  'backend_nerd@example.com',  'hash7',  'Valeria',  'Suárez',   NOW(), '2004-09-10', TRUE,  'activa'),
('front_life',    'front_life@example.com',    'hash8',  'Andrés',   'Castro',   NOW(), '2005-01-21', FALSE, 'activa'),
('db_senior',     'db_senior@example.com',     'hash9',  'Julián',   'Rojas',    NOW(), '1998-03-15', TRUE,  'activa'),
('sysadmin_pro',  'sysadmin_pro@example.com',  'hash10', 'Paula',    'Herrera',  NOW(), '1997-07-07', TRUE,  'activa'),
('dev_ops',       'dev_ops@example.com',       'hash11', 'Sergio',   'Mora',     NOW(), '1999-10-19', TRUE,  'activa'),
('ai_lover',      'ai_lover@example.com',      'hash12', 'Camila',   'Reyes',    NOW(), '2003-12-25', TRUE,  'activa'),
('linux_penguin', 'linux_penguin@example.com', 'hash13', 'Felipe',   'Duarte',   NOW(), '2002-05-30', FALSE, 'activa'),
('coffee_coder',  'coffee_coder@example.com',  'hash14', 'Daniela',  'Vega',     NOW(), '2001-04-18', TRUE,  'activa'),
('cloud_native',  'cloud_native@example.com',  'hash15', 'Nicolás',  'Santos',   NOW(), '2000-08-09', TRUE,  'activa');

-- Muchos videos adicionales (feed lleno)
INSERT INTO videos
(id_autor, titulo, descripcion, url_archivo, fecha_publicacion, visibilidad, duracion_segundos, es_educativo, estado_video)
VALUES
(1,  'SELECT básico en SQL',                 'Explico cómo hacer SELECT, WHERE y ORDER BY.',                 'https://cdn.unitok/videos/sql_select_basico.mp4',              NOW(), 'publico',         60,  TRUE,  'normal'),
(1,  'JOINS en 5 minutos',                   'Inner join, left join y right join con ejemplos.',            'https://cdn.unitok/videos/sql_joins_5min.mp4',                 NOW(), 'publico',         90,  TRUE,  'normal'),
(2,  'Mi rutina de estudio de BD',           'Cómo organizo mi tiempo para el parcial de bases de datos.',  'https://cdn.unitok/videos/rutina_bd.mp4',                      NOW(), 'solo_seguidores', 45,  FALSE, 'normal'),
(2,  'Errores típicos con claves foráneas',  'FK que fallan y cómo depurarlas.',                            'https://cdn.unitok/videos/errores_fk.mp4',                     NOW(), 'publico',         70,  TRUE,  'normal'),
(3,  'Cómo no morir en el proyecto final',   'Tips para no dejar todo para el final.',                      'https://cdn.unitok/videos/proyecto_final_tips.mp4',            NOW(), 'publico',         50,  FALSE, 'normal'),
(4,  'Normalización hasta 3FN',              'Paso a paso desde tabla fea hasta 3FN.',                      'https://cdn.unitok/videos/normalizacion_3fn.mp4',              NOW(), 'publico',        110,  TRUE,  'normal'),
(4,  'Qué es una dependencia transitiva',    'Definición y ejemplo práctico con usuarios y videos.',        'https://cdn.unitok/videos/dependencia_transitiva.mp4',         NOW(), 'publico',         80,  TRUE,  'normal'),
(4,  'BCNF con dibujitos',                   'Explicación de BCNF con ejemplos muy visuales.',              'https://cdn.unitok/videos/bcnf_dibujos.mp4',                   NOW(), 'publico',        120,  TRUE,  'normal'),
(5,  'Triggers útiles en proyectos pequeños','Ideas de triggers simples que sí aportan valor.',             'https://cdn.unitok/videos/triggers_utiles.mp4',                NOW(), 'publico',         75,  TRUE,  'normal'),
(5,  'Cuando NO usar un trigger',            'Casos donde es mejor lógica en la app que en la BD.',         'https://cdn.unitok/videos/no_trigger.mp4',                     NOW(), 'publico',         65,  TRUE,  'normal'),
(5,  'Storytime: rompí producción con un trigger','Lo que aprendí de ese desastre.',                         'https://cdn.unitok/videos/storytime_trigger_fail.mp4',         NOW(), 'solo_seguidores', 55,  FALSE, 'normal'),
(6,  'Índices y performance',                'Cómo un índice cambia el plan de ejecución.',                 'https://cdn.unitok/videos/indices_performance.mp4',            NOW(), 'publico',         90,  TRUE,  'normal'),
(6,  'EXPLAIN en MySQL',                     'Leemos el plan de ejecución para entender la consulta.',      'https://cdn.unitok/videos/explain_mysql.mp4',                  NOW(), 'publico',        100, TRUE,  'normal'),
(6,  'Index scan vs full scan',              'Simulación visual de ambos casos.',                           'https://cdn.unitok/videos/index_vs_fullscan.mp4',              NOW(), 'publico',         85,  TRUE,  'normal'),
(7,  'Backup y restore de BD',               'Buenas prácticas para no perder tu proyecto.',                'https://cdn.unitok/videos/backup_restore.mp4',                 NOW(), 'publico',         70,  TRUE,  'normal'),
(7,  'Qué es una transacción',               'BEGIN, COMMIT, ROLLBACK explicado con dibujitos.',            'https://cdn.unitok/videos/transacciones_explicadas.mp4',       NOW(), 'publico',         80,  TRUE,  'normal'),
(7,  'Historias de caídas de sistemas',      'Anécdotas de producción y cómo se solucionaron.',             'https://cdn.unitok/videos/historias_caidas.mp4',               NOW(), 'publico',         95,  FALSE, 'normal'),
(8,  'Deploy de un proyecto PHP+MySQL',      'Subiendo tu app al servidor por primera vez.',                'https://cdn.unitok/videos/deploy_php_mysql.mp4',               NOW(), 'publico',         75,  TRUE,  'normal'),
(8,  'PDO vs mysqli',                        'Por qué usamos PDO en este proyecto.',                        'https://cdn.unitok/videos/pdo_vs_mysqli.mp4',                  NOW(), 'publico',         60,  TRUE,  'normal'),
(8,  'Errores comunes con PDO',              'Try/catch, excepciones y encoding.',                          'https://cdn.unitok/videos/errores_pdo.mp4',                    NOW(), 'publico',         55,  TRUE,  'normal'),
(9,  'Introducción a IA para devs',          'Qué puede y qué no puede hacer la IA en tu día a día.',      'https://cdn.unitok/videos/ia_para_devs.mp4',                   NOW(), 'publico',         90,  TRUE,  'normal'),
(9,  'Prompt engineering básico',            'Trucos para pedirle bien ayuda a los modelos.',               'https://cdn.unitok/videos/prompt_engineering.mp4',             NOW(), 'publico',         80,  TRUE,  'normal'),
(9,  'Mi setup para estudiar en casa',       'Organización, escritorio y apps favoritas.',                  'https://cdn.unitok/videos/setup_estudio.mp4',                  NOW(), 'solo_seguidores', 45,  FALSE, 'normal'),
(10, 'Comandos básicos en Linux',            'ls, cd, grep, tail, etc. para sobrevivir.',                   'https://cdn.unitok/videos/linux_basico.mp4',                   NOW(), 'publico',         70,  TRUE,  'normal'),
(10, 'Permisos en Linux explicados',         'rwx para usuario, grupo y otros con ejemplos.',               'https://cdn.unitok/videos/linux_permisos.mp4',                 NOW(), 'publico',         85,  TRUE,  'normal'),
(10, 'Script bash para backups diarios',     'Automatizando copias de seguridad.',                          'https://cdn.unitok/videos/bash_backup.mp4',                    NOW(), 'publico',         60,  TRUE,  'normal'),
(11, 'Mi día en la facultad',                'Vlog de un día normal como estudiante de ingeniería.',        'https://cdn.unitok/videos/dia_facultad.mp4',                   NOW(), 'publico',         50,  FALSE, 'normal'),
(11, 'Cómo organizo mi Trello del proyecto', 'Columnas, tarjetas y checklists para no morir.',              'https://cdn.unitok/videos/trello_proyecto.mp4',                NOW(), 'publico',         65,  FALSE, 'normal'),
(11, 'Tips para exposiciones orales',        'Cómo no congelarse frente al profe y al grupo.',              'https://cdn.unitok/videos/tips_exposiciones.mp4',              NOW(), 'publico',         55,  TRUE,  'normal'),
(12, 'Docker para principiantes',            'Qué es una imagen, un contenedor y un volumen.',              'https://cdn.unitok/videos/docker_basico.mp4',                  NOW(), 'publico',         95,  TRUE,  'normal'),
(12, 'docker-compose en 10 minutos',         'Levantar varios servicios a la vez.',                         'https://cdn.unitok/videos/docker_compose_10min.mp4',           NOW(), 'publico',         80,  TRUE,  'normal'),
(12, 'Errores típicos con Docker',           'Puertos, redes y permisos que suelen fallar.',                'https://cdn.unitok/videos/errores_docker.mp4',                 NOW(), 'publico',         75,  TRUE,  'normal'),
(13, 'Buenas prácticas con Git',             'Commits pequeños, ramas claras y mensajes útiles.',           'https://cdn.unitok/videos/git_practicas.mp4',                  NOW(), 'publico',         70,  TRUE,  'normal'),
(13, 'Git rebase vs merge',                  'Cuándo usar cada uno, con dibujitos.',                        'https://cdn.unitok/videos/git_rebase_merge.mp4',               NOW(), 'publico',         85,  TRUE,  'normal'),
(13, 'Cómo escribir buenos mensajes de commit','Ejemplos reales de mensajes claros.',                        'https://cdn.unitok/videos/git_commits_buenos.mp4',             NOW(), 'publico',         60,  TRUE,  'normal'),
(14, 'Introducción a redes',                 'IP, máscara, gateway explicado fácil.',                       'https://cdn.unitok/videos/redes_intro.mp4',                    NOW(), 'publico',         90,  TRUE,  'normal'),
(14, 'Subredes con ejemplos',                'Dividir una red en subredes paso a paso.',                    'https://cdn.unitok/videos/subredes_ejemplos.mp4',              NOW(), 'publico',        110,  TRUE,  'normal'),
(14, 'OSI vs TCP/IP',                        'Capas del modelo y cómo se aterrizan.',                       'https://cdn.unitok/videos/osi_tcpip.mp4',                      NOW(), 'publico',         80,  TRUE,  'normal'),
(15, 'Introducción a la nube',               'IaaS, PaaS, SaaS explicado con ejemplos cotidianos.',         'https://cdn.unitok/videos/nube_intro.mp4',                     NOW(), 'publico',         85,  TRUE,  'normal'),
(15, 'Desplegando en la nube barata',        'Opciones low-cost para proyectos de la U.',                   'https://cdn.unitok/videos/nube_barata.mp4',                    NOW(), 'publico',         75,  TRUE,  'normal'),
(15, 'Errores típicos de seguridad en la nube','Configuraciones abiertas y malas prácticas.',               'https://cdn.unitok/videos/nube_seguridad_errores.mp4',        NOW(), 'publico',         90,  TRUE,  'normal'),
(1,  'Checklist antes del parcial',          'Lo que reviso la noche antes del examen de BD.',              'https://cdn.unitok/videos/checklist_parcial_bd.mp4',           NOW(), 'publico',         55,  TRUE,  'normal'),
(2,  'Repasando claves primarias y foráneas','Ejemplos rápidos para no confundirse.',                       'https://cdn.unitok/videos/repaso_pk_fk.mp4',                   NOW(), 'publico',         50,  TRUE,  'normal'),
(3,  'Qué llevar a un laboratorio de BD',    'Laptop, cable, backup y buena actitud.',                      'https://cdn.unitok/videos/lab_bd_que_llevar.mp4',              NOW(), 'publico',         45,  FALSE, 'normal'),
(4,  'Explicando mi modelo E-R',             'Recorro las entidades principales de nuestro proyecto.',      'https://cdn.unitok/videos/explicando_modelo_er.mp4',           NOW(), 'publico',         80,  TRUE,  'normal'),
(5,  'Cómo documenté mi DDL',                'Mostrar el script SQL con comentarios claros.',               'https://cdn.unitok/videos/documentar_ddl.mp4',                 NOW(), 'publico',         65,  TRUE,  'normal'),
(6,  'Probando integridad referencial',      'Borrando y viendo qué pasa con CASCADE y SET NULL.',         'https://cdn.unitok/videos/probando_fk.mp4',                    NOW(), 'publico',         75,  TRUE,  'normal'),
(7,  'Simulando transacciones fallidas',     'Ejemplos donde hacemos ROLLBACK a propósito.',                'https://cdn.unitok/videos/transacciones_fail.mp4',             NOW(), 'publico',         85,  TRUE,  'normal'),
(8,  'Qué mostrar en la demo de BD',         'Consejos para la sustentación final.',                        'https://cdn.unitok/videos/demo_bd_consejos.mp4',               NOW(), 'publico',         70,  TRUE,  'normal'),
(9,  'Cómo explicar un trigger al profe',    'Guion corto para que se entienda rápido.',                    'https://cdn.unitok/videos/explicar_trigger.mp4',               NOW(), 'publico',         60,  TRUE,  'normal'),
(10, 'Mis errores al diseñar el modelo',     'Lo que corregí gracias al feedback.',                         'https://cdn.unitok/videos/errores_modelo_bd.mp4',              NOW(), 'publico',         75,  TRUE,  'normal'),
(11, 'Vista para el feed de videos',         'Cómo armé el SELECT para la vista principal.',                'https://cdn.unitok/videos/vista_feed_videos.mp4',              NOW(), 'publico',         55,  TRUE,  'normal'),
(12, 'Clases online: cómo tomar apuntes',    'Ideas para no dormirte en la clase virtual.',                 'https://cdn.unitok/videos/apuntes_clases_online.mp4',          NOW(), 'publico',         50,  FALSE, 'normal'),
(13, 'Organizando el repositorio en GitHub', 'Estructura de carpetas para el proyecto de BD.',              'https://cdn.unitok/videos/github_estructura_bd.mp4',           NOW(), 'publico',         65,  TRUE,  'normal'),
(14, 'Checklist del Readme',                 'Qué poner en el Readme para que cualquiera pueda usar tu repo.','https://cdn.unitok/videos/checklist_readme.mp4',           NOW(), 'publico',         55,  TRUE,  'normal'),
(15, 'Qué aprendí de este curso',            'Reflexión final sobre diseño de bases de datos.',             'https://cdn.unitok/videos/reflexion_curso_bd.mp4',             NOW(), 'publico',         80,  TRUE,  'normal');
