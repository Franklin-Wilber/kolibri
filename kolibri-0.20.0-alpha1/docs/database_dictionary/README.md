# Diccionario de Datos de Kolibri

Documentacion generada desde la base SQLite principal de desarrollo.

- Base analizada: `kolibri-data-dev/db.sqlite3`
- Fecha de generacion: `2026-09-14 15:05:22`
- Tablas documentadas: `75`

## Archivos

- `database_overview.md`: proposito general de la base y agrupacion por dominios.
- `data_dictionary.md`: diccionario completo de tablas, columnas, claves foraneas e indices.
- `relationships.md`: relaciones principales del modelo de datos y guia para consultas comunes.
- `schema.sql`: DDL SQL extraido de SQLite para las tablas de la base principal.

## Base correcta

Para datos de usuarios, progreso y contenido local consulta la base principal:

```text
kolibri-data-dev/db.sqlite3
```

Las bases en `kolibri-data-dev/content/databases/*.sqlite3` son bases de contenido por canal y no contienen los logs de usuario (`logger_*`) ni usuarios (`kolibriauth_*`).
