-- Esquema SQL extraido de SQLite
-- Base: kolibri-data-dev/db.sqlite3
-- Generado: 2026-09-14 15:05:22

-- analytics_localnotification
CREATE TABLE "analytics_localnotification" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "key" varchar(50) NOT NULL UNIQUE, "created_at" datetime NOT NULL);

-- analytics_pingbacknotification
CREATE TABLE "analytics_pingbacknotification" ("id" varchar(50) NOT NULL PRIMARY KEY, "version_range" varchar(50) NOT NULL, "timestamp" date NOT NULL, "link_url" varchar(150) NOT NULL, "i18n" text NOT NULL, "active" bool NOT NULL, "source" varchar(20) NOT NULL);

-- analytics_pingbacknotificationdismissed
CREATE TABLE "analytics_pingbacknotificationdismissed" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "notification_id" varchar(50) NOT NULL REFERENCES "analytics_pingbacknotification" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" char(32) NOT NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED);

-- attendance_attendancerecord
CREATE TABLE "attendance_attendancerecord" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "present" bool NOT NULL, "attendance_session_id" char(32) NOT NULL REFERENCES "attendance_attendancesession" ("id") DEFERRABLE INITIALLY DEFERRED, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" char(32) NOT NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED);

-- attendance_attendancesession
CREATE TABLE "attendance_attendancesession" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "session_start_datetime" varchar NOT NULL, "date_created" varchar NOT NULL, "date_modified" varchar NOT NULL, "collection_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "created_by_id" char(32) NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED);

-- auth_group
CREATE TABLE "auth_group" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(150) NOT NULL UNIQUE);

-- auth_group_permissions
CREATE TABLE "auth_group_permissions" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "group_id" integer NOT NULL REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED, "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED);

-- auth_permission
CREATE TABLE "auth_permission" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "content_type_id" integer NOT NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "codename" varchar(100) NOT NULL, "name" varchar(255) NOT NULL);

-- bookmarks_bookmark
CREATE TABLE "bookmarks_bookmark" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "content_id" char(32) NULL, "channel_id" char(32) NULL, "contentnode_id" char(32) NOT NULL, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" char(32) NOT NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "created" datetime NOT NULL);

-- content_assessmentmetadata
CREATE TABLE "content_assessmentmetadata" ("id" char(32) NOT NULL PRIMARY KEY, "assessment_item_ids" text NOT NULL, "number_of_assessments" integer NOT NULL, "mastery_model" text NOT NULL, "randomize" bool NOT NULL, "is_manipulable" bool NOT NULL, "contentnode_id" char(32) NOT NULL REFERENCES "content_contentnode" ("id") DEFERRABLE INITIALLY DEFERRED);

-- content_channelmetadata
CREATE TABLE "content_channelmetadata" ("id" char(32) NOT NULL PRIMARY KEY, "name" varchar(200) NOT NULL, "description" varchar(400) NOT NULL, "author" varchar(400) NOT NULL, "version" integer NOT NULL, "thumbnail" text NOT NULL, "last_updated" varchar NULL, "min_schema_version" varchar(50) NOT NULL, "root_id" char(32) NOT NULL REFERENCES "content_contentnode" ("id") DEFERRABLE INITIALLY DEFERRED, "published_size" bigint NULL, "total_resource_count" integer NULL, "order" integer unsigned NULL CHECK ("order" >= 0), "public" bool NULL, "tagline" varchar(150) NULL, "partial" bool NULL, "included_categories" text NULL, "included_grade_levels" text NULL, "library" varchar(50) NULL);

-- content_channelmetadata_included_languages
CREATE TABLE "content_channelmetadata_included_languages" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "sort_value" integer NOT NULL, "channelmetadata_id" char(32) NOT NULL REFERENCES "content_channelmetadata" ("id") DEFERRABLE INITIALLY DEFERRED, "language_id" varchar(14) NOT NULL REFERENCES "content_language" ("id") DEFERRABLE INITIALLY DEFERRED);

-- content_contentnode
CREATE TABLE "content_contentnode" ("id" char(32) NOT NULL PRIMARY KEY, "title" varchar(200) NOT NULL, "content_id" char(32) NOT NULL, "channel_id" char(32) NOT NULL, "description" text NULL, "sort_order" real NULL, "license_owner" varchar(200) NOT NULL, "author" varchar(200) NOT NULL, "kind" varchar(200) NOT NULL, "available" bool NOT NULL, "lft" integer unsigned NOT NULL CHECK ("lft" >= 0), "rght" integer unsigned NOT NULL CHECK ("rght" >= 0), "tree_id" integer unsigned NOT NULL CHECK ("tree_id" >= 0), "level" integer unsigned NOT NULL CHECK ("level" >= 0), "lang_id" varchar(14) NULL REFERENCES "content_language" ("id") DEFERRABLE INITIALLY DEFERRED, "license_description" text NULL, "license_name" varchar(50) NULL, "coach_content" bool NOT NULL, "num_coach_contents" integer NULL, "on_device_resources" integer NULL, "options" text NULL, "accessibility_labels" text NULL, "categories" text NULL, "duration" integer unsigned NULL CHECK ("duration" >= 0), "grade_levels" text NULL, "learner_needs" text NULL, "learning_activities" text NULL, "resource_types" text NULL, "accessibility_labels_bitmask_0" bigint NULL, "categories_bitmask_0" bigint NULL, "grade_levels_bitmask_0" bigint NULL, "learner_needs_bitmask_0" bigint NULL, "learning_activities_bitmask_0" bigint NULL, "ancestors" text NULL, "admin_imported" bool NULL, "modality" varchar(50) NULL, "parent_id" char(32) NULL REFERENCES "content_contentnode" ("id") DEFERRABLE INITIALLY DEFERRED);

-- content_contentnode_has_prerequisite
CREATE TABLE "content_contentnode_has_prerequisite" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "from_contentnode_id" char(32) NOT NULL REFERENCES "content_contentnode" ("id") DEFERRABLE INITIALLY DEFERRED, "to_contentnode_id" char(32) NOT NULL REFERENCES "content_contentnode" ("id") DEFERRABLE INITIALLY DEFERRED);

-- content_contentnode_related
CREATE TABLE "content_contentnode_related" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "from_contentnode_id" char(32) NOT NULL REFERENCES "content_contentnode" ("id") DEFERRABLE INITIALLY DEFERRED, "to_contentnode_id" char(32) NOT NULL REFERENCES "content_contentnode" ("id") DEFERRABLE INITIALLY DEFERRED);

-- content_contentnode_tags
CREATE TABLE "content_contentnode_tags" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "contentnode_id" char(32) NOT NULL REFERENCES "content_contentnode" ("id") DEFERRABLE INITIALLY DEFERRED, "contenttag_id" char(32) NOT NULL REFERENCES "content_contenttag" ("id") DEFERRABLE INITIALLY DEFERRED);

