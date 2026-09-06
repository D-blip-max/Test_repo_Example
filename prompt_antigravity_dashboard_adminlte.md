# PROMPT PARA ANTIGRAVITY — Implementar Dashboard tipo AdminLTE con Menú de Módulos

Copiá y pegá todo lo que sigue tal cual.

---

## Contexto del proyecto

Estás trabajando sobre el mismo proyecto de la etapa anterior, donde **ya se implementó el módulo de Roles y Permisos** (tablas `roles`, `permissions`, `role_permissions`, columna `users.role_id`, dependency `require_permission` en el backend, y en Angular ya existen `core/guards/permission.guard.ts`, `core/directives/has-permission.directive.ts`, y los componentes `features/roles/role-list`, `features/roles/role-form`, `features/roles/role-permissions`).

Arquitectura (recordatorio):

- **Backend:** FastAPI + PostgreSQL 16 + SQLAlchemy 2.0 + Alembic + Pydantic v2, JWT (PyJWT).
- **Frontend Web:** Angular 19+ (Standalone Components, Signals, Reactive Forms), `authGuard`/`guestGuard`/`permissionGuard` funcionales, `auth.interceptor.ts`.

**IMPORTANTE — Antes de escribir una sola línea de código:**
1. Abrí `web/src/app/app.routes.ts` y confirmá cómo están declaradas hoy las rutas de `features/roles` y `features/dashboard` (si existe), y qué guards tienen aplicados.
2. Abrí `web/src/app/core/services/auth.service.ts` y confirmá cómo expone `permissions()` (signal) para poder filtrar el menú según lo que el usuario puede ver.
3. Revisá si el proyecto ya tiene **Bootstrap** instalado (`package.json` / `angular.json` → `styles`). Si no está, instalalo (`npm install bootstrap`) y usalo como base de estilos — **no** instales el paquete `admin-lte` completo (viene con jQuery y no es compatible con Angular standalone); vamos a replicar el *look & feel* de AdminLTE (sidebar, topbar, cards, tablas) con Bootstrap 5 + CSS propio, no con la librería original.
4. Si algo de lo descrito acá difiere de lo que encontrás en el código real (por ejemplo, nombres de rutas o del servicio de auth), **priorizá el código real** sobre este prompt y señalalo al final.

---

## Objetivo

Crear un **layout de dashboard** (shell general de la app autenticada), con estética tipo AdminLTE: topbar superior + panel de navegación colapsable con los módulos disponibles. Por ahora el único módulo es **Roles y Permisos**, pero el menú debe estar armado para que agregar un módulo nuevo en el futuro sea trivial (una entrada más en una lista, no reescribir el layout).

Dentro del módulo de Roles, la lista de roles debe tener, al lado de cada fila, un botón para abrir la asignación de permisos (rutas) de ese rol específico — reutilizando el componente `role-permissions` que ya existe.

## Alcance (mínimo indispensable — no te desvíes de esto)

✅ **Incluido:**
- Componente de layout (`core/layout/dashboard-layout/` o el nombre que ya siga la convención del proyecto): topbar fija arriba (logo/nombre app, usuario logueado, botón de logout) + panel de navegación **colapsable, ubicado a la derecha** de la pantalla, tipo "off-canvas" (se abre/cierra con un botón hamburguesa en la topbar, no queda fijo ocupando espacio permanentemente).
- Dentro de ese panel: lista de módulos disponibles, filtrada según los `permissions()` del usuario (si el usuario no tiene ningún permiso `roles.*`, no ve la entrada "Roles y Permisos").
- El módulo "Roles y Permisos" en el menú despliega (o navega a) las dos vistas ya existentes: listado de roles y, dentro de esa lista, gestión de permisos por rol.
- En `role-list`, agregar un botón/ícono por fila ("Asignar permisos" o ícono de llave/candado) que navegue a `role-permissions` pasando el `id` del rol clickeado (route param, ej. `/roles/:id/permissions`).
- El layout envuelve todas las rutas autenticadas vía un componente padre con `<router-outlet>`, sin duplicar el `authGuard` que ya existe en cada ruta hija.
- Responsive: en mobile el panel de navegación se comporta igual (off-canvas), no se rompe el layout.

❌ **Explícitamente fuera de alcance en esta etapa (no lo implementes aunque se te ocurra "mejorarlo"):**
- Instalar la librería `admin-lte` real (con jQuery/Bootstrap 4) — usamos solo Bootstrap 5 + CSS propio.
- Dark mode / theming configurable.
- Breadcrumbs dinámicos, notificaciones, buscador global u otros widgets típicos de AdminLTE que no se pidieron.
- Multi-nivel de submenús (por ahora cada módulo es una sola entrada; si "Roles y Permisos" necesita sub-entradas propias tipo "Roles" / "Permisos" por separado, dejalo como **una sección con dos links**, no como un sistema genérico de árboles de menú).
- Tocar el módulo de Roles y Permisos en el backend — esta etapa es 100% frontend.

