# Continuar FashionStore con otra cuenta

**Estado vigente de publicación — 6/11/2026:** commit y push S0–S6 realizados en main: backend 0b5f32b, web 7fd979d, móvil d14b237. Tres árboles de aplicaciones limpios; fuentes coinciden con evidencia S6. Backups privados anteriores al fresh guardados fuera de Git; evidencia central 290 Bs, SQLite físico no recuperado. Usuario autorizó expresamente publicar/reiniciar demo aun con esa incidencia; bloqueos inferiores son históricos. Despliegue/operador/aceptación remota aún deben comprobarse, APK Railway no generado por este push. Nuevas fases P1–P4 PayPal propuestas, sin implementar. Ver docs/auditoria_software/SAAS_PUSH_S0_S6.md.

**Autorización posterior vigente — 6/11/2026:** usuario pide completar publicación y pruebas, autoriza commit/push/despliegue y fresh demo Railway aun sin conciliar compra física anterior. Conservar evidencia disponible; no certificar esa compra ni borrar datos del teléfono. Ver docs/planes_cu/SAAS_PUBLICACION_PLAN.md. Los bloqueos de publicación inferiores son históricos y quedan reemplazados por esta autorización; configurar/permisos/respaldos y aceptación real siguen siendo trabajo pendiente.

**Ampliación SaaS (6/11/2026): S0–S5 y trabajo LOCAL S6 completados dentro de sus matrices.** Cierre vigente: docs/auditoria_software/SAAS_S6_CIERRE.md, SAAS_S6_MATRIZ.md y SAAS_S6_OPERACION_LOCAL.md. Backend 466 únicas verificadas entre corridas (completa 456/1 expectativa de seed corregida, dirigida final 24/24); web 64/build; móvil 81/analyze/APK QA local sin instalar. Migración poblada/rollback, seed optativo de operador dedicado, snapshot 4.4 y pg_dump/restore de 35 tablas aprobados; 26 invariantes demo. Fuentes/bundle/APK en SAAS_S6_ARTEFACTOS.json, con HEAD base y cambios locales. Publicación/aceptación remota PENDIENTES: compra física sin conciliar, sin autorización SaaS de commit/push/deploy; no repetir/borrar/instalar/resetear. Alta nueva bloqueada por verificación de correo. Sin otra etapa de código SaaS automática; siguiente paso es conciliar teléfono y preparar publicación autorizada, conservando UUID/huellas/contratos/colas.

**Ronda de aceptación 1 EN CURSO — incidencia de billetera.** Teléfono: reserva/cancelación y compra online verificadas; servidor en 290 Bs/nonce 4. Segunda compra offline no confirmada centralmente: no repetir, borrar datos ni desplegar/resetear. El asistente reprodujo y corrigió contador/envío manual que omitían billetera; 73 pruebas móviles aprobadas. Leer docs/auditoria_software/RONDA_1_INCIDENCIA_BILLETERA.md y RONDA_ACEPTACION_1.md. Falta conciliar cola del teléfono y verificar APK instalado. Sin commits/push/despliegues autorizados en esta ronda; fases 0–8 permanecen cerradas.

Actualizado: 4 de noviembre de 2026. Carpeta de trabajo: `D:\SI2_Proyecto\Si2_Proyecto`.

Abre esta misma carpeta en la otra cuenta. Este archivo y `AGENTS.md` permiten continuar sin depender del historial del chat. Compartir una conversación no transfiere por sí solo archivos, secretos ni cambios de Git.

**Actualización vigente:** fases 0–8 completadas dentro de sus matrices. Leer [FASE_8_CIERRE.md](docs/auditoria_software/FASE_8_CIERRE.md) y [FASE_8_MATRIZ.md](docs/auditoria_software/FASE_8_MATRIZ.md). Backend 68987c8, web 644d62a, móvil b07bb6f publicados con autorización; tres repos limpios. Backend 297, web 40/build, móvil 66/analyze y APK nuevo. Gemini textual y voz monetaria aceptados; pago sandbox aprobado/capturado en primera confirmación con un recibo, reintento sin duplicado y stock -1. QA propio detenido. Las secciones inferiores sobre fases pendientes son históricas. No iniciar una fase adicional automáticamente; no prometer ausencia absoluta de errores ni disponibilidad permanente de terceros.

## Mensaje para pegar en el nuevo chat