-- content_contentrequest
CREATE TABLE "content_contentrequest" ("id" char(32) NOT NULL PRIMARY KEY, "source_model" varchar(40) NOT NULL, "source_id" char(32) NOT NULL, "requested_at" varchar NOT NULL, "type" varchar(8) NOT NULL, "reason" varchar(14) NOT NULL, "status" varchar(11) NOT NULL, "contentnode_id" char(32) NOT NULL, "metadata" text NULL, "facility_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "source_instance_id" char(32) NULL, "priority" integer NULL, "channel_version" integer NULL);

-- content_contenttag
CREATE TABLE "content_contenttag" ("id" char(32) NOT NULL PRIMARY KEY, "tag_name" varchar(30) NOT NULL);

-- content_file
CREATE TABLE "content_file" ("id" char(32) NOT NULL PRIMARY KEY, "preset" varchar(150) NOT NULL, "supplementary" bool NOT NULL, "thumbnail" bool NOT NULL, "priority" integer NULL, "contentnode_id" char(32) NOT NULL REFERENCES "content_contentnode" ("id") DEFERRABLE INITIALLY DEFERRED, "lang_id" varchar(14) NULL REFERENCES "content_language" ("id") DEFERRABLE INITIALLY DEFERRED, "local_file_id" varchar(32) NOT NULL REFERENCES "content_localfile" ("id") DEFERRABLE INITIALLY DEFERRED, "included_presets" integer NULL);

-- content_language
CREATE TABLE "content_language" ("id" varchar(14) NOT NULL PRIMARY KEY, "lang_code" varchar(3) NOT NULL, "lang_subcode" varchar(10) NULL, "lang_name" varchar(100) NULL, "lang_direction" varchar(3) NOT NULL);

-- content_localfile
CREATE TABLE "content_localfile" ("id" varchar(32) NOT NULL PRIMARY KEY, "extension" varchar(40) NOT NULL, "available" bool NOT NULL, "file_size_bigint" bigint NULL);

-- courses_coursesession
CREATE TABLE "courses_coursesession" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "course" char(32) NOT NULL, "title" varchar(200) NOT NULL, "description" text NULL, "is_active" bool NOT NULL, "date_created" varchar NOT NULL, "collection_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "created_by_id" char(32) NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "channel_version" integer NULL);

-- courses_coursesessionassignment
CREATE TABLE "courses_coursesessionassignment" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "assigned_by_id" char(32) NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "collection_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "course_session_id" char(32) NOT NULL REFERENCES "courses_coursesession" ("id") DEFERRABLE INITIALLY DEFERRED, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED);

-- courses_unittestassignment
CREATE TABLE "courses_unittestassignment" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "unit_contentnode_id" char(32) NOT NULL, "test_type" varchar(10) NOT NULL, "activated_by_id" char(32) NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "collection_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "course_session_id" char(32) NOT NULL REFERENCES "courses_coursesession" ("id") DEFERRABLE INITIALLY DEFERRED, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "closed" bool NOT NULL);

-- device_contentcachekey
CREATE TABLE "device_contentcachekey" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "key" integer NOT NULL);

-- device_deviceappkey
CREATE TABLE "device_deviceappkey" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "key" char(32) NOT NULL);

-- device_devicepermissions
CREATE TABLE "device_devicepermissions" ("user_id" char(32) NOT NULL PRIMARY KEY REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "is_superuser" bool NOT NULL, "can_manage_content" bool NOT NULL);

-- device_devicesettings
CREATE TABLE "device_devicesettings" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "is_provisioned" bool NOT NULL, "language_id" varchar(15) NULL, "default_facility_id" char(32) NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "allow_guest_access" bool NOT NULL, "allow_learner_unassigned_resource_access" bool NOT NULL, "allow_peer_unlisted_channel_import" bool NOT NULL, "landing_page" varchar(7) NOT NULL, "name" varchar(50) NOT NULL, "allow_other_browsers_to_connect" bool NOT NULL, "subset_of_users_device" bool NOT NULL, "extra_settings" text NOT NULL);

-- device_learnerdevicestatus
CREATE TABLE "device_learnerdevicestatus" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "instance_id" char(32) NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "status" varchar(32) NOT NULL, "status_sentiment" integer NOT NULL, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" char(32) NOT NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED);

-- device_osuser
CREATE TABLE "device_osuser" ("user_id" char(32) NOT NULL PRIMARY KEY REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "os_username" varchar(64) NOT NULL);

-- device_sqlitelock
CREATE TABLE "device_sqlitelock" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT);

-- device_usersyncstatus
CREATE TABLE "device_usersyncstatus" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "sync_session_id" char(32) NULL REFERENCES "morango_syncsession" ("id") DEFERRABLE INITIALLY DEFERRED, "status" varchar(20) NOT NULL, "updated" datetime NOT NULL, "user_id" char(32) NOT NULL UNIQUE REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED);

-- discovery_pinneddevice
CREATE TABLE "discovery_pinneddevice" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "instance_id" char(32) NOT NULL, "created" datetime NOT NULL, "user_id" char(32) NOT NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED);

-- django_content_type
CREATE TABLE "django_content_type" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "app_label" varchar(100) NOT NULL, "model" varchar(100) NOT NULL);

-- django_migrations
CREATE TABLE "django_migrations" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "app" varchar(255) NOT NULL, "name" varchar(255) NOT NULL, "applied" datetime NOT NULL);

-- exams_draftexam
CREATE TABLE "exams_draftexam" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "title" varchar(200) NOT NULL, "question_count" integer NOT NULL, "question_sources" text NOT NULL, "seed" integer NOT NULL, "learners_see_fixed_order" bool NOT NULL, "data_model_version" smallint NOT NULL, "date_created" datetime NULL, "assignments" text NOT NULL, "learner_ids" text NOT NULL, "collection_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "creator_id" char(32) NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "instant_report_visibility" bool NULL);

-- exams_exam
CREATE TABLE "exams_exam" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "title" varchar(200) NOT NULL, "question_count" integer NOT NULL, "question_sources" text NOT NULL, "seed" integer NOT NULL, "active" bool NOT NULL, "archive" bool NOT NULL, "collection_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "creator_id" char(32) NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "data_model_version" smallint NOT NULL, "learners_see_fixed_order" bool NOT NULL, "date_created" datetime NOT NULL, "date_archived" datetime NULL, "date_activated" datetime NULL, "instant_report_visibility" bool NULL);

-- exams_examassignment
CREATE TABLE "exams_examassignment" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "collection_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "exam_id" char(32) NOT NULL REFERENCES "exams_exam" ("id") DEFERRABLE INITIALLY DEFERRED, "assigned_by_id" char(32) NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED);

-- exams_individualsyncableexam
CREATE TABLE "exams_individualsyncableexam" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "exam_id" char(32) NOT NULL, "serialized_exam" text NOT NULL, "collection_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" char(32) NOT NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED);

-- kolibriauth_collection
CREATE TABLE "kolibriauth_collection" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "name" varchar(100) NOT NULL, "kind" varchar(20) NOT NULL, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "parent_id" char(32) NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED);

-- kolibriauth_facilitydataset
CREATE TABLE "kolibriauth_facilitydataset" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "description" text NOT NULL, "location" varchar(200) NOT NULL, "learner_can_edit_username" bool NOT NULL, "learner_can_edit_name" bool NOT NULL, "learner_can_edit_password" bool NOT NULL, "learner_can_sign_up" bool NOT NULL, "learner_can_delete_account" bool NOT NULL, "learner_can_login_with_no_password" bool NOT NULL, "preset" varchar(50) NOT NULL, "show_download_button_in_learn" bool NOT NULL, "registered" bool NOT NULL, "extra_fields" text NULL, "enable_mark_attendance" bool NOT NULL, "picture_password_settings" text NULL);

-- kolibriauth_facilityuser
CREATE TABLE "kolibriauth_facilityuser" ("password" varchar(128) NOT NULL, "last_login" datetime NULL, "id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "username" varchar(254) NOT NULL, "full_name" varchar(120) NOT NULL, "date_joined" varchar NOT NULL, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "facility_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "birth_year" varchar(16) NOT NULL, "gender" varchar(16) NOT NULL, "id_number" varchar(64) NOT NULL, "extra_demographics" text NULL, "date_deleted" varchar NULL, "picture_password" varchar(8) NULL);

-- kolibriauth_membership
CREATE TABLE "kolibriauth_membership" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "collection_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" char(32) NOT NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED);

-- kolibriauth_role
CREATE TABLE "kolibriauth_role" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "collection_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" char(32) NOT NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "kind" varchar(26) NOT NULL);

-- lessons_individualsyncablelesson
CREATE TABLE "lessons_individualsyncablelesson" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "lesson_id" char(32) NOT NULL, "serialized_lesson" text NOT NULL, "collection_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" char(32) NOT NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED);

-- lessons_lesson
CREATE TABLE "lessons_lesson" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "description" varchar(200) NOT NULL, "resources" text NOT NULL, "is_active" bool NOT NULL, "collection_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "title" varchar(50) NOT NULL, "date_created" varchar NOT NULL, "created_by_id" char(32) NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED);

