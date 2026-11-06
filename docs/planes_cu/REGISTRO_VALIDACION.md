# Registro de validación del software

## Fase 0 — 3 de noviembre de 2026

Estado: completada. [Informe](../auditoria_software/FASE_0_CIERRE.md).

| Comprobación | Resultado | Evidencia |
|---|---|---|
| Integración backend y regresiones | 42 aprobadas, 0 fallidas/omitidas; 5 advertencias | FASE_0_PYTEST_CIERRE.log |
| Carga demo nueva y repetida | 18 controles sin diferencias; ninguna tabla cambia al repetir | FASE_0_CONCILIACION_FINAL.json |
| Interrupción, faltantes y ediciones | Aprobados | tests/test_seed_phase0.py |
| Guardas de base y arranque | Aprobados | tests/test_phase0_safety.py |
| Web y móvil | Build/analyze y tests iniciales aprobados; UI pendiente | FASE_0_CIERRE.md e INVENTARIO_CANALES.md |

Evidencias en ../auditoria_software/. Las próximas fases mantienen sus escenarios pendientes en MATRIZ_PRUEBAS_FASE_0.md. No hay aceptación integral del software todavía.

## Fase 1 — Entrega 1

Aislamiento de ventas, notas y anulación: 55 pruebas aprobadas, 0 fallidas, 49,41 s. Incluye 16 escenarios nuevos. [Informe de avance](../auditoria_software/FASE_1_AVANCE.md). Fase 1 continúa abierta; registro, fallback, sesiones y módulos restantes pendientes.

## Fase 1 — Cierre

Estado: completada. [Informe final](../auditoria_software/FASE_1_CIERRE.md). Backend: 90 pruebas de runtime aprobadas y 3 de seed en la regresión completa anterior; 93 escenarios distintos. Web: build y 4 pruebas aprobados. Flutter: análisis sin incidencias y 8 pruebas aprobadas. Migración de roles repetida en PostgreSQL desechable. Fase 2 pendiente.


## Fase 2 — Cierre, 3 de noviembre de 2026

Estado: completada. [Informe](../auditoria_software/FASE_2_CIERRE.md). Primero 11 regresiones reprodujeron los fallos y luego aprobaron. La suite completa intermedia dio 123 aprobadas y un esperado histórico de Kardex corregido; los tres tests de seed aprobaron. Aceptación posterior: 132 runtime aprobados (219,86 s), seguida de 43 regresiones comerciales aprobadas (21,99 s), con 42 escenarios solapados y un caso adicional de efectivo exacto. Total: 133 runtime distintos y 3 de seed, 136 backend distintos acreditados. Ocho escenarios concurrentes con PostgreSQL real. Web: build y 7 tests; Flutter: analyze limpio y 8 tests. Migración repetida sobre 348 inventarios demo y verificación de rechazo de datos inconsistentes; conciliación 18/18 sin discrepancias. Sin commits/push/despliegue. Fase 3 pendiente.


## Fase 3 — Cierre, 3 de noviembre de 2026

Estado: completada. [Informe](../auditoria_software/FASE_3_CIERRE.md). Diez pruebas iniciales reprodujeron los fallos. La regresión definitiva aprobó 191 runtime (151,57 s, 0 fallos/omitidos), con 58 escenarios financieros y 6 concurrentes de esta fase. Los 3 tests de seed aprobaron en la ejecución completa anterior (188 aprobadas y 1 esperado HTTP de autorización corregido después). Total: 194 backend distintos acreditados entre ejecuciones. Web: build y 9 tests; Flutter: analyze limpio y 13 tests. Migración final repetida, rechazo de ledger/saldo inválido/NaN y conciliación demo de 18 controles sin diferencias. El usuario confirmó crédito de diferencia de cambios a billetera con cliente identificado. Sin cargos reales, commits/push/despliegue. Fase 4 pendiente.


## Fase 4 — Cierre, 3 de noviembre de 2026

