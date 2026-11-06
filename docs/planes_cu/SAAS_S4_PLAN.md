# Beneficios efectivos — Implementation Plan

Fecha: 5/11/2026. S4 autorizada con «metele» después del cierre S3. Skills writing-plans/systematic-debugging; Angular para compatibilidad mínima de colas. Método nativo/secuencial. No commit/push/deploy ni S5 automática; compra física y cambios previos preservados.

**Goal:** permisos + capacidades de período efectivo para operaciones nuevas; recuperación contractual y conciliación verificable sin borrar pendientes.

**Architecture:** EntitlementService.resolve/check con START_NEW, READ_HISTORY, RECONCILE_PENDING, REMEDIATE_LIMIT. Término CONFIRMADO en rango actual, nunca precio/flags del catálogo ni renovación implícita. Dependencias de identidad separan acceso comercial/recuperación/historia. Prueba offline por UUID/actor/empresa/canal emitida por servidor bajo período válido; no confía en fecha del cliente ni firma de saldo como licencia. Ventana de conciliación 24 horas acotada por fin del término +24 h; permisos comerciales actuales, stock, precio, nonce e idempotencia siguen obligatorios.

**Spec:** plan maestro S4 y especificación SaaS. **Tech:** FastAPI/SQLAlchemy/PostgreSQL/PyJWT, Angular/TypeScript y Flutter/Dart en compatibilidad de colas, pytest/pruebas de cliente. Sin actualizar frameworks ni reconstruir/publicar APK.

## Restricciones

- No fallback permisivo cuando falta término: inicializar legados mediante migración/seed explícitos. Fixtures históricos se actualizarán para representar ese contrato, sin introducir una concesión implícita en producto.
- Sin período vigente no nuevas ventas/reservas/cambios de negocio, incluso rutas sin require_permission. Perfil/contrato/historia propia y desactivación de sucursal para remediar mantienen propósito limitado; suspensión no se levanta al renovar.
- En exceso de cupo no borrar recursos ni anticipar downgrade; creación/reactivación respeta límite efectivo. Desactivar no habilita ajustes de stock ni otros cambios en el mismo cuerpo.
- Autorizar UUID no acredita pago ni valida importe. Filas sin prueba y licencia retirada: revisión conservadora no terminal, no rechazo durable que destruya recuperabilidad. Reintento confirmado se consulta sin duplicar.
- Cambios de identidad descartan respuestas tardías/capacidades/permisos de otro propietario; nunca limpiar outbox por vencimiento. Protocolo no publicable con compra física pendiente.

## Tareas

- [x] Baseline: escritura con período vencido, flags legados que contradicen término y login de recuperación suspendido. Registrar rojo antes de corregir.
- [x] Crear services/entitlement_service.py y pruebas test_saas_entitlements.py; resolver estado efectivo, capacidades/cupo/precio origen legado, propósitos y autenticación comercial/recuperación.
- [x] Sustituir lectura de plan en get_current_subscription/require_plan_feature y /subscriptions/current; aplicar a analítica, registro público y todos los escritores HTTP del inventario S0. Preservar permisos de rol y etiquetas de IA.
- [x] Añadir desactivación propia restringida y cuota efectiva en servicio de sucursales; historial propio y reconciliación con dependencias específicas, sin aceptar flag del formulario.
- [x] Autorizaciones offline por UUID, propósito/canal y clave derivada distinta; validación en SYNC/WALLET tras comprobar replay. Sin licencia/prueba no crear efecto/rechazo terminal; conservar pendientes. No cambiar huellas monetarias legadas por agregar evidencia de licencia.
- [x] Compatibilidad mínima de clientes para conservar prueba y reconocer revisión no terminal/identidad. Datos locales y colas intactos; UI contractual completa S5.
- [x] Regresiones locales de períodos/cambio futuro/vencimiento/cupo/roles/firmas/colas/replay y clientes; fixtures explícitos, suite backend y pruebas pertinentes de apps. Informe/matriz/registro/continuidad y detener PostgreSQL propio. No despliegue ni nueva fase.

## Cierre ejecutado

S4 completada localmente: 446 backend, 43 web/build, 76 móvil entre corridas/analyze limpio. Ver ../auditoria_software/SAAS_S4_CIERRE.md, SAAS_S4_MATRIZ.md y SAAS_S4_OPERACION_LOCAL.md. No publicación ni S5 automática. Compra física pendiente preservada.
