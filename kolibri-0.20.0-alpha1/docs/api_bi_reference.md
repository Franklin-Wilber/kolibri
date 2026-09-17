# Kolibri API y datos disponibles para BI

Este documento resume las APIs REST expuestas por esta aplicacion Kolibri y los
datos que pueden usarse para reportes BI.

## Resumen ejecutivo

Kolibri expone APIs Django REST Framework bajo `/api/` y APIs de plugins bajo
`/<plugin>/api/`.

Para BI, las fuentes mas valiosas son:

- Progreso e interaccion con recursos: `/api/logger/trackprogress/`,
  `/api/logger/attemptlog/`, `/api/logger/masterylog/`,
  `/api/content/contentnodeprogress/`.
- Catalogo de contenido: `/api/content/channel/`,
  `/api/content/contentnode/`, `/api/content/contentnode_tree/`,
  `/api/content/file/`.
- Usuarios, grupos y aulas: `/api/auth/facilityuser/`,
  `/api/auth/classroom/`, `/api/auth/learnergroup/`,
  `/api/auth/membership/`, `/api/auth/role/`.
- Asignaciones: `/api/lessons/lesson/`, `/api/courses/coursesession/`,
  `/api/exams/exam/`.
- Asistencia: `/api/attendance/attendancesession/`,
  `/api/attendance/attendancerecord/`.
- Reportes agregados para coaches: `/coach/api/classsummary/`,
  `/coach/api/lessonreport/`, `/coach/api/notifications/`.
- Exportacion CSV: `/api/logger/generatecsvlogrequest/` y
  `/facility/api/downloadcsvfile/...`.

Importante: el propio codigo marca como estables solo los endpoints bajo
`/api/public/`. El resto son APIs internas usadas por el frontend y pueden
cambiar entre versiones.

## Documentacion interactiva

En modo desarrollo existe documentacion Swagger/OpenAPI:

- Swagger UI: `/api_explorer/`
- OpenAPI/Swagger JSON: `/swagger.json`
- OpenAPI/Swagger YAML: `/swagger.yaml`
- ReDoc: `/redoc/`

Estas rutas se agregan solo con `kolibri.deployment.default.settings.dev`.

## Convenciones generales

- Base interna: `/api/`
- Base publica estable: `/api/public/`
- Base de plugins: `/<plugin_slug>/api/`, por ejemplo `/learn/api/`.
- La mayoria de recursos DRF exponen:
  - `GET /recurso/`
  - `POST /recurso/` si es escribible
  - `GET /recurso/<id>/`
  - `PUT/PATCH /recurso/<id>/` si es escribible
  - `DELETE /recurso/<id>/` si es borrable
- Autenticacion principal: sesion Django. En modo desarrollo tambien se habilita
  Basic Auth para herramientas externas.
- Muchas APIs internas requieren permisos de admin, coach, superuser o usuario
  autenticado.
- Los UUID suelen representarse como strings hexadecimales de 32 caracteres.

## API core

### `/api/auth/`