-- lessons_lessonassignment
CREATE TABLE "lessons_lessonassignment" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "collection_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "lesson_id" char(32) NOT NULL REFERENCES "lessons_lesson" ("id") DEFERRABLE INITIALLY DEFERRED, "assigned_by_id" char(32) NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED);

-- logger_attemptlog
CREATE TABLE "logger_attemptlog" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "item" varchar(200) NOT NULL, "start_timestamp" varchar NOT NULL, "end_timestamp" varchar NOT NULL, "completion_timestamp" varchar NULL, "time_spent" real NOT NULL, "complete" bool NOT NULL, "correct" real NOT NULL, "hinted" bool NOT NULL, "answer" text NULL, "simple_answer" varchar(200) NOT NULL, "interaction_history" text NOT NULL, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "masterylog_id" char(32) NULL REFERENCES "logger_masterylog" ("id") DEFERRABLE INITIALLY DEFERRED, "sessionlog_id" char(32) NOT NULL REFERENCES "logger_contentsessionlog" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" char(32) NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "error" bool NOT NULL);

-- logger_contentsessionlog
CREATE TABLE "logger_contentsessionlog" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "content_id" char(32) NOT NULL, "start_timestamp" varchar NOT NULL, "end_timestamp" varchar NULL, "time_spent" real NOT NULL, "progress" real NOT NULL, "kind" varchar(200) NOT NULL, "extra_fields" text NOT NULL, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" char(32) NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "visitor_id" char(32) NULL, "channel_id" char(32) NULL);

-- logger_contentsummarylog
CREATE TABLE "logger_contentsummarylog" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "content_id" char(32) NOT NULL, "start_timestamp" varchar NOT NULL, "end_timestamp" varchar NULL, "completion_timestamp" varchar NULL, "time_spent" real NOT NULL, "progress" real NOT NULL, "kind" varchar(200) NOT NULL, "extra_fields" text NOT NULL, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" char(32) NOT NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "channel_id" char(32) NULL);

-- logger_examattemptlog
CREATE TABLE "logger_examattemptlog" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "item" varchar(200) NOT NULL, "start_timestamp" varchar NOT NULL, "end_timestamp" varchar NOT NULL, "completion_timestamp" varchar NULL, "time_spent" real NOT NULL, "complete" bool NOT NULL, "correct" real NOT NULL, "hinted" bool NOT NULL, "answer" text NULL, "simple_answer" varchar(200) NOT NULL, "interaction_history" text NOT NULL, "content_id" char(32) NOT NULL, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "examlog_id" char(32) NOT NULL REFERENCES "logger_examlog" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" char(32) NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "error" bool NOT NULL);

-- logger_examlog
CREATE TABLE "logger_examlog" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "closed" bool NOT NULL, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "exam_id" char(32) NOT NULL REFERENCES "exams_exam" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" char(32) NOT NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "completion_timestamp" varchar NULL);

-- logger_generatecsvlogrequest
CREATE TABLE "logger_generatecsvlogrequest" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "selected_end_date" varchar NULL, "date_requested" varchar NOT NULL, "log_type" varchar(7) NOT NULL, "facility_id" char(32) NOT NULL REFERENCES "kolibriauth_collection" ("id") DEFERRABLE INITIALLY DEFERRED, "selected_start_date" varchar NULL);

-- logger_masterylog
CREATE TABLE "logger_masterylog" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "mastery_criterion" text NOT NULL, "start_timestamp" varchar NOT NULL, "end_timestamp" varchar NULL, "completion_timestamp" varchar NULL, "mastery_level" integer NOT NULL, "complete" bool NOT NULL, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "summarylog_id" char(32) NOT NULL REFERENCES "logger_contentsummarylog" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" char(32) NOT NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "time_spent" real NULL);

-- logger_usersessionlog
CREATE TABLE "logger_usersessionlog" ("id" char(32) NOT NULL PRIMARY KEY, "_morango_dirty_bit" bool NOT NULL, "_morango_source_id" varchar(96) NOT NULL, "_morango_partition" varchar(128) NOT NULL, "channels" text NOT NULL, "start_timestamp" varchar NOT NULL, "last_interaction_timestamp" varchar NULL, "pages" text NOT NULL, "dataset_id" char(32) NOT NULL REFERENCES "kolibriauth_facilitydataset" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" char(32) NOT NULL REFERENCES "kolibriauth_facilityuser" ("id") DEFERRABLE INITIALLY DEFERRED, "device_info" varchar(100) NULL);

-- morango_buffer
CREATE TABLE "morango_buffer" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "serialized" text NOT NULL, "deleted" bool NOT NULL, "last_saved_instance" char(32) NOT NULL, "last_saved_counter" integer NOT NULL, "model_name" varchar(40) NOT NULL, "profile" varchar(40) NOT NULL, "partition" text NOT NULL, "model_uuid" char(32) NOT NULL, "transfer_session_id" char(32) NOT NULL REFERENCES "morango_transfersession" ("id") DEFERRABLE INITIALLY DEFERRED, "conflicting_serialized_data" text NOT NULL, "_self_ref_fk" varchar(32) NOT NULL, "source_id" varchar(96) NOT NULL, "hard_deleted" bool NOT NULL);

-- morango_certificate
CREATE TABLE "morango_certificate" ("id" char(32) NOT NULL PRIMARY KEY, "profile" varchar(20) NOT NULL, "scope_version" integer NOT NULL, "scope_params" text NOT NULL, "public_key" text NOT NULL, "serialized" text NOT NULL, "signature" text NOT NULL, "lft" integer unsigned NOT NULL CHECK ("lft" >= 0), "rght" integer unsigned NOT NULL CHECK ("rght" >= 0), "tree_id" integer unsigned NOT NULL CHECK ("tree_id" >= 0), "level" integer unsigned NOT NULL CHECK ("level" >= 0), "scope_definition_id" varchar(20) NOT NULL REFERENCES "morango_scopedefinition" ("id") DEFERRABLE INITIALLY DEFERRED, "private_key" text NULL, "salt" varchar(32) NOT NULL, "parent_id" char(32) NULL REFERENCES "morango_certificate" ("id") DEFERRABLE INITIALLY DEFERRED);

-- morango_databaseidmodel
CREATE TABLE "morango_databaseidmodel" ("id" char(32) NOT NULL PRIMARY KEY, "current" bool NOT NULL, "date_generated" datetime NOT NULL, "initial_instance_id" varchar(32) NOT NULL);

-- morango_databasemaxcounter
CREATE TABLE "morango_databasemaxcounter" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "instance_id" char(32) NOT NULL, "counter" integer NOT NULL, "partition" varchar(128) NOT NULL);

-- morango_deletedmodels
CREATE TABLE "morango_deletedmodels" ("id" char(32) NOT NULL PRIMARY KEY, "profile" varchar(40) NOT NULL);

-- morango_harddeletedmodels
CREATE TABLE "morango_harddeletedmodels" ("id" char(32) NOT NULL PRIMARY KEY, "profile" varchar(40) NOT NULL);

-- morango_instanceidmodel
CREATE TABLE "morango_instanceidmodel" ("id" char(32) NOT NULL PRIMARY KEY, "platform" text NOT NULL, "hostname" text NOT NULL, "sysversion" text NOT NULL, "node_id" varchar(20) NOT NULL, "counter" integer NOT NULL, "current" bool NOT NULL, "db_path" varchar(1000) NOT NULL, "database_id" char(32) NOT NULL REFERENCES "morango_databaseidmodel" ("id") DEFERRABLE INITIALLY DEFERRED, "system_id" varchar(100) NOT NULL);

-- morango_nonce
CREATE TABLE "morango_nonce" ("id" char(32) NOT NULL PRIMARY KEY, "timestamp" datetime NOT NULL, "ip" varchar(100) NOT NULL);

-- morango_recordmaxcounter
CREATE TABLE "morango_recordmaxcounter" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "instance_id" char(32) NOT NULL, "counter" integer NOT NULL, "store_model_id" char(32) NOT NULL REFERENCES "morango_store" ("id") DEFERRABLE INITIALLY DEFERRED);

