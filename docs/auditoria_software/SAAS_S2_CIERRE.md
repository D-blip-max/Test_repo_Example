# SaaS S2 — catálogo de planes versionado

Fecha: 5/11/2026. Estado: COMPLETADA DENTRO DE SU MATRIZ LOCAL. No publicado.

## Hallazgo y corrección

Subscription usaba directamente los precios/límites/flags de una fila mutable SubscriptionPlan. Reescribirla podía alterar condiciones de todas las empresas asociadas, sin aceptación ni historia. No existían borradores/revisiones ni separación entre oferta actual y condiciones anteriores.

Ahora el plan conserva su identidad y sus condiciones operativas legadas. SubscriptionPlanVersion conserva revisión, precio mensual BOB, límite, capacidades cerradas, descripción, origen, estado y publicación. Cambiar condiciones exige otra revisión. El backend y triggers PostgreSQL bloquean la reescritura de condiciones publicadas, identidades/números y términos legados usados por suscripciones actuales. No hay borrado de revisiones, transición de retirada a publicada ni precio aplicado a una suscripción por editar catálogo.

## Implementación

- DTO estrictos, registro de tres capacidades, validación de decimales finitos de dos posiciones y límites positivos. Sin características inventadas por formulario. Cero se muestra como gratuito/demo.
- PlanCatalogService y rutas de plataforma protegidas por S1: identidades, borradores, reemplazo condicionado por lock_version, publicación y retiro. Motivo y auditoría con la mutación en la misma transacción; fallo revierte.
- Revisión secuencial bajo bloqueo de plan. Publicación bajo bloqueo de revisión; repetirla no crea otra revisión ni auditoría. Dos sesiones reales verifican ambos recorridos.
- Adapter público conserva campos usados por clientes y añade revisión/moneda/periodicidad/capacidades/origen. Solo ofertas publicadas activas; borradores privados y retiro de última oferta sin resucitar precio anterior. Revisión retirada permanece consultable por ID autorizado.
- Migración S2 explícita y hook de esquema fresco con una única fuente SQL. No se ejecuta al importar ni migra automáticamente bases existentes. Repetición no duplica ni reescribe revisiones.
- Referencia inicial legada mantiene analítica previa también en Básico; no se certifica precio histórico aceptado/pago. `catalog_managed` evita que un seed publique por defecto planes nuevos no revisados. Seed respeta retiradas y condiciones previas.
- `GET /subscriptions/current` y Subscription conservan valores y fechas legados. ORM comercial no escribe revisiones globales. Snapshot comercial 4.2.0 por nueva columna de referencia del plan; compatibilidad anterior explícitamente pendiente de S6, sin restauración global desde empresa.

Archivos principales nuevos: models/subscription_plan_version.py, schemas/plan_catalog.py, services/plan_catalog_service.py, core/plan_features.py, core/plan_catalog_ddl.py, migrations/saas_02_contract_catalog.sql y dos suites de catálogo. Se extendieron modelo de plan, exportación de modelos, API, esquema público, auditoría permitida, guardia global ORM y seed. No cambios web/móvil.

## Pruebas ejecutadas

PostgreSQL 16 local desechable **fashionstore_test_saas_s2_20261105** en 127.0.0.1:55439, validado por conftest; no PostgreSQL Railway. Estado de repos preservado en SAAS_S2_ESTADO_REPOS.json, sin valores privados.

- Baseline: SAAS_S2_RED.log, 2 fallos antes de implementar rutas nuevas.
- Primera corrección: 2 aprobadas. Catálogo ampliado inicial: 26 aprobadas, 3 advertencias, 12,28 s.
- Suite general: **387 aprobadas, 1 fallo de arnés**, 3 advertencias, 499,62 s. Log SAAS_S2_REGRESION_COMPLETA.log. El ensayo de esquema legado quitó catalog_managed y después accedió a una empresa expirada en el ORM moderno, provocando carga anticipada del campo que acababa de quitar. Se conserva UUID ANTES de quitar la columna; los pasos sobre esquema viejo son Core/SQL. No se relajó la migración ni una expectativa de producto.
- Ocho regresiones adicionales se añadieron durante esa corrida: rollback de migración inválida y control de acceso en todas las rutas nuevas. No estaban en su recogida original; requieren la repetición final junto con el caso corregido.
- El helper de DDL conserva el error original cuando PostgreSQL aborta la transacción; no intenta consultar para restablecer search_path antes del rollback. Su rama de error se verifica con la migración inválida.
- Repetición final de catálogo, S1, ámbitos comerciales, suscripciones legadas y respaldos: **137 aprobadas**, 0 fallidas/omitidas, 3 advertencias, 105,48 s. Log SAAS_S2_CIERRE_FOCALIZADO.log. La colección actual contiene 396 casos: quedan verificados entre los 387 aprobados generales y la repetición del caso corregido y ocho añadidos. No es una única corrida general completamente verde. No se modificó producto para reparar el arnés; el ajuste del helper en la rama de error se verifica en la repetición final.

Comandos desde backend, TEST_DATABASE_URL exclusivamente local validada, OMP_NUM_THREADS/OPENBLAS_NUM_THREADS=1:

```powershell
.venv/Scripts/python.exe -m pytest tests -q --tb=short -p no:cacheprovider
.venv/Scripts/python.exe -m pytest tests/test_saas_plan_catalog.py tests/test_saas_catalog_concurrency.py tests/test_saas_platform_boundary.py tests/test_saas_provisioning.py tests/test_saas_concurrency.py tests/test_multitenant_saas.py tests/test_phase8_backup.py tests/test_tenant_contract.py -q --tb=short -p no:cacheprovider
```

Ver [matriz](SAAS_S2_MATRIZ.md) y [operación local](SAAS_S2_OPERACION_LOCAL.md). No se presenta el resultado previsto como ejecutado ni una única corrida general verde que no ocurrió.

## Próximo alcance y límites

S3 todavía no iniciada: solicitudes, aceptación, período mensual y aprobación manual. S4 aplicará beneficios por período; S5 implementará UI SaaS; S6 integrará seed canónico de operador, compatibilidad y despliegue. Las rutas legadas onboarding/change-plan conservan su defecto de aprobación/vigencia identificado para S3; el catálogo nuevo no convierte esos flujos en contratación segura. No desplegar este incremento aislado.

Para migrar contratos en S3, no elegir automáticamente la última oferta publicada como condiciones históricas: usar la referencia legada con origen explícito y conservar ausencia de precio aceptado donde corresponda. El gestor comercial no debe convertirse en operador para consultar/cotizar ofertas.

Sin commit/push/despliegue/reset remoto ni cambios de credenciales/variables. Correcciones locales S1, notificaciones, billetera y e2e preservadas. La compra offline física sigue pendiente; no repetida, borrada ni atribuida automáticamente. No APK nuevo ni prueba visual web/móvil. Las fases 0–8 y S0–S1 conservan su alcance; esto no certifica funcionamiento absoluto ni calidad de IA externa.


## Continuidad de cierre

Plan y checklists actualizados, registro y AGENTS/CONTINUAR_AQUI/contexto enlazan esta etapa. No se inició S3. PostgreSQL local de esta sesión se detiene tras verificar que no quedan conexiones ajenas. No archivos temporales de usuario eliminados ni restauraciones masivas; estados de web y móvil conservados. Git diff --check sin errores de espacios; avisos LF/CRLF habituales no son fallos de pruebas.
