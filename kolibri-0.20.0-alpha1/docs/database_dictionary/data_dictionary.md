# Diccionario de Datos

Base: `kolibri-data-dev/db.sqlite3`

Cada seccion incluye proposito, conteo observado, columnas, claves foraneas e indices. Los conteos son una fotografia del entorno local al momento de generacion.

## `analytics_localnotification`

**Proposito:** Almacena notificaciones locales mostradas o programadas por Kolibri para comunicar eventos al usuario dentro del dispositivo.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `key` | `varchar(50)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `created_at` | `datetime` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Indices:**

- `sqlite_autoindex_analytics_localnotification_1` (unique, u) sobre `key`.

## `analytics_pingbacknotification`

**Proposito:** Registra notificaciones relacionadas con el envio de estadisticas anonimas de uso o pingback.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `varchar(50)` | No | Si | `` |  | Clave primaria del registro. |
| `version_range` | `varchar(50)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `timestamp` | `date` | No | No | `` |  | Fecha/hora relacionada con el estado o ciclo de vida del registro. |
| `link_url` | `varchar(150)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `i18n` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `active` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `source` | `varchar(20)` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Indices:**

- `sqlite_autoindex_analytics_pingbacknotification_1` (unique, pk) sobre `id`.

## `analytics_pingbacknotificationdismissed`

**Proposito:** Guarda que usuarios o sesiones descartaron notificaciones de pingback para no volver a mostrarlas.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `notification_id` | `varchar(50)` | No | No | `` | `analytics_pingbacknotification.id` | Referencia a notification. |
| `user_id` | `char(32)` | No | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `notification_id` -> `analytics_pingbacknotification.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `analytics_pingbacknotificationdismissed_user_id_99b20e1e` (c) sobre `user_id`.
- `analytics_pingbacknotificationdismissed_notification_id_01d1ee67` (c) sobre `notification_id`.
- `analytics_pingbacknotificationdismissed_user_id_notification_id_8d56aefc_uniq` (unique, c) sobre `user_id`, `notification_id`.

## `attendance_attendancerecord`

**Proposito:** Registra la asistencia de un usuario en una sesion de asistencia determinada.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `present` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `attendance_session_id` | `char(32)` | No | No | `` | `attendance_attendancesession.id` | Referencia a attendance session. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `user_id` | `char(32)` | No | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `attendance_session_id` -> `attendance_attendancesession.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `attendance_attendancerecord_user_id_1bb6e31f` (c) sobre `user_id`.
- `attendance_attendancerecord_dataset_id_275474e3` (c) sobre `dataset_id`.
- `attendance_attendancerecord_attendance_session_id_ee9a8d8e` (c) sobre `attendance_session_id`.
- `attendance_attendancerecord_attendance_session_id_user_id_ed81ed10_uniq` (unique, c) sobre `attendance_session_id`, `user_id`.
- `sqlite_autoindex_attendance_attendancerecord_1` (unique, pk) sobre `id`.

## `attendance_attendancesession`

**Proposito:** Define sesiones de asistencia, normalmente asociadas a una facility o grupo y a un intervalo de tiempo.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `session_start_datetime` | `varchar` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `date_created` | `varchar` | No | No | `` |  | Fecha de creacion del registro. |
| `date_modified` | `varchar` | No | No | `` |  | Fecha de ultima modificacion. |
| `collection_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Coleccion asociada, por ejemplo clase, grupo o facility. |
| `created_by_id` | `char(32)` | Si | No | `` | `kolibriauth_facilityuser.id` | Referencia a created by. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |

**Claves foraneas:**

- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `created_by_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `collection_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `attendance_attendancesession_dataset_id_f50705a4` (c) sobre `dataset_id`.
- `attendance_attendancesession_created_by_id_8831185e` (c) sobre `created_by_id`.
- `attendance_attendancesession_collection_id_386c8b1e` (c) sobre `collection_id`.
- `sqlite_autoindex_attendance_attendancesession_1` (unique, pk) sobre `id`.

## `auth_group`

**Proposito:** Tabla estandar de Django para grupos de permisos administrativos.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `name` | `varchar(150)` | No | No | `` |  | Nombre legible de la entidad. |

**Indices:**

- `sqlite_autoindex_auth_group_1` (unique, u) sobre `name`.

## `auth_group_permissions`

**Proposito:** Relacion muchos-a-muchos entre grupos Django y permisos.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `group_id` | `INTEGER` | No | No | `` | `auth_group.id` | Referencia a group. |
| `permission_id` | `INTEGER` | No | No | `` | `auth_permission.id` | Referencia a permission. |

**Claves foraneas:**

- `permission_id` -> `auth_permission.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `group_id` -> `auth_group.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `auth_group_permissions_permission_id_84c5c92e` (c) sobre `permission_id`.
- `auth_group_permissions_group_id_b120cbf9` (c) sobre `group_id`.
- `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (unique, c) sobre `group_id`, `permission_id`.

## `auth_permission`

**Proposito:** Catalogo de permisos Django generados por aplicacion/modelo.
**Filas observadas:** 336

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `content_type_id` | `INTEGER` | No | No | `` | `django_content_type.id` | Referencia a content type. |
| `codename` | `varchar(100)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `name` | `varchar(255)` | No | No | `` |  | Nombre legible de la entidad. |

**Claves foraneas:**

- `content_type_id` -> `django_content_type.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `auth_permission_content_type_id_2f476e4b` (c) sobre `content_type_id`.
- `auth_permission_content_type_id_codename_01ab375a_uniq` (unique, c) sobre `content_type_id`, `codename`.

## `bookmarks_bookmark`

**Proposito:** Guarda recursos marcados por usuarios para acceso rapido desde la experiencia de aprendizaje.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `content_id` | `char(32)` | Si | No | `` |  | Identificador global del recurso de contenido; puede repetirse en varios ContentNode. |
| `channel_id` | `char(32)` | Si | No | `` |  | Canal de contenido al que pertenece el recurso. |
| `contentnode_id` | `char(32)` | No | No | `` |  | Identificador local del nodo de contenido dentro del arbol. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `user_id` | `char(32)` | No | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |
| `created` | `datetime` | No | No | `` |  | Marca temporal del ciclo de vida del registro. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `bookmarks_bookmark_created_eb31a9bf` (c) sobre `created`.
- `bookmarks_bookmark_user_id_a26bf17c` (c) sobre `user_id`.
- `bookmarks_bookmark_dataset_id_baf7c629` (c) sobre `dataset_id`.
- `bookmarks_bookmark_user_id_contentnode_id_e0f35590_uniq` (unique, c) sobre `user_id`, `contentnode_id`.
- `sqlite_autoindex_bookmarks_bookmark_1` (unique, pk) sobre `id`.

## `content_assessmentmetadata`

**Proposito:** Metadatos de evaluacion para ejercicios o recursos evaluables, incluyendo numero de preguntas y modelo de dominio.
**Filas observadas:** 7971

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `assessment_item_ids` | `TEXT` | No | No | `` |  | JSON con IDs de preguntas/items de evaluacion. |
| `number_of_assessments` | `INTEGER` | No | No | `` |  | Numero de preguntas/items disponibles para el recurso evaluable. |
| `mastery_model` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `randomize` | `bool` | No | No | `` |  | Indica si las preguntas se presentan en orden aleatorio. |
| `is_manipulable` | `bool` | No | No | `` |  | Indica si el contenido evaluable puede manipularse para reportes/vista coach. |
| `contentnode_id` | `char(32)` | No | No | `` | `content_contentnode.id` | Identificador local del nodo de contenido dentro del arbol. |

**Claves foraneas:**

- `contentnode_id` -> `content_contentnode.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `content_assessmentmetadata_contentnode_id_19cbc70a` (c) sobre `contentnode_id`.
- `sqlite_autoindex_content_assessmentmetadata_1` (unique, pk) sobre `id`.

## `content_channelmetadata`

**Proposito:** Metadatos de canales importados o disponibles: nombre, version, idioma, publicacion y atributos de biblioteca.
**Filas observadas:** 5

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `name` | `varchar(200)` | No | No | `` |  | Nombre legible de la entidad. |
| `description` | `varchar(400)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `author` | `varchar(400)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `version` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `thumbnail` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `last_updated` | `varchar` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `min_schema_version` | `varchar(50)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `root_id` | `char(32)` | No | No | `` | `content_contentnode.id` | Referencia a root. |
| `published_size` | `bigint` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `total_resource_count` | `INTEGER` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `order` | `integer unsigned` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `public` | `bool` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `tagline` | `varchar(150)` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `partial` | `bool` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `included_categories` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `included_grade_levels` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `library` | `varchar(50)` | Si | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `root_id` -> `content_contentnode.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `content_channelmetadata_root_id_ba963469` (c) sobre `root_id`.
- `sqlite_autoindex_content_channelmetadata_1` (unique, pk) sobre `id`.

