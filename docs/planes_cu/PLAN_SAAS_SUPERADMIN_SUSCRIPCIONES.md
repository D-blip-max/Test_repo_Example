# Superadministrador, privacidad y suscripciones — Implementation Plan

Fecha: 5/11/2026. Estado: **S0–S3 COMPLETADAS EN LOCAL; S4–S6 NO INICIADAS**.

**Goal:** separar al operador SaaS de los negocios y permitir gestión manual de empresas, planes, precios, beneficios y renovaciones con condiciones aceptadas e historial verificable.

**Architecture:** ámbitos de acceso explícitos en backend, catálogo versionado e inmutable, períodos de contrato y solicitudes idempotentes; panel Angular independiente y controles de capacidades compartidos por web/móvil. La cuenta operadora conserva pertenencia a una empresa técnica, sin facultades comerciales. PostgreSQL sigue siendo autoridad de permisos, precios y contratos.

**Tech Stack:** FastAPI/Pydantic/SQLAlchemy/PostgreSQL, Angular 21/TypeScript, Flutter/SQLite, pytest, pruebas Angular y Playwright. Sin actualización de frameworks ni proveedor de cobros SaaS en este incremento.

**Spec:** [ESPECIFICACION_SAAS_SUPERADMIN.md](ESPECIFICACION_SAAS_SUPERADMIN.md). Diagnóstico: [privacidad](../auditoria_software/REVISION_SUPERADMIN_PRIVACIDAD.md) y [roles/canales](../auditoria_software/REVISION_ROLES_WEB_MOBILE_2026-11-05.md).

**Ejecución prevista:** nativa y secuencial como venimos trabajando, una etapa por vez. Skills: writing-plans y systematic-debugging; angular-developer al implementar web. Revisión visual puntual con ui-ux-pro-max cuando corresponda, conservando marca. No delegar ni instalar nuevas skills automáticamente. El usuario autorizó la ejecución con «ya, metele»: se acordó S0 y después S1, una etapa por vez. No autoriza publicación ni ejecución automática de S2–S6.

## Restricciones globales

- Las fases 0–8 mantienen sus cierres. Esta es una ampliación SaaS con etapas S0–S6, no una certificación nueva de todo el producto.
- Decisiones CONFIRMADAS: aprobación manual primero; precio/beneficios vigentes hasta vencer; renovación con aceptación de nuevas condiciones.
- No pagos automáticos de suscripción, prorrateos, anualidad, deuda, descuentos negociados ni facturación fiscal en este alcance. PayPal de compras y recargas de billetera conserva su comportamiento.
- No acceso del operador a datos comerciales, incluso de su empresa técnica, ni exportaciones privadas, credenciales, impersonación o cambio de tenant arbitrario.
- Conservar autenticación empresarial, aislamiento, precios de servidor, bloqueos NO KEY UPDATE, UUID, firmas, colas y compensaciones de fases anteriores.
- Los nuevos nombres de archivo, modelos, funciones y rutas marcados en este plan son propuestas de implementación; no se afirma que existan hoy.
- Cada etapa termina con pruebas de su alcance e informe `docs/auditoria_software/SAAS_Sn_CIERRE.md` y matriz. Actualizar registro/continuidad. No poner aprobado sin ejecutar.
- No tocar secretos ni hacer commit/push/deploy sin autorización. No resetear Railway: sigue pendiente la operación física de billetera. Pruebas destructivas solo PostgreSQL local desechable validado por conftest.
- Preservar cambios locales de notificaciones, billetera, e2e y documentos. No limpiar ni incluirlos indiscriminadamente en commits.

## Foco de revisión

1. Operador con permisos admin heredados intenta ventas/SQL de reportes/backups por URL directa: S1 debe denegarlo en servidor.
2. Cambio de precio/beneficio afecta contratos previos o una empresa se autoextiende 365 días: S2/S3 conservan el período y exigen aprobación.
3. Doble aprobación o renovación concurrente crea períodos superpuestos: S3 bloquea el agregado y aplica un efecto por clave.
4. Empresa excedida intenta downgrade o el mes no tiene día 31: S3 conserva datos y usa calendario con ancla de facturación.
5. Vencimiento/cambio de plan coincide con una cola offline antigua: S4 conserva fuentes y usa prueba de autorización del servidor, sin confiar en fecha local.