Estado: completada. [Informe](../auditoria_software/FASE_4_CIERRE.md). Reproducción inicial: 6 fallos y 1 caso protegido. Regresión final: **209 runtime backend aprobados**, 0 fallos/omitidos, 280,57 s; excluye los 3 tests de seed, que no se ejecutaron nuevamente. Web: build y **23 tests** aprobados, Vitest con un worker. Flutter: analyze limpio y **28 tests** aprobados. Cubre reserva correcta, huella/UUID, concurrencia, auditoría atómica, rechazo durable de billetera, SQLite/IndexedDB, permisos/sesiones, fallos locales, respuestas incompletas y recuperación explícita preservando la fuente. Migración repetida y registro histórico preservado; conciliación demo **18/18 sin discrepancias**. Sin cargos reales, commits, push o despliegues. Fase 5 pendiente.


## Fase 5 — Primer cierre histórico, 4 de noviembre de 2026

Estado: completada dentro de la [matriz](../auditoria_software/FASE_5_MATRIZ.md). [Informe](../auditoria_software/FASE_5_CIERRE.md). Última regresión: **221 runtime backend aprobados**, 127,11 s, 0 fallos/omitidos; se excluyen test_seed_phase0.py (no se repitieron). Web: **32 tests**, build aprobado. Móvil: **49 tests**, analyze limpio y upgrade SQLite v5→v6 probado preservando saldos/pedidos/caché. Chrome: **24 pantallas y 3 recorridos** reales, con POS/recibo/historial, proveedor sin correo y corte/reconexión de venta IndexedDB, sin errores JS/HTTP en la ejecución final. Auditoría de 152 llamadas literales contra 143 operaciones, sin incompatibilidad de ruta/verbo; no se confunde con cobertura funcional de todos los endpoints. Cupones: crear exige productos.update y cliente recibe 403; validar autorizado permanece permitido. Sin cargos reales, commits/push/despliegues. Entorno local de pruebas detenido. Fase 6 pendiente.

## Fase 5 — Ampliación completada, 4 de noviembre de 2026

**Estado vigente: completada sin criterios abiertos de fase 5.** [Cierre](../auditoria_software/FASE_5_CIERRE.md) y [acciones](../auditoria_software/FASE_5_ACCIONES.md). Backend **223 aprobadas**, 410,98 s; web **32/build**, móvil **54/analyze limpio** (9,1 s). Chrome **20 recorridos con acciones** y 0 errores JS; rechazos intencionales comprobados. Android API 34 **1 recorrido/12 comprobaciones aprobado**, 1 min 18 s; consumidor Dart contra API **1 aprobado**. Seed no repetido; pruebas solo en bases sintéticas locales.

Nuevos fallos corregidos: deadlock usuario/sucursal (dos regresiones coordinadas; 103 pruebas comerciales/monetarias dirigidas aprobadas), bandeja/lectura falsa de notificaciones, arranque y confirmación comercial bloqueados por notificación opcional, inicialización de permiso duplicada y aserciones Material/bordes del perfil. Doble pulsación de reserva ya estaba protegida: se verificó con widget y se mantuvo. Seguridad y Permisos informa de sesión, sin botón vacío. API, Angular, emulador, daemon Gradle propio y PostgreSQL detenidos; datos de pruebas conservados. Sin commits, push, despliegues o cargos reales. Fase 6 todavía pendiente de comenzar.

## Fase 6 — Cierre, 4 de noviembre de 2026

Completada dentro de [FASE_6_MATRIZ.md](../auditoria_software/FASE_6_MATRIZ.md). [Informe](../auditoria_software/FASE_6_CIERRE.md). Backend **260 runtime aprobadas**, 182,51 s, 0 fallos/omitidos; 3 advertencias; seed excluido y no repetido. Angular **35 tests en 15 archivos**, build aprobado. Flutter **58 tests**, analyze limpio (7,8 s). Chrome real **4 recorridos aprobados**, sin errores inesperados, exportaciones PDF/XLSX/CSV comprobadas y entrenamiento real RF/KMeans con datos sintéticos.