## `content_channelmetadata_included_languages`

**Proposito:** Relacion entre canales e idiomas incluidos en sus recursos.
**Filas observadas:** 7

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `sort_value` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `channelmetadata_id` | `char(32)` | No | No | `` | `content_channelmetadata.id` | Referencia a channelmetadata. |
| `language_id` | `varchar(14)` | No | No | `` | `content_language.id` | Referencia a language. |

**Claves foraneas:**

- `language_id` -> `content_language.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `channelmetadata_id` -> `content_channelmetadata.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `content_channelmetadata_included_languages_language_id_7044f65d` (c) sobre `language_id`.
- `content_channelmetadata_included_languages_channelmetadata_id_bd8ec7ef` (c) sobre `channelmetadata_id`.
- `content_channelmetadata_included_languages_channelmetadata_id_language_id_51f20415_uniq` (unique, c) sobre `channelmetadata_id`, `language_id`.

## `content_contentnode`

**Proposito:** Arbol local de contenido disponible: topics, videos, audios, documentos, ejercicios, HTML5 y otros recursos.
**Filas observadas:** 32276

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `title` | `varchar(200)` | No | No | `` |  | Titulo legible de la entidad. |
| `content_id` | `char(32)` | No | No | `` |  | Identificador global del recurso de contenido; puede repetirse en varios ContentNode. |
| `channel_id` | `char(32)` | No | No | `` |  | Canal de contenido al que pertenece el recurso. |
| `description` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `sort_order` | `REAL` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `license_owner` | `varchar(200)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `author` | `varchar(200)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `kind` | `varchar(200)` | No | No | `` |  | Tipo de recurso o entidad, por ejemplo topic, video, audio, exercise, document. |
| `available` | `bool` | No | No | `` |  | Indica si el registro/recurso esta disponible localmente. |
| `lft` | `integer unsigned` | No | No | `` |  | Indice izquierdo MPTT del arbol de contenido/colecciones. |
| `rght` | `integer unsigned` | No | No | `` |  | Indice derecho MPTT del arbol de contenido/colecciones. |
| `tree_id` | `integer unsigned` | No | No | `` |  | Identificador del arbol MPTT. |
| `level` | `integer unsigned` | No | No | `` |  | Nivel de profundidad en el arbol MPTT. |
| `lang_id` | `varchar(14)` | Si | No | `` | `content_language.id` | Referencia a lang. |
| `license_description` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `license_name` | `varchar(50)` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `coach_content` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `num_coach_contents` | `INTEGER` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `on_device_resources` | `INTEGER` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `options` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `accessibility_labels` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `categories` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `duration` | `integer unsigned` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `grade_levels` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `learner_needs` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `learning_activities` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `resource_types` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `accessibility_labels_bitmask_0` | `bigint` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `categories_bitmask_0` | `bigint` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `grade_levels_bitmask_0` | `bigint` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `learner_needs_bitmask_0` | `bigint` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `learning_activities_bitmask_0` | `bigint` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `ancestors` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `admin_imported` | `bool` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `modality` | `varchar(50)` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `parent_id` | `char(32)` | Si | No | `` | `content_contentnode.id` | Nodo o coleccion padre en una jerarquia. |

**Claves foraneas:**

- `parent_id` -> `content_contentnode.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `lang_id` -> `content_language.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `content_con_modalit_b33128_idx` (c) sobre `modality`.
- `content_contentnode_level_channel_id_kind_fd732cc4_idx` (c) sobre `level`, `channel_id`, `kind`.
- `content_contentnode_level_channel_id_available_29f0bb18_idx` (c) sobre `level`, `channel_id`, `available`.
- `content_contentnode_parent_id_47178783` (c) sobre `parent_id`.
- `content_contentnode_lang_id_600d594b` (c) sobre `lang_id`.
- `content_contentnode_tree_id_d115ca94` (c) sobre `tree_id`.
- `content_contentnode_channel_id_77d3faec` (c) sobre `channel_id`.
- `content_contentnode_content_id_790eac82` (c) sobre `content_id`.
- `sqlite_autoindex_content_contentnode_1` (unique, pk) sobre `id`.

## `content_contentnode_has_prerequisite`

**Proposito:** Relacion de prerrequisitos entre nodos de contenido.
**Filas observadas:** 70

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `from_contentnode_id` | `char(32)` | No | No | `` | `content_contentnode.id` | Referencia a from contentnode. |
| `to_contentnode_id` | `char(32)` | No | No | `` | `content_contentnode.id` | Referencia a to contentnode. |

**Claves foraneas:**

- `to_contentnode_id` -> `content_contentnode.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `from_contentnode_id` -> `content_contentnode.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `content_contentnode_has_prerequisite_to_contentnode_id_5561f92c` (c) sobre `to_contentnode_id`.
- `content_contentnode_has_prerequisite_from_contentnode_id_1085c145` (c) sobre `from_contentnode_id`.
- `content_contentnode_has_prerequisite_from_contentnode_id_to_contentnode_id_c9e1d527_uniq` (unique, c) sobre `from_contentnode_id`, `to_contentnode_id`.

## `content_contentnode_related`

**Proposito:** Relacion de recursos relacionados entre nodos de contenido.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `from_contentnode_id` | `char(32)` | No | No | `` | `content_contentnode.id` | Referencia a from contentnode. |
| `to_contentnode_id` | `char(32)` | No | No | `` | `content_contentnode.id` | Referencia a to contentnode. |

**Claves foraneas:**

- `to_contentnode_id` -> `content_contentnode.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `from_contentnode_id` -> `content_contentnode.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `content_contentnode_related_to_contentnode_id_42e82421` (c) sobre `to_contentnode_id`.
- `content_contentnode_related_from_contentnode_id_f56e3999` (c) sobre `from_contentnode_id`.
- `content_contentnode_related_from_contentnode_id_to_contentnode_id_fc2ed20c_uniq` (unique, c) sobre `from_contentnode_id`, `to_contentnode_id`.

## `content_contentnode_tags`

**Proposito:** Relacion muchos-a-muchos entre nodos de contenido y etiquetas.
**Filas observadas:** 21790

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `contentnode_id` | `char(32)` | No | No | `` | `content_contentnode.id` | Identificador local del nodo de contenido dentro del arbol. |
| `contenttag_id` | `char(32)` | No | No | `` | `content_contenttag.id` | Referencia a contenttag. |

**Claves foraneas:**

- `contenttag_id` -> `content_contenttag.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `contentnode_id` -> `content_contentnode.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `content_contentnode_tags_contenttag_id_9518e093` (c) sobre `contenttag_id`.
- `content_contentnode_tags_contentnode_id_4ea196dd` (c) sobre `contentnode_id`.
- `content_contentnode_tags_contentnode_id_contenttag_id_64a4ac15_uniq` (unique, c) sobre `contentnode_id`, `contenttag_id`.

## `content_contentrequest`

**Proposito:** Solicitudes de descarga/importacion de contenido hechas desde el dispositivo o facility.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `source_model` | `varchar(40)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `source_id` | `char(32)` | No | No | `` |  | Referencia a source. |
| `requested_at` | `varchar` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `type` | `varchar(8)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `reason` | `varchar(14)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `status` | `varchar(11)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `contentnode_id` | `char(32)` | No | No | `` |  | Identificador local del nodo de contenido dentro del arbol. |
| `metadata` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `facility_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Facility asociada. |
| `source_instance_id` | `char(32)` | Si | No | `` |  | Referencia a source instance. |
| `priority` | `INTEGER` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `channel_version` | `INTEGER` | Si | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `facility_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `content_contentrequest_type_source_model_source_id_contentnode_id_channel_version_9de3b84b_uniq` (unique, c) sobre `type`, `source_model`, `source_id`, `contentnode_id`, `channel_version`.
- `content_contentrequest_facility_id_85cdb9e0` (c) sobre `facility_id`.
- `sqlite_autoindex_content_contentrequest_1` (unique, pk) sobre `id`.

## `content_contenttag`