## Contratos propuestos entre etapas

| Unidad | Interfaz propuesta | Responsabilidad |
|---|---|---|
| AccessPolicy | `resolve_access_scope(user) -> PLATFORM / COMPANY / DENIED` | UUID + rol/empresa técnica coherentes, sin concesión por correo |
| deps.py | `get_authenticated_identity`, `require_platform_admin`, `get_current_user` | Identidad común; autorización explícita por ámbito; get_current_user conserva contrato comercial |
| deps.py | `get_subscription_manager` | Identidad empresarial y subscriptions.manage para contrato propio; acceso restringido durante suspensión, nunca sesión comercial |
| PlanCatalogService | `create_draft`, `publish_version`, `retire_version`, `list_published` | Validar versión, publicar inmutable, retirar sin borrar contratos |
| SubscriptionContractService | `quote`, `request_change`, `decide_request`, `get_current_term` | Cotización, aceptación, aprobación manual y período único |
| EntitlementService | `resolve(db, user, at)`, `check(db, user, feature, purpose)` | Permiso y beneficio son controles diferentes; historial/conciliación explícitos |
| PlatformAuditService | `record(db, actor, action, target_type, target_id, before, after, reason)` | Auditoría SaaS con campos permitidos, atómica con la operación |

No ampliar `db.info.pop('tenant_scope')` como acceso general a todos los modelos. Las consultas globales quedan encapsuladas en servicios de plataforma de proyección administrativa, con campos permitidos y rutas autorizadas. El plan de S1 debe probar que ese contexto no se reutiliza accidentalmente en una operación comercial.

## S0 — Congelar contrato y preparar evidencia

**Archivos existentes:** AGENTS.md, CONTINUAR_AQUI.md, PLAN_MAESTRO_ESTABILIZACION.md, especificación anterior y diagnósticos. Crear al ejecutar `docs/auditoria_software/SAAS_S0_BASELINE.md`.

- [x] Registrar SHA/estado de cada repo y lista de cambios previos, sin secretos. Referenciar APK 1.0.1+2 y correcciones locales, sin mezclarlos con SaaS.
- [x] Registrar reglas confirmadas y la política propuesta de empresa operadora, datos globales permitidos, mensualidad inicial y restauración propia.
- [x] Preparar fixtures locales: operadora, empresas A/B, operador autorizado, operador revocado, admin A, cajero A y cliente A. Sin reutilizar usuarios/colas del teléfono.
- [x] Definir matriz S1 de TODOS los endpoints de router.py: identidad común, comercial, plataforma o público. Probar extremos no decorados con require_permission, no solo CRUD.
- [x] Escribir baseline de casos nuevos y fallos conocidos. Las pruebas nuevas no deben pasar por consultar un permiso desconectado de la API.

**Cierre:** alcance y fixtures identificados, fuentes disponibles, ninguna escritura remota; decisiones de producto propuestas revisadas antes de migrar. Pendiente físico no bloquea pruebas aisladas, sí bloquea la publicación.

## S1 — Separación real de plataforma y negocio

**Modificar:** backend/app/api/deps.py, models/user.py, models/tenant.py, schemas/user.py, services/auth_service.py, services/user_service.py, core/tenant_scope.py, api/v1/{subscriptions,users,auth,backup}.py y seed_permissions.py. El seed canónico de operadora en seed_database.py queda en S6; S1 utiliza fixtures y bootstrap explícito sin historia. Revisar TODAS las rutas de router.py, incluidos reportes, chat, recomendaciones, notificaciones y descargas.

**Crear:** core/access_policy.py, services/platform_company_service.py, services/platform_audit_service.py, models/platform_audit_log.py, schemas/platform.py, api/v1/platform.py, migrations/saas_01_platform_scope.sql, scripts/bootstrap_platform_operator.py, tests/test_saas_platform_boundary.py.

**Consume:** identidad/JWT actuales y UUID explícito de servidor. **Produce:** AccessPolicy y dependencias del cuadro anterior, `access_scope` y capacidades seguras en login/refresh/perfil.