-- morango_recordmaxcounterbuffer
CREATE TABLE "morango_recordmaxcounterbuffer" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "instance_id" char(32) NOT NULL, "counter" integer NOT NULL, "model_uuid" char(32) NOT NULL, "transfer_session_id" char(32) NOT NULL REFERENCES "morango_transfersession" ("id") DEFERRABLE INITIALLY DEFERRED);

-- morango_scopedefinition
CREATE TABLE "morango_scopedefinition" ("profile" varchar(20) NOT NULL, "version" integer NOT NULL, "id" varchar(20) NOT NULL PRIMARY KEY, "description" text NOT NULL, "read_filter_template" text NOT NULL, "write_filter_template" text NOT NULL, "read_write_filter_template" text NOT NULL, "primary_scope_param_key" varchar(20) NOT NULL);

-- morango_sharedkey
CREATE TABLE "morango_sharedkey" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "public_key" text NOT NULL, "private_key" text NOT NULL, "current" bool NOT NULL);

-- morango_store
CREATE TABLE "morango_store" ("serialized" text NOT NULL, "deleted" bool NOT NULL, "last_saved_instance" char(32) NOT NULL, "last_saved_counter" integer NOT NULL, "model_name" varchar(40) NOT NULL, "profile" varchar(40) NOT NULL, "partition" text NOT NULL, "id" char(32) NOT NULL PRIMARY KEY, "conflicting_serialized_data" text NOT NULL, "_self_ref_fk" varchar(32) NOT NULL, "dirty_bit" bool NOT NULL, "source_id" varchar(96) NOT NULL, "hard_deleted" bool NOT NULL, "last_transfer_session_id" char(32) NULL, "deserialization_exception" varchar(255) NULL, "deserialization_error" text NULL);

-- morango_syncsession
CREATE TABLE "morango_syncsession" ("id" char(32) NOT NULL PRIMARY KEY, "start_timestamp" datetime NOT NULL, "last_activity_timestamp" datetime NOT NULL, "active" bool NOT NULL, "connection_kind" varchar(10) NOT NULL, "connection_path" varchar(1000) NOT NULL, "is_server" bool NOT NULL, "client_ip" varchar(100) NOT NULL, "profile" varchar(40) NOT NULL, "server_ip" varchar(100) NOT NULL, "client_certificate_id" char(32) NULL REFERENCES "morango_certificate" ("id") DEFERRABLE INITIALLY DEFERRED, "server_certificate_id" char(32) NULL REFERENCES "morango_certificate" ("id") DEFERRABLE INITIALLY DEFERRED, "extra_fields" text NOT NULL, "process_id" integer NULL, "client_instance_json" text NOT NULL, "server_instance_json" text NOT NULL, "client_instance_id" char(32) NULL, "server_instance_id" char(32) NULL);

-- morango_transfersession
CREATE TABLE "morango_transfersession" ("id" char(32) NOT NULL PRIMARY KEY, "filter" text NOT NULL, "push" bool NOT NULL, "active" bool NOT NULL, "records_total" integer NULL, "sync_session_id" char(32) NOT NULL REFERENCES "morango_syncsession" ("id") DEFERRABLE INITIALLY DEFERRED, "last_activity_timestamp" datetime NOT NULL, "client_fsic" text NOT NULL, "records_transferred" integer NOT NULL, "server_fsic" text NOT NULL, "start_timestamp" datetime NOT NULL, "bytes_received" bigint NULL, "bytes_sent" bigint NULL, "transfer_stage" varchar(20) NULL, "transfer_stage_status" varchar(20) NULL);

-- silk_profile
CREATE TABLE "silk_profile" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(300) NOT NULL, "start_time" datetime NOT NULL, "end_time" datetime NULL, "time_taken" real NULL, "file_path" varchar(300) NOT NULL, "line_num" integer NULL, "end_line_num" integer NULL, "func_name" varchar(300) NOT NULL, "exception_raised" bool NOT NULL, "dynamic" bool NOT NULL, "request_id" varchar(36) NULL REFERENCES "silk_request" ("id") DEFERRABLE INITIALLY DEFERRED);

-- silk_profile_queries
CREATE TABLE "silk_profile_queries" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "profile_id" integer NOT NULL REFERENCES "silk_profile" ("id") DEFERRABLE INITIALLY DEFERRED, "sqlquery_id" integer NOT NULL REFERENCES "silk_sqlquery" ("id") DEFERRABLE INITIALLY DEFERRED);

-- silk_request
CREATE TABLE "silk_request" ("id" varchar(36) NOT NULL PRIMARY KEY, "path" varchar(190) NOT NULL, "query_params" text NOT NULL, "raw_body" text NOT NULL, "body" text NOT NULL, "method" varchar(10) NOT NULL, "start_time" datetime NOT NULL, "view_name" varchar(190) NULL, "end_time" datetime NULL, "time_taken" real NULL, "encoded_headers" text NOT NULL, "meta_time" real NULL, "meta_num_queries" integer NULL, "meta_time_spent_queries" real NULL, "pyprofile" text NOT NULL, "num_sql_queries" integer NOT NULL, "prof_file" varchar(300) NOT NULL);

-- silk_response
CREATE TABLE "silk_response" ("status_code" integer NOT NULL, "raw_body" text NOT NULL, "body" text NOT NULL, "encoded_headers" text NOT NULL, "request_id" varchar(36) NOT NULL UNIQUE REFERENCES "silk_request" ("id") DEFERRABLE INITIALLY DEFERRED, "id" varchar(36) NOT NULL PRIMARY KEY);

-- silk_sqlquery
CREATE TABLE "silk_sqlquery" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "query" text NOT NULL, "start_time" datetime NULL, "end_time" datetime NULL, "time_taken" real NULL, "traceback" text NOT NULL, "request_id" varchar(36) NULL REFERENCES "silk_request" ("id") DEFERRABLE INITIALLY DEFERRED, "identifier" integer NOT NULL, "analysis" text NULL);

-- index: analytics_pingbacknotificationdismissed_notification_id_01d1ee67 on analytics_pingbacknotificationdismissed
CREATE INDEX "analytics_pingbacknotificationdismissed_notification_id_01d1ee67" ON "analytics_pingbacknotificationdismissed" ("notification_id");

-- index: analytics_pingbacknotificationdismissed_user_id_99b20e1e on analytics_pingbacknotificationdismissed
CREATE INDEX "analytics_pingbacknotificationdismissed_user_id_99b20e1e" ON "analytics_pingbacknotificationdismissed" ("user_id");

-- index: analytics_pingbacknotificationdismissed_user_id_notification_id_8d56aefc_uniq on analytics_pingbacknotificationdismissed
CREATE UNIQUE INDEX "analytics_pingbacknotificationdismissed_user_id_notification_id_8d56aefc_uniq" ON "analytics_pingbacknotificationdismissed" ("user_id", "notification_id");

-- index: attendance_attendancerecord_attendance_session_id_ee9a8d8e on attendance_attendancerecord
CREATE INDEX "attendance_attendancerecord_attendance_session_id_ee9a8d8e" ON "attendance_attendancerecord" ("attendance_session_id");

-- index: attendance_attendancerecord_attendance_session_id_user_id_ed81ed10_uniq on attendance_attendancerecord
CREATE UNIQUE INDEX "attendance_attendancerecord_attendance_session_id_user_id_ed81ed10_uniq" ON "attendance_attendancerecord" ("attendance_session_id", "user_id");

-- index: attendance_attendancerecord_dataset_id_275474e3 on attendance_attendancerecord
CREATE INDEX "attendance_attendancerecord_dataset_id_275474e3" ON "attendance_attendancerecord" ("dataset_id");

-- index: attendance_attendancerecord_user_id_1bb6e31f on attendance_attendancerecord
CREATE INDEX "attendance_attendancerecord_user_id_1bb6e31f" ON "attendance_attendancerecord" ("user_id");

-- index: attendance_attendancesession_collection_id_386c8b1e on attendance_attendancesession
CREATE INDEX "attendance_attendancesession_collection_id_386c8b1e" ON "attendance_attendancesession" ("collection_id");