Gestiona facilities, usuarios, sesiones, aulas, grupos y permisos.

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/api/auth/session/` | POST, PUT, DELETE | Login/logout/sesion actual | No es dataset BI; sirve para autenticacion |
| `/api/auth/facilitydataset/` | CRUD | configuracion de facility dataset | Segmentacion institucional |
| `/api/auth/facility/` | CRUD | `id`, `name`, `dataset`, `num_classrooms`, `num_users`, `num_learners`, ultimos syncs | Dimension facility |
| `/api/auth/facilityuser/` | CRUD, bulk delete | `id`, `username`, `full_name`, `facility`, `roles`, `is_superuser`, `id_number`, `gender`, `birth_year`, `extra_demographics`, `date_joined` | Dimension usuario/learner |
| `/api/auth/deletedfacilityuser/` | GET | campos de usuario + `date_deleted` | Auditoria de usuarios eliminados |
| `/api/auth/classroom/` | CRUD | `id`, `name`, `parent`, `learner_count`, `coaches` | Dimension aula/clase |
| `/api/auth/learnergroup/` | CRUD | `id`, `name`, `parent`, `user_ids` | Dimension grupos |
| `/api/auth/membership/` | CRUD, bulk create/delete | `id`, `collection`, `user` | Puente usuario-grupo/aula |
| `/api/auth/role/` | CRUD, bulk create/delete | `id`, `kind`, `collection`, `user` | Roles: admin, coach, learner context |
| `/api/auth/signup/` | POST | alta de usuario | Operacional |
| `/api/auth/portal/` | GET/POST actions | portal de datos Kolibri | Integracion interna |
| `/api/auth/setnonspecifiedpassword` | POST | password no especificado | Operacional |
| `/api/auth/usernameavailable` | GET | disponibilidad de username | Operacional |
| `/api/auth/ispinvalid/<user_id>` | GET | validacion PIN | Operacional |
| `/api/auth/remotefacilityuser` | GET | busqueda usuario remoto | Sync/import |
| `/api/auth/remotefacilityauthenticateduserinfo` | GET | usuario remoto autenticado | Sync/import |
| `/api/auth/deleteimporteduser/<user_id>` | DELETE/POST segun view | elimina usuario importado | Operacional |

Filtros utiles:

- `facilityuser`: busqueda por `search`, orden por `username`, `full_name`,
  `id_number`, `gender`, `birth_year`, `date_joined`.
- `classroom`: `parent`, `role`.
- `learnergroup`: `parent`.
- `membership`: `user`, `collection`, `user_ids`, `by_ids`.
- `role`: `user`, `collection`, `kind`, `user_ids`, `by_ids`.

### `/api/content/`

Catalogo de canales, nodos de contenido, archivos, progreso por usuario y
solicitudes de descarga.

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/api/content/channel/` | GET list/retrieve | `id`, `name`, `description`, `tagline`, `author`, `root`, `lang_code`, `lang_name`, `version`, `last_updated`, `available`, `num_coach_contents`, `public` | Dimension canal |
| `/api/content/contentnode/` | GET list/retrieve | nodo de contenido con metadata, archivos, tags, idioma, arbol | Dimension recurso/topico |
| `/api/content/contentnode/random/` | GET | recursos aleatorios filtrados | Exploracion |
| `/api/content/contentnode/descendants_assessments/` | GET | `id`, `num_assessments` | Conteos de evaluaciones por rama |
| `/api/content/contentnode/<id>/recommendations_for/` | GET | recursos similares | Recomendaciones |
| `/api/content/usercontentnode/` | GET | content nodes con `last_interacted` del usuario | Recursos recientes |
| `/api/content/contentnode_tree/<id>/` | GET | arbol de contenido con hijos | Jerarquia de contenido |
| `/api/content/contentnode_bookmarks/` | GET | nodos marcados por usuario | Biblioteca personal |
| `/api/content/contentnodeprogress/` | GET | `content_id`, `progress`, `num_question_answered`, `num_question_answered_correctly`, `total_questions` | Fact de progreso por recurso |
| `/api/content/contentnodeprogress/<id>/tree/` | GET | progreso para un subarbol | BI de progreso por topico |
| `/api/content/file/` | GET | `id`, `checksum`, `storage_url`, `extension`, `file_size`, `preset`, `lang`, `available`, `supplementary`, `thumbnail` | Inventario de archivos/tamano |
| `/api/content/contentrequest/` | GET, POST | solicitudes de descarga de contenido | Demanda de contenido |
| `/api/content/contentnode_granular/<id>/` | GET | metadata granular para import/export | Administracion de contenido |
| `/api/content/remotechannel/` | GET | canales remotos | Administracion/sync |
| `/api/content/remotechannel/<id>/` | GET | canal remoto especifico | Administracion/sync |
| `/api/content/remotechannel/localimportmetadata/` | GET | metadata local importable | Administracion/sync |
| `/api/content/channel-thumbnail/<channel_id>/` | GET | thumbnail de canal | Asset |
| `/api/content/sharefile/` | POST | compartir archivo | Operacional |

