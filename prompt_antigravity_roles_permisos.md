# PROMPT PARA ANTIGRAVITY — Implementar Módulo de Roles y Permisos

Copiá y pegá todo lo que sigue tal cual.

---

## Contexto del proyecto

Estás trabajando sobre un proyecto **ya existente y funcionando en producción-ready**, con esta arquitectura:

- **Backend:** FastAPI + PostgreSQL 16 + SQLAlchemy 2.0 + Alembic + Pydantic v2, JWT (PyJWT) con `TokenBlacklist` para revocación.
- **Frontend Web:** Angular 19+ (Standalone Components, Signals, Reactive Forms), con `authGuard`/`guestGuard` funcionales y un `auth.interceptor.ts` que inyecta el Bearer Token.
- **Mobile:** Flutter 3.x con `Provider`/`ChangeNotifier`, `flutter_secure_storage`.
- **Convención crítica de IDs:** `User.id` es **UUID** (manejado como string tanto en Angular como en Flutter). **Cualquier tabla nueva que se relacione con `users` debe respetar esta misma convención de UUID**, no usar enteros autoincrementales.

Estructura de carpetas real del backend (`backend/app/`):
```
api/
├── deps.py          # get_db, get_current_user (acá viven las dependencias de auth)
└── v1/
    ├── router.py
    ├── auth.py
    └── users.py
core/
└── security.py       # JWT y hash de contraseñas
models/
├── user.py
└── token.py
schemas/
├── auth.py           # LoginRequest, RegisterRequest, TokenResponse
├── user.py           # UserResponse, UserUpdate
└── common.py
services/
├── auth_service.py
└── user_service.py
```

Estructura real del frontend (`web/src/app/`):
```
core/
├── guards/            # auth.guard.ts, guest.guard.ts (funcionales, no basados en clases)
├── interceptors/       # auth.interceptor.ts
├── models/             # auth.model.ts, user.model.ts
└── services/           # auth.service.ts, token.service.ts
features/
├── auth/
└── dashboard/
```

Estructura real del mobile (`mobile/lib/`):
```
config/            # api_config.dart, routes.dart, theme.dart
models/            # user.dart
services/          # api_service.dart, auth_service.dart (ChangeNotifier), storage_service.dart
screens/
```

**IMPORTANTE — Antes de escribir una sola línea de código:**
1. Abrí y leé `backend/app/models/user.py` y confirmá cómo se genera el UUID de `User.id` (¿`default=uuid.uuid4` en Python, o `server_default=text("gen_random_uuid()")` en Postgres?). Usá **exactamente el mismo mecanismo** para los IDs de las tablas nuevas (`roles`, `permissions`).
2. Abrí `backend/app/api/deps.py` y `backend/app/schemas/user.py` para entender el patrón exacto de `get_current_user` y `UserResponse` antes de extenderlos.
3. Abrí `web/src/app/core/services/auth.service.ts` y `web/src/app/core/guards/auth.guard.ts` para replicar el mismo estilo (signals, guards funcionales) en lo nuevo, no introduzcas un patrón distinto (ej. no uses guards basados en clases si el resto del proyecto usa funcionales).
4. Si alguno de estos archivos difiere significativamente de lo descrito acá, **priorizá lo que encuentres en el código real** sobre lo que dice este prompt.

---

## Objetivo

Agregar un módulo de **Roles y Permisos (RBAC por módulo/ruta)**, replicando el flujo de trabajo de Laravel Spatie: cada endpoint del backend queda registrado como un "permiso", y desde un panel de administración se le asignan permisos a cada rol. El acceso se valida en cada request contra la base de datos (no se embebe en el JWT), para que un cambio de permisos aplique de inmediato sin requerir nuevo login.

## Alcance (mínimo indispensable — no te desvíes de esto)

✅ **Incluido:**
- Un rol por usuario (`users.role_id` FK simple, NO tabla pivote `user_roles`).
- Permisos = rutas/endpoints del backend, declarados explícitamente en el código (no auto-escaneo mágico de rutas).
- Panel admin en Angular para asignar permisos a un rol (matriz de checkboxes agrupada por módulo).
- Verificación de permiso en cada request vía dependency de FastAPI.
- Ocultamiento de menús/botones en Angular según permisos del usuario.