> Lee AGENTS.md, CONTINUAR_AQUI.md y docs/planes_cu/CONTEXTO_CONTINUIDAD_SOFTWARE.md. Fases originales 0–8 y SaaS S0–S5 y trabajo local S6 cerrados dentro de sus matrices. Lee SAAS_S6_CIERRE/MATRIZ/OPERACION_LOCAL y el plan SaaS antes de continuar. El trabajo local S6 terminó; siguen pendientes conciliación del teléfono y publicación/aceptación remota autorizadas. Conserva contratos inmutables, aislamiento de plataforma, colas/UUID/huellas y reglas monetarias. La compra física del teléfono sigue pendiente: no repetirla, borrar datos, instalar APK ni publicar/resetear Railway. Sin commits/push/despliegues autorizados de SaaS. Usa las skills pertinentes y registra diagnóstico, regresiones y cierre; no documentos académicos ni pruebas contra producción.

## Estado que debe conservarse

- **Fase 0 cerrada:** entorno de pruebas aislado, seed repetible y conciliación demo de 18 comprobaciones sin discrepancias.
- **Fase 1 cerrada:** pertenencia a empresa, sesiones, permisos y aislamiento entre empresas en servidor y clientes.
- **Fase 2 cerrada:** stock, reservas, ventas y cambios con rollback, restricciones de base y pruebas concurrentes.
- **Fase 3 cerrada:** precios/cupones de servidor, PayPal verificado y compensable, billetera firmada, concurrencia e idempotencia monetaria.
- **Fase 4 cerrada:** idempotencia y tipos correctos, auditoría/colas atómicas, rechazo durable de billetera, reintentos y recuperación explícita. Backend 209 runtime, web 23 y móvil 28 aprobados; build/analyze y migraciones/conciliación aprobados.
- **Fase 5 cerrada, incluida su ampliación:** backend 223, web 32/build y móvil 54/analyze; Chrome 20 recorridos con acciones y Android 1 recorrido con 12 comprobaciones. La navegación anterior fue de 24 pantallas +3 flujos. SQLite v6 conserva saldos/colas y añade outbox de favoritos. Leer también FASE_5_ACCIONES.md.
- **Fase 6 cerrada:** backend 260, web 35/build, móvil 58/analyze y Chrome 4 recorridos. SQL por empresa, errores honestos, conversaciones aisladas, ofertas atómicas y cotización vigente. IA sintética y probador referencial etiquetados. Sigue fase 7; despliegue queda para fase 8.
- El cliente pertenece a una empresa y puede comprar en sus distintas sucursales. No hay cuenta comercial global.
- Los cambios de estabilización siguen locales; no se han hecho commits ni push. Clonar solo los repositorios remotos no recupera este trabajo.
- PostgreSQL de pruebas está detenido. No hay que iniciar el backend para ejecutar pytest.

## Lectura mínima

1. [Instrucciones persistentes](AGENTS.md).
2. [Contexto técnico, pruebas y próximos pasos](docs/planes_cu/CONTEXTO_CONTINUIDAD_SOFTWARE.md).
3. [Plan maestro](docs/planes_cu/PLAN_MAESTRO_ESTABILIZACION.md).
4. [Cierre fase 5](docs/auditoria_software/FASE_5_CIERRE.md), [matriz funcional](docs/auditoria_software/FASE_5_MATRIZ.md), [plan fase 5](docs/planes_cu/FASE_5_PLAN.md).
5. [Cierre fase 4](docs/auditoria_software/FASE_4_CIERRE.md), [plan de fase 4](docs/planes_cu/FASE_4_PLAN.md).
6. [Cierre fase 3](docs/auditoria_software/FASE_3_CIERRE.md), [cierre fase 2](docs/auditoria_software/FASE_2_CIERRE.md), [cierre fase 1](docs/auditoria_software/FASE_1_CIERRE.md), [cierre fase 0](docs/auditoria_software/FASE_0_CIERRE.md).

Las skills están en `.agents/skills/`. En la misma computadora los archivos continúan disponibles; en otra máquina hay que trasladar también los archivos modificados/no rastreados de los tres repositorios, los documentos de continuidad y las skills. Configurar los secretos de forma privada en el nuevo entorno; no incluirlos en el chat ni en Git.
## Ampliación de fase 5 cerrada

Se completaron las acciones de interfaz y Android solicitadas. Consultar FASE_5_PLAN.md, FASE_5_ACCIONES.md y evidencias FASE_5_AMPLIACION_*. Mantener las reglas adicionales de concurrencia y notificaciones de AGENTS.md. Después se completó fase 6: leer [cierre vigente](docs/auditoria_software/FASE_6_CIERRE.md), [matriz](docs/auditoria_software/FASE_6_MATRIZ.md) y [plan](docs/planes_cu/FASE_6_PLAN.md). No confundir entrenamiento sintético con predicción comercial validada.

## Incidencia posterior: login de Railway