Si identificás algo que valga la pena mejorar pero se sale de esto, documentalo al final en "Sugerencias fuera de alcance", sin implementarlo sin confirmación.

---

## 1. Estructura de archivos (Angular)

```
core/layout/
├── dashboard-layout/
│   ├── dashboard-layout.component.ts     # standalone, contiene topbar + nav + router-outlet
│   ├── dashboard-layout.component.html
│   └── dashboard-layout.component.scss
├── topbar/
│   └── topbar.component.ts               # logo, usuario, logout, botón toggle del menú
└── side-nav/
    └── side-nav.component.ts             # panel off-canvas a la derecha, lista de módulos

core/config/
└── nav-modules.config.ts                 # array tipado de módulos del menú (ver abajo)
```

## 2. Config de módulos del menú (`nav-modules.config.ts`)

Definir una estructura simple y tipada para que sumar un módulo futuro sea agregar un objeto, no tocar HTML del layout:

```typescript
export interface NavModule {
  label: string;
  icon: string;          // nombre de ícono (bootstrap-icons)
  route: string;
  permission: string;    // código de permiso requerido para verlo, ej. "roles.list"
}

export const NAV_MODULES: NavModule[] = [
  {
    label: 'Roles y Permisos',
    icon: 'bi-shield-lock',
    route: '/roles',
    permission: 'roles.list'
  }
  // próximos módulos se agregan acá
];
```

El `side-nav.component.ts` itera `NAV_MODULES`, y para cada uno consulta `authService.permissions()` (el signal ya existente) para decidir si lo muestra — mismo criterio que ya usa `has-permission.directive.ts`, reutilizá esa lógica en vez de duplicarla (si conviene, extraé un método `hasPermission(code: string)` en `auth.service.ts` y usalo tanto en la directiva como en el nav).

## 3. Comportamiento del panel colapsable

- Cerrado por default en mobile, tu criterio en desktop (podés dejarlo abierto por default en pantallas grandes y colapsado en chicas, usando un breakpoint de Bootstrap).
- Se abre/cierra con un botón (ícono hamburguesa) en la `topbar`.
- Al navegar a un módulo, en mobile el panel se cierra automáticamente (patrón estándar off-canvas).
- Usar los componentes de Bootstrap 5 (`offcanvas`) o una implementación propia con Signals — lo que sea más consistente con que el resto del proyecto **no usa jQuery** ni el bundle JS de Bootstrap si no hace falta; si usás el offcanvas de Bootstrap necesitás importar su JS, confirmá que eso no choque con Angular (mejor controlar el estado abierto/cerrado con un signal propio y CSS, sin depender del JS de Bootstrap, para mantener todo reactivo y sin fugas de memoria).

## 4. Cambios en rutas (`app.routes.ts`)

Envolver las rutas autenticadas (dashboard, roles, y las que vengan) bajo una ruta padre que use `DashboardLayoutComponent` con `children`, manteniendo `authGuard` a nivel del padre (no repetirlo en cada hija) y `permissionGuard` en las hijas que ya lo tenían. Ejemplo de forma esperada (ajustalo a los nombres reales que encuentres):

```typescript
{
  path: '',
  component: DashboardLayoutComponent,
  canActivate: [authGuard],
  children: [
    { path: 'roles', ...ROLE_LIST_ROUTE },
    { path: 'roles/:id/permissions', ...ROLE_PERMISSIONS_ROUTE, canActivate: [permissionGuard], data: { permission: 'roles.update' } }
  ]
}
```

## 5. Cambios en `role-list`

- Agregar columna/acción "Permisos" en la tabla con un botón por fila.
- Al hacer click, navegar a `/roles/:id/permissions` (usando `[routerLink]`, no lógica manual de navegación).
- Si el usuario no tiene el permiso `roles.update`, ese botón no debe mostrarse (usar `*appHasPermission="'roles.update'"`, la directiva que ya existe).

---

## 6. Verificación esperada al terminar

1. Al loguearse, el usuario ve la topbar y puede abrir/cerrar el panel de navegación desde el botón hamburguesa.
2. El panel muestra "Roles y Permisos" solo si el usuario tiene el permiso `roles.list`; si no lo tiene, no aparece ninguna entrada (o se muestra un estado vacío, a tu criterio, pero nunca un menú roto).
3. Desde `role-list`, el botón de "Asignar permisos" de cada fila navega correctamente a la vista de permisos de ese rol puntual.
4. El layout es usable en mobile (panel off-canvas no rompe el scroll ni tapa contenido).
5. `web` sigue compilando sin errores y las rutas previas (`/roles`, login, etc.) siguen funcionando.

---

## Sugerencias fuera de alcance (opcional, señalar solo si aplica)
Si durante la implementación notás algo que convendría corregir para que este layout escale bien a futuros módulos (por ejemplo, cómo se estructuran los breadcrumbs, o si `NAV_MODULES` debería vivir en el backend en vez de hardcodeado en el frontend), documentalo en una sección aparte al final de tu respuesta, sin aplicarlo automáticamente.
