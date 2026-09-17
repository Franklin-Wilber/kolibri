# Cambios para dockerizar Kolibri localmente

Este documento resume los cambios aplicados para poder construir y ejecutar esta version local de Kolibri con Docker, usando el codigo fuente del repositorio.

## Objetivo

La configuracion original no levantaba Kolibri desde el codigo local. El `Dockerfile` existente estaba orientado a instalar Kolibri desde paquete publicado, por lo que no garantizaba ejecutar los cambios actuales del repositorio.

Se agrego una dockerizacion local para:

- Construir los assets frontend desde este repositorio.
- Instalar Kolibri desde el codigo fuente local.
- Ejecutar Kolibri en `http://localhost:8080`.
- Mantener los datos en `./kolibri-data`.
- Activar el plugin OIDC existente para probar SSO con Google.
- Levantar una variante en modo desarrollo en `http://localhost:8000`.
- Exponer Swagger/ReDoc en modo desarrollo para explorar la API.

## Archivos modificados

### `docker/Dockerfile.local`

Se agrego un Dockerfile nuevo para construir la aplicacion desde el codigo fuente local.

Cambios principales:

- Usa una etapa `frontend-builder` basada en Node `20.19.3`.
- Instala Python dentro de la etapa de frontend porque las herramientas de build de Kolibri lo necesitan.
- Crea `kolibri/_version.py` durante la imagen para que el build tenga una version valida.
- Instala dependencias Python base desde `pyproject.toml` antes de compilar assets.
- Ejecuta:

```bash
pnpm install --frozen-lockfile
pnpm run sandbox-build
pnpm exec kolibri-build prod --file ./build_tools/build_plugins.txt --transpile --cache --parallel 1
```

- Define `NODE_OPTIONS=--max-old-space-size=4096` para evitar errores de memoria durante el build frontend.
- Valida que existan los archivos `*_stats.json` necesarios para que Django/Kolibri cargue los bundles compilados.
- Elimina `node_modules` antes de pasar a la imagen final para reducir peso.
- En la etapa final usa Python `3.12-slim`.
- Crea un usuario no-root llamado `kolibri`.
- Instala Kolibri desde el repositorio local con `pip install -e .`.
- Instala el plugin local `kolibri-oidc-client-plugin`.
- Agrega el argumento de build `INSTALL_DEV_DEPS`, desactivado por defecto.
- Cuando `INSTALL_DEV_DEPS=true`, instala dependencias de desarrollo necesarias para `kolibri.deployment.default.settings.dev`:

```bash
django-silk==5.2.0
drf-yasg==1.21.7
coreapi==2.3.3
```

- Estas dependencias se instalan usando `-c /tmp/kolibri-base-requirements.txt` para evitar que `pip` actualice dependencias base de Kolibri, especialmente `Django==3.2.25`.
- Se fijo `setuptools<82`, igual que el grupo de desarrollo de `pyproject.toml`, para mantener disponible `pkg_resources`, requerido por `drf-yasg`.

### `docker-compose.yml`

Se agrego el servicio `kolibri`.

Configuracion principal:

```yaml
services:
  kolibri:
    build:
      context: .
      dockerfile: docker/Dockerfile.local
    ports:
      - "8080:8080"
      - "8081:8081"
    volumes:
      - ./kolibri-data:/kolibri
    environment:
      KOLIBRI_HOME: /kolibri
      KOLIBRI_HTTP_PORT: 8080
      KOLIBRI_ZIP_CONTENT_PORT: 8081
      KOLIBRI_PLUGIN_ENABLE: kolibri_oidc_client_plugin
      CLIENT_ID: ${OIDC_CLIENT_ID:-kolibri.app}
      CLIENT_SECRET: ${OIDC_CLIENT_SECRET:-kolibri.app}
```

El servicio `postgres` se mantuvo separado bajo perfil `postgres`, porque para la ejecucion local actual Kolibri puede funcionar con su configuracion normal en `kolibri-data`.

### `docker-compose.dev.yml`

Se agrego un compose separado para levantar Kolibri en modo desarrollo.

Configuracion principal:

```yaml
services:
  kolibri-dev:
    build:
      context: .
      dockerfile: docker/Dockerfile.local
      args:
        KOLIBRI_VERSION: 0.20.0a1
        INSTALL_DEV_DEPS: "true"
    ports:
      - "8000:8000"
      - "8001:8001"
    volumes:
      - ./kolibri-data-dev:/kolibri
    environment:
      KOLIBRI_HOME: /kolibri
      KOLIBRI_RUN_MODE: dev
      KOLIBRI_HTTP_PORT: 8000
      KOLIBRI_ZIP_CONTENT_PORT: 8001
      KOLIBRI_PLUGIN_ENABLE: kolibri_oidc_client_plugin
      CLIENT_ID: ${OIDC_CLIENT_ID:-kolibri.app}
      CLIENT_SECRET: ${OIDC_CLIENT_SECRET:-kolibri.app}
    command:
      - kolibri
      - start
      - --debug
      - --foreground
      - --port=8000
      - --zip-port=8001
      - --settings=kolibri.deployment.default.settings.dev
```

Este comando toma como referencia la version de desarrollo definida en `package.json`:

```bash
kolibri start --debug --foreground --port=8000 --settings=kolibri.deployment.default.settings.dev
```

La variante dev usa datos separados en `./kolibri-data-dev` para no mezclar el entorno de pruebas con la ejecucion normal de `docker-compose.yml`.

Tambien incluye un servicio opcional `postgres-dev` bajo perfil `postgres`, expuesto en el host por el puerto `15433`.

Endpoints utiles en modo desarrollo:

