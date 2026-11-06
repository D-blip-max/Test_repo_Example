# SaaS S5 — Matriz de validación

6/11/2026. Ejecución local, sin commit/push/deploy/APK. Alta nueva permanece deshabilitada por decisión S3. No se usó la base remota ni el teléfono pendiente.

| Requisito | Evidencia ejecutada | Alcance |
|---|---|---|
| Restauración antes de comprobar ámbito | platform.guard.spec + navegación real /dashboard y /empresa/suscripcion | Regresión de carrera entre guardas; no redirigir prematuramente por perfil aún vacío. |
| Operador exclusivo de plataforma | E2E escenario 1, network paths y ausencia de componentes comerciales | Login/refresh/URL directa; no ventas, bandeja, chat, sincronización ni contrato comercial desde su layout. |
| Admin de empresa fuera de plataforma | E2E escenario 3; guardas y 446 backend | Backend conserva control final, sin confiar en guardas locales. |
| Empresas y estado | CompaniesComponent y E2E suspensión/habilitación | Metadatos/contacto/cupo, confirmación/motivo/UUID/expected_version, sin impersonación ni datos comerciales. |
| Conflicto de versión | Dos sesiones reales de operador, E2E acciones 1 | 409 real, mensaje para actualizar, estado local no sobrescrito como éxito. |
| Catálogo versionado | E2E escenarios 2 + acciones 2 | Crear plan, crear/editar borrador, copiar publicado a nueva revisión, publicar y retirar. Publicado conserva condiciones. |
| Catálogo público y precio | E2E acciones 3–4 | Portada usa oferta/revisión/beneficios del servidor, no precios 199/499 ni beneficios inventados. Retiro de última revisión no resucita precio anterior. |
| Contrato actual/futuro | E2E escenarios 3 y 7 + component specs | Precio legado NULL mostrado desconocido; futuro aprobado 150 y oferta posterior 185 separados. Cupo actual cuatro no se anticipa a dos. |
| Aceptación expresa | E2E escenario 5 y component specs | Checkbox no preseleccionado, expiración, propósito/tipo y UUID estable; sin aceptación no solicitud. |
| Doble envío/respuesta incierta | Platform/Company component specs | Busy excluye duplicados simultáneos; clave de solicitud se conserva tras 503; no mensaje falso de cobro. |
| Aprobación manual | E2E escenario 6 | Condiciones/fechas/versión/actor aceptante visibles, motivo y confirmación; MANUAL y pago NO_VERIFICADO. |
| Cancelar solicitud | E2E acciones 5 | Motivo y lock_version; conserva términos confirmados. |
| Servicio suspendido | E2E escenario 8 | Admin verificado accede solo a contrato/perfil; renovar no reactiva empresa. Otra empresa no ve solicitud ajena. |
| Cliente sin gestión contractual | E2E escenario 9 | Denegación por URL directa y sin GET de contrato; aviso de permisos distinto de vencimiento. |
| Respaldo empresarial | Ruta/menú backups.download y restauración backups.restore; servidor preservado | Sin botón de respaldo/restauración en plataforma. Se verificaron permisos/compilación, no restore mediante UI en S5. |
| Identidad y respuestas tardías | Specs de servicios/guardas/componentes Angular y Flutter | No aplicar estado/contrato/tema de otra cuenta. Login móvil tardío tras logout no reactiva sesión. |
| Exclusión móvil de plataforma | platform_scope_test.dart: login, restauración, perfil legado | Rechazo antes de persistir token/activar ámbito; pantalla con enlace web. No acceso administrativo móvil. |
| Preservación de cola móvil | Prueba SQLite real temporal con operación sintética anterior + 81 tests | Rechazo de operador no borra fila ni reasigna propietario; no toca base del teléfono. |
| Pantalla estrecha | Capturas reales Chrome a 375px, verificación de ancho | Empresas, contrato y auditoría sin desborde horizontal; revisión visual ejecutada. No auditoría WCAG integral. |
| Regresión general | Backend 446, Angular 64/build, Flutter 81/analyze | Automatización local; proveedores y hardware no certificados por estos tests. |

## Evidencia y límites

- SAAS_S5_E2E.json: nueve escenarios aprobados con API real PostgreSQL local; un 503 se inyectó deliberadamente para probar error/reintento. No presentar esa respuesta como un incidente del proveedor.
- SAAS_S5_E2E_ACCIONES.json: cinco escenarios reales adicionales; conflicto 409 originado por dos revisiones simultáneas, sin simulación de ese conflicto.
- Capturas en SAAS_S5_CAPTURAS. Datos sintéticos, sin JWT ni claves en informes. Las capturas de fallo intermedias no representan el estado final.
- Flutter: 81 pruebas locales y análisis; sin compilar/instalar APK ni abrir navegador externo desde un teléfono físico. El enlace se conserva como acción de UI; entrega nativa queda para aceptación.
- No SMTP/invitación ni alta nueva; se quitó el formulario público de alta para que la UI refleje el bloqueo real. No PayPal/Gemini ni pagos de suscripciones en S5.
- La compra física pendiente continúa sin conciliar y bloquea publicación/fresh remoto. Fases originales 0–8 y cierres S0–S4 conservados; S6 no iniciada.

## Ampliación de cierre

SAAS_S5_TRANSICION_E2E.json añade tres recorridos aprobados: cambio empresa→operador→empresa sin recargar la SPA, ausencia de consultas comerciales heredadas y foco/teclado en ambos layouts. Son 17 recorridos verificados nuevamente en la entrega final. platform-storage-boundary.spec.ts verifica almacenamiento comercial NULL para operador y descarte de contador de notificaciones tardío; se conserva el JWT para plataforma y las colas anteriores. No confundir scope=NULL con cierre de sesión. Se corrigió el salto contra base href; no vuelve a la portada.
