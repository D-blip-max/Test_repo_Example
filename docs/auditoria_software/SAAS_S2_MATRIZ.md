# SaaS S2 — matriz de validación

Fecha: 5/11/2026. Estado: COMPLETADA EN ALCANCE LOCAL. Solo backend local, HTTP TestClient y PostgreSQL real desechable fashionstore_test_saas_s2_20261105. No navegador/APK ni aceptación remota.

| Criterio | Prueba/evidencia | Resultado |
|---|---|---|
| Empresa no administra catálogo | test_company_cannot_write_catalog y test_all_catalog_routes_require_platform_before_access | Aprobado en cierre focalizado / suite general según logs |
| Valores válidos/capacidades cerradas/cero explícito | parametrización test_invalid_conditions_never_enter_catalog y publicación/retiro | 26 casos iniciales aprobados en SAAS_S2_CATALOGO.log |
| Actualizar borrador con versión; no editar publicación | test_draft_edit_conflict_and_published_immutability | Aprobado en primera integración |
| Oferta nueva conserva revisión anterior | test_publish_new_price_preserves_previous_version | Aprobado |
| Publicación repetida no duplica efecto/auditoría | test_publish_retry_is_one_effect_and_retirement_does_not_resurrect_old_offer | Aprobado |
| Retirar conserva historia y no reofrece precio anterior | mismo caso y test_legacy_reference_never_recreates_retired_offer | Aprobado en cierre focalizado / suite general según logs |
| SQL directo no reescribe condiciones/borrado/duplicación | test_database_rejects_overwrite_delete_and_duplicate_revision y parametrización published_database_conditions | Aprobado en cierre focalizado / suite general según logs |
| Fallo de auditoría revierte publicación | test_catalog_publication_audit_failure_rolls_back | Aprobado |
| Publicar no cambia suscripción/fechas/condiciones actuales | test_legacy_migration_preserves_basic_analytics_current_subscription_and_seed_repeat | Aprobado |
| Básico conserva analítica previa, origen no equivale a aceptación | mismo caso y explicit_upgrade | Aprobado en cierre focalizado / suite general según logs |
| Migración repetida conserva filas y seed no publica planes nuevos | test_explicit_upgrade_is_repeatable_without_contract_edits y seed_cannot_publish_unreviewed_platform_identity | Aprobado en cierre focalizado / suite general según logs |
| Migración inválida revierte esquema/datos | test_invalid_legacy_upgrade_rolls_back_original_schema_and_data | Aprobado en cierre focalizado / suite general según logs |
| Sesiones simultáneas: revisiones únicas, publicación una vez | test_saas_catalog_concurrency.py, esquemas locales aislados | Aprobado en cierre focalizado / suite general según logs |
| Empresa no escribe modelo global desde ORM | test_company_orm_cannot_write_global_version | Aprobado en cierre focalizado / suite general según logs |
| Roles/tenants/stock/dinero/colas/backups/seed previos | SAAS_S2_REGRESION_COMPLETA.log | Aprobado en cierre focalizado / suite general según logs |

Baseline: SAAS_S2_RED.log, 2 fallos de rutas del nuevo contrato antes de implementar; primera corrección 2 aprobadas. Catálogo ampliado inicial: 26 aprobadas, 3 advertencias, 12,28 s. No marcar como ejecución verde las ampliaciones todavía sin resultado.

Pendientes fuera de S2: aceptación y períodos (S3), aplicación de beneficios (S4), UI (S5), compatibilidad histórica y despliegue (S6). Datos físicos y correcciones locales previas preservados. Sin commit/push/reset/despliegue.


## Resultado definitivo

Suite general: **387 aprobadas**, un fallo de preparación del ensayo legado, 3 advertencias, 499,62 s. Se guardó el UUID antes de quitar la columna para evitar carga ORM moderna durante la simulación antigua; no se relajó el contrato. Repetición final: **137 aprobadas**, 0 fallidas/omitidas, 3 advertencias, 105,48 s. Log SAAS_S2_CIERRE_FOCALIZADO.log. Incluye ocho regresiones añadidas después de la recogida general (rollback inválido y todas las rutas). Colección actual: 396 casos; todos verificados entre corridas. Se conserva el log rojo general y no se afirma una única corrida general verde.

Seed nuevo/repetido, interrupción, conciliación y fresh local aprobaron en la suite general. Dos sesiones PostgreSQL independientes confirman revisiones 1/2 sin duplicados y una publicación/auditoría pese a dos solicitudes simultáneas. Ensayo de migración repetida conserva Subscription y revisión inicial; origen REFERENCIA_LEGADA no acredita aceptación/pago.

Sin commit/push/despliegue/reset remoto. S3–S6 siguen pendientes. PostgreSQL de pruebas propio se detiene al finalizar.