Corregidos: fallback de empresa, permisos por nombre de rol, consultas SQL sin ámbito/filtrado suficiente, reportes sustituidos ante fallo, filtros/atributos incorrectos, exportaciones con fórmulas, historial cruzado/respuestas ficticias offline, reemplazos TTS literales, stock reservado, precio vigente/recargos, NaN en tallas y autoofertas parcialmente confirmadas. Modelos demo y fallback visual etiquetados; no se certifican precisión comercial ni proveedores/audio físicos. Límites en matriz/cierre. Servicios propios detenidos, sin commits/push/despliegues/cargos. Sigue fase 7.

## Hotfix de login Railway — 4/11/2026

[Informe](../auditoria_software/HOTFIX_LOGIN_RAILWAY.md). Causa remota confirmada: falta roles.tenant_id. Se añadió runner transaccional de phase1_role_tenants.sql y preDeployCommand en railway.json. Regresión local: **45 aprobadas**, 19,04 s; schema legado, repetición, conservación de cuentas, rollback y autenticación/empresa. Sin seed ni borrado de datos. Hotfix sin commit/push por el asistente; pendiente publicación y aceptación remota. No marca fase 8 completada.

## Demo descartable por despliegue — 4/11/2026

[Informe](../auditoria_software/RESET_DEMO_RAILWAY.md). Usuario autoriza fresh + seed de la base demo Railway en cada despliegue. Esquema/seed/validación en una única transacción y paso previo; conserva seeder normal, no se ejecuta en reinicios. **12 pruebas dirigidas aprobadas**, 183,60 s; esquema antiguo, datos descartables, seed repetido, 18 invariantes, login de ambos admins, rollback y regresiones seed/roles. Publicación/aplicación remota pendiente. No habilita borrado de otras bases ni de una futura producción.

## Fase 7 — Cierre, 4/11/2026

[Cierre](../auditoria_software/FASE_7_CIERRE.md) y [matriz](../auditoria_software/FASE_7_MATRIZ.md). **271 backend aprobadas**, 277,53 s, 0 fallos/omitidos, 3 advertencias; seed histórico excluido, reset demo sí siembra y concilia. **40 web/19 archivos/build**, **66 móvil/analyze limpio** (47,1 s). Chrome **11 escenarios de accesibilidad/layout +20 recorridos comerciales**, sin errores JS inesperados. Android API 34: **1 recorrido/12 comprobaciones**, aprobado, 1 min 55 s tras compilar.

Corregidos: foco/menú oculto y colapsado, salto a portada, contraste/tema/targets, filas que desbordaban a 320px/200%, recuperación de catálogo, pérdida de branding en GET/PUT de perfil y suscripción de identidad anterior. La regresión completa además encontró contaminación de fixtures por test_demo_reset; se aisló su esquema por caso y luego aprobó toda la suite. Sin certificación WCAG integral o hardware físico. Servicios QA propios detenidos; cambios locales preservados, sin commits/push/despliegues del asistente. Sigue fase 8.


## Fase 8 — Avance y publicación autorizada, 4/11/2026

[Informe y matriz](../auditoria_software/FASE_8_AVANCE.md), [runbook](../auditoria_software/FASE_8_RUNBOOK.md). **287 backend** (209,18 s), **40 web/build**, **66 móvil/analyze**, 2 pruebas dirigidas de chat y APK nuevo generado/instalado. Vercel **15 comprobaciones**, ambas empresas sin errores JS; APK previo crea/cancela reserva y lee catálogo offline. Recuperación en PostgreSQL aislado: **31 tablas idénticas y 18 conciliaciones**, firma monetaria correcta y otra empresa inalterada. Probador real Gemini 200 con maniquí sintético; PayPal sandbox crea orden 201, sin aprobación/captura. Voz requiere corregir modelos retirados/saturados y chat tiempos; cambios locales probados, usuario autorizó publicar backend/web/mobile. Aceptación remota de revisión nueva pendiente: fase 8 sigue abierta. No usar una respuesta local 200 como evidencia de inferencia externa.

