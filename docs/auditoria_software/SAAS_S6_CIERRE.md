# S6 — Cierre del trabajo local

6/11/2026. Implementación y verificación LOCAL terminadas dentro de esta matriz. Publicación y aceptación remota pendientes; no declarar la ampliación SaaS aceptada en Railway/teléfono. Sin commit, push, despliegue, reset remoto ni instalación de APK. Compra física pendiente de ronda 1 intacta.

## Qué se encontró y corrigió

1. Las tres SQL SaaS existían, pero faltaba un comando único para aplicarlas de forma explícita y atómica sobre esquema poblado. migrate_saas.py ahora comprueba prerrequisitos/destino, usa exclusión y una transacción y no ejecuta seed. Se probó actualización real pre-SaaS, repetición exacta, conservación de hash/fechas/analítica y rollback de DDL inducido. El precio histórico desconocido sigue NULL, sin aceptación ni pago inventados.
2. Readiness solo miraba columnas; ahora también detecta ausencia/deshabilitación de cinco triggers SaaS. verify_saas_scope.py añade inspección agregada read-only. Una consulta inicial del verificador omitía un rol reservado con tenant_id NULL por lógica ternaria SQL; se reprodujo y corrigió con IS DISTINCT FROM. La importación del mantenimiento no carga app.config/.env: el módulo puro está en app/saas_integrity.py, fuera del inicializador de app.core que importa seguridad/settings.
3. El seed habitual no proveía una identidad de plataforma separada. Se añadió un operador demo OPTATIVO por UUID y contraseña explícitos, empresa técnica/rol reservado sin permisos comerciales, sin tocar admins comerciales ni conceder acceso por nombre/correo. PLATFORM_ADMIN_USER_IDS se configura aparte; la repetición no reinicia contraseña ni altera permisos personalizados. Colisiones se rechazan; incluso tras un fresh fallido se conserva el esquema anterior mediante rollback. Conciliación demo ampliada de 18 a 26 invariantes.
4. Snapshot comercial 4.3 no referenciaba revisiones globales ni necesariamente un plan futuro distinto. Formato 4.4.0 incluye solo las revisiones/planes referenciados por sus contratos/solicitudes. No se importan ni revierten catálogo, operador o auditoría SaaS. Manipulación, UUID ajeno y firma inválida se rechazan, manteniendo las garantías anteriores. El formato 4.3 se rechaza claramente antes de mutar; generar uno nuevo, no editar su versión.
5. El ensayo de recuperación de fase 8 suponía un admin comercial global, incompatible con S1. Ahora ese arnés histórico se detiene sin conectar una base y dirige al nuevo ensayo S6, con identidades separadas. Se restauró JSON de empresa y pg_dump/pg_restore global, con términos manuales y auditoría no vacíos. Las 35 tablas coincidieron por huellas, otra empresa quedó intacta y la firma de billetera fue válida; 26 invariantes sin discrepancias. Una migración repetida sobre esa base restaurada conservó las 35 tablas sin cambios.
6. El build Android con --no-pub conservaba el registro de integration_test de una corrida anterior. Se reprodujeron dos fallos; regenerar metadatos y ejecutar el build release normal resolvió la compilación sin editar archivos generados ni cambiar versiones de dependencias. APK anterior conservado en build/qa_previous. APK nuevo de QA apunta al emulador local, con firma debug existente: no instalarlo en el teléfono pendiente ni usarlo como distribución final.

## Validación y evidencia

| Verificación | Resultado |
|---|---|
| Backend completo inicial | 456 aprobadas, 1 falla: expectativa antigua de 18 verificaciones del seed, frente a las 26 vigentes |
| Regresión final de módulos modificados | 24/24 aprobadas, incluidas la corrección anterior y 9 casos nuevos posteriores a la colección completa |
| Backend: casos únicos verificados entre corridas | 466; no hubo una sola corrida completa de 466. No presentar el log inicial como todo verde |
| Web | 64 pruebas aprobadas y build completado |
| Móvil | 81 aprobadas, analyze sin incidencias, APK release local compilado, sin instalar |
| Seed demo / recuperación global | 26 invariantes cero; 35 tablas idénticas tras pg_restore |
| Verificador explícito | 9 contadores cero con operador dedicado; import sin cargar configuración privada |
| Reaplicar migración sobre restaurada poblada | 35 tablas sin cambios; SQL con SHA, sin seed |
| Artefactos | SAAS_S6_ARTEFACTOS.json: HEAD base, cambios locales y huellas de fuentes, bundle y APK |

Detalle: SAAS_S6_MATRIZ.md, SAAS_S6_VALIDACION.json y SAAS_S6_OPERACION_LOCAL.md. Logs con prefijo SAAS_S6_ conservan también las corridas rojas y fallidas: no se borraron para aparentar éxito. pytest se ejecutó exclusivamente bajo tests, con PostgreSQL local validado; sin proveedores/cargos reales.

Los 17 recorridos Chrome/API de S5 se reutilizan como evidencia local previa de la interfaz sin cambios S6, no como nuevas ejecuciones. Los tests y compilaciones no certifican entrega push, migración SQLite del teléfono, precisión de IA ni proveedores reales. Readiness y las cantidades de pruebas no prueban ausencia absoluta de errores.

Advertencias: deprecaciones FastAPI on_event/Starlette-httpx; web mantiene avisos CSS de analítica y CommonJS de PDF. Flutter avisa sobre KGP de flutter_tts y acceso nativo Java. No se actualizaron frameworks/dependencias ni se elevaron presupuestos para silenciarlos.

## Lo pendiente para publicar y aceptar

Conciliar primero la compra offline física de ronda 1 (central 290 Bs/nonce 4 según última evidencia, no una consulta remota nueva). No repetir, borrar datos ni reemplazar APK mientras se conserva su cola. Luego autorización específica para commit/push/deploy SaaS, revisión privada de variables/UUID/clave de billetera estable, respaldo y estrategia compatible. Fresh por despliegue Railway sigue siendo destructivo: un rollback de código antiguo no recupera sus datos ni certifica compatibilidad SaaS.

Después de publicación autorizada deben probarse en remoto ambos ámbitos, permisos API, contratos/colas y pantallas reales con datos sintéticos. El alta de nuevas empresas continúa bloqueada hasta verificación de correo. No queda otra etapa de código SaaS planificada después de S6; queda esta puerta de publicación/aceptación, sin ejecutar automáticamente.


**Entorno al cerrar:** PostgreSQL propio 55439 detenido después de comprobar cero conexiones de cliente ajenas; SAAS_S6_ENTORNO.log confirma server stopped. No se iniciaron servidores web/API S6 ni se instalaron APK; fuentes y cambios previos preservados.
