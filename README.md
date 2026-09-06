# Sistema de Autenticación Full-Stack (FastAPI + Angular + Flutter + PostgreSQL)

Sistema de autenticación y gestión de usuarios multiplataforma, seguro, modular y listo para producción. Diseñado con separación de responsabilidades entre Backend (REST API), Frontend Web (Angular) y Aplicación Móvil (Flutter), respaldado por una base de datos relacional PostgreSQL.

---

## 📐 Arquitectura General

```
                          ┌───────────────────────────┐
                          │   PostgreSQL (Port 5432)  │
                          │   DB: probando_1_db       │
                          └─────────────▲─────────────┘
                                        │ (SQLAlchemy ORM)
                          ┌─────────────┴─────────────┐
                          │    Backend (FastAPI)      │
                          │   http://127.0.0.1:8000   │
                          └──────┬─────────────┬──────┘
                                 │             │
              (REST API + JWT)   │             │   (REST API + JWT)
            ┌────────────────────┘             └────────────────────┐
            ▼                                                       ▼
┌───────────────────────┐                               ┌───────────────────────┐
│   Frontend Web (SPA)  │                               │    App Móvil (Flutter)│
│    Angular 19+        │                               │   Web / Android / iOS │
│ http://localhost:4200 │                               │ http://127.0.0.1:8080 │
└───────────────────────┘                               └───────────────────────┘
```

---

## 🛠️ Tech Stack & Tecnologías

### 1. Backend (`/backend`)
- **Framework:** FastAPI (Python 3.12 / 3.13)
- **Base de Datos:** PostgreSQL 16
- **ORM:** SQLAlchemy 2.0+
- **Migraciones:** Alembic
- **Seguridad & Auth:** OAuth2 con tokens JWT (PyJWT), Hashing con Passlib & Bcrypt, Revocación de Tokens (`TokenBlacklist`).
- **Validación de Datos:** Pydantic v2
- **Testing:** Pytest & HTTPX

### 2. Frontend Web (`/web`)
- **Framework:** Angular 19+ (Standalone Components, Signals, Reactive Forms)
- **Routing & Guards:** `authGuard` (rutas privadas), `guestGuard` (rutas públicas)
- **HTTP Interceptors:** Inyección automática de `Bearer Token` JWT y manejo global de errores 401.
- **Estilos:** CSS3 nativo con diseño oscuro moderno (Glassmorphism, Gradiantes).

### 3. App Móvil (`/mobile`)
- **Framework:** Flutter 3.x / Dart 3.x (Soporte multiplataforma: Web, Android, iOS, Windows)
- **Gestión de Estado:** Provider (`ChangeNotifier`)
- **Persistencia Segura:** `flutter_secure_storage` con sistema híbrido de caché en memoria de alta velocidad.
- **Cliente HTTP:** `http` customizado con manejo centralizado de respuestas, timeouts strictly acotados y re-intentos.

---

## 📂 Estructura Detallada del Proyecto

