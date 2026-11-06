# Paneles SaaS y compatibilidad móvil — Implementation Plan

6/11/2026. S5 autorizada con «metele S5». Ejecución nativa y secuencial como las etapas previas; sin delegación, commit/push/deploy ni S6 automática. Skills writing-plans, systematic-debugging, angular-developer y frontend-design. Las reglas del usuario de preservar datos y ejecutar la fase prevalecen sobre pasos genéricos de aprobación/commits de las skills.

**Goal:** operador limitado a plataforma; empresa completa cotización/aceptación/solicitud manual; móvil excluye plataforma conservando colas.

**Architecture:** guardas por ámbito después de restaurar perfil, layout de plataforma sin componentes comerciales, servicios HTTP tipados con descarte de respuesta tardía, paneles pequeños por responsabilidad. Contratos S1–S4 son autoridad; nunca deducir plataforma por correo/rol local ni plan por código. Compatibilidad Flutter en recepción/restauración de sesión, sin panel administrativo móvil.

**Tech Stack:** Angular 21/TypeScript/signals, formularios existentes, Flutter/Dart; Vitest, Flutter test y Playwright con API local PostgreSQL desechable.

**Spec:** PLAN_SAAS_SUPERADMIN_SUSCRIPCIONES.md S5, ESPECIFICACION_SAAS_SUPERADMIN.md, SAAS_S4_CIERRE/MATRIZ.

## Global Constraints

- Sin acceso de operador a ventas/clientes/stock/secretos ni solicitudes comerciales desde su layout. Empresa técnica y UUID se validan en servidor.
- Alta nueva deshabilitada hasta correo verificable. Aprobación MANUAL/NO_VERIFICADO; no ingreso cobrado sin evidencia.
- Preservar condiciones de término, mostrar NULL legado como desconocido, aceptación explícita y respuesta de conflictos; nunca auto-renovar.
- Preservar fases originales y colas/teléfono; solo prueba aislada local. Sin actualizar Angular ni instalar APK.

## Review Focus

1. URL directa/refresh de operador: restaurar perfil antes del guard y no cargar componentes comerciales.
2. Cambio de identidad durante respuesta/acción: descartar resultado y no imponer contrato/tema ajeno.
3. Doble envío, 409/503 y cotización vencida: conservar información, reintento explícito/idempotencia y no anunciar éxito falso.
4. Término vigente/futuro con mismo código y distinto precio/beneficios: distinguir versión/fechas, no anticipar cambio.
5. Flutter perfil legado/operador/restaurado: no activar ámbito de plataforma, preservar archivos/colas previas y ofrecer enlace web.

## Diseño

Panel de operación sobrio para FashionStore: navegación índigo #4338ca, texto #172033, fondo #f6f7fb, superficies blancas, bordes #d4d9e4 y avisos #92400e. Tipografía existente heredada, títulos 28/22 y cuerpo 16px; formularios alineados a izquierda y listas adaptables, sin dependencias ni fuentes externas. Barra de plataforma propia con cuatro destinos. Empresa conserva marca y usa comparación contractual con fechas/condiciones, no tarjetas de beneficios inventados. Validar foco, 375px/teclado y estados de error; quitar decoración que no ayude a decidir.

### 1. Ámbitos y sesión

Files: core/guards/{platform,company,guest,permission}.guard.ts, core/services/{auth,subscription}.service.ts, app.routes.ts, login, nav-modules, models/user. Consumes perfil access_scope/is_platform_admin/service_restricted y permisos; produces destino sesión y guardas await-profile.
- [x] Regresiones rojas de URL directa, restauración y carga tardía del contrato.
- [x] Separar layout/rutas plataforma, recuperación propia y negocio; corregir permiso de respaldo y suscripción. Quitar HTTP en constructor de suscripción y filtrar por identidad.
- [x] Specs de guardas/servicio y build.

### 2. Plataforma

Files: core/models/saas.model.ts, core/services/platform.service.ts, core/layout/platform-layout y features/platform/{companies,plans,requests,audit}. Consumes DTO cerrados S1–S3; produces UI de metadatos, catálogo versionado y decisiones con expected_version/motivo/UUID idempotente.
- [x] Empresas: listado paginado, confirmación de estado con motivo y conflicto sin sobrescribir.
- [x] Planes: crear identidad, borrador/editar borrador/nueva revisión/publicar/retirar; nunca editar publicación ni mostrar referencia como oferta nueva.
- [x] Solicitudes: condiciones/fechas aceptadas, aprobar/rechazar manual y auditoría paginada sin datos del negocio.
- [x] Pruebas de acciones, denegaciones y estados de carga/error/reintento.

### 3. Empresa

Files: features/subscription/subscription-detail y core/services/subscription.service.ts. Consumes /contract,/plans,/quote,/requests y cancel; produces comparación y aceptación, listado de términos/solicitudes, sin change-plan automático.
- [x] Vigente/futuro con fechas/versión/precio legado desconocido; capacidades/cupo efectivos.
- [x] Cotizar tipo apropiado, aceptar checkbox sin preselección, enviar con UUID estable y cancelar pendiente con motivo/versionado.
- [x] Respuestas tardías/409/doble envío e incertidumbre conservadas; pruebas de aceptación y errores.

### 4. Móvil

Files: lib/models/user.dart, services/auth_service.dart, main.dart y pantalla explicativa si aplica; test/platform_scope_test.dart. Consumes access_scope=PLATFORM confirmado por servidor; produces rechazo antes de cache/activar ámbito y enlace web.
- [x] Regresión roja login/restauración operador y perfil legado sin plataforma.
- [x] Preservar colas de propietarios anteriores; pruebas de identidad/sesión y analyze.

### 5. Integración y cierre

Files: backend/scripts/saas_s5_browser_api.py, web/e2e/saas-platform.mjs y docs/auditoria_software/SAAS_S5_{CIERRE,MATRIZ}.md.
- [x] API real aislada, cuentas separadas y ciclo catálogo → cotización → aceptación → aprobación → contrato; URL directa y privacidad de red, error/reintento y pantallas estrechas. Capturas sin tokens.
- [x] Suite web/build, móvil/test/analyze y backend pertinente; registrar diferencias entre simulación, API local y hardware no probado.
- [x] Actualizar plan/registro/continuidad; detener servicios propios y no avanzar a S6.

## Cierre ejecutado

446 backend, 64 web/build, 81 Flutter/analyze y 17 recorridos Chrome/API local aprobados. Ver ../auditoria_software/SAAS_S5_CIERRE.md y matriz/runbook. Ampliación de regresión: scope comercial NULL para operador, notificaciones tardías, salto y teclado de ambos layouts. Sin publicación/APK ni S6 automática.
