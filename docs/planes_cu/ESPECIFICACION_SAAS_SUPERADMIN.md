# Especificación — plataforma SaaS, privacidad y suscripciones

Fecha: 5/11/2026. Estado: diseño propuesto para revisión; no implementado. Esta ampliación no reabre las fases 0–8 ni cierra la ronda de aceptación pendiente.

## 1. Petición y decisiones confirmadas

El usuario solicita un superadministrador que gestione empresas, precios y beneficios de suscripciones sin acceso a los datos privados del negocio de cada empresa.

Confirmaciones expresas del usuario en esta conversación:

1. **Activaciones y renovaciones por aprobación manual del superadministrador**, antes de incorporar pagos automáticos de suscripciones.
2. **Conservar las condiciones contratadas hasta su vencimiento.** Renovar requiere aceptación de las nuevas condiciones por la empresa.

El resto de este documento concreta recomendaciones de diseño. No constituye autorización para ejecutar migraciones, cambiar permisos, publicar o efectuar cobros.

## 2. Diagnóstico que motiva la ampliación

Fuentes: `../auditoria_software/REVISION_SUPERADMIN_PRIVACIDAD.md`, su JSON y `REVISION_ROLES_WEB_MOBILE_2026-11-05.md`.

- Existen cuatro roles comerciales; la autorización de plataforma es adicional por `PLATFORM_ADMIN_USER_IDS`.
- La cuenta demo comprobada `admin@sistema.com` tiene admin/44 permisos de UrbanStyle, `is_platform_admin=false`; panel global 403 y ventas/usuarios propios 200. No se inspeccionaron todas las cuentas ni la configuración privada de IDs.
- Agregar su UUID a la lista permitiría funciones globales sin retirar permisos comerciales: no resuelve la separación.
- `subscriptions.py` mezcla información de empresa, onboarding y administración global. Sus rutas de plataforma retiran el filtro de empresa de la sesión para consultas globales.
- El catálogo guarda precio mensual y beneficios directamente en `SubscriptionPlan`; las suscripciones apuntan al plan mutable y no conservan condiciones contratadas.
- `/subscriptions/change-plan` cambia el plan y concede otros 365 días con `roles.update`, sin aprobación ni pago. El alta también concede 365 días aunque el catálogo publica precio mensual. Es inspección estática; no se ejecutó esa escritura remota.
- No existe CRUD global de planes/precios/versiones. La comprobación de beneficios es desigual: voz usa permiso y plan, analítica no usa la misma dependencia; el flag offline no es un contrato uniforme.
- El onboarding de plataforma actual puede recibir contraseña del administrador y configuración PayPal de la empresa. Eso contradice una operación SaaS sin acceso a credenciales del negocio.

## 3. Personas y ámbitos

| Actor | Permitido | Prohibido |
|---|---|---|
| Superadministrador de plataforma | Empresas, catálogo/versiones de planes, solicitudes, aprobación manual, suscripciones, estados y auditoría SaaS | Ventas, clientes del negocio, usuarios internos, inventario, billeteras, reservas, reportes comerciales, respaldos privados o impersonación |
| Administrador de empresa | Administración de su empresa; consultar contrato, aceptar oferta y solicitar activación/renovación/cambio | Cambiar catálogo global/precios, aprobar su solicitud, administrar otra empresa o asignar privilegios de plataforma |
| Encargado, cajero y cliente | Sus operaciones comerciales autorizadas dentro de la empresa | Administración SaaS y gestión contractual, salvo futura delegación explícita |

Se mantiene la pertenencia empresarial de todas las cuentas. La cuenta operadora tendrá empresa técnica propia, identificada como operadora; no será cliente global ni quedará asociada a UrbanStyle para administrar su negocio.

### Autorización de plataforma propuesta