Campos principales de `contentnode`:

- Identidad: `id`, `content_id`, `channel_id`, `parent`, `tree_id`.
- Jerarquia: `lft`, `rght`, `sort_order`, `ancestors`, `is_leaf`.
- Metadata: `title`, `description`, `author`, `kind`, `duration`, `modality`.
- Disponibilidad: `available`, `coach_content`, `num_coach_contents`,
  `on_device_resources`.
- Clasificacion: `learning_activities`, `grade_levels`, `resource_types`,
  `accessibility_labels`, `learner_needs`, `categories`, `tags`.
- Licencia: `license_name`, `license_description`, `license_owner`.
- Recursos relacionados: `files`, `thumbnail`, `lang`, `assessmentmetadata`.

Filtros utiles de `contentnode`:

- `ids`, `channels`, `languages`, `kind`, `kind_in`.
- `search`, `question` o `keywords` para busqueda textual.
- `authors`, `tags`, `learning_activities`, `grade_levels`,
  `resource_types`, `accessibility_labels`, `learner_needs`, `categories`.
- `descendant_of`, `lft__gt`, `rght__lt`.
- `include_coach_content`, `exclude_content_ids`, `exclude_modalities`,
  `exclude_course_ancestry`, `contains_quiz`.
- Paginacion: `max_results`, cursor; en algunos endpoints `page_size` y `page`.

### `/api/logger/`

Es la fuente principal para analitica de interaccion y progreso.

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/api/logger/trackprogress/` | POST | inicia una sesion de contenido | Ingesta desde frontend |
| `/api/logger/trackprogress/<session_id>/` | PUT | actualiza progreso, tiempo, estado e interacciones | Ingesta desde frontend |
| `/api/logger/userprogress/<user_id>/` | GET | total de recursos/progreso completado del usuario | KPI general de avance |
| `/api/logger/attemptlog/` | GET | intentos por pregunta/item | Fact de respuestas |
| `/api/logger/masterylog/` | GET | intentos de dominio por ejercicio/quiz | Fact de mastery/quiz |
| `/api/logger/masterylog/<index>/diff/` | GET | diferencias entre intentos | Analisis de mejora |
| `/api/logger/generatecsvlogrequest/` | CRUD | solicitud de generacion CSV | Export BI |

Payload de inicio de sesion en `trackprogress`:

- Recurso: `node_id`, `content_id`, `channel_id`, `kind`.
- Contexto opcional: `lesson_id`, `course_session_id`.
- Quiz: `quiz_id`.
- Pre/post test: `unit_id`, `test_type`, `course_session_id`.
- Evaluacion: `mastery_model`.
- `repeat`: reinicia progreso del recurso/intento.

Payload de actualizacion en `trackprogress/<session_id>/`:

- `progress_delta` o `progress`.
- `time_spent_delta`.
- `extra_fields`, especialmente `contentState`.
- `interactions`: `item`, `correct`, `complete`, `time_spent`, `answer`,
  `simple_answer`, `error`, `hinted`, `replace`.

Campos de `attemptlog`:

- `id`, `item`, `start_timestamp`, `end_timestamp`, `completion_timestamp`.
- `time_spent`, `complete`, `correct`, `hinted`, `error`.
- `answer`, `simple_answer`, `interaction_history`.
- `user`, `masterylog`, `sessionlog`.

Filtros de `attemptlog`:

- `masterylog`, `complete`, `user`, `content`, `item`, `mastery_level`.

Campos de `masterylog`:

- `id`, `mastery_criterion`, `start_timestamp`, `end_timestamp`.
- `completion_timestamp`, `complete`, `correct`, `time_spent`.

Filtros de `masterylog`:

- `content`, `user`, `complete`, `quiz`.

Tablas/modelos de fondo importantes para BI:

- `ContentSessionLog`: una visita/sesion de un recurso. Tiene `user`,
  `visitor_id`, `content_id`, `channel_id`, `start_timestamp`,
  `end_timestamp`, `time_spent`, `progress`, `kind`, `extra_fields`.
- `ContentSummaryLog`: resumen acumulado por usuario y recurso. Tiene `user`,
  `content_id`, `channel_id`, timestamps, `completion_timestamp`,
  `time_spent`, `progress`, `kind`, `extra_fields`.
- `MasteryLog`: intento de dominio para ejercicios/quizzes.
- `AttemptLog`: respuesta/intento por pregunta/item.

### `/api/bookmarks/`

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/api/bookmarks/bookmarks/` | CRUD | `id`, `channel_id`, `content_id`, `contentnode_id`, `user` | Interes del usuario / biblioteca personal |