**Proposito:** Catalogo de etiquetas asociadas a nodos de contenido.
**Filas observadas:** 1426

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `tag_name` | `varchar(30)` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Indices:**

- `sqlite_autoindex_content_contenttag_1` (unique, pk) sobre `id`.

## `content_file`

**Proposito:** Archivos que pertenecen a recursos de contenido, enlazando presets, idioma y archivo fisico local.
**Filas observadas:** 52028

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `preset` | `varchar(150)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `supplementary` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `thumbnail` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `priority` | `INTEGER` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `contentnode_id` | `char(32)` | No | No | `` | `content_contentnode.id` | Identificador local del nodo de contenido dentro del arbol. |
| `lang_id` | `varchar(14)` | Si | No | `` | `content_language.id` | Referencia a lang. |
| `local_file_id` | `varchar(32)` | No | No | `` | `content_localfile.id` | Referencia a local file. |
| `included_presets` | `INTEGER` | Si | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `local_file_id` -> `content_localfile.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `lang_id` -> `content_language.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `contentnode_id` -> `content_contentnode.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `content_file_local_file_id_9780c2ab` (c) sobre `local_file_id`.
- `content_file_lang_id_364540cd` (c) sobre `lang_id`.
- `content_file_contentnode_id_d4089e6e` (c) sobre `contentnode_id`.
- `content_file_priority_073dafe4` (c) sobre `priority`.
- `sqlite_autoindex_content_file_1` (unique, pk) sobre `id`.

## `content_language`

**Proposito:** Catalogo de idiomas utilizados por el contenido.
**Filas observadas:** 3

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `varchar(14)` | No | Si | `` |  | Clave primaria del registro. |
| `lang_code` | `varchar(3)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `lang_subcode` | `varchar(10)` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `lang_name` | `varchar(100)` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `lang_direction` | `varchar(3)` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Indices:**

- `content_language_lang_subcode_6ca3c58e` (c) sobre `lang_subcode`.
- `content_language_lang_code_7a423afe` (c) sobre `lang_code`.
- `sqlite_autoindex_content_language_1` (unique, pk) sobre `id`.

## `content_localfile`

**Proposito:** Archivos fisicos almacenados localmente por checksum, disponibilidad y tamano.
**Filas observadas:** 18842

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `varchar(32)` | No | Si | `` |  | Clave primaria del registro. |
| `extension` | `varchar(40)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `available` | `bool` | No | No | `` |  | Indica si el registro/recurso esta disponible localmente. |
| `file_size_bigint` | `bigint` | Si | No | `` |  | Campo de datos propio de esta tabla. |

**Indices:**

- `sqlite_autoindex_content_localfile_1` (unique, pk) sobre `id`.

## `courses_coursesession`

**Proposito:** Instancias de curso asignadas o seguidas por usuarios/grupos dentro de Kolibri.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `course` | `char(32)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `title` | `varchar(200)` | No | No | `` |  | Titulo legible de la entidad. |
| `description` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `is_active` | `bool` | No | No | `` |  | Bandera booleana de configuracion o estado. |
| `date_created` | `varchar` | No | No | `` |  | Fecha de creacion del registro. |
| `collection_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Coleccion asociada, por ejemplo clase, grupo o facility. |
| `created_by_id` | `char(32)` | Si | No | `` | `kolibriauth_facilityuser.id` | Referencia a created by. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `channel_version` | `INTEGER` | Si | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `created_by_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `collection_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `courses_coursesession_dataset_id_25fc5112` (c) sobre `dataset_id`.
- `courses_coursesession_created_by_id_e5fd1ccb` (c) sobre `created_by_id`.
- `courses_coursesession_collection_id_fdac6d7b` (c) sobre `collection_id`.
- `sqlite_autoindex_courses_coursesession_1` (unique, pk) sobre `id`.

## `courses_coursesessionassignment`

**Proposito:** Asignaciones de sesiones de curso a colecciones o usuarios.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `assigned_by_id` | `char(32)` | Si | No | `` | `kolibriauth_facilityuser.id` | Referencia a assigned by. |
| `collection_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Coleccion asociada, por ejemplo clase, grupo o facility. |
| `course_session_id` | `char(32)` | No | No | `` | `courses_coursesession.id` | Referencia a course session. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |

**Claves foraneas:**

- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `course_session_id` -> `courses_coursesession.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `collection_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `assigned_by_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `courses_coursesessionassignment_dataset_id_b1e1ce14` (c) sobre `dataset_id`.
- `courses_coursesessionassignment_course_session_id_63856105` (c) sobre `course_session_id`.
- `courses_coursesessionassignment_collection_id_96e8bcfb` (c) sobre `collection_id`.
- `courses_coursesessionassignment_assigned_by_id_4e3b553a` (c) sobre `assigned_by_id`.
- `sqlite_autoindex_courses_coursesessionassignment_1` (unique, pk) sobre `id`.

## `courses_unittestassignment`

**Proposito:** Asignaciones de pruebas de unidad dentro de cursos.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `unit_contentnode_id` | `char(32)` | No | No | `` |  | Referencia a unit contentnode. |
| `test_type` | `varchar(10)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `activated_by_id` | `char(32)` | Si | No | `` | `kolibriauth_facilityuser.id` | Referencia a activated by. |
| `collection_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Coleccion asociada, por ejemplo clase, grupo o facility. |
| `course_session_id` | `char(32)` | No | No | `` | `courses_coursesession.id` | Referencia a course session. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `closed` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `course_session_id` -> `courses_coursesession.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `collection_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `activated_by_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `courses_unittestassignment_dataset_id_ebdea473` (c) sobre `dataset_id`.
- `courses_unittestassignment_course_session_id_63cf8395` (c) sobre `course_session_id`.
- `courses_unittestassignment_collection_id_f397f727` (c) sobre `collection_id`.
- `courses_unittestassignment_activated_by_id_f96fbc35` (c) sobre `activated_by_id`.
- `sqlite_autoindex_courses_unittestassignment_1` (unique, pk) sobre `id`.

## `device_contentcachekey`

**Proposito:** Claves de cache relacionadas con contenido disponible en el dispositivo.
**Filas observadas:** 1

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `key` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |

## `device_deviceappkey`

**Proposito:** Claves de aplicacion/dispositivo usadas para integraciones y autenticacion local.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `key` | `char(32)` | No | No | `` |  | Campo de datos propio de esta tabla. |

## `device_devicepermissions`

**Proposito:** Configuracion de permisos a nivel de dispositivo.
**Filas observadas:** 1

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `user_id` | `char(32)` | No | Si | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |
| `is_superuser` | `bool` | No | No | `` |  | Bandera booleana de configuracion o estado. |
| `can_manage_content` | `bool` | No | No | `` |  | Bandera booleana de configuracion o estado. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `sqlite_autoindex_device_devicepermissions_1` (unique, pk) sobre `user_id`.

## `device_devicesettings`

**Proposito:** Configuracion global del dispositivo Kolibri, como acceso invitado, nombre y politicas locales.
**Filas observadas:** 1

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `is_provisioned` | `bool` | No | No | `` |  | Bandera booleana de configuracion o estado. |
| `language_id` | `varchar(15)` | Si | No | `` |  | Referencia a language. |
| `default_facility_id` | `char(32)` | Si | No | `` | `kolibriauth_collection.id` | Referencia a default facility. |
| `allow_guest_access` | `bool` | No | No | `` |  | Bandera booleana de configuracion o estado. |
| `allow_learner_unassigned_resource_access` | `bool` | No | No | `` |  | Bandera booleana de configuracion o estado. |
| `allow_peer_unlisted_channel_import` | `bool` | No | No | `` |  | Bandera booleana de configuracion o estado. |
| `landing_page` | `varchar(7)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `name` | `varchar(50)` | No | No | `` |  | Nombre legible de la entidad. |
| `allow_other_browsers_to_connect` | `bool` | No | No | `` |  | Bandera booleana de configuracion o estado. |
| `subset_of_users_device` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `extra_settings` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `default_facility_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `device_devicesettings_default_facility_id_8937e0b7` (c) sobre `default_facility_id`.

## `device_learnerdevicestatus`

**Proposito:** Estado de sincronizacion o disponibilidad de aprendices en el dispositivo.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `instance_id` | `char(32)` | No | No | `` |  | Referencia a instance. |
| `created_at` | `datetime` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `updated_at` | `datetime` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `status` | `varchar(32)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `status_sentiment` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `user_id` | `char(32)` | No | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `device_learnerdevicestatus_user_id_348765fa` (c) sobre `user_id`.
- `device_learnerdevicestatus_dataset_id_f6c55adc` (c) sobre `dataset_id`.
- `device_learnerdevicestatus_instance_id_user_id_786bc903_uniq` (unique, c) sobre `instance_id`, `user_id`.
- `sqlite_autoindex_device_learnerdevicestatus_1` (unique, pk) sobre `id`.