El usuario publicó backend fase 6 (bbcdbb8). Railway no tenía roles.tenant_id y el login devuelve 500 ocultado como CORS. Hotfix local probado con 45 tests: backend/railway.json ejecuta scripts/migrate_role_tenants.py como preDeployCommand. Leer docs/auditoria_software/HOTFIX_LOGIN_RAILWAY.md. No se publicó ni se aplicó a Railway desde esta sesión; el siguiente despliegue debe mostrar roles migration OK y verificarse con login real. No borrar tablas ni activar seed. Las migraciones 2–4 siguen requiriendo revisión de despliegue.

## Regla vigente posterior: fresh + seed de la demo

El usuario confirmó después que TODOS los datos de Railway son de pruebas descartables y que lo importante está en los seeders. Autorizó reinicio completo por despliegue. Sustituye el hotfix conservador como política de ESA base: railway.json ahora debe ejecutar `python scripts/reset_demo_database.py --confirm-disposable-demo` en Pre-deploy. Mantener RUN_STARTUP_MIGRATIONS/RUN_DEMO_SEED desactivados; no reiniciar por cada caída de Uvicorn. Leer docs/auditoria_software/RESET_DEMO_RAILWAY.md.

El comando usa DATABASE_URL explícita, recrea public con modelos actuales, siembra dos veces, compara huellas y exige 18 controles sin diferencias antes de confirmar la transacción. Fallo revierte incluso DROP/CREATE. seed_all(db=None) conserva comportamiento normal y permite sesión externa para esta atomicidad. Pruebas dirigidas: 12 aprobadas, incluidas cuentas de ambos admins, repetición y rollback. Publicación y aceptación remota pendientes. Si Railway tiene comando manual anterior, sustituirlo por el nuevo; no dar la demo como reparada hasta que su despliegue muestre demo reset OK y funcione el login.

## Estado vigente: fase 7 completada; siguiente fase 8

Aprobados: backend 271, web 40/build, móvil 66/analyze, Chrome 11 accesibilidad/layout +20 recorridos comerciales y Android 12 comprobaciones. Leer FASE_7_CIERRE.md y FASE_7_MATRIZ.md. La revisión visual reprodujo pérdida de branding al recargar: /users/me duplicaba un constructor sin datos de empresa; se unificó con el servicio de login. TenantThemeService ignora suscripción de otra empresa.

La regresión completa backend inicial expuso que test_demo_reset dejaba datos confirmados para tests posteriores; se añadió aislamiento del esquema antes/después de cada caso. FASE_7_BACKEND_REGRESION.log terminó con 271 aprobadas en 277,53 s, sin fallos/omitidos. API 58001, Angular 54205, emulador y Gradle propios detenidos; PostgreSQL 55499 también está detenido. No se han hecho commits, push ni despliegues; cambios móviles previos de fase 6 preservados.

Entrega final: fase 7 completada dentro de su matriz. Sigue fase 8; no se inició. El historial anterior de fase 6/7 pendiente queda como referencia histórica, prevalece este cierre.

Nota 5/11: notificaciones de reserva dañadas corregidas LOCALMENTE en backend; 5 pruebas unitarias aprobadas. Leer docs/auditoria_software/RONDA_1_NOTIFICACIONES_CODIFICACION.md. No publicar todavía: fresh Railway borraría datos de la compra física pendiente. APK de billetera no incluye esta corrección de servidor.

Nota 5/11 — revisión por petición del usuario: matriz de roles/canales en docs/auditoria_software/REVISION_ROLES_WEB_MOBILE_2026-11-05.md. Roles y permisos publicados leídos para ambas empresas; 36 GET válidas de cuatro roles verificadas en UrbanStyle. No se modificaron permisos ni software. Hallazgos y diferencias UI/API registrados; no autoriza reparaciones masivas ni despliegues. La conciliación de la compra física sigue pendiente.


**Contrato técnico S6:** `scripts/migrate_saas.py --apply` es mantenimiento explícito, transaccional, sin seed/settings; `scripts/verify_saas_scope.py` es read-only y requiere concesión UUID válida para certificar operador. `app/saas_integrity.py` es puro (no moverlo a app.core sin evitar import de settings). Seed operador optativo por DEMO_OPERATOR_USER_ID/PASSWORD, distinto de la concesión PLATFORM_ADMIN_USER_IDS; nunca reusar cuenta comercial. Snapshot 4.4 conserva planes/revisiones/contratos como referencias centrales; 4.3 falla antes de mutar. Mantener firma privada de billetera estable; rollback no resigna saldo. El arnés histórico fase 8 se detiene por su supuesto anterior de admin global; usar el arnés SaaS solo sobre sus dos bases locales vacías. APK S6 apunta al emulador QA y no está instalado: no sustituir el del teléfono pendiente.