❌ **Explícitamente fuera de alcance en esta etapa (no lo implementes aunque se te ocurra "mejorarlo"):**
- Múltiples roles por usuario.
- UI para que el admin cree permisos nuevos a mano (los permisos se generan por seed script, reflejando el código).
- Cacheo de permisos (Redis, etc.).
- Control de permisos en Flutter (se deja el campo disponible en la API, pero no se implementa lógica de bloqueo en mobile todavía).

Si identificás una mejora real fuera de este alcance (ej. algo que evite un bug futuro o una inconsistencia con el resto del proyecto), **señalala al final en una sección "Sugerencias fuera de alcance"**, pero no la implementes sin confirmación.

---

## 1. Base de Datos

Crear 3 tablas nuevas + 1 columna nueva en `users`:

```sql
roles
├── id            UUID PK   -- mismo mecanismo de generación que User.id
├── name          VARCHAR(50) UNIQUE NOT NULL      -- ej. "admin", "editor", "viewer"
├── description   VARCHAR(255)
├── created_at    TIMESTAMP DEFAULT now()
└── updated_at    TIMESTAMP DEFAULT now()

permissions
├── id            UUID PK
├── code          VARCHAR(100) UNIQUE NOT NULL      -- ej. "users.list", "users.create"
├── module        VARCHAR(50) NOT NULL              -- ej. "Usuarios", "Roles"
├── method        VARCHAR(10) NOT NULL              -- GET, POST, PUT, DELETE
├── path          VARCHAR(255) NOT NULL             -- ej. "/api/v1/users"
├── description   VARCHAR(255)
└── created_at    TIMESTAMP DEFAULT now()

role_permissions                                     -- tabla pivote
├── role_id        UUID FK -> roles.id
├── permission_id  UUID FK -> permissions.id
└── PRIMARY KEY (role_id, permission_id)

users
└── role_id   UUID FK -> roles.id   -- nullable al inicio
```

### Migración Alembic (en este orden, en una sola revisión o en revisiones encadenadas)
1. Crear `roles`.
2. Crear `permissions`.
3. Crear `role_permissions`.
4. Agregar `users.role_id` (nullable).
5. **Data migration dentro de la misma migración:** crear un rol `"admin"` por defecto e insertar `role_id` de ese rol para todos los usuarios existentes.
6. Alterar `users.role_id` a `NOT NULL` una vez poblado.

No rompas la migración existente: generá esto como una nueva revisión de Alembic que dependa de la última (`down_revision` apuntando a la cabeza actual del historial).

---

## 2. Backend (FastAPI)

Seguí exactamente esta ubicación de archivos:

```
models/role.py                 # Modelo Role
models/permission.py           # Modelo Permission
models/role_permission.py      # Tabla pivote (Table() o modelo asociativo)

schemas/role.py                # RoleCreate, RoleUpdate, RoleResponse, RoleWithPermissions
schemas/permission.py          # PermissionResponse (agrupable por módulo)

api/v1/roles.py                # CRUD de roles + asignar permisos
api/v1/permissions.py          # Listar permisos, agrupados por módulo (solo lectura)

services/role_service.py       # Lógica de asignación rol↔permiso

api/deps.py                    # EXTENDER este archivo (no crear uno nuevo) con:
                                #   require_permission(permission_code: str) -> Depends
                                #   que reutiliza get_current_user ya existente
```

### Dependency de verificación de permisos (agregar en `api/deps.py`)

```python
def require_permission(permission_code: str):
    def dependency(current_user = Depends(get_current_user), db = Depends(get_db)):
        user_permissions = role_service.get_permission_codes(db, current_user.role_id)
        if permission_code not in user_permissions:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="No tienes permiso para acceder a este recurso"
            )
        return current_user
    return dependency
```

Aplicar en los endpoints existentes y nuevos, por ejemplo:
```python
@router.get("/users", dependencies=[Depends(require_permission("users.list"))])
```