- [x] Añadir primero regresiones con operador autorizado que conserva permisos admin: ventas, usuarios/clientes, inventario, reservas, billeteras, reportes SQL, chat comercial, notificaciones ajenas y backup deben responder 403, incluida su empresa técnica. Invocar rutas reales.
- [x] Separar identidad de autorización: login/logout/refresh/perfil propio permitidos; rutas comerciales rechazan cualquier identidad operadora aunque exista permiso heredado. No degradar operador revocado a usuario comercial. `/users/me` para operador devuelve solo identidad propia, no reutiliza el listado empresarial.
- [x] Exigir UUID autorizado + rol reservado + empresa operadora. Admin normal, rol homónimo, correo parecido, claim o tenant_id del formulario no conceden plataforma. Registro/edición comercial rechaza asignar ese rol o mover usuarios a la operadora.
- [x] Encapsular listado/alta/suspensión de empresas en PlatformCompanyService. DTO cerrado: no serializar User, Sale, Wallet o integraciones. Excluir operadora del directorio público y bloquear su suspensión accidental desde este panel.
- [x] Cambiar toggle de empresa por estado explícito e idempotente (`activo=true/false`, motivo, expected_version). Un reintento no revierte la suspensión. No borrar registros ni extender vigencia al reactivar.
- [x] Añadir auditoría SaaS en transacción, con antes/después permitidos; fallo de auditoría revierte el cambio. Nunca registrar contraseña, token ni datos del negocio.
- [x] Aprovisionamiento con `bootstrap_platform_operator.py --dry-run` y selección explícita de UUID. Ensayo local de migración por IDs conocidos; no convertir cuentas por nombre/correo. Conserva pertenencia empresarial y valida que no se modifica ningún cliente.
- [x] Retirar del operador descarga/restauración de datos comerciales. Permisos `backups.download` y `backups.restore` para admin comercial propio; mantener controles de fase 8 y añadir rechazo de snapshot de otra empresa/global. Registrar esta sustitución explícita de la política anterior.
- [x] Repetir prueba de acceso por ámbitos; empresa A no consulta B, operador solo metadatos administrativos. Probar revocación con access/refresh ya emitidos y protección de roles compartidos.

**Pruebas mínimas:** `test_platform_operator_denied_business_even_with_admin_permissions`, `test_uuid_grant_alone_does_not_bypass_operator_context`, `test_company_admin_cannot_assign_platform_role`, `test_platform_response_has_only_allowed_fields`, `test_suspend_retry_keeps_same_state`, `test_company_restore_is_own_and_platform_cannot_export`.

**Evidencia ejecutada:** SAAS_S1_CIERRE.md y SAAS_S1_MATRIZ.md: 350 aprobadas en corrida general y dos expectativas históricas actualizadas; repetición focalizada final 89 aprobadas, incluida concurrencia PostgreSQL. 353 casos actuales verificados entre ambas corridas; no una única corrida general verde. No publicado.

**Cierre:** operador gestiona metadatos globales y ninguna ruta comercial lo acepta; admin empresa conserva las operaciones propias aprobadas. No basta ocultar menús. Reporte S1 con estados HTTP y campos, sin filas privadas.

## S2 — Catálogo de planes, precios y beneficios versionados

**Modificar:** models/subscription_plan.py, schemas/subscription.py, models/__init__.py, api/v1/subscriptions.py, core/tenant_scope.py. **Crear:** models/subscription_plan_version.py, services/plan_catalog_service.py, core/plan_features.py, migrations/saas_02_contract_catalog.sql, tests/test_saas_plan_catalog.py.

**Consume:** require_platform_admin y auditoría S1. **Produce:** revisiones públicas inmutables y registro de capacidades.

