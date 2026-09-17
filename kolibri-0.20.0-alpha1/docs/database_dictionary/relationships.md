# Relaciones Principales

Este archivo resume las relaciones mas utiles para consultas. El detalle completo esta en `data_dictionary.md` y `schema.sql`.

## Progreso y consumo de recursos

- `logger_contentsummarylog.user_id` -> `kolibriauth_facilityuser.id`.
- `logger_contentsummarylog.content_id` se une logicamente con `content_contentnode.content_id`.
- `logger_contentsessionlog.user_id` -> `kolibriauth_facilityuser.id`.
- `logger_contentsessionlog.content_id` se une logicamente con `content_contentnode.content_id`.
- `logger_masterylog.summarylog_id` -> `logger_contentsummarylog.id`.
- `logger_attemptlog.masterylog_id` -> `logger_masterylog.id`.
- `content_assessmentmetadata.contentnode_id` -> `content_contentnode.id`.

Consulta base para progreso por usuario y recurso:

```sql
SELECT
  u.username,
  u.full_name,
  s.content_id,
  n.id AS contentnode_id,
  n.title,
  s.kind,
  s.progress,
  s.time_spent,
  s.end_timestamp,
  s.completion_timestamp
FROM logger_contentsummarylog s
JOIN kolibriauth_facilityuser u ON u.id = s.user_id
LEFT JOIN content_contentnode n ON n.content_id = s.content_id
WHERE n.kind IS NULL OR n.kind != 'topic'
ORDER BY u.username, s.end_timestamp DESC;
```

## Usuarios, facilities, clases y roles

- `kolibriauth_facilityuser.facility_id` -> `kolibriauth_collection.id`.
- `kolibriauth_facilityuser.dataset_id` -> `kolibriauth_facilitydataset.id`.
- `kolibriauth_membership.user_id` -> `kolibriauth_facilityuser.id`.
- `kolibriauth_membership.collection_id` -> `kolibriauth_collection.id`.
- `kolibriauth_role.user_id` -> `kolibriauth_facilityuser.id`.
- `kolibriauth_role.collection_id` -> `kolibriauth_collection.id`.
- `kolibriauth_collection.parent_id` modela jerarquia entre facility, clase y grupos.

## Contenido

- `content_contentnode.parent_id` -> `content_contentnode.id` para el arbol de contenido.
- `content_file.contentnode_id` -> `content_contentnode.id`.
- `content_file.local_file_id` -> `content_localfile.id`.
- `content_channelmetadata.root_id` -> `content_contentnode.id` cuando existe metadata del canal.
- Tablas `content_contentnode_*` son relaciones muchos-a-muchos de tags, relacionados y prerrequisitos.

## Asignaciones pedagogicas

- `lessons_lesson` define lecciones; sus recursos viven en campos JSON como `resources`.
- `lessons_lessonassignment.lesson_id` -> `lessons_lesson.id`.
- `lessons_lessonassignment.collection_id` -> `kolibriauth_collection.id`.
- `exams_examassignment.exam_id` -> `exams_exam.id`.
- `exams_examassignment.collection_id` -> `kolibriauth_collection.id`.
- `courses_coursesessionassignment.collection_id` -> `kolibriauth_collection.id`.

## Sincronizacion

- Tablas `morango_*` mantienen certificados, buffers, contadores y sesiones de sincronizacion.
- Las columnas `_morango_*` en tablas de negocio existen para control de cambios y particiones de sync.

## Claves Foraneas Detectadas por SQLite