Publicación autorizada realizada: backend 34a3ca9, web 644d62a, móvil b07bb6f. Railway /health/ready confirma SHA esperado, PostgreSQL y esquema; descarga de empresa v4.0.0/checksum válida. Vercel nuevo main-GL3U2DLY.js idéntico a dist, 15 comprobaciones y 0 errores JS. APK nuevo instalado, login/catálogo contra backend nuevo aprobados. Probador nuevo Gemini 200 (9,51 s). Voz no predefinida sigue 503 y chat origen local en repetición posterior con SHA y hora UTC registrados: aceptación de IA textual abierta; no mezclar logs de revisión anterior. Orden PayPal sandbox creada sin captura; aprobación/captura y teléfono físico no certificados.


## Fase 8 — Cierre final, 4/11/2026

[Cierre](../auditoria_software/FASE_8_CIERRE.md) y [matriz](../auditoria_software/FASE_8_MATRIZ.md). **COMPLETADA dentro de esa matriz.** Backend final 68987c8 en Railway/readiness SHA correcto; web 644d62a en Vercel y móvil b07bb6f/APK instalado. **297 backend/0 fallos**, 330,44 s; **40 web/build**, **66 móvil/analyze**. Recuperación completa local: 31 tablas idénticas/18 invariantes. Voz no canónica/chat Gemini reales y resumen monetario en Bolivianos aceptados; primer 503 de aceptación conservado, reintento correcto. PayPal comprador sandbox autorizado: primera compra recuperó 409 de respuesta mínima sin duplicar; transporte corregido con representación completa y GET de la misma orden. Compra posterior: primera confirmación **200**, recibo **VTA-20261104-62EF05**, una captura/venta, reintento mismos IDs y stock -1. FASE_8_PAYPAL_COMPRADOR_CORREGIDO.json. Credenciales solo en memoria. Pago por navegador comprador + API real, no botón de captura APK. QA propio detenido; repos aplicaciones limpios y main remoto coincidente. No otra fase iniciada ni garantía de cero errores/proveedores siempre disponibles.


## Ronda de aceptación 1 — PAUSADA por usuario, 4/11/2026

[Ronda](../auditoria_software/RONDA_ACEPTACION_1.md): 22 comprobaciones web/servidor aprobadas, 0 fallos y sin errores JavaScript. Incluye CRUD, reserva/preparación/cobro/anulación, diferencia a favor en billetera y venta offline sincronizada una sola vez; saldo QA 310 Bs/stock 20/reservado 0. Fallos iniciales del arnés separados y repetidos. Sin fallos de producto reproducidos ni nueva publicación. APK existente; nuevo recorrido Android no aprobado por problemas de entorno. Usuario tiene APK en teléfono, pendiente confirmar login/saldo; solicitó parar hasta nuevo aviso. QA propio apagado y fuentes/cuenta conservadas. No continuar automáticamente.

## Ronda 1 — reanudación e incidencia de billetera, 4/11/2026

Usuario confirmó físicamente login/saldo inicial, reserva/cancelación y compra online: saldo 290 Bs, stock 19. Segunda compra offline informada no confirmó en servidor; no repetir cobro ni limpiar su teléfono. Asistente reprodujo 2 defectos en contador/envío manual de billetera, corrigió integración y actualización del historial/mensaje pendiente. 73 pruebas móviles aprobadas; API simulada en regresión, consulta remota de lectura preservó saldo 290/nonce 4. Leer [incidencia](../auditoria_software/RONDA_1_INCIDENCIA_BILLETERA.md). Captura y APK local difieren en acciones de barra; versión instalada y UUID físico todavía sin comprobar. Sin commit/push/reset/deploy. Fases anteriores conservan su cierre; ronda actual EN CURSO.

APK de la incidencia: **1.0.1+2**, build release aprobado, SHA256 df988214ddd12b27514bcc7604fca53932598a5927f67ee76c4ca83abad40c6e, misma firma que artefacto local previo. flutter analyze final sin incidencias. RONDA_1_APK_MANIFIESTO.json registra archivo y límites. Actualización física y conciliación de su cola pendientes; sin nueva compra ni publicación. Emulador/compiladores propios detenidos.

## Ronda 1 — codificación de notificaciones, 5/11/2026