- Rol reservado `superadmin_plataforma`, sin permisos comerciales.
- Empresa técnica con `Tenant.es_operadora=true`; fuera del directorio público y del listado de empresas clientes.
- La concesión sigue dependiendo del UUID autorizado por servidor: el nombre de rol, correo o un campo del navegador no conceden privilegios.
- Condiciones conjuntas: usuario activo, empresa operadora activa, rol reservado y UUID autorizado. Configuración incoherente se rechaza; no se degrada silenciosamente a admin comercial.
- Una cuenta marcada como operadora o autorizada por UUID no debe poder usar rutas comerciales aunque conserve por error los 44 permisos anteriores.
- Los administradores comerciales no pueden crear/asignar el rol reservado, mover cuentas hacia la operadora ni editar su condición.
- Aprovisionamiento inicial mediante comando administrativo explícito, revisable y con modo simulación; jamás desde registro público.
- Retirar el UUID invalida autorización en la siguiente solicitud; refresh, cookies o roles cacheados no conservan acceso.

## 4. Privacidad por diseño

El panel global utilizará respuestas con lista cerrada de campos: identificador de empresa, nombre/razón social, slug, datos de contacto administrativo declarados por la empresa, estado, fecha de alta, plan/revisión, vigencia, precio contratado y conteo de sucursales necesario para el límite.

No devolverá registros de usuarios/clientes, ventas, existencias, saldos, comprobantes del comercio, prompts/conversaciones, credenciales, tokens, claves PayPal/Gemini o documentos privados. Se eliminan del resumen global los contadores de usuarios que no se necesitan para un beneficio contratado.

El superadministrador no tendrá acceso a exportaciones/restauraciones privadas de clientes. La restauración propia de empresa se propone para admin comercial con permiso específico, conservando checksum, validación, ámbito y atomicidad de fase 8. Esto sustituiría explícitamente el requisito actual de operador de plataforma; debe probarse como cambio de autorización, no quitar controles para hacer pasar una prueba.

El administrador comercial conserva su branding y sus claves de integración, que no aparecen en formularios de plataforma. No se implementa «entrar como empresa», cambio libre de tenant en JWT, contraseña maestra ni recuperación de contraseña por el operador.

El alta del propietario debe ser autoservicio con contraseña elegida por él o invitación de un solo uso entregada exclusivamente a su correo verificado. Ninguna contraseña o enlace de acceso se devuelve al operador. Para el primer incremento se prioriza el autoservicio existente, adaptado a un alta pendiente; la creación de acceso desde el panel solo estará habilitada cuando la entrega privada de invitación y verificación esté disponible. No se simula una invitación entregada ni se muestra un enlace reutilizable como alternativa.

## 5. Catálogo versionado

`SubscriptionPlan` será la identidad estable del producto (código/nombre comercial). `SubscriptionPlanVersion` conservará una revisión de condiciones:

- Identificador y revisión secuencial por plan.
- Estado `BORRADOR`, `PUBLICADA` o `RETIRADA`.
- Precio mensual en BOB con dos decimales; valor no negativo, cero explícitamente gratuito/demo.
- Periodicidad inicial `MENSUAL`; no se crea modalidad anual usando precio mensual ni 365 días fijos.
- Límite de sucursales, mayor o igual a uno.
- Beneficios exigibles: reportes IA, analítica avanzada y operaciones offline, con un registro cerrado de capacidades.
- Descripción comercial y fecha de publicación.

Una revisión publicada es inmutable en precio/beneficios/límites. Para cambiarlos se publica otra revisión. Retirar una revisión impide nuevas solicitudes, pero no invalida períodos ya aceptados. No se borran planes o revisiones referenciados.

No se anuncian como beneficios límites de usuarios, productos, almacenamiento, consumo IA, reportes ilimitados u otras prestaciones sin mecanismo implementado y probado. Texto comercial y capacidades efectivas deben coincidir.

## 6. Suscripción y condiciones aceptadas

Se propone conservar `Subscription` como agregado de la empresa y añadir `SubscriptionTerm` para cada período contratado. El período referencia una revisión inmutable, con precio/moneda y condiciones congeladas; nunca toma sus condiciones del precio actual del catálogo.