### Extender `schemas/user.py` → `UserResponse`
Agregar los campos `role: RoleResponse | None` y `permissions: list[str]`. Esto es un cambio **aditivo**, no rompe a los consumidores actuales de Angular/Flutter (que solo leen los campos que ya conocen).

### Endpoints nuevos

| Método | Ruta | Protegido con |
|---|---|---|
| `GET` | `/api/v1/roles` | `roles.list` |
| `POST` | `/api/v1/roles` | `roles.create` |
| `PUT` | `/api/v1/roles/{id}` | `roles.update` |
| `DELETE` | `/api/v1/roles/{id}` | `roles.delete` |
| `GET` | `/api/v1/permissions` | `roles.list` |
| `PUT` | `/api/v1/roles/{id}/permissions` | `roles.update` |

### Seed de permisos
Crear `backend/app/seed_permissions.py`: script que registra en la tabla `permissions` un registro por cada endpoint protegido (auth, users, roles). Correrlo una vez al desplegar y cada vez que se agregue un endpoint protegido nuevo.

### Reglas de negocio a respetar
- El rol `"admin"` no puede eliminarse ni puede quedar sin el permiso `roles.update` (para que nunca se bloquee el acceso administrativo por error).
- Un usuario no puede eliminar el rol al que pertenece su propio usuario.

---

## 3. Frontend Angular

Seguí el mismo estilo del código existente (Standalone Components, Signals, guards **funcionales** — no basados en clases).

```
core/models/role.model.ts              # Role, Permission
core/models/user.model.ts              # EXTENDER: agregar role y permissions al modelo existente
core/guards/permission.guard.ts        # Guard funcional, mismo patrón que auth.guard.ts
core/directives/has-permission.directive.ts   # *appHasPermission="'users.create'"
core/services/auth.service.ts          # EXTENDER (no crear PermissionService aparte):
                                        #   guardar permissions[] junto al resto del estado de sesión
                                        #   que ya maneja este servicio

features/roles/
├── role-list/           # Tabla de roles
├── role-form/           # Crear/editar rol
└── role-permissions/    # Matriz: filas = módulos, columnas = permisos, checkboxes
```

**Importante:** no crees un `PermissionService` nuevo si `auth.service.ts` ya centraliza el estado de sesión con signals — extendé ese mismo servicio para exponer `permissions()` como signal derivado, manteniendo un solo lugar de verdad para el estado de autenticación.

En cada ruta protegida del `app.routes.ts`, agregar `data: { permission: 'codigo.permiso' }` y aplicar `permissionGuard` junto al `authGuard` ya existente.

---

## 4. Mobile (Flutter)

**No implementar lógica de control de acceso en esta etapa.** Único cambio permitido: si `models/user.dart` tiene un `fromJson` explícito, verificar que no falle al recibir los campos nuevos `role` y `permissions` del backend (ignorarlos si no se van a usar todavía, pero no debe romper el parseo).

---

## 5. Verificación esperada al terminar

1. La migración corre limpio sobre una base con usuarios existentes, sin perder datos.
2. Un usuario con rol sin el permiso `users.list` recibe `403` al llamar `GET /api/v1/users`.
3. Si el admin le quita un permiso a un rol desde el panel, un usuario con ese rol pierde el acceso en el **siguiente request**, sin necesidad de volver a loguearse.
4. El rol `admin` no puede eliminarse ni perder `roles.update` desde el panel.
5. `web` sigue compilando y los tests de `backend` (`pytest`) siguen pasando sin romper `test_auth.py` ni `test_users.py`.

---

## Sugerencias fuera de alcance (opcional, señalar solo si aplica)
Si durante la implementación detectás algo que rompería esta arquitectura si no se corrige (por ejemplo, inconsistencia entre cómo se genera el UUID en `User` vs. lo que pide este prompt, o un patrón de manejo de errores 403 que ya existe y debería reusarse en vez de duplicarse), documentalo en una sección aparte al final de tu respuesta, sin aplicarlo automáticamente.