## `device_osuser`

**Proposito:** Asociacion entre usuarios del sistema operativo y usuarios Kolibri cuando aplica.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `user_id` | `char(32)` | No | Si | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |
| `os_username` | `varchar(64)` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `device_osuser_os_username_81b2e3a5` (c) sobre `os_username`.
- `sqlite_autoindex_device_osuser_1` (unique, pk) sobre `user_id`.

## `device_sqlitelock`

**Proposito:** Locks internos usados para coordinar acceso concurrente a SQLite.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |

## `device_usersyncstatus`

**Proposito:** Estado de sincronizacion por usuario/dispositivo.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `sync_session_id` | `char(32)` | Si | No | `` | `morango_syncsession.id` | Referencia a sync session. |
| `status` | `varchar(20)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `updated` | `datetime` | No | No | `` |  | Marca temporal del ciclo de vida del registro. |
| `user_id` | `char(32)` | No | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `sync_session_id` -> `morango_syncsession.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `device_usersyncstatus_sync_session_id_f1f21f58` (c) sobre `sync_session_id`.
- `sqlite_autoindex_device_usersyncstatus_1` (unique, u) sobre `user_id`.

## `discovery_pinneddevice`

**Proposito:** Dispositivos descubiertos en red que fueron fijados o guardados por el usuario/admin.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `instance_id` | `char(32)` | No | No | `` |  | Referencia a instance. |
| `created` | `datetime` | No | No | `` |  | Marca temporal del ciclo de vida del registro. |
| `user_id` | `char(32)` | No | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `discovery_pinneddevice_user_id_468c983d` (c) sobre `user_id`.
- `discovery_pinneddevice_created_b2b4bb42` (c) sobre `created`.
- `discovery_pinneddevice_user_id_instance_id_14dd8643_uniq` (unique, c) sobre `user_id`, `instance_id`.

## `django_content_type`

**Proposito:** Catalogo Django que identifica cada modelo instalado por app/modelo.
**Filas observadas:** 84

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `app_label` | `varchar(100)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `model` | `varchar(100)` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Indices:**

- `django_content_type_app_label_model_76bd3d3b_uniq` (unique, c) sobre `app_label`, `model`.

## `django_migrations`

**Proposito:** Historial de migraciones Django aplicadas a esta base.
**Filas observadas:** 228

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `app` | `varchar(255)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `name` | `varchar(255)` | No | No | `` |  | Nombre legible de la entidad. |
| `applied` | `datetime` | No | No | `` |  | Campo de datos propio de esta tabla. |

## `exams_draftexam`

**Proposito:** Borradores de examenes o quizzes antes de publicarlos/asignarlos.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `title` | `varchar(200)` | No | No | `` |  | Titulo legible de la entidad. |
| `question_count` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `question_sources` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `seed` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `learners_see_fixed_order` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `data_model_version` | `smallint` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `date_created` | `datetime` | Si | No | `` |  | Fecha de creacion del registro. |
| `assignments` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `learner_ids` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `collection_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Coleccion asociada, por ejemplo clase, grupo o facility. |
| `creator_id` | `char(32)` | Si | No | `` | `kolibriauth_facilityuser.id` | Referencia a creator. |
| `instant_report_visibility` | `bool` | Si | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `creator_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `collection_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `exams_draftexam_creator_id_30383308` (c) sobre `creator_id`.
- `exams_draftexam_collection_id_89be964c` (c) sobre `collection_id`.

## `exams_exam`

**Proposito:** Examenes o quizzes asignables, con preguntas, configuracion y estado.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `title` | `varchar(200)` | No | No | `` |  | Titulo legible de la entidad. |
| `question_count` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `question_sources` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `seed` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `active` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `archive` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `collection_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Coleccion asociada, por ejemplo clase, grupo o facility. |
| `creator_id` | `char(32)` | Si | No | `` | `kolibriauth_facilityuser.id` | Referencia a creator. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `data_model_version` | `smallint` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `learners_see_fixed_order` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `date_created` | `datetime` | No | No | `` |  | Fecha de creacion del registro. |
| `date_archived` | `datetime` | Si | No | `` |  | Fecha/hora relacionada con el estado o ciclo de vida del registro. |
| `date_activated` | `datetime` | Si | No | `` |  | Fecha/hora relacionada con el estado o ciclo de vida del registro. |
| `instant_report_visibility` | `bool` | Si | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `creator_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `collection_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `exams_exam_dataset_id_7dff1bad` (c) sobre `dataset_id`.
- `exams_exam_creator_id_37d1b2e5` (c) sobre `creator_id`.
- `exams_exam_collection_id_9dc0b187` (c) sobre `collection_id`.
- `sqlite_autoindex_exams_exam_1` (unique, pk) sobre `id`.

## `exams_examassignment`

**Proposito:** Asignaciones de examenes a clases, grupos o usuarios.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `collection_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Coleccion asociada, por ejemplo clase, grupo o facility. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `exam_id` | `char(32)` | No | No | `` | `exams_exam.id` | Referencia a exam. |
| `assigned_by_id` | `char(32)` | Si | No | `` | `kolibriauth_facilityuser.id` | Referencia a assigned by. |

**Claves foraneas:**

- `assigned_by_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `exam_id` -> `exams_exam.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `collection_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `exams_examassignment_assigned_by_id_53aa193a` (c) sobre `assigned_by_id`.
- `exams_examassignment_exam_id_d7c499da` (c) sobre `exam_id`.
- `exams_examassignment_dataset_id_3200aa09` (c) sobre `dataset_id`.
- `exams_examassignment_collection_id_90ec6a7a` (c) sobre `collection_id`.
- `sqlite_autoindex_exams_examassignment_1` (unique, pk) sobre `id`.

## `exams_individualsyncableexam`

**Proposito:** Datos de examenes individualmente sincronizables para escenarios de sync por usuario.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `exam_id` | `char(32)` | No | No | `` |  | Referencia a exam. |
| `serialized_exam` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `collection_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Coleccion asociada, por ejemplo clase, grupo o facility. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `user_id` | `char(32)` | No | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `collection_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `exams_individualsyncableexam_user_id_28fbd7b0` (c) sobre `user_id`.
- `exams_individualsyncableexam_dataset_id_d3570826` (c) sobre `dataset_id`.
- `exams_individualsyncableexam_collection_id_00d1fd6f` (c) sobre `collection_id`.
- `sqlite_autoindex_exams_individualsyncableexam_1` (unique, pk) sobre `id`.

## `kolibriauth_collection`

**Proposito:** Jerarquia de colecciones de auth: facilities, classrooms, learner groups y agrupaciones relacionadas.
**Filas observadas:** 1

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `name` | `varchar(100)` | No | No | `` |  | Nombre legible de la entidad. |
| `kind` | `varchar(20)` | No | No | `` |  | Tipo de recurso o entidad, por ejemplo topic, video, audio, exercise, document. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `parent_id` | `char(32)` | Si | No | `` | `kolibriauth_collection.id` | Nodo o coleccion padre en una jerarquia. |

**Claves foraneas:**