`SubscriptionChangeRequest` conserva la solicitud, aceptación y decisión manual. Campos mínimos: empresa, tipo (alta/renovación/cambio), revisión ofrecida, importe y condiciones aceptadas, instante de aceptación, versión de la solicitud, fecha efectiva, estado, motivo de decisión, actor y resultado contractual. El cliente no decide el importe ni los beneficios efectivos.

Flujo:

1. Admin de empresa consulta una revisión publicada y solicita una cotización identificada con vencimiento.
2. Acepta expresamente precio, periodicidad, beneficios, límite y fecha efectiva de esa cotización.
3. Servidor registra solicitud propia `PENDIENTE` sin activar beneficios ni extender vigencia.
4. Operador aprueba/rechaza con motivo y clave de idempotencia. La aprobación valida que la revisión aceptada sigue disponible y que no existe otro período incompatible.
5. Aprobar crea exactamente un período `CONFIRMADO`, inmediato para alta o futuro para renovación. Rechazar no altera el contrato vigente.
6. Vencido el período, no se renueva ni reactiva silenciosamente. Una nueva revisión necesita otra aceptación.

Una cotización aceptada mantiene el precio de su revisión aunque se publique otra. Si la revisión se retira antes de aprobar o la cotización vence, se pide nueva aceptación; nunca se sustituye por otra oferta sin consentimiento.

Los períodos usan fechas locales de negocio, calendario mensual y rango inicio inclusivo/fin exclusivo. Ejemplo: 31/1 → último día válido de febrero. La renovación encadena el fin del período previo; las solicitudes tardías parten del día efectivo aprobado y no generan deuda retroactiva. El servidor calcula fechas; no confía en la fecha del formulario.

La aprobación manual es autorización comercial, **no prueba de pago ni captura PayPal**. Este incremento no añade cobros automáticos, facturas fiscales, prorrateos ni deudas. El indicador global se llama «valor mensual contratado», no «ingresos cobrados»; usa contratos vigentes y no ventas de las tiendas. La conciliación de un pago de suscripción será otro alcance explícito.

### Cambios y bajas

- Primer incremento: cambios de plan efectivos en la próxima renovación; no prorrateo ni retiro de beneficios a mitad del período.
- Si la empresa excede el nuevo límite de sucursales, el cambio queda bloqueado con explicación hasta que la empresa ajuste su situación. No se borran datos ni se cierran sucursales automáticamente.
- La suspensión exige motivo y confirmación; impide nuevas operaciones según política, pero no destruye información. Reactivar empresa/suscripción no crea un nuevo período ni prolonga fechas.
- Vencimiento, suspensión de empresa y estado contractual son conceptos separados. Una empresa activa con período vencido no obtiene beneficios de pago.

## 7. Permisos, plan y operaciones pendientes

Toda operación nueva necesita identidad válida + empresa correcta + permiso de rol + capacidad contractual cuando corresponda. Un plan Pro no concede permisos de cajero al cliente; un cajero con reportes no obtiene IA si su período no la incluye.

Se propone `EntitlementService.check(..., purpose)` con propósitos explícitos `START_NEW`, `RECONCILE_PENDING`, `READ_HISTORY` y `REMEDIATE_LIMIT`.

