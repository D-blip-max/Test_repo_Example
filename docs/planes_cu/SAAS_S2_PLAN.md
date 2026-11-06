# Catálogo versionado — Implementation Plan

Fecha: 5/11/2026. Ejecución S2 autorizada por «metele con el s2», nativa/secuencial conforme al plan maestro. Sin commits, push ni despliegue. No S3–S6 en esta etapa.

**Goal:** publicar revisiones inmutables de precio mensual BOB, límite y capacidades, conservando los planes/contratos legados.

**Architecture:** identidad SubscriptionPlan estable y condiciones operativas legadas congeladas al existir revisiones; SubscriptionPlanVersion con borrador/publicación/retiro, bloqueo por plan y auditoría atómica. Proyecciones cerradas en rutas de plataforma y adaptador público de oferta vigente. Protección PostgreSQL adicional a la API.

**Tech Stack:** FastAPI, Pydantic, SQLAlchemy, PostgreSQL, pytest. **Spec:** ESPECIFICACION_SAAS_SUPERADMIN.md sección 5 y plan maestro S2.

## Restricciones y decisiones

- Preservar datos/colas físicos y todo cambio S1/local anterior. PostgreSQL únicamente local fashionstore_test_ validado por conftest; nueva base S2. No certificados visuales ni cambios web/APK.
- Features cerradas: reportes_ia, analitica_avanzada, offline. Booleanos estrictos, precio decimal finito 0..99999999.99 con máximo dos decimales, sucursales enteras >=1. BOB/MENSUAL. Cero explícito como gratuito/demo.
- POST /platform/plans crea identidad sin oferta. POST /platform/plans/{id}/versions crea borrador; PUT /platform/plan-versions/{id} reemplaza condiciones de borrador con expected_version. Publicar/retirar requieren motivo y expected_version; publicar de nuevo la misma revisión no crea otro efecto/auditoría.
- La oferta pública corresponde a la última revisión no borrador de cada plan activo solo si está PUBLICADA. Retirar la última no reofrece un precio antiguo. Las revisiones anteriores siguen resolubles por ID para cotizaciones/contratos, sin mutar sus condiciones.
- Migración/seed inicial crean solo referencia legada si el plan nunca tuvo revisión; analítica=true preserva acceso previo también en Básico. No prueba precio aceptado, no activa ni prolonga suscripción. Condiciones por período/aceptación son S3–S4.

## Foco de revisión

1. Escritura ORM/Core/SQL no reescribe revisión publicada ni condiciones legadas que usan contratos actuales.
2. Dos creaciones concurrentes no repiten revision; dos publicaciones no repiten auditoría.
3. Retiro no elimina historia ni resucita oferta previa; borrador/precio inválido/capacidad inventada no son públicos.
4. Fallo de auditoría revierte catálogo; admin comercial no obtiene permisos globales.
5. Migración y seed repetidos preservan condiciones, no regeneran ofertas retiradas y no convierten referencias históricas en aceptación.

## Tareas y archivos

- [x] Reproducir mediante pruebas HTTP nuevas en tests/test_saas_plan_catalog.py y guardar SAAS_S2_RED.log antes de implementación.
- [x] Crear core/plan_features.py, schemas/plan_catalog.py, models/subscription_plan_version.py y core/plan_catalog_ddl.py. Exportar modelo, ampliar lectura de plataforma/protección global ORM y registrar DDL también en create_all para los tests/fresh demo. No SQL automático sobre bases existentes.
- [x] Crear migrations/saas_02_contract_catalog.sql: tabla/checks/FK RESTRICT/unicidad, triggers de inmutabilidad, referencia legada; repetir transaccionalmente sobre esquema previo sin alterar Subscription.
- [x] PlanCatalogService: create_plan/list_plans, create_draft/update_draft, publish_version/retire_version, get_version/list_versions/list_published. Core con campos cerrados y autorización S1; bloqueo de plan/revisión, antes/después permitidos y commit/rollback con auditoría.
- [x] Añadir rutas /platform y adapter /subscriptions/plans conservando campos actuales más version_id/revision/moneda/periodicidad/features/es_gratuito/origen. /subscriptions/current conserva condiciones legadas; cambios de catálogo no escriben plan operativo ni Subscription.
- [x] Sembrar referencia inicial dentro de seed_all sin repetirla ni sobrescribir revisiones; pruebas de migración, repetición y coexistencia de revisión nueva/legada. Actualizar expectativa de modelos globales sin ampliar propiedad comercial.
- [x] Ejecutar tests de valores/API/DB/rollback/concurrencia, regresión SaaS S1, multitenant, backups y seed. Documentar resultados reales en cierre/matriz, actualizar continuidad y plan. Detener PostgreSQL propio al terminar. No iniciar S3.

Validación desde backend, TEST_DATABASE_URL exclusivamente local: `.venv/Scripts/python.exe -m pytest tests/test_saas_plan_catalog.py -q --tb=short -p no:cacheprovider`, luego alcance ampliado. Suite por defecto limitada a tests por pytest.ini; no recoger scripts históricos externos de raíz.


Cierre local ejecutado: SAAS_S2_CIERRE.md y SAAS_S2_MATRIZ.md. General 387 aprobadas + un arnés corregido; repetición final 137 aprobadas, colección actual 396 casos verificados entre corridas. Sin publicación ni inicio S3.