- `parent_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `kolibriauth_collection_parent_id_1561ec4a` (c) sobre `parent_id`.
- `kolibriauth_collection_dataset_id_5689c7d8` (c) sobre `dataset_id`.
- `sqlite_autoindex_kolibriauth_collection_1` (unique, pk) sobre `id`.

## `kolibriauth_facilitydataset`

**Proposito:** Configuracion y metadatos sincronizables de una facility.
**Filas observadas:** 1

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `description` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `location` | `varchar(200)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `learner_can_edit_username` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `learner_can_edit_name` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `learner_can_edit_password` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `learner_can_sign_up` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `learner_can_delete_account` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `learner_can_login_with_no_password` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `preset` | `varchar(50)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `show_download_button_in_learn` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `registered` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `extra_fields` | `TEXT` | Si | No | `` |  | JSON con datos adicionales especificos del recurso o evento. |
| `enable_mark_attendance` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `picture_password_settings` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |

**Indices:**

- `sqlite_autoindex_kolibriauth_facilitydataset_1` (unique, pk) sobre `id`.

## `kolibriauth_facilityuser`

**Proposito:** Usuarios de Kolibri pertenecientes a una facility: credenciales, perfil y datos demograficos.
**Filas observadas:** 2

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `password` | `varchar(128)` | No | No | `` |  | Hash de contrasena Django; no contiene la contrasena en texto plano. |
| `last_login` | `datetime` | Si | No | `` |  | Ultima fecha de inicio de sesion. |
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `username` | `varchar(254)` | No | No | `` |  | Nombre de usuario usado para iniciar sesion. |
| `full_name` | `varchar(120)` | No | No | `` |  | Nombre completo visible del usuario. |
| `date_joined` | `varchar` | No | No | `` |  | Fecha de creacion del usuario. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `facility_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Facility asociada. |
| `birth_year` | `varchar(16)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `gender` | `varchar(16)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `id_number` | `varchar(64)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `extra_demographics` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `date_deleted` | `varchar` | Si | No | `` |  | Fecha/hora relacionada con el estado o ciclo de vida del registro. |
| `picture_password` | `varchar(8)` | Si | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `facility_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `kolibriauth_facilityuser_dataset_id_picture_password_78a7cf39_uniq` (unique, c) sobre `dataset_id`, `picture_password`.
- `kolibriauth_facilityuser_facility_id_f602d621` (c) sobre `facility_id`.
- `kolibriauth_facilityuser_dataset_id_0dab63f9` (c) sobre `dataset_id`.
- `sqlite_autoindex_kolibriauth_facilityuser_1` (unique, pk) sobre `id`.

## `kolibriauth_membership`

**Proposito:** Membresias que asocian usuarios con colecciones, por ejemplo estudiantes en clases o grupos.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `collection_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Coleccion asociada, por ejemplo clase, grupo o facility. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `user_id` | `char(32)` | No | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `collection_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `kolibriauth_membership_user_id_collection_id_48b95423_uniq` (unique, c) sobre `user_id`, `collection_id`.
- `kolibriauth_membership_user_id_79317fa1` (c) sobre `user_id`.
- `kolibriauth_membership_dataset_id_13e29803` (c) sobre `dataset_id`.
- `kolibriauth_membership_collection_id_c955dbd2` (c) sobre `collection_id`.
- `sqlite_autoindex_kolibriauth_membership_1` (unique, pk) sobre `id`.

## `kolibriauth_role`

**Proposito:** Roles de usuarios sobre colecciones, por ejemplo admin o coach.
**Filas observadas:** 1

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `collection_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Coleccion asociada, por ejemplo clase, grupo o facility. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `user_id` | `char(32)` | No | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |
| `kind` | `varchar(26)` | No | No | `` |  | Tipo de recurso o entidad, por ejemplo topic, video, audio, exercise, document. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `collection_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `kolibriauth_role_user_id_d4014967` (c) sobre `user_id`.
- `kolibriauth_role_dataset_id_70eb0469` (c) sobre `dataset_id`.
- `kolibriauth_role_collection_id_1fa9ce6f` (c) sobre `collection_id`.
- `kolibriauth_role_user_id_collection_id_kind_9c51e8a2_uniq` (unique, c) sobre `user_id`, `collection_id`, `kind`.
- `sqlite_autoindex_kolibriauth_role_1` (unique, pk) sobre `id`.

## `lessons_individualsyncablelesson`

**Proposito:** Lecciones sincronizables individualmente para escenarios de sync por usuario.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `lesson_id` | `char(32)` | No | No | `` |  | Referencia a lesson. |
| `serialized_lesson` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `collection_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Coleccion asociada, por ejemplo clase, grupo o facility. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `user_id` | `char(32)` | No | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `collection_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `lessons_individualsyncablelesson_user_id_ddf66bab` (c) sobre `user_id`.
- `lessons_individualsyncablelesson_dataset_id_b329a015` (c) sobre `dataset_id`.
- `lessons_individualsyncablelesson_collection_id_190c1ec5` (c) sobre `collection_id`.
- `sqlite_autoindex_lessons_individualsyncablelesson_1` (unique, pk) sobre `id`.

## `lessons_lesson`

**Proposito:** Lecciones creadas por coaches, con lista de recursos, asignaciones y estado.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `description` | `varchar(200)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `resources` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `is_active` | `bool` | No | No | `` |  | Bandera booleana de configuracion o estado. |
| `collection_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Coleccion asociada, por ejemplo clase, grupo o facility. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `title` | `varchar(50)` | No | No | `` |  | Titulo legible de la entidad. |
| `date_created` | `varchar` | No | No | `` |  | Fecha de creacion del registro. |
| `created_by_id` | `char(32)` | Si | No | `` | `kolibriauth_facilityuser.id` | Referencia a created by. |

**Claves foraneas:**

- `created_by_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `collection_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `lessons_lesson_created_by_id_441dbacf` (c) sobre `created_by_id`.
- `lessons_lesson_dataset_id_da71bead` (c) sobre `dataset_id`.
- `lessons_lesson_collection_id_13b7d040` (c) sobre `collection_id`.
- `sqlite_autoindex_lessons_lesson_1` (unique, pk) sobre `id`.

## `lessons_lessonassignment`

**Proposito:** Asignaciones de lecciones a clases, grupos o aprendices.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `collection_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Coleccion asociada, por ejemplo clase, grupo o facility. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `lesson_id` | `char(32)` | No | No | `` | `lessons_lesson.id` | Referencia a lesson. |
| `assigned_by_id` | `char(32)` | Si | No | `` | `kolibriauth_facilityuser.id` | Referencia a assigned by. |

**Claves foraneas:**

- `assigned_by_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `lesson_id` -> `lessons_lesson.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `collection_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `lessons_lessonassignment_assigned_by_id_ed8b2358` (c) sobre `assigned_by_id`.
- `lessons_lessonassignment_lesson_id_52b19e73` (c) sobre `lesson_id`.
- `lessons_lessonassignment_dataset_id_07c252d8` (c) sobre `dataset_id`.
- `lessons_lessonassignment_collection_id_d30ca20a` (c) sobre `collection_id`.
- `sqlite_autoindex_lessons_lessonassignment_1` (unique, pk) sobre `id`.

## `logger_attemptlog`