- [x] Escribir pruebas: empresa no puede escribir catálogo; precio negativo, tres decimales, límite <1, revisión duplicada y capacidad desconocida se rechazan; publicar dos veces no crea dos revisiones.
- [x] SubscriptionPlanVersion: FK plan, revision única por plan, estado BORRADOR/PUBLICADA/RETIRADA, precio mensual Numeric(10,2), moneda BOB, periodicidad MENSUAL, max_sucursales, flags reportes_ia/analitica_avanzada/offline, descripción y publicación. Nuevas capacidades solo mediante registro de servidor y validación.
- [x] Crear/editar borrador, publicar, retirar y consultar versiones en PlanCatalogService. Bloqueo al asignar número de revisión. No actualizar condiciones de una revisión publicada ni borrar referencias.
- [x] Exponer rutas propuestas `/platform/plans`, `/platform/plans/{id}/versions`, `/platform/plan-versions/{id}/publish` y `/retire`. Catálogo comercial `/subscriptions/plans` devuelve solo ofertas publicadas disponibles, con adaptador para campos actuales; nunca borradores ni auditoría interna.
- [x] Presentar capacidades exigibles; no vender prestaciones sin implementación. Precio cero debe identificarse como gratuito/demo, no precio ausente.
- [x] Migración inicial crea revisión a partir del estado disponible; no altera empresas/períodos. La referencia mensual actual no se convierte en precio histórico aceptado. Inicializar analitica_avanzada desde el acceso efectivo anterior (hoy por permiso también en Básico), no con false que retire un beneficio a mitad del período. Revisiones nuevas pueden ofrecer condiciones distintas con aceptación posterior.

**Pruebas:** `test_published_version_is_immutable`, `test_new_price_does_not_mutate_existing_version`, `test_retired_version_remains_resolvable_for_contract`, `test_unknown_feature_is_not_an_entitlement`.

**Cierre:** CRUD/versionado autorizado, valores validados, adapter compatible y ningún contrato afectado por editar el catálogo. Seed/migración repetidos sin duplicar revisiones.

**Evidencia ejecutada S2:** SAAS_S2_CIERRE.md, SAAS_S2_MATRIZ.md y SAAS_S2_OPERACION_LOCAL.md. 387 aprobadas generales y un arnés corregido; cierre focalizado 137 aprobadas, incluye ocho regresiones adicionales. 396 casos actuales verificados entre corridas. No publicado.

## S3 — Solicitud, aceptación y aprobación manual de contratos

**Modificar:** models/subscription.py, schemas/subscription.py y api/v1/subscriptions.py. **Crear:** models/subscription_term.py, models/subscription_change_request.py, services/subscription_contract_service.py, core/billing_calendar.py, schemas/subscription_contract.py, migrations/saas_03_subscription_terms.sql y tests/test_saas_subscription_contracts.py.

**Consume:** catálogo S2 y permisos S1. **Produce:** períodos confirmados y cotización/solicitud contractual para S4/S5.

- [x] Reproducir localmente que `/change-plan` autoextiende 365 días. La regresión posterior exige que el mismo actor solo genere una solicitud; ni plan ni vencimiento cambian sin aceptación y aprobación.
- [x] Añadir `subscriptions.manage` a admin comercial mediante migración explícita; no sobrescribir permisos personalizados. No usar roles.update como permiso financiero/contractual. Plataforma no recibe permiso comercial por ello. `get_subscription_manager` valida usuario activo, pertenencia y ese permiso para acceder SOLO al contrato propio; no exige que el negocio esté habilitado para vender.
- [x] `quote(db, actor, plan_version_id, kind)` devuelve condiciones de servidor y token de cotización con propósito específico, actor/empresa, revisión, huella, fechas y vencimiento de 15 minutos. No reutilizar firma de billetera ni confiar en importes/flags enviados por cliente.
- [x] `request_change(db, actor, quote_token, acceptance, idempotency_key)` valida aceptación explícita y registra PENDIENTE. La misma clave con otro contenido se rechaza; vencida o retirada requiere recotizar. Nueva revisión publicada no sustituye una cotización vigente de la revisión anterior.
- [x] `decide_request(db, operator, request_id, decision, reason, expected_version, idempotency_key)` aprueba/rechaza. Revalidar rol/UUID y condiciones aceptadas. Aprobación crea exactamente un SubscriptionTerm CONFIRMADO; captura referencia de decisión y aceptación sin duplicar efectos.
- [x] SubscriptionTerm: FK subscription, FK revisión, precio/moneda y condiciones congeladas, fecha_inicio/fin, origen, aceptación y actor/instante de aprobación. Precio pactado legado puede ser desconocido; referencia migrada no cuenta como aceptación ni pago. La versión publicada no cambia después de aceptar.
- [x] Bloquear Subscription antes de comprobar/crear períodos; validar que no se superponen con otro confirmado y usar unique(subscription_id, fecha_inicio) y check(fin>inicio). El bloqueo se exige en TODOS los escritores contractuales. Probar dos sesiones PostgreSQL independientes.
- [x] Usar `next_billing_date(start, anchor_day)` con calendario local y ancla persistida: enero 31 → febrero 28 → marzo 31 en año no bisiesto. Rango [inicio, fin); renovación adelantada comienza al terminar el anterior, atrasada desde aprobación sin deuda retroactiva y con nueva ancla. No sumar 365/30 por defecto.
- [x] Renovación/cambio futuro no altera beneficios actuales. Downgrade con exceso de sucursales se bloquea y explica, sin cerrar/eliminar recursos. Evaluar cuota bajo bloqueo de empresa para evitar carrera con alta/reactivación de sucursal.
- [x] Rechazo/cancelación conserva historial. Suspendida y vencida no son lo mismo; reactivar no genera otro período. Aprobación manual se muestra como MANUAL, nunca PAGADA/CAPTURED sin evidencia monetaria.
- [x] Adaptar `/change-plan` a respuesta de solicitud; clientes antiguos reciben error claro si requieren confirmación nueva, jamás una activación silenciosa. Cambio de alcance confirmado por el usuario durante S3: alta pública NUEVA bloqueada con 503 hasta disponer de verificación de correo; sin crear propietario/empresa ni 365 días. No se presenta como onboarding completo.
- [x] Separar payload de alta de plataforma del autoservicio: operador no recibe/setea contraseña ni claves PayPal de empresa. No hay entrega verificable; por decisión expresa, no se implementa/simula alta del propietario. Queda deshabilitada y fuera del cierre funcional de empresas existentes hasta petición/configuración posterior.