Filtros:

- `contentnode_id`.
- `descendant_of` para obtener bookmarks bajo un topico.

### `/api/exams/`

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/api/exams/exam/` | CRUD | quizzes/examenes asignados | Dimension quiz/asignacion |
| `/api/exams/exam/size/` | GET | tamano total por quiz | Inventario |

Campos principales:

- `id`, `title`, `question_sources`, `seed`, `active`, `archive`.
- `collection`, `assignments`, `learner_ids`.
- `learners_see_fixed_order`, `instant_report_visibility`.
- `question_count`, `creator`, `data_model_version`.
- `date_created`, `date_archived`, `date_activated`.
- `draft`.

### `/api/lessons/`

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/api/lessons/lesson/` | CRUD | lecciones, recursos asignados, grupos asignados | Dimension asignaciones |
| `/api/lessons/lesson/size/` | GET | tamano total por leccion | Inventario |

Campos principales:

- `id`, `title`, `description`, `resources`, `active`.
- `collection`, `classroom`, `assignments`, `learner_ids`.
- `created_by`, `date_created`.

Cada recurso de una leccion incluye:

- `content_id`, `channel_id`, `contentnode_id`.

### `/api/courses/`

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/api/courses/coursesession/` | CRUD | cursos asignados como sesiones | Dimension curso/asignacion |
| `/api/courses/coursesession/<id>/activate_test/` | POST | activa pre/post test de una unidad | Seguimiento curso |
| `/api/courses/coursesession/<id>/close_test/` | POST | cierra test activo | Seguimiento curso |
| `/api/courses/coursesession/<id>/active_test/` | GET | test activo | Estado operativo |
| `/api/courses/coursesession/<id>/last_unit_test/` | GET | ultimo test de unidad | Estado operativo |

Campos principales:

- `id`, `title`, `description`, `course`, `active`.
- `collection`, `classroom`, `created_by`, `date_created`.
- `assignments`, `learner_ids`, `missing_resource`.
- `unit_phase`, `active_unit_number`, `active_unit_title`.
- `test_learner_progress`.

### `/api/attendance/`

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/api/attendance/attendancesession/` | CRUD | sesiones de asistencia | Fact asistencia |
| `/api/attendance/attendancesession/recent/` | GET | sesiones recientes | Dashboard operativo |
| `/api/attendance/attendancerecord/` | GET | registros usuario-presente | Fact asistencia detalle |
| `/api/attendance/attendancerecord/bulk_update/` | POST | actualizacion masiva | Operacional |

Campos de `attendancesession`:

- `id`, `collection`, `created_by`, `session_start_datetime`.
- `date_created`, `date_modified`, `present_count`, `total_count`.
- En escritura puede recibir `attendance_records`.

Campos de `attendancerecord`:

- `id`, `user`, `present`, `attendance_session`, `user_name`,
  `user_username`.

Filtros:

- `attendancesession`: `collection`, `start_date`, `end_date`.
- `attendancerecord`: `attendance_session`.