- Lectura de historia propia y acceso administrativo de recuperación/renovación no dependen de tener un nuevo período de pago.
- Nuevas operaciones comerciales y cambios de datos del negocio requieren un período vigente, incluso si no usan IA. La consulta del catálogo y otros datos deliberadamente públicos conserva su política pública; no implica permiso de compra.
- Admin de empresa activa pero vencida puede desactivar sucursales propias para resolver un exceso de cuota bajo `REMEDIATE_LIMIT`, conservando permiso y validaciones comerciales existentes. Esa excepción no habilita altas, reactivaciones, ventas, ajustes o eliminación de datos.
- La suspensión de empresa requiere un acceso limitado del administrador para consultar su contrato y pedir recuperación: validar usuario activo, credenciales, pertenencia y permiso contractual sin convertirlo en sesión comercial. No listar públicamente empresas suspendidas ni permitir que el administrador se reactive/apruebe solo. Cajero/cliente no reciben este acceso administrativo.
- Quitar offline o suspender servicio no borra colas SQLite/IndexedDB ni transforma guardado local en pago confirmado.
- La conciliación de pendientes no es una excepción abierta: conserva firmas, identidad, precio de servidor, stock, idempotencia y prueba de autorización previa del servidor. La fecha local sola no demuestra anterioridad.
- Pendientes heredados sin prueba suficiente se preservan para revisión explícita, sin cobro, aprobación, eliminación o atribución automática.
- El diseño de una autorización offline con vigencia debe ser compatible con fase 4; no basta con consultar un booleano en la UI. No publicar un cambio incompatible mientras siga pendiente la operación física de esta ronda.

## 8. Canales

Web plataforma con layout/rutas propios: empresas, planes/versiones, solicitudes, suscripciones y auditoría SaaS. No usa el dashboard de ventas, menú comercial, chatbot del comercio ni bandeja de clientes.

Web empresa: administración comercial propia y apartado Mi suscripción. Permisos contractuales separados de gestionar roles. Cliente/encargado/cajero reciben solo las capacidades necesarias para su interfaz, no facultad para gestionar el contrato.

El acceso administrativo restringido por vencimiento/suspensión solo abre Mi suscripción y perfil propio, mediante un flujo de identidad específico. Las dependencias comerciales siguen rechazándolo en servidor aunque se use un cliente antiguo.

Móvil: conserva experiencia comercial; operador de plataforma recibe «Esta cuenta se administra desde la web», sin entrar a Tienda. Perfiles/capacidades se invalidan al cambiar identidad. No se borran colas anteriores al rechazar otro inicio de sesión. No se construye un panel SaaS móvil en este incremento.

## 9. Migración, evidencia y límites

- Todo cambio de esquema tendrá migración repetible y ensayo de recuperación local; no se aplica sobre Railway en esta planificación.
- Crear revisión inicial y período legado preservando fechas, precio y beneficios realmente persistidos; no inventar pago, aceptación histórica o firma. Marcar origen `MIGRACION_LEGADA`, distinto de aceptación nueva.
- Si no existe precio históricamente aceptado, guardar la referencia actual como referencia, no como precio pactado. Señalar `REQUIERE_CONCILIACION` y excluirlo de importes contratados confirmados; no afirmar que se reconstruyó un contrato que la base nunca guardó.
- Beneficios nuevos como analítica deben migrarse desde el acceso efectivo anterior, no desde un booleano nuevo con default false. En particular, no retirar a contratos legados el acceso de analítica que hoy obtienen por permiso al introducir una nueva restricción de plan.
- `backup_recovery.py` y sus snapshots deben incorporar los nuevos datos privados de contrato propios, sin permitir sobrescribir catálogo global o aprovisionar operadores desde un respaldo.
- El seed demo incluye cuenta operadora estable y empresas comerciales con administradores propios. Repetición conserva personalizaciones; no convierte usuarios por coincidencia de correo ni nombre.
- Se preservan correcciones locales de billetera/notificaciones, pruebas previas y datos de la compra física pendiente.
- Antes de publicación: conciliar esa operación, cerrar la evidencia, obtener autorización específica y comprobar versiones. El fresh demo autorizado no equivale a permiso para publicarlo ahora.

Fuera del primer alcance: pagos automáticos SaaS, modalidad anual, prorrateos, créditos/deuda de suscripción, descuentos negociados, administración SaaS móvil y cambios generales de funciones de encargado/cajero. Los hallazgos del cliente web quedan registrados, pero no se mezclan con este desarrollo salvo compatibilidad imprescindible.