**Pruebas:** precio sintético 100→150 BOB: contrato vigente sigue 100; nueva revisión requiere aceptación y renovación queda 150 sin cargo. `test_approval_retry_creates_one_term`, `test_concurrent_approvals_do_not_overlap`, `test_rejection_does_not_extend_term`, `test_month_end_anchor`, `test_downgrade_never_deletes_branches`, `test_old_client_cannot_self_activate`, `test_platform_cannot_set_company_admin_password`.

**Cierre:** contratos e historial preservados, aprobación manual idempotente, vigencia correcta y ninguna acción de cliente autoaprueba o prolonga condiciones. Si falta canal verificado de invitación, esa vía de alta queda explícitamente pendiente: no cerrar como flujo completo.

**Cierre ejecutado:** SAAS_S3_CIERRE.md y SAAS_S3_MATRIZ.md: 429 aprobadas generales, 173 de cierre focalizado (tres casos añadidos); 432 casos actuales verificados entre corridas. Alcance empresas existentes y alta nueva bloqueada expresamente. Snapshot 4.3.0 con contratos como referencias centrales. Sin publicación.

## S4 — Beneficios efectivos y continuidad comercial

**Modificar:** api/deps.py, api/v1/{voice_reports,analytics,branches,sync,wallet}.py, services/{sync_service,wallet_service}.py solo donde lo exija el contrato; servicios de alta/reactivación de sucursal y respuestas de suscripción. **Crear:** services/entitlement_service.py y tests/test_saas_entitlements.py.

**Consume:** AccessScope y términos confirmados. **Produce:** capacidades efectivas de servidor y razón legible de bloqueo.

- [x] `EntitlementService.resolve(db, user, at)` selecciona período CONFIRMADO cuyo rango incluye la fecha; períodos futuros no conceden acceso. No exige cron ni inventa renovación en una lectura. Subscription conserva estado administrativo y la respuesta expone estado efectivo separado.
- [x] Si el uso crece dentro del cupo vigente después de aprobar una reducción futura, al entrar el nuevo término gestionar exceso con REMEDIATE_LIMIT sin borrar/cerrar sucursales ni anticipar la reducción; caso de carrera registrado en S3.
- [x] Resolver desde el término, no desde el precio/flags actuales del plan. Sin período válido no otorgar capacidades pagadas.
- [x] Aplicar permiso + capacidad a voz/IA y analítica; a cuota de sucursales al crear/reactivar; a nuevas autorizaciones offline según su contrato. Nuevas escrituras comerciales (ventas, reservas, cambios de catálogo/inventario/usuarios del negocio) exigen período vigente; revisar rutas/services de S0 para no dejar escritores alternativos. No dar permisos de rol por contratar un plan superior.
- [x] Diferenciar START_NEW, RECONCILE_PENDING, READ_HISTORY y REMEDIATE_LIMIT. Comprobar lectura propia/renovación en vencimiento, desactivación propia de sucursal excedida con validaciones y acceso restringido de onboarding, evitando abrir operaciones comerciales por una excepción amplia.
- [x] Adaptar login/refresh al acceso de recuperación contractual del admin en empresa suspendida: credenciales/usuario válidos y empresa identificada sin directorio público de suspendidas. Exponer `service_restricted` en perfil; no concederlo a roles sin subscriptions.manage ni aceptar esa bandera del cliente. get_current_user continúa rechazando sesión comercial suspendida. Recuperación no aprueba cambios ni reactiva empresa.
- [x] Diseñar y probar conciliación offline con prueba previa emitida por servidor; nunca usar fecha_local o flag del cliente para eludir suspensión/límite. Mantener firma, nonce, stock, precio e idempotencia. Legados ambiguos quedan preservados y requieren revisión explícita.
- [x] Probar separación de identidades con caché viejo, downgrade durante desconexión, respuesta tardía y nueva identidad. No borrar UUID/colas por cambiar condiciones. No publicar protocolo incompatible con la compra física pendiente.

