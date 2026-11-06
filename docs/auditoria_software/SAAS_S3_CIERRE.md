# S3 — solicitudes y contratos manuales

Fecha: 5/11/2026. Estado: COMPLETADA EN SU MATRIZ LOCAL PARA EMPRESAS EXISTENTES. No publicado.

## Alcance autorizado y decisión

El usuario pidió ejecutar S3. Se revisaron S2, plan, especificación y código con writing-plans/systematic-debugging, ejecución nativa secuencial. Decisión adicional confirmada mediante pregunta durante el trabajo: **bloquear altas nuevas por ahora**, hasta disponer de verificación privada de correo. Por ello el alcance implementado es contratación de empresas existentes; no se certifica onboarding completo ni se simula entrega de invitaciones.

## Hallazgos y correcciones

1. `/change-plan` asignaba ACTIVA y 365 días sin aceptación ni operador. Ahora el cuerpo viejo devuelve 409 explicativo; un cuerpo con cotización/aceptación registra PENDIENTE, sin beneficios/vigencia nuevos.
2. Onboarding público creaba empresa/propietario y año activo sin verificación. Ahora queda bloqueado con 503 y sin escrituras, conforme al acuerdo nuevo. No contraseña/link de acceso en panel del operador.
3. No había período aceptado ni calendario mensual. Se añadieron SubscriptionChangeRequest y SubscriptionTerm con condiciones congeladas, ancla y rango [inicio, fin). Migración/seed conservan el rango legado inclusivo como fin+1 día, precio aceptado NULL, origen REFERENCIA_LEGADA y sin aceptación inventada. No usan la última oferta para reescribir historia.
4. Cotización de 15 minutos vinculada a actor/empresa/revisión/base/calendario, con firma y propósito/audiencia separados de sesión y billetera. Fechas/precios/capacidades provienen de servidor. Vencimiento, retiro o cambio de base exige otra aceptación; publicar otra revisión no sustituye una cotización emitida.
5. Decisión manual exclusiva de operador S1, con motivo, expected_version e idempotencia. Empresa no se autoaprueba. Reintentos iguales no duplican términos/auditoría; conflictos se rechazan. MANUAL y NO_VERIFICADO no acreditan captura/ingreso/pago.
6. Bloqueos empresa → suscripción → solicitud; NO KEY UPDATE conserva compatibilidad con FK. Triggers bloquean solapamiento/reescritura de términos y aceptación, y un término manual distinto de lo aceptado. Referencia de versión bloqueada frente a retiro al aprobar. Auditoría en la transacción; su fallo revierte.
7. Cupos: aprobación comprueba uso bajo el mutex de empresa compartido con alta/reactivación. Se mantiene cupo vigente hasta vencer; un límite futuro NO se anticipa. Si el uso crece después de aprobar un downgrade, la transición S4 debe permitir REMEDIATE_LIMIT sin borrar/cerrar recursos. Mejora futura tampoco aumenta cupo actual. Se comprobó ambos órdenes de carrera.
8. Respaldo 4.3.0 mantiene agregado/términos/solicitudes como referencias centrales, no destinos de restauración. Snapshot viejo con contrato cambiado: 409. Preserva historial/auditoría, aislamiento, rollback y firmas de billetera. Bootstrap también reconoce historia contractual sin FK a usuario y no reasigna esa identidad a plataforma.

## Implementación y pruebas

Archivos nuevos: core/billing_calendar.py, core/subscription_contract_ddl.py, models/subscription_term.py, models/subscription_change_request.py, schemas/subscription_contract.py, services/subscription_contract_service.py, api/v1/subscription_contracts.py, migrations/saas_03_subscription_terms.sql y dos suites de contratos/concurrencia. Se modifican permisos, dependencias, router/alias legados, seed, protección ORM, cuota de sucursales y referencias de respaldo. No web/móvil ni configuración remota.

PostgreSQL local desechable **fashionstore_test_saas_s3_20261105** en 127.0.0.1:55439, validado por conftest. Estado SHA/status sin secretos: SAAS_S3_ESTADO_REPOS.json. No scripts externos históricos de raíz: pytest limitado a tests.