5 pruebas unitarias sin DB aprobadas (backend/tests/test_notification_encoding.py, --noconftest). Repara literales de reserva y representación de plantillas históricas sin mutación ORM. Corrección local: NO publicada, NO incluida en APK previo. No desplegar backend hasta conciliar operación física; fresh Railway perdería datos QA. Evidencia: RONDA_1_NOTIFICACIONES_CODIFICACION.md y RONDA_1_NOTIFICACIONES_FINAL.log.

## Revisión de acceso por rol y canal — 5/11/2026

Informe REVISION_ROLES_WEB_MOBILE_2026-11-05.md. Configuración Railway comprobada en ambas empresas: admin44/encargado15/cajero11/cliente6, coincidente con seed. 36 GET válidas de 4 roles en UrbanStyle conformes a autorización; 4 sondeos iniciales de ruta inexistente excluidos y corregidos. Menús/rutas/acciones inspeccionados estáticamente, sin aceptación completa de escrituras. Hallazgos: cliente web redirigido a listado de reservas prohibido; dashboard sin adaptación de consultas a permisos; APK común sin gestión por rol; reserva online/offline con controles diferentes para staff. Sin cambios de producto/permisos, seed, commit/push o deploy. Operación física pendiente y correcciones locales previas conservadas.

## Aclaración de superadministrador — 5/11/2026

Diagnóstico REVISION_SUPERADMIN_PRIVACIDAD.md/JSON: mecanismo adicional por PLATFORM_ADMIN_USER_IDS existe; no es rol comercial separado. Cuenta demo admin@sistema.com: login correcto, admin44/UrbanStyle, is_platform_admin=false; overview403, ventas/usuarios propios200. Sin filas privadas guardadas. No se implementó separación plataforma/negocio ni se modificó configuración. No atribuir acceso a otras empresas por estas pruebas ni asumir ausencia de otras cuentas configuradas. Usuario precisa operador que gestione empresas sin datos privados; diferencia registrada para decisión posterior.

## Ampliación SaaS — plan preparado, 5/11/2026

Usuario confirmó aprobación manual de suscripciones y conservación de condiciones hasta vencer con aceptación en renovación. Especificación ESPECIFICACION_SAAS_SUPERADMIN.md y PLAN_SAAS_SUPERADMIN_SUSCRIPCIONES.md en docs/planes_cu. Plan S0–S6 revisado documentalmente, sin ejecución de software/pruebas nuevas, ni cambios de permisos/BD. Auditoría SAAS_PLANIFICACION.md. No desplegar mientras siga la conciliación física pendiente. S0/S1 solo tras indicación posterior; fases anteriores conservan cierres.


## Ampliación SaaS S0–S1 — 5 de noviembre de 2026

Completadas en local. Ver [cierre S1](../auditoria_software/SAAS_S1_CIERRE.md), [matriz](../auditoria_software/SAAS_S1_MATRIZ.md) y [operación/migración](../auditoria_software/SAAS_S1_OPERACION_LOCAL.md).

| Comprobación | Resultado | Evidencia |
|---|---|---|
| Baseline nuevo contrato | 27 fallos reproducidos | SAAS_S0_RED.log |
| Integración S1 | 51 aprobadas | SAAS_S1_INTEGRACION_2.log |
| Suite general, seed e invariantes previos | 350 aprobadas; dos expectativas históricas pendientes de actualización en esa corrida | SAAS_S1_REGRESION_TESTS.log |
| Repetición final: contratos, SaaS, concurrencia y backups | 89 aprobadas, 0 fallidas/omitidas, 3 advertencias | SAAS_S1_CIERRE_FOCALIZADO.log |
| Casos actuales verificados entre corridas | 353; no una única corrida general verde | Desglose en cierre S1 |
| Publicación, UI SaaS, APK, migración remota | No ejecutados | S2–S6 pendientes; compra física offline preservada |

La recogida general inicial fuera de tests se interrumpió por efectos externos de scripts históricos; no se cuenta como evidencia. pytest.ini ahora limita la recogida por defecto a tests. No commit/push/reset/despliegue.


## SaaS S2 — 5 de noviembre de 2026