**Pruebas:** `test_paid_plan_does_not_grant_staff_permission`, `test_old_term_keeps_features_until_end`, `test_future_term_not_effective_early`, `test_no_implicit_renewal`, `test_feature_disabled_preserves_pending_queue`, `test_client_timestamp_does_not_authorize_pending_operation`, `test_suspended_admin_can_request_recovery_but_not_sell`, `test_expired_company_can_reduce_branch_limit_without_creating_stock_writes`.

**Cierre:** mismo contrato aplicado por API/cliente, pruebas de límites y recuperación aprobadas; se conserva clasificación de IA sintética/probador referencial y las garantías monetarias anteriores.

**Cierre ejecutado S4:** SAAS_S4_CIERRE.md, SAAS_S4_MATRIZ.md y SAAS_S4_OPERACION_LOCAL.md. 446 backend aprobadas; 43 web y build; 76 móvil verificadas entre corridas y analyze limpio. Recuperación PayPal previa incluida con proveedor simulado. Sin despliegue/APK ni S5 automática.

## S5 — Paneles web separados y compatibilidad móvil

**Modificar web:** app.routes.ts, core/guards/{auth,guest,permission}.guard.ts, core/models/{user,subscription}.model.ts, core/services/{auth,subscription}.service.ts, core/config/nav-modules.config.ts y features/subscription/subscription-detail/*.

**Crear web:** core/guards/{platform,company}.guard.ts, core/layout/platform-layout/, core/services/platform.service.ts, features/platform/{companies,plans,requests,audit}/ y specs por componente/guard. Crear web/e2e/saas-platform.mjs.

**Modificar móvil:** lib/models/user.dart, services/auth_service.dart, main.dart y contrato de capacidades; tests de identidad y compatibilidad. No añadir paneles administrativos móviles.

**Consume:** DTO/contratos S1–S4. **Produce:** UI que muestra solo su ámbito y acciones permitidas; backend conserva la última decisión.

- [x] Regresiones de rutas por URL directa y restauración de perfil: operador aterriza en `/plataforma/empresas`, admin comercial en su dashboard. No arranca consultas de ventas, bandeja o chat comercial desde el layout de plataforma.
- [x] Panel Empresas: metadatos permitidos, solicitud/estado y conteo de sucursales; sin enlaces a clientes/ventas ni botón de impersonación. Cambios con confirmación, motivo, estado explícito y manejo de conflicto por versión.
- [x] Panel Planes: borrador/validación/publicación/retiro, precio mensual, beneficios reales y revisión. Publicado se muestra de solo lectura; editar crea otra revisión.
- [x] Panel Solicitudes/contratos: condiciones aceptadas, actuales/propuestas, aprobación/rechazo y auditoría. Mostrar «aprobación manual», próximo período y fechas; no mostrar ingreso cobrado sin pago.
- [x] Corregir identificación visual del contrato por término/version_id y flags efectivos, no por código BASICO/PROFESIONAL ni por la última oferta: la UI actual compara codigo y contiene beneficios fijos. No presentar precio de referencia legado como aceptado/cobrado.
- [x] Mi suscripción empresarial: contrato vigente y período futuro, ofertas, comparación y aceptación explícita; sin autoextender y sin acceso para cajero/cliente a gestionar la solicitud. Se conserva información mínima de capacidades para sus interfaces.
- [x] Móvil rechaza cuenta de plataforma con explicación y enlace web, sin cachear datos comerciales de esa identidad ni borrar colas de la identidad anterior. Perfil antiguo sin access_scope no concede plataforma; servidor sigue rechazando operaciones no autorizadas.
- [x] Probar accesibilidad y pantalla estrecha con estilo de marca, estados de carga/error/reintento y botones sin doble envío. Angular 21 actual, sin actualizar framework.

**Pruebas:** `platform.guard.spec.ts`, `company.guard.spec.ts`, specs de planes/aceptación/errores y Playwright con cuentas separadas. Flutter `test/platform_scope_test.dart` y regresión de colas/propietario. API simulada debe identificarse como tal; repetir recorridos reales locales con backend aislado.

**Cierre:** cada rol entra a su ámbito, el operador no ve componentes/datos comerciales y la empresa puede completar solicitud/aceptación. Grabar evidencia de pantallas sin datos privados ni secretos.

**Cierre ejecutado S5:** SAAS_S5_CIERRE.md, SAAS_S5_MATRIZ.md y SAAS_S5_OPERACION_LOCAL.md. 446 backend, 64 web/build, 81 móvil/analyze y 17 recorridos locales reales. Contratos/privacidad/identidad y teclado verificados; sin APK/publicación ni S6 automática.

## S6 — Migraciones, seed, recuperación y aceptación final

**Modificar:** backend/app/seed_database.py, seed_permissions.py, seed_audit.py, models/__init__.py, services/backup_recovery.py, scripts/reset_demo_database.py y configuración de readiness cuando corresponda. Adaptar tests de fases previas solo donde cambió explícitamente el contrato, sin eliminar controles de aislamiento/monetarios para obtener verde.

**Crear:** tests/test_saas_migration_seed.py, tests/test_saas_backup_contracts.py, scripts/verify_saas_scope.py y docs/auditoria_software/SAAS_S6_{MATRIZ,CIERRE}.md al ejecutar.

- [x] Ensayar actualización de esquema poblado desechable, no solo create_all. Crear datos de contrato legado conservando fechas y condiciones disponibles, identificando precio histórico desconocido; ninguna bandera MIGRACION equivale a pago/aceptación. Incluir `test_migration_preserves_effective_legacy_analytics_access` para no retirar acceso anterior por defaults de campos nuevos.
- [x] Preparar seed repetible con operadora, UUID estable para operador y admins comerciales distintos. No asignar privilegios por nombre/email ni pisar permisos de roles personalizados; bootstrap de plataforma sigue explícito.
- [x] Añadir tablas al export/import de empresa con contrato versionado: solo datos propios, revisiones globales como referencias inmutables; rechazo de manipulación de catálogo, operador, UUID de otra empresa o firma de billetera. Auditoría SaaS no se importa como dato comercial.
- [x] Revisar versión del snapshot y compatibilidad: preservar lectura segura del formato anterior o error de migración claro; no restaurar parcialmente ni saltarse checksum. Ensayo rollback y restauración local completa de ambos ámbitos por herramientas separadas.
- [x] Ejecutar dirigidas de cada etapa; luego regresión backend, web y móvil, build y revisión posterior de clientes. Repetir únicamente por fallos/cambios relevantes; no contar cantidad de tests como cobertura completa.
- [x] Registrar versión/hash del backend, bundle y APK si móvil cambió. Flutter test, analyze y build se ejecutan secuencialmente: ya hubo carrera de registros de plugins al solaparlos.
- [x] Matriz final: operador permitido en SaaS/denegado en negocio; admin A permitido propio/denegado B y plataforma; precio viejo/nuevo, aprobación/rechazo/duplicado, cuotas, expiración, cola conservada, migración y recuperación.
- [ ] Antes de publicación: conciliar compra física pendiente y conservar evidencia; autorización específica de commit/push/deploy, variables revisadas sin imprimirlas, respaldo pertinente y ensayo de revisión anterior compatible. Un rollback de código no revierte un fresh demo.
- [ ] Tras publicación autorizada, comprobar UUID/ámbito efectivo, permisos API reales y pantallas con datos sintéticos, sin proveedor de cobro SaaS. No cerrar con una mera compilación o health 200.


**Cierre local S6:** SAAS_S6_CIERRE/MATRIZ/OPERACION_LOCAL.md. 466 backend únicas verificadas entre corridas, web 64/build, móvil 81/analyze/APK QA sin instalar. Migración poblada, rollback, seed optativo y pg_restore de 35 tablas aprobados. Las dos puertas externas de arriba siguen pendientes.

## Comandos de validación previstos (no ejecutados en esta planificación)

Backend desde backend, con TEST_DATABASE_URL ya validada como PostgreSQL local desechable: `.venv/Scripts/python.exe -m pytest tests/test_saas_platform_boundary.py -q -p no:cacheprovider`; equivalentes para cada nuevo archivo al crearse. No cargar .env ni usar URL Railway.

Regresión backend al cierre: conservar el comando de runtime de FASE_8_CIERRE.md y agregar suites SaaS; seed repetido/recuperación se ensayan por separado como allí se documenta.

Web desde web: `npx ng test --watch=false`, `npm run build`; ejecutar `node e2e/saas-platform.mjs` contra entorno aislado especificado, no contra Railway por defecto.

Móvil desde mobile: `flutter test`, luego `flutter analyze`, luego `flutter build apk --release` con API de pruebas explícita. No instalar sobre el teléfono del usuario para ensayar migraciones ni borrar datos.

## Criterios de aceptación globales

Verificados localmente en las matrices S0–S6; la aceptación en servicios publicados sigue pendiente de las dos puertas externas S6. Las casillas globales se reservan para ese cierre externo.

- [ ] Operador autorizado administra empresas/precios/beneficios sin poder leer ni modificar datos comerciales de ninguna empresa.
- [ ] Administrador comercial no alcanza funciones de plataforma ni se autoactiva/extiende suscripción.
- [ ] Contrato vigente conserva condiciones; renovación exige aceptación y aprobación manual.
- [ ] Publicar otra revisión no cambia términos previos; no se atribuyen cobros inexistentes.
- [ ] Solicitudes, fechas y cuotas mantienen coherencia bajo reintentos/concurrencia.
- [ ] Vencimiento/suspensión/downgrade no borran datos ni pendientes ni falsifican conciliaciones.
- [ ] Web/móvil aplican el contrato sin convertir la UI en autoridad de permisos.
- [ ] Seed, migración, backup/restore, pruebas y despliegue tienen evidencia diferenciada y límites documentados.

## Estado de entrega de ESTE plan

Este plan nació como planificación. Estado vigente: S0–S5 completadas localmente dentro de sus matrices y trabajo local S6 completado; publicación y aceptación remota pendientes. Para evidencia prevalecen los cierres SAAS_S0–S6 y sus límites, no las propuestas históricas.

## Autorrevisión de cobertura del plan

| Requisito | Entrega y comprobación prevista |
|---|---|
| Superadmin solo empresas y SaaS, nunca datos del negocio | S1 + S5: matriz de rutas, DTO cerrado, prueba de permisos heredados y E2E por URL |
| Gestión de precio, beneficios y límites | S2: borrador/publicación/retiro e inmutabilidad |
| Aprobación manual confirmada por usuario | S3: solicitud, aceptación, decisión idempotente; sin proveedor de pago SaaS |
| Condiciones preservadas hasta vencer | S2–S4: revisión/término, calendario y pruebas de renovación/cambio |
| Privacidad de contraseña, claves e integraciones | S1/S3/S5: payload separado, alta privada del propietario, sin impersonación |
| Vencimiento/suspensión/cuotas y pendientes | S3/S4: acceso contractual limitado, REMEDIATE_LIMIT y conciliación con prueba |
| Compatibilidad, seed, migración y recuperación | S6: versiones legadas, analítica efectiva, snapshots y ensayo local |
| No perder operación física ni cambios existentes | Restricción global + puerta de publicación S6 |

Revisión realizada sobre nombres de interfaces, estados, campos, dependencias y propósitos: las etapas consumidoras usan los contratos definidos arriba. Este plan precedió a la implementación. Para resultados ejecutados prevalecen SAAS_S0_BASELINE.md y matrices/cierres S1–S5; S6 sigue pendiente.