```
Si2_Proyecto/
├── README.md                  # Este documento (Guía del proyecto)
├── implementation_planALL     # Plan de implementación y diagnóstico inicial
│
├── backend/                   # Módulo Backend (FastAPI + PostgreSQL)
│   ├── .env                   # Variables de entorno locales
│   ├── .env.example           # Plantilla de variables de entorno
│   ├── alembic.ini            # Configuración de migraciones de base de datos
│   ├── requirements.txt       # Dependencias de Python
│   ├── alembic/               # Scripts de versión y migraciones SQL
│   │   ├── env.py
│   │   └── versions/
│   ├── app/
│   │   ├── main.py            # Punto de entrada de FastAPI, CORS y rutas raíz
│   │   ├── config.py          # Configuración global y Settings de Pydantic
│   │   ├── database.py        # Configuración del Engine de SQLAlchemy y SessionLocal
│   │   ├── api/
│   │   │   ├── deps.py        # Inyección de dependencias (get_db, get_current_user)
│   │   │   └── v1/            # Versión 1 de la API REST
│   │   │       ├── router.py  # Router principal v1
│   │   │       ├── auth.py    # Endpoints (/register, /login, /logout, /refresh)
│   │   │       └── users.py   # Endpoints (/users/me, edición de perfil)
│   │   ├── core/
│   │   │   └── security.py    # Utilidades JWT y hash de contraseñas (bcrypt)
│   │   ├── models/            # Modelos ORM de Base de Datos
│   │   │   ├── user.py        # Modelo User (ID es UUID string)
│   │   │   └── token.py       # Modelo TokenBlacklist para revocación
│   │   ├── schemas/           # Esquemas de Validación Pydantic
│   │   │   ├── auth.py        # LoginRequest, RegisterRequest, TokenResponse
│   │   │   ├── user.py        # UserResponse, UserUpdate
│   │   │   └── common.py      # MessageResponse
│   │   └── services/          # Lógica de Negocio
│   │       ├── auth_service.py # Servicio de Autenticación
│   │       └── user_service.py # Servicio de gestión de usuarios
│   └── tests/                 # Pruebas automatizadas backend (Pytest)
│       ├── test_auth.py
│       └── test_users.py
│
├── web/                       # Módulo Frontend Web (Angular)
│   ├── package.json           # Dependencias de Node.js
│   ├── angular.json           # Configuración del workspace de Angular
│   ├── tsconfig.json          # Configuración de TypeScript
│   └── src/
│       ├── index.html         # Documento HTML principal
│       ├── styles.css         # Estilos globales y sistema de tokens CSS
│       ├── app/
│       │   ├── app.ts         # Componente raíz
│       │   ├── app.routes.ts  # Definición de rutas y guards
│       │   ├── core/          # Módulo Core (Servicios, Guardias, Interceptores)
│       │   │   ├── guards/    # auth.guard.ts, guest.guard.ts
│       │   │   ├── interceptors/ # auth.interceptor.ts
│       │   │   ├── models/    # auth.model.ts, user.model.ts
│       │   │   └── services/  # auth.service.ts, token.service.ts
│       │   └── features/      # Pantallas y Funcionalidades
│       │       ├── auth/      # Pantallas Login y Register
│       │       └── dashboard/ # Pantalla de Panel de Usuario
│       └── environments/      # Configuración de API URLs (environment.ts)
│
└── mobile/                    # Módulo App Móvil (Flutter)
    ├── pubspec.yaml           # Dependencias de Flutter/Dart
    ├── analysis_options.yaml  # Reglas del linter de Dart
    ├── lib/
    │   ├── main.dart          # Punto de entrada Flutter y AuthWrapper
    │   ├── config/
    │   │   ├── api_config.dart # Base URLs y timeouts de API
    │   │   ├── routes.dart    # Definición de rutas nombradas
    │   │   └── theme.dart     # Tema visual oscuro y estilos globales
    │   ├── models/
    │   │   └── user.dart      # Modelo User (ID es String UUID)
    │   ├── services/
    │   │   ├── api_service.dart     # Cliente HTTP con timeouts y manejo de errores
    │   │   ├── auth_service.dart    # ChangeNotifier para estado global de sesión
    │   │   └── storage_service.dart # Persistencia JWT con caché en memoria
    │   └── screens/
    │       ├── auth/          # LoginScreen, RegisterScreen
    │       └── home/          # HomeScreen (Dashboard móvil)
    └── test/
        └── widget_test.dart   # Pruebas unitarias de modelos y utilidades
```

---

## 🔑 Módulos y Contratos de la API REST

### 1. Autenticación (`/api/v1/auth`)