- Baseline: 2 fallos reproducidos, SAAS_S3_RED.log.
- Primera corrección: 10 aprobadas, SAAS_S3_PRIMERA_REGRESION.log.
- Ampliación contratos/backups: 27 aprobadas, SAAS_S3_CONTRATOS.log.
- Integración ampliada: 76 aprobadas y un mensaje de cupo incompatible con expectativa histórica. Se conservó prefijo de límite y nombre del plan, sin relajar el cupo. En revisión se corrigió la propuesta de aplicar un cupo futuro antes de tiempo, para respetar condiciones vigentes.
- Integración actualizada: **84 aprobadas**, 3 advertencias, 46,89 s, SAAS_S3_INTEGRACION_2.log.
- Suite general: **429 aprobadas**, 0 fallidas/omitidas, 3 advertencias, 376,03 s; SAAS_S3_REGRESION_COMPLETA.log. Repetición final: **173 aprobadas**, 0 fallidas/omitidas, 3 advertencias, 85,63 s; SAAS_S3_CIERRE_FOCALIZADO.log. Incluye tres casos añadidos durante la corrida general: upgrade desde tablas ausentes, reactivación sin cupo de mejora futura y SQL que intenta otro precio. Los 432 casos actuales quedan verificados entre ambas corridas; no se suman las repeticiones como casos únicos.

Desde backend, con TEST_DATABASE_URL exclusivamente local validada y OMP_NUM_THREADS/OPENBLAS_NUM_THREADS=1:

```powershell
.venv/Scripts/python.exe -m pytest tests -q --tb=short -p no:cacheprovider
.venv/Scripts/python.exe -m pytest tests/test_saas_subscription_contracts.py tests/test_saas_contract_concurrency.py tests/test_saas_platform_boundary.py tests/test_saas_provisioning.py tests/test_saas_concurrency.py tests/test_saas_plan_catalog.py tests/test_saas_catalog_concurrency.py tests/test_phase8_backup.py tests/test_multitenant_saas.py tests/test_tenant_contract.py -q --tb=short -p no:cacheprovider
```

Las pruebas S2 que simulan eliminar su tabla anterior usan CASCADE únicamente en la base de test para quitar las nuevas FK S3 durante esa simulación, con rollback de su transacción. No se relaja FK ni se aplica ese borrado en la migración de producto. Fixtures legados de admin se identifican como verificados; el test que antes exigía upgrade automático ahora exige rechazo sin modificación por la regla S3. La contratación correcta se comprueba mediante cotización/aceptación/decisión real de la API.

## Límites y siguiente paso

S4 no iniciada: aplicar términos efectivos en autorización/IA/offline y `/subscriptions/current`, recuperación de login suspendido y tratamiento de excedentes sin borrar datos. La API de contrato nueva ya distingue término actual/futuro; el consumidor legado permanece para transición y no demuestra aplicación integral de beneficios. S5 UI y S6 compatibilidad/publicación pendientes. No reabrir fases 0–8 ni declarar disponibilidad externa por estos tests locales.

Alta de empresa nueva queda expresamente deshabilitada por decisión del usuario, no «implementada al 100 %». No proveedor de correo ni cobro automático de suscripción. Cuenta con JWT existente de empresa suspendida puede gestionar solo contrato; renovar no reactiva empresa ni habilita ventas. No garantía de login nuevo en suspensión antes de S4.

Sin commit/push/despliegue/reset remoto. Compra física pendiente intacta; no repetida ni borrada. Correcciones locales previas de billetera/notificaciones/e2e preservadas. Ninguna credencial/clave se copia al informe. Ver [matriz](SAAS_S3_MATRIZ.md) y [operación local](SAAS_S3_OPERACION_LOCAL.md).


## Continuidad de cierre

S0–S3 completadas dentro de sus matrices y alcance acordado; alta nueva expresamente bloqueada. Plan/registro/AGENTS/CONTINUAR_AQUI/contexto actualizados. S4 no iniciada. PostgreSQL local propio se detiene tras comprobar que no quedan conexiones ajenas. Diff --check sin errores; avisos LF/CRLF habituales no son fallo funcional. No publicación ni autorización inferida para hacerlo.