**Proposito:** Intentos individuales de respuestas dentro de ejercicios o quizzes asociados a un MasteryLog.
**Filas observadas:** 11

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `item` | `varchar(200)` | No | No | `` |  | Identificador de pregunta/item dentro de una evaluacion. |
| `start_timestamp` | `varchar` | No | No | `` |  | Fecha/hora de inicio del evento o sesion. |
| `end_timestamp` | `varchar` | No | No | `` |  | Fecha/hora de finalizacion o ultima actividad registrada. |
| `completion_timestamp` | `varchar` | Si | No | `` |  | Fecha/hora en la que se marco como completado. |
| `time_spent` | `REAL` | No | No | `` |  | Tiempo acumulado en segundos. |
| `complete` | `bool` | No | No | `` |  | Indica si el intento o actividad esta completado. |
| `correct` | `REAL` | No | No | `` |  | Indica si una respuesta fue correcta. |
| `hinted` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `answer` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `simple_answer` | `varchar(200)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `interaction_history` | `TEXT` | No | No | `` |  | Historial JSON de interacciones del intento. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `masterylog_id` | `char(32)` | Si | No | `` | `logger_masterylog.id` | Referencia al intento/nivel de dominio de un ejercicio o quiz. |
| `sessionlog_id` | `char(32)` | No | No | `` | `logger_contentsessionlog.id` | Referencia a sessionlog. |
| `user_id` | `char(32)` | Si | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |
| `error` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `sessionlog_id` -> `logger_contentsessionlog.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `masterylog_id` -> `logger_masterylog.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `logger_attemptlog_user_id_cd57843f` (c) sobre `user_id`.
- `logger_attemptlog_sessionlog_id_0a239a1a` (c) sobre `sessionlog_id`.
- `logger_attemptlog_masterylog_id_d65af27c` (c) sobre `masterylog_id`.
- `logger_attemptlog_dataset_id_3017c88e` (c) sobre `dataset_id`.
- `sqlite_autoindex_logger_attemptlog_1` (unique, pk) sobre `id`.

## `logger_contentsessionlog`

**Proposito:** Sesiones de interaccion con un recurso; mide visitas, tiempo, progreso parcial y eventos por sesion.
**Filas observadas:** 11

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `content_id` | `char(32)` | No | No | `` |  | Identificador global del recurso de contenido; puede repetirse en varios ContentNode. |
| `start_timestamp` | `varchar` | No | No | `` |  | Fecha/hora de inicio del evento o sesion. |
| `end_timestamp` | `varchar` | Si | No | `` |  | Fecha/hora de finalizacion o ultima actividad registrada. |
| `time_spent` | `REAL` | No | No | `` |  | Tiempo acumulado en segundos. |
| `progress` | `REAL` | No | No | `` |  | Progreso acumulado o de sesion, normalmente entre 0 y 1; 1 indica completado. |
| `kind` | `varchar(200)` | No | No | `` |  | Tipo de recurso o entidad, por ejemplo topic, video, audio, exercise, document. |
| `extra_fields` | `TEXT` | No | No | `` |  | JSON con datos adicionales especificos del recurso o evento. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `user_id` | `char(32)` | Si | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |
| `visitor_id` | `char(32)` | Si | No | `` |  | Referencia a visitor. |
| `channel_id` | `char(32)` | Si | No | `` |  | Canal de contenido al que pertenece el recurso. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `logger_contentsessionlog_user_id_173ee284` (c) sobre `user_id`.
- `logger_contentsessionlog_dataset_id_9b53cdba` (c) sobre `dataset_id`.
- `logger_contentsessionlog_content_id_12ef7b71` (c) sobre `content_id`.
- `sqlite_autoindex_logger_contentsessionlog_1` (unique, pk) sobre `id`.

## `logger_contentsummarylog`

**Proposito:** Resumen acumulado por usuario y contenido; fuente principal para progreso, tiempo total y completitud.
**Filas observadas:** 10

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `content_id` | `char(32)` | No | No | `` |  | Identificador global del recurso de contenido; puede repetirse en varios ContentNode. |
| `start_timestamp` | `varchar` | No | No | `` |  | Fecha/hora de inicio del evento o sesion. |
| `end_timestamp` | `varchar` | Si | No | `` |  | Fecha/hora de finalizacion o ultima actividad registrada. |
| `completion_timestamp` | `varchar` | Si | No | `` |  | Fecha/hora en la que se marco como completado. |
| `time_spent` | `REAL` | No | No | `` |  | Tiempo acumulado en segundos. |
| `progress` | `REAL` | No | No | `` |  | Progreso acumulado o de sesion, normalmente entre 0 y 1; 1 indica completado. |
| `kind` | `varchar(200)` | No | No | `` |  | Tipo de recurso o entidad, por ejemplo topic, video, audio, exercise, document. |
| `extra_fields` | `TEXT` | No | No | `` |  | JSON con datos adicionales especificos del recurso o evento. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `user_id` | `char(32)` | No | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |
| `channel_id` | `char(32)` | Si | No | `` |  | Canal de contenido al que pertenece el recurso. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `logger_contentsummarylog_user_id_16aa2b2c` (c) sobre `user_id`.
- `logger_contentsummarylog_dataset_id_f9a1ad8e` (c) sobre `dataset_id`.
- `logger_contentsummarylog_content_id_2e21d8cf` (c) sobre `content_id`.
- `sqlite_autoindex_logger_contentsummarylog_1` (unique, pk) sobre `id`.

## `logger_examattemptlog`

**Proposito:** Intentos de preguntas dentro de examenes legacy o logs de examenes.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `item` | `varchar(200)` | No | No | `` |  | Identificador de pregunta/item dentro de una evaluacion. |
| `start_timestamp` | `varchar` | No | No | `` |  | Fecha/hora de inicio del evento o sesion. |
| `end_timestamp` | `varchar` | No | No | `` |  | Fecha/hora de finalizacion o ultima actividad registrada. |
| `completion_timestamp` | `varchar` | Si | No | `` |  | Fecha/hora en la que se marco como completado. |
| `time_spent` | `REAL` | No | No | `` |  | Tiempo acumulado en segundos. |
| `complete` | `bool` | No | No | `` |  | Indica si el intento o actividad esta completado. |
| `correct` | `REAL` | No | No | `` |  | Indica si una respuesta fue correcta. |
| `hinted` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `answer` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `simple_answer` | `varchar(200)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `interaction_history` | `TEXT` | No | No | `` |  | Historial JSON de interacciones del intento. |
| `content_id` | `char(32)` | No | No | `` |  | Identificador global del recurso de contenido; puede repetirse en varios ContentNode. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `examlog_id` | `char(32)` | No | No | `` | `logger_examlog.id` | Referencia a examlog. |
| `user_id` | `char(32)` | Si | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |
| `error` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `examlog_id` -> `logger_examlog.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `logger_examattemptlog_user_id_5442dc41` (c) sobre `user_id`.
- `logger_examattemptlog_examlog_id_ad0f674d` (c) sobre `examlog_id`.
- `logger_examattemptlog_dataset_id_9f9d1b24` (c) sobre `dataset_id`.
- `sqlite_autoindex_logger_examattemptlog_1` (unique, pk) sobre `id`.

## `logger_examlog`

**Proposito:** Resumen legacy del progreso de usuario en examenes.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `closed` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `exam_id` | `char(32)` | No | No | `` | `exams_exam.id` | Referencia a exam. |
| `user_id` | `char(32)` | No | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |
| `completion_timestamp` | `varchar` | Si | No | `` |  | Fecha/hora en la que se marco como completado. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `exam_id` -> `exams_exam.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `logger_examlog_user_id_05397f8b` (c) sobre `user_id`.
- `logger_examlog_exam_id_41856b8c` (c) sobre `exam_id`.
- `logger_examlog_dataset_id_13109aa7` (c) sobre `dataset_id`.
- `sqlite_autoindex_logger_examlog_1` (unique, pk) sobre `id`.

## `logger_generatecsvlogrequest`

**Proposito:** Solicitudes de generacion de CSV para logs de uso.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `selected_end_date` | `varchar` | Si | No | `` |  | Fecha/hora relacionada con el estado o ciclo de vida del registro. |
| `date_requested` | `varchar` | No | No | `` |  | Fecha/hora relacionada con el estado o ciclo de vida del registro. |
| `log_type` | `varchar(7)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `facility_id` | `char(32)` | No | No | `` | `kolibriauth_collection.id` | Facility asociada. |
| `selected_start_date` | `varchar` | Si | No | `` |  | Fecha/hora relacionada con el estado o ciclo de vida del registro. |

**Claves foraneas:**

- `facility_id` -> `kolibriauth_collection.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `logger_generatecsvlogrequest_facility_id_9d4a007d` (c) sobre `facility_id`.

## `logger_masterylog`