-- index: attendance_attendancesession_created_by_id_8831185e on attendance_attendancesession
CREATE INDEX "attendance_attendancesession_created_by_id_8831185e" ON "attendance_attendancesession" ("created_by_id");

-- index: attendance_attendancesession_dataset_id_f50705a4 on attendance_attendancesession
CREATE INDEX "attendance_attendancesession_dataset_id_f50705a4" ON "attendance_attendancesession" ("dataset_id");

-- index: auth_group_permissions_group_id_b120cbf9 on auth_group_permissions
CREATE INDEX "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" ("group_id");

-- index: auth_group_permissions_group_id_permission_id_0cd325b0_uniq on auth_group_permissions
CREATE UNIQUE INDEX "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" ("group_id", "permission_id");

-- index: auth_group_permissions_permission_id_84c5c92e on auth_group_permissions
CREATE INDEX "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" ("permission_id");

-- index: auth_permission_content_type_id_2f476e4b on auth_permission
CREATE INDEX "auth_permission_content_type_id_2f476e4b" ON "auth_permission" ("content_type_id");

-- index: auth_permission_content_type_id_codename_01ab375a_uniq on auth_permission
CREATE UNIQUE INDEX "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" ("content_type_id", "codename");

-- index: bookmarks_bookmark_created_eb31a9bf on bookmarks_bookmark
CREATE INDEX "bookmarks_bookmark_created_eb31a9bf" ON "bookmarks_bookmark" ("created");

-- index: bookmarks_bookmark_dataset_id_baf7c629 on bookmarks_bookmark
CREATE INDEX "bookmarks_bookmark_dataset_id_baf7c629" ON "bookmarks_bookmark" ("dataset_id");

-- index: bookmarks_bookmark_user_id_a26bf17c on bookmarks_bookmark
CREATE INDEX "bookmarks_bookmark_user_id_a26bf17c" ON "bookmarks_bookmark" ("user_id");

-- index: bookmarks_bookmark_user_id_contentnode_id_e0f35590_uniq on bookmarks_bookmark
CREATE UNIQUE INDEX "bookmarks_bookmark_user_id_contentnode_id_e0f35590_uniq" ON "bookmarks_bookmark" ("user_id", "contentnode_id");

-- index: content_assessmentmetadata_contentnode_id_19cbc70a on content_assessmentmetadata
CREATE INDEX "content_assessmentmetadata_contentnode_id_19cbc70a" ON "content_assessmentmetadata" ("contentnode_id");

-- index: content_channelmetadata_included_languages_channelmetadata_id_bd8ec7ef on content_channelmetadata_included_languages
CREATE INDEX "content_channelmetadata_included_languages_channelmetadata_id_bd8ec7ef" ON "content_channelmetadata_included_languages" ("channelmetadata_id");

-- index: content_channelmetadata_included_languages_channelmetadata_id_language_id_51f20415_uniq on content_channelmetadata_included_languages
CREATE UNIQUE INDEX "content_channelmetadata_included_languages_channelmetadata_id_language_id_51f20415_uniq" ON "content_channelmetadata_included_languages" ("channelmetadata_id", "language_id");

-- index: content_channelmetadata_included_languages_language_id_7044f65d on content_channelmetadata_included_languages
CREATE INDEX "content_channelmetadata_included_languages_language_id_7044f65d" ON "content_channelmetadata_included_languages" ("language_id");

-- index: content_channelmetadata_root_id_ba963469 on content_channelmetadata
CREATE INDEX "content_channelmetadata_root_id_ba963469" ON "content_channelmetadata" ("root_id");

-- index: content_con_modalit_b33128_idx on content_contentnode
CREATE INDEX "content_con_modalit_b33128_idx" ON "content_contentnode" ("modality");

-- index: content_contentnode_channel_id_77d3faec on content_contentnode
CREATE INDEX "content_contentnode_channel_id_77d3faec" ON "content_contentnode" ("channel_id");

-- index: content_contentnode_content_id_790eac82 on content_contentnode
CREATE INDEX "content_contentnode_content_id_790eac82" ON "content_contentnode" ("content_id");

-- index: content_contentnode_has_prerequisite_from_contentnode_id_1085c145 on content_contentnode_has_prerequisite
CREATE INDEX "content_contentnode_has_prerequisite_from_contentnode_id_1085c145" ON "content_contentnode_has_prerequisite" ("from_contentnode_id");

-- index: content_contentnode_has_prerequisite_from_contentnode_id_to_contentnode_id_c9e1d527_uniq on content_contentnode_has_prerequisite
CREATE UNIQUE INDEX "content_contentnode_has_prerequisite_from_contentnode_id_to_contentnode_id_c9e1d527_uniq" ON "content_contentnode_has_prerequisite" ("from_contentnode_id", "to_contentnode_id");

-- index: content_contentnode_has_prerequisite_to_contentnode_id_5561f92c on content_contentnode_has_prerequisite
CREATE INDEX "content_contentnode_has_prerequisite_to_contentnode_id_5561f92c" ON "content_contentnode_has_prerequisite" ("to_contentnode_id");

-- index: content_contentnode_lang_id_600d594b on content_contentnode
CREATE INDEX "content_contentnode_lang_id_600d594b" ON "content_contentnode" ("lang_id");

-- index: content_contentnode_level_channel_id_available_29f0bb18_idx on content_contentnode
CREATE INDEX "content_contentnode_level_channel_id_available_29f0bb18_idx" ON "content_contentnode" ("level", "channel_id", "available");

-- index: content_contentnode_level_channel_id_kind_fd732cc4_idx on content_contentnode
CREATE INDEX "content_contentnode_level_channel_id_kind_fd732cc4_idx" ON "content_contentnode" ("level", "channel_id", "kind");

-- index: content_contentnode_parent_id_47178783 on content_contentnode
CREATE INDEX "content_contentnode_parent_id_47178783" ON "content_contentnode" ("parent_id");

-- index: content_contentnode_related_from_contentnode_id_f56e3999 on content_contentnode_related
CREATE INDEX "content_contentnode_related_from_contentnode_id_f56e3999" ON "content_contentnode_related" ("from_contentnode_id");

-- index: content_contentnode_related_from_contentnode_id_to_contentnode_id_fc2ed20c_uniq on content_contentnode_related
CREATE UNIQUE INDEX "content_contentnode_related_from_contentnode_id_to_contentnode_id_fc2ed20c_uniq" ON "content_contentnode_related" ("from_contentnode_id", "to_contentnode_id");

-- index: content_contentnode_related_to_contentnode_id_42e82421 on content_contentnode_related
CREATE INDEX "content_contentnode_related_to_contentnode_id_42e82421" ON "content_contentnode_related" ("to_contentnode_id");

-- index: content_contentnode_tags_contentnode_id_4ea196dd on content_contentnode_tags
CREATE INDEX "content_contentnode_tags_contentnode_id_4ea196dd" ON "content_contentnode_tags" ("contentnode_id");

-- index: content_contentnode_tags_contentnode_id_contenttag_id_64a4ac15_uniq on content_contentnode_tags
CREATE UNIQUE INDEX "content_contentnode_tags_contentnode_id_contenttag_id_64a4ac15_uniq" ON "content_contentnode_tags" ("contentnode_id", "contenttag_id");

-- index: content_contentnode_tags_contenttag_id_9518e093 on content_contentnode_tags
CREATE INDEX "content_contentnode_tags_contenttag_id_9518e093" ON "content_contentnode_tags" ("contenttag_id");

-- index: content_contentnode_tree_id_d115ca94 on content_contentnode
CREATE INDEX "content_contentnode_tree_id_d115ca94" ON "content_contentnode" ("tree_id");

-- index: content_contentrequest_facility_id_85cdb9e0 on content_contentrequest
CREATE INDEX "content_contentrequest_facility_id_85cdb9e0" ON "content_contentrequest" ("facility_id");

