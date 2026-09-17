# Esquema General de la Base de Datos

Kolibri separa sus datos por dominios usando prefijos de tabla. La base principal combina configuracion del dispositivo, usuarios/facilities, catalogo local de contenido, asignaciones, logs de aprendizaje y metadatos de sincronizacion.

## Bases SQLite en `kolibri-data-dev`

| Archivo | Proposito | Consultar progreso aqui |
|---|---|---|
| `db.sqlite3` | Base principal de aplicacion: usuarios, contenido local, logs, roles, asignaciones. | Si |
| `db-1.sqlite3` | Copia/variante local con el mismo esquema observada en este entorno; no es la ruta default si `DATABASE_NAME` esta vacio. | Solo si Kolibri fue configurado explicitamente para usarla |
| `content/databases/*.sqlite3` | Bases de canales de contenido importado. | No |
| `notifications.sqlite3` | Notificaciones separadas. | No |
| `sessions.sqlite3` | Sesiones HTTP. | No |
| `job_storage.sqlite3` | Cola/estado de tareas. | No |
| `syncqueue.sqlite3` | Cola de sincronizacion. | No |
| `networklocation.sqlite3` | Ubicaciones/red para discovery. | No |

## Grupos de tablas

| Prefijo | Tablas | Proposito |
|---|---:|---|
| `analytics_*` | 3 | Notificaciones y telemetria local/anonima. |
| `attendance_*` | 2 | Asistencia de usuarios. |
| `auth_*` | 3 | Tablas internas de permisos Django. |
| `bookmarks_*` | 1 | Marcadores de recursos por usuario. |
| `content_*` | 12 | Catalogo de canales, nodos, archivos y metadata de contenido. |
| `courses_*` | 3 | Cursos y asignaciones de cursos. |
| `device_*` | 8 | Configuracion y estado del dispositivo Kolibri. |
| `discovery_*` | 1 | Descubrimiento de dispositivos en red. |
| `django_*` | 2 | Infraestructura interna de Django. |
| `exams_*` | 4 | Examenes/quizzes y asignaciones. |
| `kolibriauth_*` | 5 | Facilities, usuarios, roles, grupos y membresias. |
| `lessons_*` | 3 | Lecciones y asignaciones. |
| `logger_*` | 8 | Logs de progreso, sesiones, intentos y reportes. |
| `morango_*` | 15 | Sincronizacion distribuida de datos. |
| `silk_*` | 5 | Profiling/debug de rendimiento. |

## Flujo principal para progreso de recursos

1. `kolibriauth_facilityuser` identifica al usuario.
2. `content_contentnode` identifica el recurso local visible en el arbol de contenido.
3. `logger_contentsummarylog` guarda el progreso acumulado por `user_id` y `content_id`.
4. `logger_contentsessionlog` guarda sesiones individuales de uso del recurso.
5. Para ejercicios/quizzes, `logger_masterylog` y `logger_attemptlog` agregan intentos y respuestas.

El campo clave para unir progreso con contenido es `content_id`; el campo `content_contentnode.id` identifica una ubicacion del recurso en el arbol local.