### `/api/tasks/`

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/api/tasks/tasks/` | GET, POST | jobs asincronos | Monitoreo operacional |
| `/api/tasks/tasks/<job_id>/` | GET, PUT/PATCH, DELETE | estado job | Monitoreo operacional |
| `/api/tasks/tasks/<job_id>/restart/` | POST | reinicia job | Operacional |
| `/api/tasks/tasks/<job_id>/cancel/` | POST | cancela job | Operacional |
| `/api/tasks/tasks/<job_id>/clear/` | POST | limpia job finalizado | Operacional |
| `/api/tasks/tasks/clearall/` | POST | limpia jobs finalizados | Operacional |

Campos de respuesta de job:

- `id`, `type`, `status`, `exception`, `traceback`, `percentage`.
- `cancellable`, `clearable`, `facility_id`.
- `args`, `kwargs`, `extra_metadata`.
- `scheduled_datetime`, `last_finished_status`,
  `last_finished_datetime`, `repeat`, `repeat_interval`, `retry_interval`,
  `max_retries`.

### `/api/device/`

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/api/device/devicepermissions/` | CRUD | `user`, `is_superuser`, `can_manage_content` | Permisos |
| `/api/device/usersyncstatus/` | GET | estado de sync por usuario | Salud sync |
| `/api/device/driveinfo/` | GET | drives montados | Operacional |
| `/api/device/freespace/` | GET | espacio libre | Operacional |
| `/api/device/deviceinfo/` | GET | version, storage, device_id, urls, database path para superuser | Dimension dispositivo |
| `/api/device/devicesettings/` | GET, PATCH | configuracion global | Configuracion |
| `/api/device/devicename/` | GET, PATCH | nombre dispositivo | Dimension dispositivo |
| `/api/device/devicerestart/` | GET, POST | estado/reinicio | Operacional |
| `/api/device/pathpermission/` | GET | permisos sobre path | Operacional |
| `/api/device/initialize/<token>` | GET/POST | inicializacion app | Operacional |
| `/api/device/check_metered_connection/` | GET | conexion medida | Operacional |

Campos de `usersyncstatus`:

- `status`, `last_synced`, `device_status`, `device_status_sentiment`,
  `user`, `has_downloads`, `last_download_removed`,
  `sync_downloads_in_progress`.

Filtros:

- `usersyncstatus`: `user`, `member_of`.

### `/api/discovery/`

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/api/discovery/networklocation/` | CRUD/GET | ubicaciones Kolibri en red | Topologia/sync |
| `/api/discovery/staticnetworklocation/` | CRUD/GET | ubicaciones fijas | Topologia/sync |
| `/api/discovery/dynamicnetworklocation/` | GET | ubicaciones descubiertas | Topologia/sync |
| `/api/discovery/networklocation_facilities/` | GET | facilities disponibles en ubicaciones | Sync |
| `/api/discovery/pinned_devices/` | CRUD | dispositivos fijados por usuario | Preferencias |

### `/api/notifications/`

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/api/notifications/pingbacknotification/` | GET | notificaciones remotas activas | Operacional |
| `/api/notifications/pingbacknotificationdismissed/` | CRUD | `user`, `notification` | Operacional |
| `/api/notifications/localnotification/` | GET, DELETE | `id`, `key`, `created_at`, `facility_name`, `learner_count` | Operacional |

### `/api/public/`