-- index: content_contentrequest_type_source_model_source_id_contentnode_id_channel_version_9de3b84b_uniq on content_contentrequest
CREATE UNIQUE INDEX "content_contentrequest_type_source_model_source_id_contentnode_id_channel_version_9de3b84b_uniq" ON "content_contentrequest" ("type", "source_model", "source_id", "contentnode_id", "channel_version");

-- index: content_file_contentnode_id_d4089e6e on content_file
CREATE INDEX "content_file_contentnode_id_d4089e6e" ON "content_file" ("contentnode_id");

-- index: content_file_lang_id_364540cd on content_file
CREATE INDEX "content_file_lang_id_364540cd" ON "content_file" ("lang_id");

-- index: content_file_local_file_id_9780c2ab on content_file
CREATE INDEX "content_file_local_file_id_9780c2ab" ON "content_file" ("local_file_id");

-- index: content_file_priority_073dafe4 on content_file
CREATE INDEX "content_file_priority_073dafe4" ON "content_file" ("priority");

-- index: content_language_lang_code_7a423afe on content_language
CREATE INDEX "content_language_lang_code_7a423afe" ON "content_language" ("lang_code");

-- index: content_language_lang_subcode_6ca3c58e on content_language
CREATE INDEX "content_language_lang_subcode_6ca3c58e" ON "content_language" ("lang_subcode");

-- index: courses_coursesession_collection_id_fdac6d7b on courses_coursesession
CREATE INDEX "courses_coursesession_collection_id_fdac6d7b" ON "courses_coursesession" ("collection_id");

-- index: courses_coursesession_created_by_id_e5fd1ccb on courses_coursesession
CREATE INDEX "courses_coursesession_created_by_id_e5fd1ccb" ON "courses_coursesession" ("created_by_id");

-- index: courses_coursesession_dataset_id_25fc5112 on courses_coursesession
CREATE INDEX "courses_coursesession_dataset_id_25fc5112" ON "courses_coursesession" ("dataset_id");

-- index: courses_coursesessionassignment_assigned_by_id_4e3b553a on courses_coursesessionassignment
CREATE INDEX "courses_coursesessionassignment_assigned_by_id_4e3b553a" ON "courses_coursesessionassignment" ("assigned_by_id");

-- index: courses_coursesessionassignment_collection_id_96e8bcfb on courses_coursesessionassignment
CREATE INDEX "courses_coursesessionassignment_collection_id_96e8bcfb" ON "courses_coursesessionassignment" ("collection_id");

-- index: courses_coursesessionassignment_course_session_id_63856105 on courses_coursesessionassignment
CREATE INDEX "courses_coursesessionassignment_course_session_id_63856105" ON "courses_coursesessionassignment" ("course_session_id");

-- index: courses_coursesessionassignment_dataset_id_b1e1ce14 on courses_coursesessionassignment
CREATE INDEX "courses_coursesessionassignment_dataset_id_b1e1ce14" ON "courses_coursesessionassignment" ("dataset_id");

-- index: courses_unittestassignment_activated_by_id_f96fbc35 on courses_unittestassignment
CREATE INDEX "courses_unittestassignment_activated_by_id_f96fbc35" ON "courses_unittestassignment" ("activated_by_id");

-- index: courses_unittestassignment_collection_id_f397f727 on courses_unittestassignment
CREATE INDEX "courses_unittestassignment_collection_id_f397f727" ON "courses_unittestassignment" ("collection_id");

-- index: courses_unittestassignment_course_session_id_63cf8395 on courses_unittestassignment
CREATE INDEX "courses_unittestassignment_course_session_id_63cf8395" ON "courses_unittestassignment" ("course_session_id");

-- index: courses_unittestassignment_dataset_id_ebdea473 on courses_unittestassignment
CREATE INDEX "courses_unittestassignment_dataset_id_ebdea473" ON "courses_unittestassignment" ("dataset_id");

-- index: device_devicesettings_default_facility_id_8937e0b7 on device_devicesettings
CREATE INDEX "device_devicesettings_default_facility_id_8937e0b7" ON "device_devicesettings" ("default_facility_id");

-- index: device_learnerdevicestatus_dataset_id_f6c55adc on device_learnerdevicestatus
CREATE INDEX "device_learnerdevicestatus_dataset_id_f6c55adc" ON "device_learnerdevicestatus" ("dataset_id");

-- index: device_learnerdevicestatus_instance_id_user_id_786bc903_uniq on device_learnerdevicestatus
CREATE UNIQUE INDEX "device_learnerdevicestatus_instance_id_user_id_786bc903_uniq" ON "device_learnerdevicestatus" ("instance_id", "user_id");

-- index: device_learnerdevicestatus_user_id_348765fa on device_learnerdevicestatus
CREATE INDEX "device_learnerdevicestatus_user_id_348765fa" ON "device_learnerdevicestatus" ("user_id");

-- index: device_osuser_os_username_81b2e3a5 on device_osuser
CREATE INDEX "device_osuser_os_username_81b2e3a5" ON "device_osuser" ("os_username");

-- index: device_usersyncstatus_sync_session_id_f1f21f58 on device_usersyncstatus
CREATE INDEX "device_usersyncstatus_sync_session_id_f1f21f58" ON "device_usersyncstatus" ("sync_session_id");

-- index: discovery_pinneddevice_created_b2b4bb42 on discovery_pinneddevice
CREATE INDEX "discovery_pinneddevice_created_b2b4bb42" ON "discovery_pinneddevice" ("created");

-- index: discovery_pinneddevice_user_id_468c983d on discovery_pinneddevice
CREATE INDEX "discovery_pinneddevice_user_id_468c983d" ON "discovery_pinneddevice" ("user_id");

-- index: discovery_pinneddevice_user_id_instance_id_14dd8643_uniq on discovery_pinneddevice
CREATE UNIQUE INDEX "discovery_pinneddevice_user_id_instance_id_14dd8643_uniq" ON "discovery_pinneddevice" ("user_id", "instance_id");

-- index: django_content_type_app_label_model_76bd3d3b_uniq on django_content_type
CREATE UNIQUE INDEX "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" ("app_label", "model");

-- index: exams_draftexam_collection_id_89be964c on exams_draftexam
CREATE INDEX "exams_draftexam_collection_id_89be964c" ON "exams_draftexam" ("collection_id");

-- index: exams_draftexam_creator_id_30383308 on exams_draftexam
CREATE INDEX "exams_draftexam_creator_id_30383308" ON "exams_draftexam" ("creator_id");

-- index: exams_exam_collection_id_9dc0b187 on exams_exam
CREATE INDEX "exams_exam_collection_id_9dc0b187" ON "exams_exam" ("collection_id");

-- index: exams_exam_creator_id_37d1b2e5 on exams_exam
CREATE INDEX "exams_exam_creator_id_37d1b2e5" ON "exams_exam" ("creator_id");

-- index: exams_exam_dataset_id_7dff1bad on exams_exam
CREATE INDEX "exams_exam_dataset_id_7dff1bad" ON "exams_exam" ("dataset_id");

-- index: exams_examassignment_assigned_by_id_53aa193a on exams_examassignment
CREATE INDEX "exams_examassignment_assigned_by_id_53aa193a" ON "exams_examassignment" ("assigned_by_id");

-- index: exams_examassignment_collection_id_90ec6a7a on exams_examassignment
CREATE INDEX "exams_examassignment_collection_id_90ec6a7a" ON "exams_examassignment" ("collection_id");

-- index: exams_examassignment_dataset_id_3200aa09 on exams_examassignment
CREATE INDEX "exams_examassignment_dataset_id_3200aa09" ON "exams_examassignment" ("dataset_id");

-- index: exams_examassignment_exam_id_d7c499da on exams_examassignment
CREATE INDEX "exams_examassignment_exam_id_d7c499da" ON "exams_examassignment" ("exam_id");

-- index: exams_individualsyncableexam_collection_id_00d1fd6f on exams_individualsyncableexam
CREATE INDEX "exams_individualsyncableexam_collection_id_00d1fd6f" ON "exams_individualsyncableexam" ("collection_id");

