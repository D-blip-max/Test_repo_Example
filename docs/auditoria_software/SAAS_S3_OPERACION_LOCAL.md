# S3 — contratos manuales y operación local

Fecha: 5/11/2026. No publicado. No ejecutar migraciones/reset en Railway: la compra física offline sigue pendiente. No se cambia APK, colas ni credenciales.

## Alcance acordado

Contratos de empresas existentes: cotización → aceptación explícita → solicitud PENDIENTE → decisión manual → período CONFIRMADO. La decisión expresa del usuario bloquea altas nuevas hasta tener verificación de correo; no hay invitación simulada ni contraseña administrada por el operador.

S3 registra contratos. S4 aplicará de forma central sus beneficios/fechas y recuperación de login; S5 adapta interfaz y S6 prepara publicación. No desplegar este incremento aislado: el endpoint anterior de suscripción aún expone datos legados y los clientes anteriores deben actualizar sus flujos. Cambios futuros no actualizan los campos operativos legados ni se convierten en actuales por aprobarse.

## Autoridad y cotización

`subscriptions.manage` es permiso empresarial, concedido al admin base mediante seed/migración explícita, sin reemplazar roles personalizados. El gestor debe ser usuario activo/verificado de su empresa; no operador. Su acceso contractual limitado permite usar un JWT existente de una empresa suspendida, sin habilitar ventas ni reactivarla. Login nuevo en suspensión se resolverá en S4.

La cotización fija revisión, precio mensual BOB, capacidades, límite, rango y ancla. Firma HS256 con clave derivada por HMAC de SECRET_KEY y contexto exclusivo de suscripciones; audiencia/issuer/purpose distintos de sesión. No se usa WALLET_SIGNING_KEY. Vinculada a usuario, empresa y base contractual, vence en 15 minutos. No guardar/publicar el token en logs o documentos.

Solo se cotiza la oferta vigente. Una cotización ya emitida conserva su revisión aunque se publique otra; retiro/inactivación/vencimiento o cambio de base/calendario exigen nueva aceptación. Esto también se revalida al aprobar: una solicitud no conserva indefinidamente una cotización vencida.

Solicitud recibe exclusivamente token, acceptance=true booleano estricto y UUID idempotency_key. Empresa, importes y fechas nunca proceden de campos libres. Reintento idéntico devuelve solicitud existente; misma clave con otro contenido: 409. La decisión requiere estado esperado, motivo e idempotency_key; su repetición exacta devuelve el resultado sin otro período/auditoría. Otra decisión o versión obsoleta: 409. Rechazo/cancelación no extienden nada ni borran historia.

MANUAL significa autorización comercial; `payment_status=NO_VERIFICADO`. No es captura, ingreso cobrado, deuda, factura ni pago PayPal. Los cobros de compras/billetera no se modifican.

## Rutas (/api/v1)

| Método/ruta | Destinatario y efecto |
|---|---|
| POST /subscriptions/quote | Gestor propio: version_id y kind ALTA/RENOVACION/CAMBIO |
| POST /subscriptions/requests | Gestor propio: acepta cotización, queda PENDIENTE |
| GET /subscriptions/requests | Gestor propio: listado paginado de su empresa |
| GET /subscriptions/contract | Gestor propio: historial, término actual por rango y estado administrativo separado |
| POST /subscriptions/requests/{id}/cancel | Gestor propio: expected_version y reason |
| GET /platform/subscription-requests | Operador S1: metadatos de solicitudes, sin usuarios/ventas/claves de empresa |
| POST /platform/subscription-requests/{id}/decision | Operador: APROBADA/RECHAZADA, expected_version, idempotency_key y reason |
| POST /subscriptions/change-plan | Cuerpo anterior: 409 explicativo; nuevo cuerpo aceptado: solicitud pendiente |
| POST /subscriptions/onboarding | Alta válida: 503 por bloqueo acordado; sin escrituras. Validación de campos requeridos permanece |

No existe ruta para que la empresa se apruebe sola ni para que el operador elija la contraseña del propietario. Cajero/cliente/operador no usan el gestor contractual empresarial.

## Calendario, exclusión y condiciones

Rangos `[fecha_inicio, fecha_fin)` en calendario de Bolivia UTC-4. Ancla persistida: 31 enero → 28/29 febrero → 31 marzo. Renovación adelantada empieza al terminar el último período; tardía empieza en aprobación y adquiere ancla de ese día, sin deuda retroactiva. Si cambia el calendario aceptado, se recotiza.

Orden transaccional empresa → suscripción → solicitud, con NO KEY UPDATE en empresa/agregado para compatibilidad de FK. Revalidación de disponibilidad de revisión con bloqueo compartido frente a retiro. Unicidad de suscripción por empresa, período por inicio y solicitud por clave. Trigger PostgreSQL bloquea término solapado/reescrito, cambio de condiciones del agregado y cambio de aceptación/historia de solicitud. Un término manual debe coincidir con precio, fechas, capacidades e identidad aceptados en la solicitud. Auditoría en la misma transacción; fallo revierte todo.

El downgrade compara uso al decidir, bajo el mismo mutex de empresa que creación/reactivación de sucursal. El límite futuro NO se anticipa: se conserva el cupo actual hasta vencer. Si después de aprobar un downgrade crece el uso dentro de su cupo vigente, S4 deberá gestionar el exceso al entrar el término nuevo con REMEDIATE_LIMIT, sin cerrar/borrar sucursales. Una nueva alta/reactivación tampoco recibe antes de tiempo el cupo de una mejora futura.

## Migración, seed y recuperación

Fuente: migrations/saas_03_subscription_terms.sql; después de S1 y S2, transacción explícita. Tablas subscription_terms y subscription_change_requests, índice único de agregado por empresa, triggers y permiso. Datos duplicados/incompatibles deben conciliarse antes: la migración no elige ni borra contratos a escondidas.

Legados: conserva fechas anteriores como fin exclusivo `fecha_vencimiento + 1 día` porque el esquema anterior vencía inclusivamente. Capacidades operativas del plan anterior y analítica previamente disponible; precio aceptado NULL, origen REFERENCIA_LEGADA, sin inventar aceptación/pago. Nunca toma la última oferta nueva como condiciones históricas. El hook after_create sirve para esquemas NUEVOS; no se migra por importación/arranque automático. Seed añade referencias faltantes de agregados legados y no repite/modifica existentes. Nuevos agregados PENDIENTE no reciben vigencia gratuita por seed.

Snapshot comercial **4.3.0**: agregado/términos/solicitudes se exportan como referencias centrales propias; no son destinos de restauración. Si cambian, se rechaza el respaldo antiguo con 409. Esto impide borrar aprobaciones, restaurar solicitudes pendientes o ampliar fechas por recuperar datos del negocio. Continúan checksum, grafo propio, rollback y validación de billetera. Compatibilidad histórica integral sigue en S6. Bootstrap del operador también rechaza cuentas con historia contractual aunque sus UUID de auditoría no tengan FK a usuarios.

S3 no utiliza SMTP ni prueba entrega de correo. El alta queda deshabilitada por acuerdo expreso, no presentada como flujo implementado. Sin commit/push/despliegue/reset remoto; no permisos inferidos para publicar.