Estos son los endpoints marcados como estables para integraciones externas.

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/api/public/info/` | GET | metadata del dispositivo | Inventario dispositivos |
| `/api/public/v1/facility/` | GET | facilities publicas | Dimension facility externa |
| `/api/public/facilityuser/` | GET | usuarios publicos con auth | Dimension usuario externa |
| `/api/public/facilitysearchuser/` | GET | `id`, `username` | Login/sync |
| `/api/public/signup/` | POST | alta publica | Operacional |
| `/api/public/v2/channel/` | GET | canales publicos | Catalogo estable |
| `/api/public/v2/contentnode/` | GET | nodos publicos | Catalogo estable |
| `/api/public/v2/contentnode_tree/<id>/` | GET | arbol publico | Catalogo estable |
| `/api/public/v2/importmetadata/` | GET | metadata de importacion | Integracion contenido |
| `/api/public/<version>/channels` | GET | lista canales publica legacy | Catalogo estable |
| `/api/public/<version>/channels/lookup/<identifier>` | GET | canal por id | Catalogo estable |
| `/api/public/<version>/file_checksums/` | POST | bitmask de archivos disponibles | Sync contenido |
| `/api/public/syncqueue/` | POST | cola de sync por usuario/instancia | Sync |

## APIs de plugins

### `/learn/api/`

Datos para la experiencia del learner.

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/learn/api/learnerclassroom/` | GET | aulas del learner con `exams`, `lessons`, `courses` | Dashboard learner |
| `/learn/api/learnerlesson/` | GET | lecciones asignadas al learner | Asignaciones learner |
| `/learn/api/learnercourse/` | GET | cursos asignados al learner | Asignaciones learner |
| `/learn/api/learnercourse/<id>/resume/` | GET | siguiente recurso/estado de reanudacion | Journey learner |
| `/learn/api/state` | GET | estado inicial learn | Hidratacion frontend |
| `/learn/api/homehydrate` | GET | datos home learner | Hidratacion frontend |

Campos de `learnerclassroom`:

- `id`, `name`.
- `exams`: quiz asignado + progreso (`score`, `answer_count`, `started`,
  `closed`).
- `lessons`: leccion + recursos + progreso.
- `courses`: curso + `unit_count`, `lesson_count`, `progress`.

### `/coach/api/`

Datos agregados para coaches. Muy utiles para BI porque ya consolidan estado de
clases, lecciones, quizzes y preguntas dificiles.

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/coach/api/classsummary/<classroom_id>/` | GET | resumen de clase: learners, grupos, lessons, quizzes, estados de contenido | Mart de clase |
| `/coach/api/lessonreport/` | GET | `id`, `title`, `progress`, `total_learners` | Progreso por leccion |
| `/coach/api/lessonreport/<id>/` | GET | detalle leccion | Reporte coach |
| `/coach/api/notifications/` | GET | notificaciones learner/progreso | Eventos pedagogicos |
| `/coach/api/exercisedifficulties/<content_id>/` | GET | preguntas dificiles en ejercicio | Analisis preguntas |
| `/coach/api/quizdifficulties/<quiz_id>/` | GET | preguntas dificiles en quiz asignado | Analisis quiz |
| `/coach/api/practicequizdifficulties/<content_id>/` | GET | preguntas dificiles en quiz de practica | Analisis preguntas |
| `/coach/api/coursesession/<course_session_id>/unit/<unit_contentnode_id>/report/` | GET | reporte de unidad | BI cursos |
| `/coach/api/coursesession/<course_session_id>/unit/<unit_contentnode_id>/lessonprogress/` | GET | progreso de lecciones en unidad | BI cursos |

### `/device/api/`

Administracion de contenido del dispositivo.

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/device/api/device_channel/` | GET | canales del dispositivo + flags de disponibilidad | Inventario |
| `/device/api/devicechannelorder` | POST | orden de canales | Operacional |
| `/device/api/importexportsizeview` | POST | tamano estimado import/export | Capacidad |

### `/setup_wizard/api/`

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/setup_wizard/api/facilityimport/` | acciones ViewSet | importacion de facility | Operacional |
| `/setup_wizard/api/setupwizard/` | acciones ViewSet | estado/configuracion wizard | Operacional |

### `/user_auth/api/`

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/user_auth/api/facilityusername/` | GET | `username` filtrado por facility | Operacional/login |

### `/facility/api/`