| Tabla | Columna | Referencia | On delete |
|---|---|---|---|
| `analytics_pingbacknotificationdismissed` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `analytics_pingbacknotificationdismissed` | `notification_id` | `analytics_pingbacknotification.id` | `NO ACTION` |
| `attendance_attendancerecord` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `attendance_attendancerecord` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `attendance_attendancerecord` | `attendance_session_id` | `attendance_attendancesession.id` | `NO ACTION` |
| `attendance_attendancesession` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `attendance_attendancesession` | `created_by_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `attendance_attendancesession` | `collection_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `auth_group_permissions` | `permission_id` | `auth_permission.id` | `NO ACTION` |
| `auth_group_permissions` | `group_id` | `auth_group.id` | `NO ACTION` |
| `auth_permission` | `content_type_id` | `django_content_type.id` | `NO ACTION` |
| `bookmarks_bookmark` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `bookmarks_bookmark` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `content_assessmentmetadata` | `contentnode_id` | `content_contentnode.id` | `NO ACTION` |
| `content_channelmetadata` | `root_id` | `content_contentnode.id` | `NO ACTION` |
| `content_channelmetadata_included_languages` | `language_id` | `content_language.id` | `NO ACTION` |
| `content_channelmetadata_included_languages` | `channelmetadata_id` | `content_channelmetadata.id` | `NO ACTION` |
| `content_contentnode` | `parent_id` | `content_contentnode.id` | `NO ACTION` |
| `content_contentnode` | `lang_id` | `content_language.id` | `NO ACTION` |
| `content_contentnode_has_prerequisite` | `to_contentnode_id` | `content_contentnode.id` | `NO ACTION` |
| `content_contentnode_has_prerequisite` | `from_contentnode_id` | `content_contentnode.id` | `NO ACTION` |
| `content_contentnode_related` | `to_contentnode_id` | `content_contentnode.id` | `NO ACTION` |
| `content_contentnode_related` | `from_contentnode_id` | `content_contentnode.id` | `NO ACTION` |
| `content_contentnode_tags` | `contenttag_id` | `content_contenttag.id` | `NO ACTION` |
| `content_contentnode_tags` | `contentnode_id` | `content_contentnode.id` | `NO ACTION` |
| `content_contentrequest` | `facility_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `content_file` | `local_file_id` | `content_localfile.id` | `NO ACTION` |
| `content_file` | `lang_id` | `content_language.id` | `NO ACTION` |
| `content_file` | `contentnode_id` | `content_contentnode.id` | `NO ACTION` |
| `courses_coursesession` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `courses_coursesession` | `created_by_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `courses_coursesession` | `collection_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `courses_coursesessionassignment` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `courses_coursesessionassignment` | `course_session_id` | `courses_coursesession.id` | `NO ACTION` |
| `courses_coursesessionassignment` | `collection_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `courses_coursesessionassignment` | `assigned_by_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `courses_unittestassignment` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `courses_unittestassignment` | `course_session_id` | `courses_coursesession.id` | `NO ACTION` |
| `courses_unittestassignment` | `collection_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `courses_unittestassignment` | `activated_by_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `device_devicepermissions` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `device_devicesettings` | `default_facility_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `device_learnerdevicestatus` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `device_learnerdevicestatus` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `device_osuser` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `device_usersyncstatus` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `device_usersyncstatus` | `sync_session_id` | `morango_syncsession.id` | `NO ACTION` |
| `discovery_pinneddevice` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `exams_draftexam` | `creator_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `exams_draftexam` | `collection_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `exams_exam` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `exams_exam` | `creator_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `exams_exam` | `collection_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `exams_examassignment` | `assigned_by_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `exams_examassignment` | `exam_id` | `exams_exam.id` | `NO ACTION` |
| `exams_examassignment` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `exams_examassignment` | `collection_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `exams_individualsyncableexam` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `exams_individualsyncableexam` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `exams_individualsyncableexam` | `collection_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `kolibriauth_collection` | `parent_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `kolibriauth_collection` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `kolibriauth_facilityuser` | `facility_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `kolibriauth_facilityuser` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `kolibriauth_membership` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `kolibriauth_membership` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `kolibriauth_membership` | `collection_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `kolibriauth_role` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `kolibriauth_role` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `kolibriauth_role` | `collection_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `lessons_individualsyncablelesson` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `lessons_individualsyncablelesson` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `lessons_individualsyncablelesson` | `collection_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `lessons_lesson` | `created_by_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `lessons_lesson` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `lessons_lesson` | `collection_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `lessons_lessonassignment` | `assigned_by_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `lessons_lessonassignment` | `lesson_id` | `lessons_lesson.id` | `NO ACTION` |
| `lessons_lessonassignment` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `lessons_lessonassignment` | `collection_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `logger_attemptlog` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `logger_attemptlog` | `sessionlog_id` | `logger_contentsessionlog.id` | `NO ACTION` |
| `logger_attemptlog` | `masterylog_id` | `logger_masterylog.id` | `NO ACTION` |
| `logger_attemptlog` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `logger_contentsessionlog` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `logger_contentsessionlog` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `logger_contentsummarylog` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `logger_contentsummarylog` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `logger_examattemptlog` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `logger_examattemptlog` | `examlog_id` | `logger_examlog.id` | `NO ACTION` |
| `logger_examattemptlog` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `logger_examlog` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `logger_examlog` | `exam_id` | `exams_exam.id` | `NO ACTION` |
| `logger_examlog` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `logger_generatecsvlogrequest` | `facility_id` | `kolibriauth_collection.id` | `NO ACTION` |
| `logger_masterylog` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `logger_masterylog` | `summarylog_id` | `logger_contentsummarylog.id` | `NO ACTION` |
| `logger_masterylog` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `logger_usersessionlog` | `user_id` | `kolibriauth_facilityuser.id` | `NO ACTION` |
| `logger_usersessionlog` | `dataset_id` | `kolibriauth_facilitydataset.id` | `NO ACTION` |
| `morango_buffer` | `transfer_session_id` | `morango_transfersession.id` | `NO ACTION` |
| `morango_certificate` | `parent_id` | `morango_certificate.id` | `NO ACTION` |
| `morango_certificate` | `scope_definition_id` | `morango_scopedefinition.id` | `NO ACTION` |
| `morango_instanceidmodel` | `database_id` | `morango_databaseidmodel.id` | `NO ACTION` |
| `morango_recordmaxcounter` | `store_model_id` | `morango_store.id` | `NO ACTION` |
| `morango_recordmaxcounterbuffer` | `transfer_session_id` | `morango_transfersession.id` | `NO ACTION` |
| `morango_syncsession` | `server_certificate_id` | `morango_certificate.id` | `NO ACTION` |
| `morango_syncsession` | `client_certificate_id` | `morango_certificate.id` | `NO ACTION` |
| `morango_transfersession` | `sync_session_id` | `morango_syncsession.id` | `NO ACTION` |
| `silk_profile` | `request_id` | `silk_request.id` | `NO ACTION` |
| `silk_profile_queries` | `sqlquery_id` | `silk_sqlquery.id` | `NO ACTION` |
| `silk_profile_queries` | `profile_id` | `silk_profile.id` | `NO ACTION` |
| `silk_response` | `request_id` | `silk_request.id` | `NO ACTION` |
| `silk_sqlquery` | `request_id` | `silk_request.id` | `NO ACTION` |
