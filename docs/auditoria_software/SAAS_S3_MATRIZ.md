# SaaS S3 — matriz de aceptación

Fecha: 5/11/2026. Estado: COMPLETADA PARA EMPRESAS EXISTENTES; ALTAS NUEVAS BLOQUEADAS POR ACUERDO. PostgreSQL real local validado, HTTP TestClient y transacciones independientes; no UI ni proveedor de pagos/correo.

| Contrato | Evidencia | Estado |
|---|---|---|
| Cliente antiguo no se activa/extiende 365 días | test_old_client_cannot_self_activate, multitenant test actualizado por regla S3 | Aprobado integración |
| Alta nueva deshabilitada sin efectos | test_onboarding_disabled_without_verified_channel | Aprobado integración, decisión expresa usuario |
| Solicitud aceptada PENDIENTE y aprobación/reintento únicos | test_acceptance_is_pending_and_approval_retry_creates_one_term | Aprobado integración |
| Precio 100 vigente, 150 solo futuro tras aceptar | test_price_100_to_150_keeps_current_term_and_requires_new_acceptance | Aprobado integración |
| Cotización previa conserva precio al publicar otra | test_issued_quote_keeps_old_price_when_another_revision_is_published | Aprobado integración |
| Otra identidad, firma, propósito, campos extra o falta de aceptación | pruebas de token/identidad y DTO estrictos | Aprobado integración |
| Cotización vencida o retirada requiere recotizar | test_expired_or_retired_offer_requires_new_acceptance | Aprobado integración |
| Clave reutilizada con contenido diferente no duplica | test_request_and_decision_keys_reject_different_payload | Aprobado integración |
| Rechazo/cancelación conserva historial y fechas | test_rejection_or_cancel_never_extends_terms | Aprobado integración |
| Rol/empresa: solo gestor propio y operador para decidir | role_cannot_manage, manager_can_only_see_and_cancel_own_company | Aprobado integración |
| Fallo auditoría revierte aprobación | test_audit_failure_rolls_back_approval | Aprobado integración |
| Ancla mensual y año bisiesto | test_month_end_anchor parametrizado | Aprobado integración |
| Downgrade excesivo no borra sucursales | test_downgrade_preserves_branches_and_rejects_excess | Aprobado integración |
| No anticipar downgrade ni mejora; reactivar respeta cupo | future_downgrade y future_upgrade tests | Aprobado en suite general/cierre focalizado |
| Concurrencia mismo/distinto key, solicitudes hermanas y sucursal | test_saas_contract_concurrency.py | Aprobado integración; repetición con regla sin anticipar cupo futuro |
| Historia/fechas inmutables en SQL, rango sin solape y precio aceptado | tests direct_sql/legacy_term/database_rejects/database_term | Aprobado en suite general/cierre focalizado |
| Migración/seed repetidos: precio desconocido, sin aceptación inventada | test_migration_and_seed_repeat y upgrade_from_existing_subscription | Aprobado en suite general/cierre focalizado |
| Respaldo no reescribe contrato ni pierde billetera | contract_snapshots_are_references y test_phase8_backup | Aprobado integración |
| Renovar con JWT existente suspendido no reactiva negocio | existing_suspended_manager test | Aprobado en suite general/cierre focalizado |
| ALTA contractual de empresa existente sin agregado no se autoaprueba | no_subscription_manager test | Aprobado en suite general/cierre focalizado |
| Stock/tenants/dinero/offline/seed/regresión SaaS anterior | SAAS_S3_REGRESION_COMPLETA.log | Aprobado en suite general/cierre focalizado |

Baseline rojo: 2 fallos reproducidos antes de corregir rutas. Primera integración 10 aprobadas; ampliación contratos/backups 27 aprobadas; integración con catálogo/concurrencia y legado: 76 aprobadas y un texto histórico de error corregido conservando límite y nombre del plan. Integración posterior **84 aprobadas**, 3 advertencias, 46,89 s. No sumar esas corridas como casos únicos.

No ejecutado: navegador, APK, actualización de interfaces y entrega/verificación de correo. Alta bloqueada por decisión, S4–S6 pendientes. Compra física preservada; sin commit/push/deploy/reset.


## Resultado definitivo

General: **429 aprobadas**, 0 fallidas/omitidas, 3 advertencias, 376,03 s. Cierre focalizado: **173 aprobadas**, 0 fallidas/omitidas, 3 advertencias, 85,63 s. Los tres casos nuevos añadidos después de la recogida general aprobaron en ese cierre; 432 casos actuales verificados entre corridas. Logs SAAS_S3_REGRESION_COMPLETA.log y SAAS_S3_CIERRE_FOCALIZADO.log. Seed nuevo/repetido, interrupción, conciliación, fresh local y garantías previas aprobaron en general. Sin repetir proveedores externos ni certificar UI por TestClient.

Concurrencia real: mismo key 200/200 con un término, keys distintos/solicitudes hermanas 200/409 con un término. Carrera de cupo serializa el conteo: si se crea primero y excede target, decisión 409; si se aprueba primero, creación posterior conserva cupo actual. Exceso futuro se remedia en S4 sin borrar recursos ni anticipar recorte.

No se ejecutó alta verificada ni entrega de correo: esa vía queda deshabilitada por decisión explícita, no aprobada como implementada. Sin commit/push/despliegue/reset.