Exportacion de CSVs administrativos.

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/facility/api/firstlogdate/<facility_id>/` | GET | `first_log_date` | Parametros export |
| `/facility/api/exportedcsvinfo/<facility_id>/` | GET | timestamp de CSVs existentes | Estado export |
| `/facility/api/downloadcsvfile/<csv_type>/<facility_id>/` | GET | descarga CSV | Extraccion BI |

Tipos de CSV relevantes:

- `session`: logs de sesiones de contenido.
- `summary`: resumen acumulado de progreso por usuario/recurso.
- `user`: usuarios exportados.

Columnas de CSV de logs:

- `Facility name`, `Username`, `User type`.
- `Channel id`, `Channel name`.
- `Content id`, `Content title`.
- `Time of first interaction`, `Time of last interaction`,
  `Time of completion`.
- `Time Spent (sec)`, `Progress (0-1)`, `Content kind`.
- `Folder level N` para jerarquia del contenido.

### `/user_profile/api/`

| Endpoint | Metodos principales | Datos principales | Uso BI |
| --- | --- | --- | --- |
| `/user_profile/api/onmyownsetup` | GET/POST | setup autonomo de usuario | Operacional |
| `/user_profile/api/loginmergeduser` | POST | login tras merge de usuario | Operacional |

## Modelo recomendado para BI

### Dimensiones

`dim_facility`

- Fuente: `/api/auth/facility/` o `/api/public/v1/facility/`.
- Clave: `facility.id`.
- Campos: nombre, dataset, conteos, ultimos syncs.

`dim_user`

- Fuente: `/api/auth/facilityuser/`.
- Clave: `facilityuser.id`.
- Campos: username, nombre, facility, genero, anio nacimiento,
  identificador externo, demografia extra, fecha de alta.
- Precaucion: `password` es write-only y no debe consumirse.

`dim_classroom_group`

- Fuentes: `/api/auth/classroom/`, `/api/auth/learnergroup/`,
  `/api/auth/membership/`, `/api/auth/role/`.
- Claves: `collection.id`, `membership.user`.
- Uso: pertenencia a clases/grupos y rol de coach/admin.

`dim_channel`

- Fuente: `/api/content/channel/` o `/api/public/v2/channel/`.
- Clave: `channel.id`.
- Campos: nombre, idioma, autor, version, publico/disponible.

`dim_contentnode`

- Fuente: `/api/content/contentnode/` y `/api/content/contentnode_tree/`.
- Claves: `contentnode.id` y `contentnode.content_id`.
- Campos: titulo, tipo, canal, jerarquia, tags, actividades, duracion,
  metadata de evaluacion, licencia, disponibilidad.
- Precaucion: el progreso se asocia por `content_id`; una misma pieza de
  contenido puede aparecer en varios `contentnode.id`.

`dim_lesson`

- Fuente: `/api/lessons/lesson/`.
- Clave: `lesson.id`.
- Puente a contenido: `lesson.resources[*].contentnode_id`,
  `content_id`, `channel_id`.

`dim_course_session`

- Fuente: `/api/courses/coursesession/`.
- Clave: `coursesession.id`.
- Puente a curso: `course`.

`dim_exam`

- Fuente: `/api/exams/exam/`.
- Clave: `exam.id`.
- Campos: titulo, activo/archivado, preguntas, asignaciones, fechas.

### Facts

`fact_content_session`

- Fuente preferida: CSV `session` o modelo/API de logger via backend interno.
- Grano: una visita a un recurso por usuario o visitante anonimo.
- Campos: usuario, `content_id`, `channel_id`, inicio, fin, tiempo, progreso,
  tipo de contenido, contexto (`lesson_id`, `course_session_id`, `node_id` si
  esta en `extra_fields.context`).
- KPI: tiempo total, sesiones por recurso, ultima actividad, recursos iniciados.

`fact_content_summary`

- Fuente preferida: CSV `summary`; API operativa relacionada:
  `/api/content/contentnodeprogress/`.
- Grano: usuario + `content_id`.
- Campos: progreso acumulado, tiempo acumulado, completado, timestamps.
- KPI: tasa de completitud, progreso promedio, usuarios activos por recurso.

`fact_attempt`

- Fuente: `/api/logger/attemptlog/`.
- Grano: respuesta/intento por pregunta (`item`) dentro de un intento de mastery.
- Campos: usuario, item, timestamps, tiempo, correcto, completo, pista, error,
  respuesta simple, historial.
- KPI: dificultad por pregunta, precision, tiempo por pregunta, uso de pistas.

`fact_mastery`

- Fuente: `/api/logger/masterylog/`.
- Grano: intento de ejercicio/quiz por usuario y contenido.
- Campos: criterio de mastery, inicio/fin, completado, correctas, tiempo.
- KPI: intentos hasta dominio, mejora entre intentos, finalizacion de quizzes.

`fact_attendance`

- Fuentes: `/api/attendance/attendancesession/`,
  `/api/attendance/attendancerecord/`.
- Grano: usuario + sesion de asistencia.
- Campos: presente, fecha/hora, clase/grupo.
- KPI: asistencia, ausentismo, correlacion asistencia-progreso.

`fact_bookmark`

- Fuente: `/api/bookmarks/bookmarks/`.
- Grano: usuario + recurso marcado.
- KPI: interes declarado, recursos guardados.

`fact_sync_status`

- Fuentes: `/api/device/usersyncstatus/`, `/api/discovery/*`,
  `/api/public/syncqueue/`.
- Grano: usuario/dispositivo.
- KPI: usuarios sin sync reciente, descargas en progreso, problemas de storage.

### Llaves de union importantes

- Usuario: `FacilityUser.id`.
- Facility: `Facility.id`; dataset via `facility.dataset`.
- Aula/grupo: `Collection.id`; memberships unen `collection` con `user`.
- Canal: `ChannelMetadata.id` = `channel_id`.
- Recurso canonico: `ContentNode.content_id`.
- Instancia en arbol: `ContentNode.id` = `contentnode_id` o `node_id`.
- Leccion a contenido: `Lesson.resources[*].contentnode_id`.
- Curso a contenido: `CourseSession.course` apunta al `ContentNode` raiz del
  curso.
- Progreso a recurso: `ContentSummaryLog.content_id` o
  `contentnodeprogress.content_id` con `ContentNode.content_id`.
- Attempt a mastery: `AttemptLog.masterylog`.
- Mastery a contenido: `MasteryLog.summarylog.content_id`.

## Recomendacion de extraccion BI

1. Usar `/api/public/` para integraciones externas cuando sea suficiente.
2. Para BI interno, autenticar como usuario con permisos administrativos y leer:
   `/api/auth/facilityuser/`, `/api/auth/classroom/`,
   `/api/auth/learnergroup/`, `/api/auth/membership/`, `/api/content/channel/`,
   `/api/content/contentnode/`, `/api/content/contentnodeprogress/`,
   `/api/logger/attemptlog/`, `/api/logger/masterylog/`,
   `/api/lessons/lesson/`, `/api/courses/coursesession/`,
   `/api/exams/exam/`, `/api/attendance/*`.
3. Para logs historicos de sesiones/resumen, preferir la exportacion CSV
   administrativa (`session` y `summary`), porque esos modelos no tienen un
   endpoint REST directo de lectura equivalente a `ContentSessionLog` y
   `ContentSummaryLog` completos.
4. Normalizar catalogo de contenido usando `content_id` para hechos de progreso
   y `contentnode_id` para ubicacion jerarquica.
5. Conservar `channel_id`, `content_id`, `contentnode_id`, `lesson_id` y
   `course_session_id` como llaves separadas; en Kolibri no son equivalentes.

## Limitaciones y precauciones

- Las APIs internas no garantizan compatibilidad entre versiones.
- Algunos endpoints devuelven datos segun permisos; un admin, coach y learner
  pueden ver universos distintos.
- Los usuarios anonimos pueden generar `ContentSessionLog` con `visitor_id`,
  pero no `ContentSummaryLog` asociado a usuario.
- El panel de biblioteca y busquedas no parecen tener un fact especifico de
  click/navegacion; se registra principalmente cuando se abre/consume un
  recurso.
- Las respuestas de ejercicios pueden contener datos sensibles en `answer` e
  `interaction_history`; para BI conviene minimizar o anonimizar esos campos.
- `full_name`, `id_number`, genero, anio de nacimiento y demografia extra son
  datos personales. Deben tratarse como PII.