| Método | Endpoint | Descripción | Body Request / Headers | Respuesta Exito |
|---|---|---|---|---|
| `POST` | `/api/v1/auth/register` | Registrar nuevo usuario | `{ "email", "password", "full_name" }` | `201 Created` (`TokenResponse`) |
| `POST` | `/api/v1/auth/login` | Iniciar sesión (JSON) | `{ "email", "password" }` | `200 OK` (`TokenResponse`) |
| `POST` | `/api/v1/auth/refresh` | Refrescar token expirado | `{ "refresh_token" }` | `200 OK` (`TokenResponse`) |
| `POST` | `/api/v1/auth/logout` | Revocar tokens de sesión | Header `Authorization: Bearer <token>` | `200 OK` (`MessageResponse`) |

#### Esquema de Respuesta de Token (`TokenResponse`):
```json
{
  "access_token": "eyJhbGciOiJIUzI1Ni...",
  "refresh_token": "eyJhbGciOiJIUzI1Ni...",
  "token_type": "bearer",
  "user": {
    "id": "c56a4180-65aa-42ec-a945-5fd21dec0538",
    "email": "usuario@ejemplo.com",
    "full_name": "Nombre Usuario",
    "is_active": true,
    "is_verified": false,
    "created_at": "2026-09-04T06:17:34Z",
    "updated_at": "2026-09-04T06:17:34Z"
  }
}
```

### 2. Usuarios (`/api/v1/users`)

| Método | Endpoint | Descripción | Headers | Respuesta Exito |
|---|---|---|---|---|
| `GET` | `/api/v1/users/me` | Obtener perfil actual | Header `Authorization: Bearer <token>` | `200 OK` (`UserResponse`) |
| `PUT` | `/api/v1/users/me` | Actualizar perfil | Header `Authorization: Bearer <token>` + Body | `200 OK` (`UserResponse`) |

---

## ⚙️ Variables de Entorno (Backend `.env`)

Ubicación: `backend/.env`

```env
PROJECT_NAME="Sistema de Autenticacion"
API_V1_STR="/api/v1"
SECRET_KEY="supersecretkey-change-this-in-production-long-random-string"
ALGORITHM="HS256"
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

POSTGRES_SERVER="localhost"
POSTGRES_PORT=5432
POSTGRES_USER="postgres"
POSTGRES_PASSWORD="tu_contraseña_postgres"
POSTGRES_DB="probando_1_db"
```

---

## 🚀 Guía de Inicio Rápido y Ejecución

### 1. Iniciar el Backend (FastAPI)
```powershell
cd backend
.venv\Scripts\activate
python -m uvicorn app.main:app --reload --port 8000
```
- **Documentación Swagger:** [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)

### 2. Iniciar el Frontend Web (Angular)
```powershell
cd web
npm start -- --port 4200
```
- **Aplicación Web:** [http://localhost:4200](http://localhost:4200)

### 3. Iniciar la Aplicación Móvil (Flutter)
```powershell
cd mobile
flutter run -d web-server --web-port 8080
# O para emulador Android / dispositivo físico:
# flutter run
```
- **App Móvil (Web Server):** [http://127.0.0.1:8080](http://127.0.0.1:8080)

---

## 🧪 Ejecución de Pruebas Automatizadas

### Backend (Pytest):
```powershell
cd backend
pytest
```

### App Móvil (Flutter Test):
```powershell
cd mobile
flutter test
```

---

## 💡 Notas para Desarrollo con IA & Escalabilidad Futura
- **UUID de Usuario:** El modelo `User.id` en PostgreSQL/SQLAlchemy se genera como `uuid.UUID`. Tanto en el frontend Web (`string`) como Móvil (`String`), el `id` debe manejarse siempre como tipo cadena de caracteres.
- **Almacenamiento en Flutter:** `StorageService` implementa una caché en memoria para garantizar que lecturas de token sean inmediatas (0ms), complementando `flutter_secure_storage`.
- **Nuevos Módulos:** Para agregar nuevas entidades (ej. Productos, Tareas, Notificaciones), crear los archivos correspondientes en `backend/app/models/`, `backend/app/schemas/`, `backend/app/api/v1/`, y replicar el consumo en `web/src/app/core/services/` y `mobile/lib/services/`.