**Proposito:** Resumen de dominio por intento/nivel de dominio en ejercicios o quizzes.
**Filas observadas:** 2

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `mastery_criterion` | `TEXT` | No | No | `` |  | JSON con criterio de dominio usado para el ejercicio. |
| `start_timestamp` | `varchar` | No | No | `` |  | Fecha/hora de inicio del evento o sesion. |
| `end_timestamp` | `varchar` | Si | No | `` |  | Fecha/hora de finalizacion o ultima actividad registrada. |
| `completion_timestamp` | `varchar` | Si | No | `` |  | Fecha/hora en la que se marco como completado. |
| `mastery_level` | `INTEGER` | No | No | `` |  | Nivel/intento de dominio para ejercicios o quizzes. |
| `complete` | `bool` | No | No | `` |  | Indica si el intento o actividad esta completado. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `summarylog_id` | `char(32)` | No | No | `` | `logger_contentsummarylog.id` | Referencia al resumen acumulado de progreso del usuario en un contenido. |
| `user_id` | `char(32)` | No | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |
| `time_spent` | `REAL` | Si | No | `` |  | Tiempo acumulado en segundos. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `summarylog_id` -> `logger_contentsummarylog.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `logger_masterylog_user_id_3f58a1cb` (c) sobre `user_id`.
- `logger_masterylog_summarylog_id_f2816f59` (c) sobre `summarylog_id`.
- `logger_masterylog_dataset_id_f5b54331` (c) sobre `dataset_id`.
- `sqlite_autoindex_logger_masterylog_1` (unique, pk) sobre `id`.

## `logger_usersessionlog`

**Proposito:** Sesiones de uso de la aplicacion por usuario: paginas, timestamps y datos de dispositivo.
**Filas observadas:** 9

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `_morango_dirty_bit` | `bool` | No | No | `` |  | Bandera interna de Morango que marca cambios pendientes de sincronizacion. |
| `_morango_source_id` | `varchar(96)` | No | No | `` |  | Identificador fuente usado por Morango para calcular/versionar registros. |
| `_morango_partition` | `varchar(128)` | No | No | `` |  | Particion/scope de sincronizacion Morango. |
| `channels` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `start_timestamp` | `varchar` | No | No | `` |  | Fecha/hora de inicio del evento o sesion. |
| `last_interaction_timestamp` | `varchar` | Si | No | `` |  | Fecha/hora relacionada con el estado o ciclo de vida del registro. |
| `pages` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `dataset_id` | `char(32)` | No | No | `` | `kolibriauth_facilitydataset.id` | FacilityDataset al que pertenece el dato sincronizable. |
| `user_id` | `char(32)` | No | No | `` | `kolibriauth_facilityuser.id` | Usuario Kolibri asociado al registro. |
| `device_info` | `varchar(100)` | Si | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `user_id` -> `kolibriauth_facilityuser.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `dataset_id` -> `kolibriauth_facilitydataset.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `logger_usersessionlog_user_id_a755b0c2` (c) sobre `user_id`.
- `logger_usersessionlog_dataset_id_1a2bbb5f` (c) sobre `dataset_id`.
- `sqlite_autoindex_logger_usersessionlog_1` (unique, pk) sobre `id`.

## `morango_buffer`

**Proposito:** Buffer de Morango usado durante sincronizacion de datos entre dispositivos.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `serialized` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `deleted` | `bool` | No | No | `` |  | Bandera de borrado logico. |
| `last_saved_instance` | `char(32)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `last_saved_counter` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `model_name` | `varchar(40)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `profile` | `varchar(40)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `partition` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `model_uuid` | `char(32)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `transfer_session_id` | `char(32)` | No | No | `` | `morango_transfersession.id` | Referencia a transfer session. |
| `conflicting_serialized_data` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `_self_ref_fk` | `varchar(32)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `source_id` | `varchar(96)` | No | No | `` |  | Referencia a source. |
| `hard_deleted` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `transfer_session_id` -> `morango_transfersession.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `morango_buffer_transfer_session_id_8e70af5a` (c) sobre `transfer_session_id`.
- `morango_buffer_transfer_session_id_model_uuid_2a7288db_uniq` (unique, c) sobre `transfer_session_id`, `model_uuid`.

## `morango_certificate`

**Proposito:** Certificados de Morango para autorizacion y particiones de sincronizacion.
**Filas observadas:** 1

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `profile` | `varchar(20)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `scope_version` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `scope_params` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `public_key` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `serialized` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `signature` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `lft` | `integer unsigned` | No | No | `` |  | Indice izquierdo MPTT del arbol de contenido/colecciones. |
| `rght` | `integer unsigned` | No | No | `` |  | Indice derecho MPTT del arbol de contenido/colecciones. |
| `tree_id` | `integer unsigned` | No | No | `` |  | Identificador del arbol MPTT. |
| `level` | `integer unsigned` | No | No | `` |  | Nivel de profundidad en el arbol MPTT. |
| `scope_definition_id` | `varchar(20)` | No | No | `` | `morango_scopedefinition.id` | Referencia a scope definition. |
| `private_key` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `salt` | `varchar(32)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `parent_id` | `char(32)` | Si | No | `` | `morango_certificate.id` | Nodo o coleccion padre en una jerarquia. |

**Claves foraneas:**

- `parent_id` -> `morango_certificate.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `scope_definition_id` -> `morango_scopedefinition.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `morango_certificate_parent_id_60dedc2b` (c) sobre `parent_id`.
- `morango_certificate_scope_definition_id_1f75587b` (c) sobre `scope_definition_id`.
- `morango_certificate_tree_id_88a9f83c` (c) sobre `tree_id`.
- `sqlite_autoindex_morango_certificate_1` (unique, pk) sobre `id`.

## `morango_databaseidmodel`

**Proposito:** Identificador persistente de la base local para Morango.
**Filas observadas:** 1

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `current` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `date_generated` | `datetime` | No | No | `` |  | Fecha/hora relacionada con el estado o ciclo de vida del registro. |
| `initial_instance_id` | `varchar(32)` | No | No | `` |  | Referencia a initial instance. |

**Indices:**

- `sqlite_autoindex_morango_databaseidmodel_1` (unique, pk) sobre `id`.

## `morango_databasemaxcounter`

**Proposito:** Contadores maximos por base para control de cambios Morango.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `instance_id` | `char(32)` | No | No | `` |  | Referencia a instance. |
| `counter` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `partition` | `varchar(128)` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Indices:**

- `morango_databasemaxcounter_instance_id_partition_99e4f1fb_uniq` (unique, c) sobre `instance_id`, `partition`.

## `morango_deletedmodels`

**Proposito:** Registros de modelos borrados para propagacion durante sincronizacion.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `profile` | `varchar(40)` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Indices:**

- `sqlite_autoindex_morango_deletedmodels_1` (unique, pk) sobre `id`.

## `morango_harddeletedmodels`

**Proposito:** Registros de borrados permanentes para sincronizacion.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `profile` | `varchar(40)` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Indices:**

- `sqlite_autoindex_morango_harddeletedmodels_1` (unique, pk) sobre `id`.

## `morango_instanceidmodel`

**Proposito:** Identificador de instancia local Morango.
**Filas observadas:** 1

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `platform` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `hostname` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `sysversion` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `node_id` | `varchar(20)` | No | No | `` |  | Referencia a node. |
| `counter` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `current` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `db_path` | `varchar(1000)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `database_id` | `char(32)` | No | No | `` | `morango_databaseidmodel.id` | Referencia a database. |
| `system_id` | `varchar(100)` | No | No | `` |  | Referencia a system. |

**Claves foraneas:**

- `database_id` -> `morango_databaseidmodel.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `morango_instanceidmodel_database_id_3d1b7c0a` (c) sobre `database_id`.
- `sqlite_autoindex_morango_instanceidmodel_1` (unique, pk) sobre `id`.

## `morango_nonce`

**Proposito:** Nonces usados en autenticacion/sesiones de sincronizacion Morango.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `timestamp` | `datetime` | No | No | `` |  | Fecha/hora relacionada con el estado o ciclo de vida del registro. |
| `ip` | `varchar(100)` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Indices:**

- `sqlite_autoindex_morango_nonce_1` (unique, pk) sobre `id`.

## `morango_recordmaxcounter`

**Proposito:** Contadores maximos por registro para control de version Morango.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `instance_id` | `char(32)` | No | No | `` |  | Referencia a instance. |
| `counter` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `store_model_id` | `char(32)` | No | No | `` | `morango_store.id` | Referencia a store model. |

**Claves foraneas:**

- `store_model_id` -> `morango_store.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `morango_recordmaxcounter_store_model_id_2a91327d` (c) sobre `store_model_id`.
- `morango_recordmaxcounter_store_model_id_instance_id_d478818f_uniq` (unique, c) sobre `store_model_id`, `instance_id`.

## `morango_recordmaxcounterbuffer`

**Proposito:** Buffer temporal de contadores de registros durante transferencias Morango.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `instance_id` | `char(32)` | No | No | `` |  | Referencia a instance. |
| `counter` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `model_uuid` | `char(32)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `transfer_session_id` | `char(32)` | No | No | `` | `morango_transfersession.id` | Referencia a transfer session. |

**Claves foraneas:**

- `transfer_session_id` -> `morango_transfersession.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `morango_recordmaxcounterbuffer_transfer_session_id_1e48e3dd` (c) sobre `transfer_session_id`.
- `morango_recordmaxcounterbuffer_model_uuid_27589dbd` (c) sobre `model_uuid`.

## `morango_scopedefinition`

