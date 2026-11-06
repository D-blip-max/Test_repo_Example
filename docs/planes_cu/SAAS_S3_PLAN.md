# Contratos manuales — Implementation Plan

Fecha: 5/11/2026. S3 autorizada, ejecución nativa/secuencial. Skills writing-plans y systematic-debugging. Sin commit/push/deploy; no S4 automáticamente.

**Goal:** solicitud/aceptación explícita y aprobación manual idempotente, con períodos mensuales inmutables e historia preservada.

**Architecture:** Subscription como agregado de empresa; SubscriptionTerm inmutable y SubscriptionChangeRequest con estado/versionado. Cotización JWT de propósito/audiencia y clave derivada independientes de sesiones/billetera, 15 minutos, vinculada a identidad/empresa/revisión/condiciones/calendario. Transacciones en orden empresa → suscripción → solicitud, bloqueos NO KEY UPDATE compatibles con FK. Auditoría atómica. Ninguna aprobación acredita pago.

**Spec:** PLAN_SAAS_SUPERADMIN_SUSCRIPCIONES.md S3 y ESPECIFICACION_SAAS_SUPERADMIN.md. **Tech:** FastAPI/Pydantic/SQLAlchemy/PostgreSQL, PyJWT instalado, stdlib calendar y pytest. Sin proveedor nuevo.

**Decisión posterior explícita del usuario:** bloquear altas nuevas hasta disponer de verificación de correo. No implementar invitación simulada ni activar por email declarado. El onboarding público devuelve explicación sin crear cuenta/empresa/contrato. Alcance de cierre: contratos de empresas existentes; alta queda deshabilitada por decisión, no certificada como flujo completo.

## Restricciones y focos

- Preservar compra física, colas, secretos y cambios previos. Solo nueva DB local fashionstore_test_saas_s3_20261105 validada por conftest.
- Conservar condiciones hasta vencer; aceptar nueva revisión no activa nada. Renovaciones/cambios futuros encadenan al último fin; tardíos empiezan en aprobación, sin deuda; fin exclusivo y ancla persistida (31 ene → 28 feb → 31 mar).
- Precio/beneficios/fechas/actor de cotización vienen de servidor. Al vencer/retirarse o cambiar la base contractual, recotizar; nunca sustituir oferta ni mover fechas sin aceptación.
- Todos los escritores de contrato deben compartir exclusión. Triggers protegen término, solicitud y condiciones del agregado; respaldo comercial conserva referencias y no reescribe contratos.
- Downgrade revisa cantidad bajo el mismo bloqueo de empresa que altas/reactivaciones de sucursal. Beneficio pagado no concede permiso de rol. MANUAL no es PAGADA.

## Tareas

- [x] Baseline HTTP: cambio de plan legado no debe autoactivar, cotizar/solicitar/decidir todavía no existe. Guardar log rojo.
- [x] Crear core/billing_calendar.py; modelos subscription_term.py/subscription_change_request.py, schemas/subscription_contract.py; migración saas_03_subscription_terms.sql y hook de fresh. Permiso subscriptions.manage solo admin base/migración explícita, sin pisar roles personalizados.
- [x] Migrar/sembrar referencias legadas sin inventar precio aceptado: rango inclusivo previo se conserva como fin exclusivo +1 día, condiciones operativas antiguas y precio NULL; nunca elegir última oferta como aceptación. Repetir sin diferencias.
- [x] Servicio quote/request_change/decide_request/cancel/get_current_term: validación de propósito/actor/empresa/aceptación/cotización/versión/disponibilidad, idempotencia, bloqueo y auditoría. Rutas de contrato propio y solicitudes globales con DTO cerrado.
- [x] /change-plan devuelve error claro para cuerpo viejo o solicitud para cuerpo nuevo; retirar activación anual y deshabilitar onboarding conforme a decisión del usuario. No cambiar UI ni propagar términos futuros como actuales.
- [x] Bloquear empresa en creación/reactivación de sucursales; respetar cupo efectivo actual sin anticipar la reducción/mejora futura; preservar restauración privada sin permitir reescribir agregado/términos/solicitudes. Snapshot nuevo explícito.
- [x] Tests: valor 100→150, rechazo/cancelación, firmas/expiración/otra identidad, fin de mes/bisiesto, exceso de cuota, dos aprobaciones concurrentes, rollback, seed/migración repetidos y regresión pertinente. Informe/matriz/registro/continuidad y siguiente S4 pendiente.


Cierre ejecutado: SAAS_S3_CIERRE.md y SAAS_S3_MATRIZ.md. General 429 aprobadas, cierre focalizado 173 aprobadas con tres casos adicionales; 432 casos actuales entre corridas. Sin despliegue; alta nueva bloqueada por acuerdo. S4 pendiente, incluye REMEDIATE_LIMIT para exceso que aparezca después de aprobar una reducción futura.