-- index: exams_individualsyncableexam_dataset_id_d3570826 on exams_individualsyncableexam
CREATE INDEX "exams_individualsyncableexam_dataset_id_d3570826" ON "exams_individualsyncableexam" ("dataset_id");

-- index: exams_individualsyncableexam_user_id_28fbd7b0 on exams_individualsyncableexam
CREATE INDEX "exams_individualsyncableexam_user_id_28fbd7b0" ON "exams_individualsyncableexam" ("user_id");

-- index: idx_morango_deserialize on morango_store
CREATE INDEX "idx_morango_deserialize" ON "morango_store" ("profile", "model_name", "partition", "dirty_bit") WHERE "dirty_bit";

-- index: idx_morango_store_partition on morango_store
CREATE INDEX "idx_morango_store_partition" ON "morango_store" ("partition");

-- index: kolibriauth_collection_dataset_id_5689c7d8 on kolibriauth_collection
CREATE INDEX "kolibriauth_collection_dataset_id_5689c7d8" ON "kolibriauth_collection" ("dataset_id");

-- index: kolibriauth_collection_parent_id_1561ec4a on kolibriauth_collection
CREATE INDEX "kolibriauth_collection_parent_id_1561ec4a" ON "kolibriauth_collection" ("parent_id");

-- index: kolibriauth_facilityuser_dataset_id_0dab63f9 on kolibriauth_facilityuser
CREATE INDEX "kolibriauth_facilityuser_dataset_id_0dab63f9" ON "kolibriauth_facilityuser" ("dataset_id");

-- index: kolibriauth_facilityuser_dataset_id_picture_password_78a7cf39_uniq on kolibriauth_facilityuser
CREATE UNIQUE INDEX "kolibriauth_facilityuser_dataset_id_picture_password_78a7cf39_uniq" ON "kolibriauth_facilityuser" ("dataset_id", "picture_password");

-- index: kolibriauth_facilityuser_facility_id_f602d621 on kolibriauth_facilityuser
CREATE INDEX "kolibriauth_facilityuser_facility_id_f602d621" ON "kolibriauth_facilityuser" ("facility_id");

-- index: kolibriauth_membership_collection_id_c955dbd2 on kolibriauth_membership
CREATE INDEX "kolibriauth_membership_collection_id_c955dbd2" ON "kolibriauth_membership" ("collection_id");

-- index: kolibriauth_membership_dataset_id_13e29803 on kolibriauth_membership
CREATE INDEX "kolibriauth_membership_dataset_id_13e29803" ON "kolibriauth_membership" ("dataset_id");

-- index: kolibriauth_membership_user_id_79317fa1 on kolibriauth_membership
CREATE INDEX "kolibriauth_membership_user_id_79317fa1" ON "kolibriauth_membership" ("user_id");

-- index: kolibriauth_membership_user_id_collection_id_48b95423_uniq on kolibriauth_membership
CREATE UNIQUE INDEX "kolibriauth_membership_user_id_collection_id_48b95423_uniq" ON "kolibriauth_membership" ("user_id", "collection_id");

-- index: kolibriauth_role_collection_id_1fa9ce6f on kolibriauth_role
CREATE INDEX "kolibriauth_role_collection_id_1fa9ce6f" ON "kolibriauth_role" ("collection_id");

-- index: kolibriauth_role_dataset_id_70eb0469 on kolibriauth_role
CREATE INDEX "kolibriauth_role_dataset_id_70eb0469" ON "kolibriauth_role" ("dataset_id");

-- index: kolibriauth_role_user_id_collection_id_kind_9c51e8a2_uniq on kolibriauth_role
CREATE UNIQUE INDEX "kolibriauth_role_user_id_collection_id_kind_9c51e8a2_uniq" ON "kolibriauth_role" ("user_id", "collection_id", "kind");

-- index: kolibriauth_role_user_id_d4014967 on kolibriauth_role
CREATE INDEX "kolibriauth_role_user_id_d4014967" ON "kolibriauth_role" ("user_id");

-- index: lessons_individualsyncablelesson_collection_id_190c1ec5 on lessons_individualsyncablelesson
CREATE INDEX "lessons_individualsyncablelesson_collection_id_190c1ec5" ON "lessons_individualsyncablelesson" ("collection_id");

-- index: lessons_individualsyncablelesson_dataset_id_b329a015 on lessons_individualsyncablelesson
CREATE INDEX "lessons_individualsyncablelesson_dataset_id_b329a015" ON "lessons_individualsyncablelesson" ("dataset_id");

-- index: lessons_individualsyncablelesson_user_id_ddf66bab on lessons_individualsyncablelesson
CREATE INDEX "lessons_individualsyncablelesson_user_id_ddf66bab" ON "lessons_individualsyncablelesson" ("user_id");

-- index: lessons_lesson_collection_id_13b7d040 on lessons_lesson
CREATE INDEX "lessons_lesson_collection_id_13b7d040" ON "lessons_lesson" ("collection_id");

-- index: lessons_lesson_created_by_id_441dbacf on lessons_lesson
CREATE INDEX "lessons_lesson_created_by_id_441dbacf" ON "lessons_lesson" ("created_by_id");

-- index: lessons_lesson_dataset_id_da71bead on lessons_lesson
CREATE INDEX "lessons_lesson_dataset_id_da71bead" ON "lessons_lesson" ("dataset_id");

-- index: lessons_lessonassignment_assigned_by_id_ed8b2358 on lessons_lessonassignment
CREATE INDEX "lessons_lessonassignment_assigned_by_id_ed8b2358" ON "lessons_lessonassignment" ("assigned_by_id");

-- index: lessons_lessonassignment_collection_id_d30ca20a on lessons_lessonassignment
CREATE INDEX "lessons_lessonassignment_collection_id_d30ca20a" ON "lessons_lessonassignment" ("collection_id");

-- index: lessons_lessonassignment_dataset_id_07c252d8 on lessons_lessonassignment
CREATE INDEX "lessons_lessonassignment_dataset_id_07c252d8" ON "lessons_lessonassignment" ("dataset_id");

-- index: lessons_lessonassignment_lesson_id_52b19e73 on lessons_lessonassignment
CREATE INDEX "lessons_lessonassignment_lesson_id_52b19e73" ON "lessons_lessonassignment" ("lesson_id");

-- index: logger_attemptlog_dataset_id_3017c88e on logger_attemptlog
CREATE INDEX "logger_attemptlog_dataset_id_3017c88e" ON "logger_attemptlog" ("dataset_id");

-- index: logger_attemptlog_masterylog_id_d65af27c on logger_attemptlog
CREATE INDEX "logger_attemptlog_masterylog_id_d65af27c" ON "logger_attemptlog" ("masterylog_id");

-- index: logger_attemptlog_sessionlog_id_0a239a1a on logger_attemptlog
CREATE INDEX "logger_attemptlog_sessionlog_id_0a239a1a" ON "logger_attemptlog" ("sessionlog_id");

-- index: logger_attemptlog_user_id_cd57843f on logger_attemptlog
CREATE INDEX "logger_attemptlog_user_id_cd57843f" ON "logger_attemptlog" ("user_id");

-- index: logger_contentsessionlog_content_id_12ef7b71 on logger_contentsessionlog
CREATE INDEX "logger_contentsessionlog_content_id_12ef7b71" ON "logger_contentsessionlog" ("content_id");

-- index: logger_contentsessionlog_dataset_id_9b53cdba on logger_contentsessionlog
CREATE INDEX "logger_contentsessionlog_dataset_id_9b53cdba" ON "logger_contentsessionlog" ("dataset_id");

-- index: logger_contentsessionlog_user_id_173ee284 on logger_contentsessionlog
CREATE INDEX "logger_contentsessionlog_user_id_173ee284" ON "logger_contentsessionlog" ("user_id");

-- index: logger_contentsummarylog_content_id_2e21d8cf on logger_contentsummarylog
CREATE INDEX "logger_contentsummarylog_content_id_2e21d8cf" ON "logger_contentsummarylog" ("content_id");

-- index: logger_contentsummarylog_dataset_id_f9a1ad8e on logger_contentsummarylog
CREATE INDEX "logger_contentsummarylog_dataset_id_f9a1ad8e" ON "logger_contentsummarylog" ("dataset_id");

