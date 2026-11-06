# SaaS S2 — contrato y operación local

Fecha: 5/11/2026. No desplegado. La compra física offline sigue pendiente; no publicar/resetear Railway ni reinstalar/borrar datos del teléfono.

## Datos y reglas

`SubscriptionPlan` conserva identidad estable y condiciones operativas legadas. `catalog_managed=true` identifica planes nuevos del catálogo, para que una repetición del seed no les publique una oferta sin aprobación. Esa marca no es un beneficio ni una aceptación. Los campos legados que usan suscripciones existentes quedan protegidos cuando hay revisiones; nuevas ofertas no los sobrescriben.

`SubscriptionPlanVersion`: UUID, plan_id FK RESTRICT, revisión única por plan, estado BORRADOR/PUBLICADA/RETIRADA, lock_version, precio decimal, moneda BOB, periodicidad MENSUAL, max_sucursales, tres flags, descripción, origen y fechas. Las condiciones publicadas no cambian: se crea otra revisión. No hay borrado de revisiones y las retiradas no se republican.

Registro cerrado de features: reportes_ia, analitica_avanzada y offline. Booleanos estrictos, precio finito no negativo hasta 99999999.99 con máximo dos decimales, sucursales enteras de 1 a 2147483647. Cero se presenta como es_gratuito, con periodicidad/moneda explícitas. No se incorporaron cuotas de usuarios, consumo IA ilimitado, productos o almacenamiento.

Estos flags definen ofertas; su aplicación por período contratado corresponde a S3–S4. Un plan no concede permisos comerciales de rol. Se conservan etiquetas previas de IA sintética/probador referencial.

## API de plataforma

Todas las rutas exigen el ámbito PLATFORM de S1. Operador: UUID autorizado + empresa técnica y rol reservado coherentes, usuario/empresa activos. Admin comercial no escribe catálogo.

| Método/ruta (/api/v1) | Entrada y efecto |
|---|---|
| GET /platform/plans | Identidades globales, limit/offset |
| POST /platform/plans | codigo, nombre, reason; identidad sin oferta |
| GET /platform/plans/{id}/versions | Historial autorizado, limit/offset |
| POST /platform/plans/{id}/versions | precio_mensual_bob, max_sucursales, features completas, descripcion opcional, reason; asigna revisión bajo bloqueo de plan |
| GET /platform/plan-versions/{id} | Revisión, incluida retirada, sin datos comerciales |
| PUT /platform/plan-versions/{id} | Condiciones completas + expected_version y reason; solo borrador |
| POST /platform/plan-versions/{id}/publish | expected_version, reason; publicación una vez |
| POST /platform/plan-versions/{id}/retire | expected_version, reason; retiro sin destruir historia |

Crear/editar/publicar/retirar registra auditoría SaaS atómica con campos permitidos. Conflictos de versión/estado o duplicación de identidad: 409. Validación: 422. Repetir publicación/retiro ya aplicado devuelve el resultado actual sin otro efecto ni entrada de auditoría. No acepta identidad de versión, revisión, estado ni origen impuestos por formulario.

## Lectura pública y condiciones actuales

`GET /subscriptions/plans` conserva id/codigo/nombre/descripcion/max_sucursales/permite_reportes_ia/permite_offline/precio_mensual_bob/activo. Añade version_id, revision, moneda, periodicidad, features, es_gratuito y origen. Solo la última revisión no borrador de cada plan activo es oferta si está PUBLICADA. Retirar la última no vuelve a ofrecer automáticamente la anterior; borradores y auditoría no se publican.

`GET /subscriptions/current` continúa mostrando condiciones operativas legadas; publicar otra oferta no cambia Subscription, fechas ni esas condiciones. La migración inicial es REFERENCIA_LEGADA: no demuestra precio histórico aceptado ni cobro. Conserva analitica_avanzada=true también en Básico porque ese acceso existía por permiso, no por el flag de IA.

Los endpoints legados de onboarding/change-plan todavía tienen la deuda de aceptación/vigencia identificada para S3. S2 no los presenta como contratación versionada ni autorización de desplegar una ampliación parcial. En S3 se sustituirá la asignación de condiciones legadas por solicitud/aceptación/decisión y período confirmado.

## Migración y fresh local

Fuente única: backend/migrations/saas_02_contract_catalog.sql. Migración explícita en transacción, después de S1: agrega catalog_managed, tabla/restricciones, triggers y referencia inicial donde nunca hubo revisión y no es identidad nueva de plataforma. No altera contratos. No se debe publicar el backend contra el esquema anterior.

El hook after_create de Version instala el mismo SQL al construir un esquema NUEVO con create_all, respetando el esquema traducido de los tests concurrentes. No se ejecuta al importar ni hace migración automática sobre base existente. RUN_STARTUP_MIGRATIONS y RUN_DEMO_SEED siguen desactivados por defecto. seed_all llama ensure_legacy_versions dentro de su propia transacción; no reemplaza ofertas, no reedita condiciones ni regenera retiradas.

Datos legados inválidos no se corrigen a escondidas: el check provoca fallo de migración y rollback, preservando los datos para revisión. El contador/revisión y campos de condiciones también se protegen por PostgreSQL, además de la API; esto no equivale a RLS ni limita a un administrador que quite deliberadamente triggers.

El respaldo comercial pasa a **4.2.0** por nueva columna de referencia del plan. Los formatos anteriores se rechazan explícitamente, conservando fuente y sin simulación de compatibilidad. Revisión histórica integral: S6. Las versiones de catálogo son datos globales: no se restauran desde un snapshot comercial.

## Siguiente etapa

S3: solicitudes, aceptación, calendario mensual y aprobación manual de contratos; todavía sin cobro automático SaaS. La interfaz de plataforma corresponde a S5 y el despliegue coordinado a S6. Este incremento no modifica web/móvil, credenciales ni variables remotas.
