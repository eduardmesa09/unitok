
# UniTok – Fork mejorado tipo TikTok (Proyecto de Bases de Datos)

Este repositorio contiene el proyecto **UniTok**, un fork mejorado de una aplicación tipo TikTok, desarrollado para el curso de **Bases de Datos**.

El objetivo principal es diseñar y demostrar una base de datos relacional bien normalizada (hasta 3FN/BCNF), con:

- Modelo E-R y mapeo relacional.
- Uso de **PK, FK, UNIQUE, CHECK** e integridad referencial (`ON DELETE` / `ON UPDATE`).
- **Trigger** útil (notificaciones por like).
- **Transacción** que agrupa varias operaciones lógicas.
- Demo técnica con **PHP + PDO** y formularios HTML.

---

## Tecnologías utilizadas

- **MySQL/MariaDB** (BD `unitok`)
- **PHP 8+** (extensión PDO)
- **Servidor web**: Apache (LAMP en Ubuntu)
- **HTML + CSS + JS** (fetch/AJAX para el botón de like)
- Herramienta de diagramas E-R (por ejemplo, DrawDB) para el modelo conceptual.

---

## Estructura del proyecto

Este proyecto está instalado en `/var/www/html/unitok` y se organiza así:

```text
unitok/
├─ config.php                         # Configuración PDO (host, usuario, contraseña, BD)
├─ index.php                          # Página principal: feed de videos + likes + reporte
├─ toggle_like.php       	      # Endpoint AJAX para like/unlike (usa PDO y JSON)
├─ report_video.php        	      # Procesa reporte de video con una transacción
├─ notification_like.php              # Lista notificaciones generadas por el trigger
├─ sql/
│  ├─ 01_ddl_unitok.sql               # Creación de la BD, tablas, PK/FK, UNIQUE, CHECK
│  ├─ 02_datos_iniciales.sql          # Datos base: usuarios, videos, etc.
│  ├─ 03_datos_extra_videos.sql       # Carga adicional de usuarios y ~50 videos
│  ├─ 04_trigger_notificaciones.sql   # Trigger AFTER INSERT en reacciones_video
│  └─ 05_vista_y_demo_transaccion.sql (opcional, vistas/ejemplos extra)
├─ docs/
│  ├─ modelo_ER_unitok.png            # Diagrama E-R exportado
│  ├─ normalizacion_unitok.pdf        # Proceso de normalización y dependencias
│  ├─ informe_proyecto.pdf            # Informe escrito del proyecto
│  ├─ presentacion_final.pptx         # Diapositivas para la sustentación
│  └─ video_demo.mp4                  # (Opcional) Video corto con la demo técnica
└─ README.md
```

Requisitos previos:

  1. Tener instalado y corriendo MySQL/MariaDB.
  2. Tener instalado PHP 8+ con extensión PDO para MySQL.
  3. Tener Apache instalado y corriendo (LAMP en Ubuntu).
  4. Tener el proyecto ubicado en: /var/www/html/unitok
  5. Tener permisos para crear y usar una base de datos llamada “unitok”.

##Paso 1: Verificar/encender Apache

Revisar estado:
 sudo systemctl status apache2

Si no está activo, iniciarlo:
 sudo systemctl start apache2

##Paso 2: Entrar a MySQL

Abrir MySQL (si tu root tiene contraseña, te la pedirá):
 mysql -u root -p

##Paso 3: Ejecutar el DDL (crear estructura)

Dentro de MySQL, ejecutar el script DDL:
 SOURCE /var/www/html/unitok/sql/01_ddl_unitok.sql;

##Paso 4: Cargar datos iniciales (DML)

Dentro de MySQL, cargar datos básicos:
  SOURCE /var/www/html/unitok/sql/02_datos_iniciales.sql;

Cargar datos extra (más usuarios y +50 videos):
  SOURCE /var/www/html/unitok/sql/03_datos_extra_videos.sql;

##Paso 5: Crear el trigger (notificaciones por like)

Dentro de MySQL, ejecutar el trigger:
  SOURCE /var/www/html/unitok/sql/04_trigger_notificaciones.sql;

##Paso 6 (opcional): Ejecutar vistas / scripts extra

Si existe el archivo para vistas o ejemplos:
  SOURCE /var/www/html/unitok/sql/05_vista_y_demo_transaccion.sql;

##Paso 7: Configurar credenciales en PHP

Abrir el archivo:
  nano /var/www/html/unitok/config.php

Verificar/ajustar estos valores según tu MySQL:
  $DB_HOST = 'localhost';
  $DB_NAME = 'unitok';
  $DB_USER = 'root';
  $DB_PASS = ''; (poner contraseña si aplica)

Verificar el usuario de demo:
  $USUARIO_DEMO_ID = 2;
(Asegúrate de que exista un usuario con id_usuario=2 en la tabla usuarios, esto lo crean los scripts DML.)

##Paso 8: Abrir la demo en el navegador

Ir a:
  http://localhost/unitok/index.php

Deberías ver:
  - El feed de videos públicos
  - El nombre del usuario logueado
  - Corazones de like/unlike junto al contador de likes
  - Caja de texto y botón para reportar cada video

##Paso 9: Qué probar en la demo

Consulta: el feed de videos públicos aparece en index.php con autores y conteo de likes.

Trigger: dar like con el corazón (se pone rojo) y luego abrir:
  http://localhost/unitok/notification_like.php

O, simplemente dar click en la seccion notificaciones para ver que se creó una notificación automáticamente.

Transacción: reportar un video con el formulario “Reportar”; el sistema inserta el reporte y cambia el estado del video a “reportado”, por eso desaparece del feed (porque el feed filtra estado_video='normal').

##En la carpeta docs/ se incluyen los recursos de las entregas previas

#Créditos

Proyecto desarrollado por: Eduard meza Salazar

Asignatura: Bases de Datos

Institución: Universidad de la Sabana

Cualquier persona puede clonar este repositorio, ejecutar los scripts SQL, ajustar config.php con sus credenciales, y levantar la demo PHP para explorar la base de datos y la lógica de negocio implementada en UniTok.