-- index: logger_contentsummarylog_user_id_16aa2b2c on logger_contentsummarylog
CREATE INDEX "logger_contentsummarylog_user_id_16aa2b2c" ON "logger_contentsummarylog" ("user_id");

-- index: logger_examattemptlog_dataset_id_9f9d1b24 on logger_examattemptlog
CREATE INDEX "logger_examattemptlog_dataset_id_9f9d1b24" ON "logger_examattemptlog" ("dataset_id");

-- index: logger_examattemptlog_examlog_id_ad0f674d on logger_examattemptlog
CREATE INDEX "logger_examattemptlog_examlog_id_ad0f674d" ON "logger_examattemptlog" ("examlog_id");

-- index: logger_examattemptlog_user_id_5442dc41 on logger_examattemptlog
CREATE INDEX "logger_examattemptlog_user_id_5442dc41" ON "logger_examattemptlog" ("user_id");

-- index: logger_examlog_dataset_id_13109aa7 on logger_examlog
CREATE INDEX "logger_examlog_dataset_id_13109aa7" ON "logger_examlog" ("dataset_id");

-- index: logger_examlog_exam_id_41856b8c on logger_examlog
CREATE INDEX "logger_examlog_exam_id_41856b8c" ON "logger_examlog" ("exam_id");

-- index: logger_examlog_user_id_05397f8b on logger_examlog
CREATE INDEX "logger_examlog_user_id_05397f8b" ON "logger_examlog" ("user_id");

-- index: logger_generatecsvlogrequest_facility_id_9d4a007d on logger_generatecsvlogrequest
CREATE INDEX "logger_generatecsvlogrequest_facility_id_9d4a007d" ON "logger_generatecsvlogrequest" ("facility_id");

-- index: logger_masterylog_dataset_id_f5b54331 on logger_masterylog
CREATE INDEX "logger_masterylog_dataset_id_f5b54331" ON "logger_masterylog" ("dataset_id");

-- index: logger_masterylog_summarylog_id_f2816f59 on logger_masterylog
CREATE INDEX "logger_masterylog_summarylog_id_f2816f59" ON "logger_masterylog" ("summarylog_id");

-- index: logger_masterylog_user_id_3f58a1cb on logger_masterylog
CREATE INDEX "logger_masterylog_user_id_3f58a1cb" ON "logger_masterylog" ("user_id");

-- index: logger_usersessionlog_dataset_id_1a2bbb5f on logger_usersessionlog
CREATE INDEX "logger_usersessionlog_dataset_id_1a2bbb5f" ON "logger_usersessionlog" ("dataset_id");

-- index: logger_usersessionlog_user_id_a755b0c2 on logger_usersessionlog
CREATE INDEX "logger_usersessionlog_user_id_a755b0c2" ON "logger_usersessionlog" ("user_id");

-- index: morango_buffer_transfer_session_id_8e70af5a on morango_buffer
CREATE INDEX "morango_buffer_transfer_session_id_8e70af5a" ON "morango_buffer" ("transfer_session_id");

-- index: morango_buffer_transfer_session_id_model_uuid_2a7288db_uniq on morango_buffer
CREATE UNIQUE INDEX "morango_buffer_transfer_session_id_model_uuid_2a7288db_uniq" ON "morango_buffer" ("transfer_session_id", "model_uuid");

-- index: morango_certificate_parent_id_60dedc2b on morango_certificate
CREATE INDEX "morango_certificate_parent_id_60dedc2b" ON "morango_certificate" ("parent_id");

-- index: morango_certificate_scope_definition_id_1f75587b on morango_certificate
CREATE INDEX "morango_certificate_scope_definition_id_1f75587b" ON "morango_certificate" ("scope_definition_id");

-- index: morango_certificate_tree_id_88a9f83c on morango_certificate
CREATE INDEX "morango_certificate_tree_id_88a9f83c" ON "morango_certificate" ("tree_id");

-- index: morango_databasemaxcounter_instance_id_partition_99e4f1fb_uniq on morango_databasemaxcounter
CREATE UNIQUE INDEX "morango_databasemaxcounter_instance_id_partition_99e4f1fb_uniq" ON "morango_databasemaxcounter" ("instance_id", "partition");

-- index: morango_instanceidmodel_database_id_3d1b7c0a on morango_instanceidmodel
CREATE INDEX "morango_instanceidmodel_database_id_3d1b7c0a" ON "morango_instanceidmodel" ("database_id");

-- index: morango_recordmaxcounter_store_model_id_2a91327d on morango_recordmaxcounter
CREATE INDEX "morango_recordmaxcounter_store_model_id_2a91327d" ON "morango_recordmaxcounter" ("store_model_id");

-- index: morango_recordmaxcounter_store_model_id_instance_id_d478818f_uniq on morango_recordmaxcounter
CREATE UNIQUE INDEX "morango_recordmaxcounter_store_model_id_instance_id_d478818f_uniq" ON "morango_recordmaxcounter" ("store_model_id", "instance_id");

-- index: morango_recordmaxcounterbuffer_model_uuid_27589dbd on morango_recordmaxcounterbuffer
CREATE INDEX "morango_recordmaxcounterbuffer_model_uuid_27589dbd" ON "morango_recordmaxcounterbuffer" ("model_uuid");

-- index: morango_recordmaxcounterbuffer_transfer_session_id_1e48e3dd on morango_recordmaxcounterbuffer
CREATE INDEX "morango_recordmaxcounterbuffer_transfer_session_id_1e48e3dd" ON "morango_recordmaxcounterbuffer" ("transfer_session_id");

-- index: morango_store_last_transfer_session_id_258a67a1 on morango_store
CREATE INDEX "morango_store_last_transfer_session_id_258a67a1" ON "morango_store" ("last_transfer_session_id");

-- index: morango_syncsession_client_certificate_id_507e0d5d on morango_syncsession
CREATE INDEX "morango_syncsession_client_certificate_id_507e0d5d" ON "morango_syncsession" ("client_certificate_id");

-- index: morango_syncsession_server_certificate_id_52bf728f on morango_syncsession
CREATE INDEX "morango_syncsession_server_certificate_id_52bf728f" ON "morango_syncsession" ("server_certificate_id");

-- index: morango_transfersession_sync_session_id_0455b5bd on morango_transfersession
CREATE INDEX "morango_transfersession_sync_session_id_0455b5bd" ON "morango_transfersession" ("sync_session_id");

-- index: silk_profile_queries_profile_id_a3d76db8 on silk_profile_queries
CREATE INDEX "silk_profile_queries_profile_id_a3d76db8" ON "silk_profile_queries" ("profile_id");

-- index: silk_profile_queries_profile_id_sqlquery_id_b2403d9b_uniq on silk_profile_queries
CREATE UNIQUE INDEX "silk_profile_queries_profile_id_sqlquery_id_b2403d9b_uniq" ON "silk_profile_queries" ("profile_id", "sqlquery_id");

-- index: silk_profile_queries_sqlquery_id_155df455 on silk_profile_queries
CREATE INDEX "silk_profile_queries_sqlquery_id_155df455" ON "silk_profile_queries" ("sqlquery_id");

-- index: silk_profile_request_id_7b81bd69 on silk_profile
CREATE INDEX "silk_profile_request_id_7b81bd69" ON "silk_profile" ("request_id");

-- index: silk_request_path_9f3d798e on silk_request
CREATE INDEX "silk_request_path_9f3d798e" ON "silk_request" ("path");

-- index: silk_request_start_time_1300bc58 on silk_request
CREATE INDEX "silk_request_start_time_1300bc58" ON "silk_request" ("start_time");

-- index: silk_request_view_name_68559f7b on silk_request
CREATE INDEX "silk_request_view_name_68559f7b" ON "silk_request" ("view_name");

-- index: silk_sqlquery_request_id_6f8f0527 on silk_sqlquery
CREATE INDEX "silk_sqlquery_request_id_6f8f0527" ON "silk_sqlquery" ("request_id");