```text
http://localhost:8000/api_explorer/
http://localhost:8000/swagger.json
http://localhost:8000/swagger.yaml
http://localhost:8000/redoc/
http://localhost:8000/profile/
```

### `kolibri-data/options.ini`

Se agrego la configuracion OIDC para Google.

Parametros relevantes:

```ini
[OIDCClient]
PROVIDER_URL = https://accounts.google.com
CLIENT_URL = http://localhost:8080
AUTHORIZATION_ENDPOINT = https://accounts.google.com/o/oauth2/v2/auth
TOKEN_ENDPOINT = https://oauth2.googleapis.com/token
USERINFO_ENDPOINT = https://openidconnect.googleapis.com/v1/userinfo
ENDSESSION_ENDPOINT =
JWKS_URI = https://www.googleapis.com/oauth2/v3/certs
```

El endpoint de token se corrigio a:

```ini
TOKEN_ENDPOINT = https://oauth2.googleapis.com/token
```

Esto evita el error que ocurria cuando el plugin intentaba usar una URL incorrecta bajo `accounts.google.com`.

### `.env`

Se usa `.env` para pasar credenciales de Google OAuth/OIDC al contenedor.

Variables esperadas:

```dotenv
OIDC_CLIENT_ID=...
OIDC_CLIENT_SECRET=...
```

No se deben versionar ni publicar valores reales de estas variables.

En Google Cloud Console, el redirect URI autorizado debe ser:

```text
http://localhost:8080/oidccallback/
```

### `python_packages/kolibri-oidc-client-plugin/kolibri_oidc_client_plugin/auth.py`

Se ajusto el mapeo de usuario para Google.

Google no siempre devuelve `nickname` o `username`. Para evitar errores durante el callback OIDC, se agrego fallback a `email` cuando no existe username:

```python
if not username:
    username = claim.get("email")
```

Esto permite que el plugin use el correo de Google como nombre de usuario cuando sea necesario.

### `kolibri/core/auth/viewsets/classroom.py`

Se agrego `ref_name = "AuthClassroom"` al serializer de aulas usado por el modulo de autenticacion.

Este cambio evita que `drf-yasg` falle al generar Swagger por tener dos serializers distintos con el mismo nombre `ClassroomSerializer`.

### `kolibri/core/lessons/viewsets/lesson.py`

Se agrego `ref_name = "LessonClassroom"` al serializer de aulas embebido en lecciones.

Este cambio complementa el ajuste anterior y permite que Swagger genere definiciones OpenAPI separadas para ambos serializers.

## Comandos de uso

Desde la carpeta del proyecto:

```bash
cd /home/fwilber/Documentos/apps/kolibri-docker/kolibri-0.20.0-alpha1
```

Construir la imagen:

```bash
sudo docker compose build kolibri
```

Levantar la aplicacion:

```bash
sudo docker compose up
```

Abrir en el navegador:

```text
http://localhost:8080
```

## Comandos de uso en modo desarrollo

Construir la imagen dev:

```bash
sudo docker compose -f docker-compose.dev.yml build kolibri-dev
```

Levantar la aplicacion en modo desarrollo:

```bash
sudo docker compose -f docker-compose.dev.yml up
```

Abrir Kolibri:

```text
http://localhost:8000
```

Abrir Swagger:

```text
http://localhost:8000/api_explorer/
```

## Reconstruccion limpia

Si se cambian dependencias, codigo del plugin o assets frontend, conviene reconstruir:

```bash
sudo docker compose down
sudo docker compose build --no-cache kolibri
sudo docker compose up
```

Si solo se cambia `kolibri-data/options.ini`, normalmente basta con reiniciar el contenedor:

```bash
sudo docker compose down
sudo docker compose up
```

Para reconstruir limpiamente la variante de desarrollo:

```bash
sudo docker compose -f docker-compose.dev.yml down
sudo docker compose -f docker-compose.dev.yml build --no-cache kolibri-dev
sudo docker compose -f docker-compose.dev.yml up
```

Si solo se cambia `kolibri-data-dev/options.ini`, normalmente basta con reiniciar el contenedor dev:

```bash
sudo docker compose -f docker-compose.dev.yml down
sudo docker compose -f docker-compose.dev.yml up
```

## Verificaciones realizadas

- Se valido que la configuracion Docker Compose sea parseable.
- Se valido que `docker-compose.dev.yml` sea parseable.
- Se corrigieron errores de build frontend relacionados con Python, memoria y ejecucion de `kolibri-build`.
- Se agrego validacion de archivos `*_stats.json` para detectar builds incompletos antes de arrancar Kolibri.
- Se valido con `py_compile` el archivo modificado del plugin OIDC.
- Se corrigio la instalacion de dependencias dev para evitar incompatibilidades con Django.
- Se corrigio el error `No module named 'pkg_resources'` fijando `setuptools<82`.
- Se corrigio el choque de serializers `ClassroomSerializer` para la generacion de Swagger.

## Notas importantes

- La imagen construida con `docker/Dockerfile.local` ejecuta la version actual del repositorio local.
- Los datos quedan persistidos en `./kolibri-data`.
- La variante dev usa `./kolibri-data-dev`.
- `docker-compose.yml` levanta Kolibri en modo normal/prod-like en `8080`.
- `docker-compose.dev.yml` levanta Kolibri en modo desarrollo en `8000` y habilita Swagger/ReDoc.
- El compose dev no monta el codigo fuente como volumen en `/app`; si se cambia codigo Python, hay que reconstruir la imagen.
- Los codigos OAuth de Google son de un solo uso. Si ocurre un error en el callback, hay que iniciar el flujo de login nuevamente.
- Las credenciales reales de Google deben mantenerse solo en `.env` o en un gestor de secretos.