**Proposito:** Definiciones de scopes/particiones que controlan que datos se sincronizan.
**Filas observadas:** 2

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `profile` | `varchar(20)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `version` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `id` | `varchar(20)` | No | Si | `` |  | Clave primaria del registro. |
| `description` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `read_filter_template` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `write_filter_template` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `read_write_filter_template` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `primary_scope_param_key` | `varchar(20)` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Indices:**

- `sqlite_autoindex_morango_scopedefinition_1` (unique, pk) sobre `id`.

## `morango_sharedkey`

**Proposito:** Claves compartidas usadas por Morango para autenticacion de sync.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `public_key` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `private_key` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `current` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |

## `morango_store`

**Proposito:** Almacen generico de registros serializados usado por Morango durante sincronizacion.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `serialized` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `deleted` | `bool` | No | No | `` |  | Bandera de borrado logico. |
| `last_saved_instance` | `char(32)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `last_saved_counter` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `model_name` | `varchar(40)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `profile` | `varchar(40)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `partition` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `conflicting_serialized_data` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `_self_ref_fk` | `varchar(32)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `dirty_bit` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `source_id` | `varchar(96)` | No | No | `` |  | Referencia a source. |
| `hard_deleted` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `last_transfer_session_id` | `char(32)` | Si | No | `` |  | Referencia a last transfer session. |
| `deserialization_exception` | `varchar(255)` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `deserialization_error` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |

**Indices:**

- `idx_morango_deserialize` (c) sobre `profile`, `model_name`, `partition`, `dirty_bit`.
- `idx_morango_store_partition` (c) sobre `partition`.
- `morango_store_last_transfer_session_id_258a67a1` (c) sobre `last_transfer_session_id`.
- `sqlite_autoindex_morango_store_1` (unique, pk) sobre `id`.

## `morango_syncsession`

**Proposito:** Sesiones de sincronizacion entre instancias Morango.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `start_timestamp` | `datetime` | No | No | `` |  | Fecha/hora de inicio del evento o sesion. |
| `last_activity_timestamp` | `datetime` | No | No | `` |  | Fecha/hora relacionada con el estado o ciclo de vida del registro. |
| `active` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `connection_kind` | `varchar(10)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `connection_path` | `varchar(1000)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `is_server` | `bool` | No | No | `` |  | Bandera booleana de configuracion o estado. |
| `client_ip` | `varchar(100)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `profile` | `varchar(40)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `server_ip` | `varchar(100)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `client_certificate_id` | `char(32)` | Si | No | `` | `morango_certificate.id` | Referencia a client certificate. |
| `server_certificate_id` | `char(32)` | Si | No | `` | `morango_certificate.id` | Referencia a server certificate. |
| `extra_fields` | `TEXT` | No | No | `` |  | JSON con datos adicionales especificos del recurso o evento. |
| `process_id` | `INTEGER` | Si | No | `` |  | Referencia a process. |
| `client_instance_json` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `server_instance_json` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `client_instance_id` | `char(32)` | Si | No | `` |  | Referencia a client instance. |
| `server_instance_id` | `char(32)` | Si | No | `` |  | Referencia a server instance. |

**Claves foraneas:**

- `server_certificate_id` -> `morango_certificate.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `client_certificate_id` -> `morango_certificate.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `morango_syncsession_server_certificate_id_52bf728f` (c) sobre `server_certificate_id`.
- `morango_syncsession_client_certificate_id_507e0d5d` (c) sobre `client_certificate_id`.
- `sqlite_autoindex_morango_syncsession_1` (unique, pk) sobre `id`.

## `morango_transfersession`

**Proposito:** Transferencias individuales dentro de una sesion de sincronizacion Morango.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `char(32)` | No | Si | `` |  | Clave primaria del registro. |
| `filter` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `push` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `active` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `records_total` | `INTEGER` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `sync_session_id` | `char(32)` | No | No | `` | `morango_syncsession.id` | Referencia a sync session. |
| `last_activity_timestamp` | `datetime` | No | No | `` |  | Fecha/hora relacionada con el estado o ciclo de vida del registro. |
| `client_fsic` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `records_transferred` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `server_fsic` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `start_timestamp` | `datetime` | No | No | `` |  | Fecha/hora de inicio del evento o sesion. |
| `bytes_received` | `bigint` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `bytes_sent` | `bigint` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `transfer_stage` | `varchar(20)` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `transfer_stage_status` | `varchar(20)` | Si | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `sync_session_id` -> `morango_syncsession.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `morango_transfersession_sync_session_id_0455b5bd` (c) sobre `sync_session_id`.
- `sqlite_autoindex_morango_transfersession_1` (unique, pk) sobre `id`.

## `silk_profile`

**Proposito:** Datos de profiling de Django Silk para diagnostico de rendimiento.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `name` | `varchar(300)` | No | No | `` |  | Nombre legible de la entidad. |
| `start_time` | `datetime` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `end_time` | `datetime` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `time_taken` | `REAL` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `file_path` | `varchar(300)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `line_num` | `INTEGER` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `end_line_num` | `INTEGER` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `func_name` | `varchar(300)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `exception_raised` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `dynamic` | `bool` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `request_id` | `varchar(36)` | Si | No | `` | `silk_request.id` | Referencia a request. |

**Claves foraneas:**

- `request_id` -> `silk_request.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `silk_profile_request_id_7b81bd69` (c) sobre `request_id`.

## `silk_profile_queries`

**Proposito:** Relacion entre perfiles Silk y consultas SQL capturadas.
**Filas observadas:** 0

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `profile_id` | `INTEGER` | No | No | `` | `silk_profile.id` | Referencia a profile. |
| `sqlquery_id` | `INTEGER` | No | No | `` | `silk_sqlquery.id` | Referencia a sqlquery. |

**Claves foraneas:**

- `sqlquery_id` -> `silk_sqlquery.id`; on update `NO ACTION`, on delete `NO ACTION`.
- `profile_id` -> `silk_profile.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `silk_profile_queries_sqlquery_id_155df455` (c) sobre `sqlquery_id`.
- `silk_profile_queries_profile_id_a3d76db8` (c) sobre `profile_id`.
- `silk_profile_queries_profile_id_sqlquery_id_b2403d9b_uniq` (unique, c) sobre `profile_id`, `sqlquery_id`.

## `silk_request`

**Proposito:** Solicitudes HTTP capturadas por Django Silk.
**Filas observadas:** 991

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `varchar(36)` | No | Si | `` |  | Clave primaria del registro. |
| `path` | `varchar(190)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `query_params` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `raw_body` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `body` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `method` | `varchar(10)` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `start_time` | `datetime` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `view_name` | `varchar(190)` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `end_time` | `datetime` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `time_taken` | `REAL` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `encoded_headers` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `meta_time` | `REAL` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `meta_num_queries` | `INTEGER` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `meta_time_spent_queries` | `REAL` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `pyprofile` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `num_sql_queries` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `prof_file` | `varchar(300)` | No | No | `` |  | Campo de datos propio de esta tabla. |

**Indices:**

- `silk_request_view_name_68559f7b` (c) sobre `view_name`.
- `silk_request_start_time_1300bc58` (c) sobre `start_time`.
- `silk_request_path_9f3d798e` (c) sobre `path`.
- `sqlite_autoindex_silk_request_1` (unique, pk) sobre `id`.

## `silk_response`

**Proposito:** Respuestas HTTP capturadas por Django Silk.
**Filas observadas:** 991

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `status_code` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `raw_body` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `body` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `encoded_headers` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `request_id` | `varchar(36)` | No | No | `` | `silk_request.id` | Referencia a request. |
| `id` | `varchar(36)` | No | Si | `` |  | Clave primaria del registro. |

**Claves foraneas:**

- `request_id` -> `silk_request.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `sqlite_autoindex_silk_response_2` (unique, pk) sobre `id`.
- `sqlite_autoindex_silk_response_1` (unique, u) sobre `request_id`.

## `silk_sqlquery`

**Proposito:** Consultas SQL capturadas por Django Silk para analisis de rendimiento.
**Filas observadas:** 5307

| Columna | Tipo | Nulo | PK | Default | Referencia | Descripcion |
|---|---|---:|---:|---|---|---|
| `id` | `INTEGER` | No | Si | `` |  | Clave primaria del registro. |
| `query` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `start_time` | `datetime` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `end_time` | `datetime` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `time_taken` | `REAL` | Si | No | `` |  | Campo de datos propio de esta tabla. |
| `traceback` | `TEXT` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `request_id` | `varchar(36)` | Si | No | `` | `silk_request.id` | Referencia a request. |
| `identifier` | `INTEGER` | No | No | `` |  | Campo de datos propio de esta tabla. |
| `analysis` | `TEXT` | Si | No | `` |  | Campo de datos propio de esta tabla. |

**Claves foraneas:**

- `request_id` -> `silk_request.id`; on update `NO ACTION`, on delete `NO ACTION`.

**Indices:**

- `silk_sqlquery_request_id_6f8f0527` (c) sobre `request_id`.