Completada en alcance local. [Cierre](../auditoria_software/SAAS_S2_CIERRE.md), [matriz](../auditoria_software/SAAS_S2_MATRIZ.md), [operación](../auditoria_software/SAAS_S2_OPERACION_LOCAL.md).

| Verificación | Resultado | Evidencia |
|---|---|---|
| Baseline rutas S2 | 2 fallos antes de implementar | SAAS_S2_RED.log |
| Catálogo inicial ampliado | 26 aprobadas | SAAS_S2_CATALOGO.log |
| Suite general + seed/fresh/conciliación | 387 aprobadas, un arnés legado fallido y posteriormente corregido | SAAS_S2_REGRESION_COMPLETA.log |
| Cierre: catálogo/concurrencia/migración/S1/tenants/suscripciones/backups | 137 aprobadas, 0 fallidas/omitidas, 3 advertencias, 105,48 s | SAAS_S2_CIERRE_FOCALIZADO.log |
| Colección actual | 396 casos verificados entre ambas corridas, no única corrida general verde | SAAS_S2_COLECCION.log y cierre |
| UI/APK/publicación/migración remota | No ejecutados | S3–S6 pendientes; compra física preservada |

Snapshot 4.2.0, origen legado no prueba aceptación/precio pagado; se conservan condiciones actuales. No commit/push/reset remoto.


## SaaS S3 — 5 de noviembre de 2026

Completada localmente para empresas existentes; alta nueva bloqueada por decisión del usuario hasta verificar correo. [Cierre](../auditoria_software/SAAS_S3_CIERRE.md), [matriz](../auditoria_software/SAAS_S3_MATRIZ.md), [operación](../auditoria_software/SAAS_S3_OPERACION_LOCAL.md).

| Verificación | Resultado | Evidencia |
|---|---|---|
| Baseline cambio anual y onboarding | 2 fallos reproducidos | SAAS_S3_RED.log |
| Integración ampliada | 84 aprobadas, 3 advertencias | SAAS_S3_INTEGRACION_2.log |
| Suite general, seed e invariantes previos | 429 aprobadas, 0 fallidas/omitidas, 3 advertencias, 376,03 s | SAAS_S3_REGRESION_COMPLETA.log |
| Cierre: contratos/concurrencia/S1/S2/tenants/backups | 173 aprobadas, 0 fallidas/omitidas, 3 advertencias, 85,63 s | SAAS_S3_CIERRE_FOCALIZADO.log |
| Casos actuales entre corridas | 432; tres añadidos después de recoger la general | Desglose en cierre |
| UI/APK/alta verificada/SMTP/publicación | No ejecutados; alta deshabilitada por acuerdo | S4–S6 pendientes, compra física preservada |

No asignación automática anual, cuota futura sin anticipar, precio legado desconocido NULL y modo MANUAL/NO_VERIFICADO. Snapshot 4.3.0 preserva referencias contractuales. No commit/push/reset remoto.


## SaaS S4 — 5 de noviembre de 2026

Completada localmente. [Cierre](../auditoria_software/SAAS_S4_CIERRE.md), [matriz](../auditoria_software/SAAS_S4_MATRIZ.md), [operación](../auditoria_software/SAAS_S4_OPERACION_LOCAL.md).

| Verificación final | Resultado | Evidencia |
|---|---|---|
| Backend completo | 446 aprobadas, 0 fallidas/omitidas, 3 advertencias, 361,30 s | SAAS_S4_BACKEND_FINAL.log |
| Angular | 43 aprobadas / 19 archivos; build correcto | SAAS_S4_WEB_TESTS_FINAL.log, SAAS_S4_WEB_BUILD_2.log |
| Flutter | 75 aprobadas generales + 1 identidad nueva = 76 casos verificados | SAAS_S4_MOBILE_TESTS_2.log, SAAS_S4_MOBILE_IDENTIDAD.log |
| Flutter analyze final | Sin incidencias, 6,7 s | SAAS_S4_MOBILE_ANALYZE_FINAL.log |
| Diff de aplicaciones | --check correcto en los tres repos; avisos LF/CRLF conservados | SAAS_S4_DIFF_*_AVISOS.log |

Advertencias backend: deprecaciones previas Starlette/httpx y on_event; web conserva aviso CommonJS html2canvas/jsPDF. No son pruebas fallidas ni se actualizaron dependencias para silenciarlas.

Licencia efectiva y permisos separados; suspender/vencer no borra pendientes. Autorización contractual no prueba pago. Sin APK/publicación ni S5 automática; compra física intacta.


## SaaS S5 — 6 de noviembre de 2026

Completada localmente. [Cierre](../auditoria_software/SAAS_S5_CIERRE.md), [matriz](../auditoria_software/SAAS_S5_MATRIZ.md), [operación](../auditoria_software/SAAS_S5_OPERACION_LOCAL.md).

| Verificación | Resultado | Evidencia |
|---|---|---|
| Backend completo | 446 aprobadas; 3 advertencias; 928,13 s | SAAS_S5_BACKEND.log |
| Web | 64 aprobadas / 24 archivos | SAAS_S5_WEB_CIERRE_2.log |
| Build | Correcto; sin aumentar presupuestos | SAAS_S5_WEB_BUILD_CIERRE.log |
| Flutter | 81 aprobadas / analyze limpio | SAAS_S5_MOBILE_VALIDACION_FINAL.log, SAAS_S5_MOBILE_ANALYZE_FINAL.log |
| API local y Chrome | 17 escenarios aprobados, repetición final completa | SAAS_S5_E2E.json, SAAS_S5_E2E_ACCIONES.json, SAAS_S5_TRANSICION_E2E.json |

Separación plataforma/empresa incluso después de cambiar cuenta sin reload. Catálogo versionado, aceptación y aprobación manual, suspensión/recuperación, NULL legado y condiciones futuras, revisión de conflicto y teclado a 375px. Un 503 deliberadamente inyectado; resto de los contratos/409 con API real aislada. Sin proveedores, pagos, publicación, APK ni prueba física. Compra del teléfono preservada; S6 no iniciada.


## SaaS S6 — 6/11/2026 — trabajo local terminado

[Informe](../auditoria_software/SAAS_S6_CIERRE.md), matriz y operación local en la misma carpeta. Backend: completa inicial 456 aprobadas/1 expectativa de seed corregida, dirigida final 24/24; 466 casos únicos verificados entre corridas, no una sola completa de 466. Web 64/build; móvil 81/analyze limpio y APK local QA generado sin instalar. Migración poblada/idempotente con rollback, seed optativo dedicado y 26 invariantes, snapshot 4.4, pg_dump/restore 35 tablas idénticas y billetera firmada aprobados. Import mantenimiento sin settings y verificador read-only con 9 contadores cero. Fuentes/bundle/APK identificados por SHA en SAAS_S6_ARTEFACTOS.json; HEAD es base previa con cambios locales. Proceso PostgreSQL propio detenido tras comprobar cero conexiones de cliente ajenas (SAAS_S6_ENTORNO.log).

Sin commit/push/deploy/reset remoto ni instalación. Compra física sigue pendiente; conservar cola del teléfono, conciliarla antes de publicar y obtener autorización SaaS. Alta nueva sigue bloqueada por verificación de correo. S6 local no equivale a aceptación final en servicios publicados.


## Commit/push S0–S6 — 6/11/2026

**Estado vigente de publicación — 6/11/2026:** commit y push S0–S6 realizados en main: backend 0b5f32b, web 7fd979d, móvil d14b237. Tres árboles de aplicaciones limpios; fuentes coinciden con evidencia S6. Backups privados anteriores al fresh guardados fuera de Git; evidencia central 290 Bs, SQLite físico no recuperado. Usuario autorizó expresamente publicar/reiniciar demo aun con esa incidencia; bloqueos inferiores son históricos. Despliegue/operador/aceptación remota aún deben comprobarse, APK Railway no generado por este push. Nuevas fases P1–P4 PayPal propuestas, sin implementar. Ver docs/auditoria_software/SAAS_PUSH_S0_S6.md.
