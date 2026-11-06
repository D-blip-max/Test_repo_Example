# Contexto técnico de continuidad — FashionStore

**Estado vigente de publicación — 6/11/2026:** commit y push S0–S6 realizados en main: backend 0b5f32b, web 7fd979d, móvil d14b237. Tres árboles de aplicaciones limpios; fuentes coinciden con evidencia S6. Backups privados anteriores al fresh guardados fuera de Git; evidencia central 290 Bs, SQLite físico no recuperado. Usuario autorizó expresamente publicar/reiniciar demo aun con esa incidencia; bloqueos inferiores son históricos. Despliegue/operador/aceptación remota aún deben comprobarse, APK Railway no generado por este push. Nuevas fases P1–P4 PayPal propuestas, sin implementar. Ver docs/auditoria_software/SAAS_PUSH_S0_S6.md.

**Autorización posterior vigente — 6/11/2026:** usuario pide completar publicación y pruebas, autoriza commit/push/despliegue y fresh demo Railway aun sin conciliar compra física anterior. Conservar evidencia disponible; no certificar esa compra ni borrar datos del teléfono. Ver docs/planes_cu/SAAS_PUBLICACION_PLAN.md. Los bloqueos de publicación inferiores son históricos y quedan reemplazados por esta autorización; configurar/permisos/respaldos y aceptación real siguen siendo trabajo pendiente.

**Ampliación SaaS (6/11/2026): S0–S5 y trabajo LOCAL S6 completados dentro de sus matrices.** Cierre vigente: docs/auditoria_software/SAAS_S6_CIERRE.md, SAAS_S6_MATRIZ.md y SAAS_S6_OPERACION_LOCAL.md. Backend 466 únicas verificadas entre corridas (completa 456/1 expectativa de seed corregida, dirigida final 24/24); web 64/build; móvil 81/analyze/APK QA local sin instalar. Migración poblada/rollback, seed optativo de operador dedicado, snapshot 4.4 y pg_dump/restore de 35 tablas aprobados; 26 invariantes demo. Fuentes/bundle/APK en SAAS_S6_ARTEFACTOS.json, con HEAD base y cambios locales. Publicación/aceptación remota PENDIENTES: compra física sin conciliar, sin autorización SaaS de commit/push/deploy; no repetir/borrar/instalar/resetear. Alta nueva bloqueada por verificación de correo. Sin otra etapa de código SaaS automática; siguiente paso es conciliar teléfono y preparar publicación autorizada, conservando UUID/huellas/contratos/colas.

**Ronda de aceptación 1 EN CURSO — incidencia de billetera.** Teléfono: reserva/cancelación y compra online verificadas; servidor en 290 Bs/nonce 4. Segunda compra offline no confirmada centralmente: no repetir, borrar datos ni desplegar/resetear. El asistente reprodujo y corrigió contador/envío manual que omitían billetera; 73 pruebas móviles aprobadas. Leer docs/auditoria_software/RONDA_1_INCIDENCIA_BILLETERA.md y RONDA_ACEPTACION_1.md. Falta conciliar cola del teléfono y verificar APK instalado. Sin commits/push/despliegues autorizados en esta ronda; fases 0–8 permanecen cerradas.

Fecha de entrega: 4 de noviembre de 2026. Alcance: estabilización del software, no redacción académica. Leer primero los acuerdos de `../../AGENTS.md`.

## Estado vigente de fase 8

COMPLETADA dentro de FASE_8_MATRIZ.md; leer ../auditoria_software/FASE_8_CIERRE.md y su runbook. Backend 68987c8b2b39c11ad5f27a89282671f78beaabc7 en Railway con readiness real; web 644d62a y móvil b07bb6f enviados con autorización. Tres repos de aplicaciones limpios; los informes del repo raíz quedan locales y su índice histórico se preservó. 297 backend, 40 web/build, 66 móvil/analyze; APK nuevo 3c6a04e82790f2776b76e911f6f4167c1cc7aec6cb1f04fc8504478e35ca70e6 compilado/instalado. Recuperación: 31 tablas idénticas/18 invariantes. Gemini-3.6-flash responde voz no canónica y chat de ambas empresas; hubo un 503 transitorio conservado, reintento posterior correcto. Resumen usa AST SQL para distinguir dinero/cantidad/COUNT en vez de adivinar por alias. PayPal solicitaba representación insuficiente: ahora Prefer:return=representation y GET de la misma orden tras captura COMPLETED, sin omitir validaciones ni repetir cargo. Comprador sandbox autorizado, credenciales solo en memoria. Recibo final VTA-20261104-62EF05, primera confirmación 200; una captura/venta, reintento mismos IDs y stock -1. Recorrido navegador comprador + API real; no afirmar pulsación de captura en APK. Datos demo posteriores al seed se perderán en siguiente fresh autorizado. QA propio detenido. No iniciar otra fase sin petición. Mantener límites de firma debug/teléfono físico/push/voz física/calidad visual/recuperación remota descritos en cierre.

## 1. Proyecto y orden de autoridad

Backend Python/FastAPI/SQLAlchemy/PostgreSQL; web Angular **21** y TypeScript; móvil Flutter/Dart y SQLite. Web utiliza IndexedDB para datos offline. Railway aloja backend y PostgreSQL; Vercel sirve frontend; Flutter se ejecuta en Android. No se ha desplegado esta estabilización.

Prevalecen las instrucciones actuales del usuario y las reglas comerciales acordadas. Después, el código y las pruebas ejecutadas, los informes de cierre y el plan maestro. Los documentos académicos, planes antiguos y afirmaciones de «100 % operativo» no son evidencia de funcionamiento.

La raíz y cada aplicación tienen repositorio independiente. Los cambios de estabilización siguen locales, sin commits/push. Revisar git status en raíz, backend, web y mobile al retomar; no descartar cambios por no reconocer su autoría.

## 2. Fuentes que leer sin cargar todo el historial

| Archivo | Uso |
|---|---|
| [PLAN_MAESTRO_ESTABILIZACION.md](PLAN_MAESTRO_ESTABILIZACION.md) | Fases, dependencias y criterios de aceptación. |
| [FASE_0_CIERRE.md](../auditoria_software/FASE_0_CIERRE.md) | Seeders, entorno y conciliación aprobados. |
| [FASE_1_CIERRE.md](../auditoria_software/FASE_1_CIERRE.md) | Implementación final, pruebas y límites de la fase 1. |
| [FASE_2_CIERRE.md](../auditoria_software/FASE_2_CIERRE.md) | Cierre comercial y concurrencia; ampliado por fase 3. |
| [FASE_3_CIERRE.md](../auditoria_software/FASE_3_CIERRE.md) | Cierre financiero: precios, pagos, billetera y compensación. |
| [FASE_4_CIERRE.md](../auditoria_software/FASE_4_CIERRE.md) | Cierre offline: sincronización y recuperación. |
| [FASE_5_CIERRE.md](../auditoria_software/FASE_5_CIERRE.md) | Contratos/recorridos web y Android; leer también FASE_5_MATRIZ.md. |
| [REGISTRO_VALIDACION.md](REGISTRO_VALIDACION.md) | Registro de ejecuciones. |
| [HALLAZGOS_Y_LOGICA.md](../auditoria_software/HALLAZGOS_Y_LOGICA.md) | Hallazgos iniciales y actualizaciones; contrastar con cierres. |
| [INVENTARIO_FUNCIONAL.md](../auditoria_software/INVENTARIO_FUNCIONAL.md) | Inventario estático de 140 operaciones HTTP; no equivale a cobertura probada. |
| [INVENTARIO_CANALES.md](../auditoria_software/INVENTARIO_CANALES.md) | Componentes web/pantallas móviles; recorridos todavía pendientes. |

Los archivos FASE_0_AVANCE, FASE_1_AVANCE, planes PLAN_01–21 y logs intermedios son históricos. Un fallo en un log intermedio no invalida una regresión final posterior. Los archivos `test_phase2.py`, `test_phase3.py`, etc. ya existían: sus nombres no significan que las fases actuales estén cerradas.

## 3. Qué se corrigió y qué proteger

**Fase 0:** arranque sin DDL/seed automático; seed dentro de transacción, sin sobrescribir ediciones comerciales y con repetición verificable. `backend/app/seed_audit.py` concilia 18 invariantes demo. Fixtures aíslan esquema, datos y artefactos ML. `backend/scripts/verify_phase0_seed.py` verifica dos ejecuciones y hashes en una base vacía desechable; no usarlo en datos de trabajo.

**Fase 1:** `backend/app/core/tenant_scope.py` liga el ORM a empresa/actor, filtra entidades directas e hijas y valida relaciones antes de escribir. `app/api/deps.py` obtiene identidad/empresa de JWT y usuario real; no hay fallback a primera empresa. Reportes SQL usan `tenant_sql.py` con análisis AST/SQLGlot, no sustitución por regex. Recibos, devoluciones, sincronización, backups y referencias de PayPal respetan pertenencia y permisos.

Registro público exige empresa activa y crea cliente; alta explícita de empresa crea su administrador. El email mantiene unicidad global. Roles base son plantillas compartidas de solo lectura; roles personalizados son de empresa. Acceso de plataforma exige UUID en configuración del servidor, no correo/dominio, y no permite compras entre empresas.

JWT usa clave privada obligatoria y pertenencia a empresa, con expiración/revocación. La clave local se renovó en archivo ignorado; sesiones antiguas deben volver a ingresar. No copiar su valor. Tokens temporales de test se generan dentro del proceso.

IndexedDB y SQLite separan datos por empresa+usuario. Peticiones y respuestas tardías conservan su identidad; logout no entrega colas a otra cuenta. Almacenes heredados sin propietario se conservan excluidos de sincronización automática, con recuperación explícita implementada y probada en fase 4; conservar cuarentena cuando no pueda verificarse propietario.

Archivos de referencia: backend `app/core/tenant_scope.py`, `app/core/tenant_sql.py`, `app/api/deps.py`, servicios de venta/sync/backup; web `src/app/core/services/` y sus pruebas de auth/almacenamiento; móvil `lib/` y `test/tenant_storage_test.dart`, `test/session_requests_test.dart`.

## 4. Evidencia real al entregar

| Verificación | Resultado registrado |
|---|---|
| Cierre fase 0 | 42 tests aprobados; conciliación 18/18; repetición del seed sin cambios indebidos. |
| Fase 1, suite completa anterior | 89 aprobados, incluidos 3 tests de seed; 454,05 s. |
| Fase 1, última suite de runtime | 90 aprobados, sin fallos/omitidos; 213,96 s; excluye los 3 tests de seed sin cambios. |
| Total backend fase 1 | 93 escenarios distintos acreditados entre esas ejecuciones; **no hubo una ejecución única de 93 tests**. |
| Web | Compilación aprobada y 4 tests aprobados. |
| Móvil | flutter analyze limpio y 8 tests aprobados. |
| Migración roles | Ejecutada dos veces con éxito en base antigua desechable. |

Logs en `../auditoria_software/`: `FASE_1_ACEPTACION_DEFINITIVA.log`, `FASE_1_CIERRE_PYTEST.log`, `FASE_1_CIERRE_WEB_BUILD.log`, `FASE_1_CIERRE_WEB_TESTS.log`, `FASE_1_CIERRE_FLUTTER_ANALYZE.log`, `FASE_1_CIERRE_MOBILE_TESTS.log` y `FASE_1_MIGRACION.log`.

Siguen advertencias de deprecación y CommonJS de librerías. No se ejecutaron recorridos completos en navegador/emulador, cobros reales ni recuperación integral de backups. No confundir tests con una certificación fiscal o de producción.

## 5. Reproducir pruebas sin tocar datos comerciales

Comandos PowerShell, partiendo de la raíz. Python existente: `backend/.venv/Scripts/python.exe`. PostgreSQL 16 está en PATH. Flutter está en `C:/dev/flutter/bin/flutter.bat`. La base aislada está detenida al entregar; comprobar disponibilidad antes de arrancar.

```powershell
pg_ctl -D "$env:TEMP/fashionstore-phase0-pg" status
# Si está detenido y existe el cluster local preparado:
pg_ctl -D "$env:TEMP/fashionstore-phase0-pg" -l "$env:TEMP/fashionstore-phase0-pg/server.log" -o "-p 55439 -h 127.0.0.1" -w start

Set-Location D:/SI2_Proyecto/Si2_Proyecto/backend
$env:TEST_DATABASE_URL = 'postgresql://audit@127.0.0.1:55439/fashionstore_test_integration'
.venv/Scripts/python.exe -m pytest tests -q --tb=short -p no:cacheprovider

# Alternativa para cambios sin impacto en seed: runtime, registrando la exclusión.
.venv/Scripts/python.exe -m pytest tests --ignore=tests/test_seed_phase0.py -q --tb=short -p no:cacheprovider
```

Ejecutar **una** variante según el alcance; no ambas por rutina. Primero ejecutar los tests específicos del fallo, después la regresión correspondiente. No usar dos sesiones pytest simultáneas sobre esa base.

`tests/conftest.py` valida host local, PostgreSQL, prefijo `fashionstore_test_` y ausencia de query params. Crea y elimina todas las tablas del esquema; no usar `DATABASE_URL` de trabajo. Sin `TEST_DATABASE_URL` se omiten pruebas integradas: eso no cierra una fase. Usa transacciones/savepoints por test y desvía artefactos ML a temporales.

```powershell
Set-Location D:/SI2_Proyecto/Si2_Proyecto/web
npm exec ng build
npm exec ng test -- --watch=false --runner-config=vitest.config.ts

Set-Location D:/SI2_Proyecto/Si2_Proyecto/mobile
flutter analyze
flutter test

# Al terminar, si esta sesión arrancó el cluster y nadie más lo utiliza:
pg_ctl -D "$env:TEMP/fashionstore-phase0-pg" -m fast -w stop
```

En otra máquina el cluster temporal puede no existir. Preparar uno nuevo local desechable y una base con el prefijo validado antes de ejecutar; no redirigir a producción para evitar instalar PostgreSQL. Las dependencias de tests nuevas están declaradas: SQLGlot backend, fake-indexeddb web y sqflite_common_ffi móvil. Mantener sus archivos de lock.

## 6. Configuración y migraciones pendientes fuera de tests

Para una base anterior, revisar `backend/migrations/phase1_role_tenants.sql`, respaldar y ensayar en copia antes de aplicarla. No se aplicó a producción. Roles ambiguos y cuentas antiguas sin empresa requieren asignación explícita, nunca a la primera empresa disponible.

`SECRET_KEY` privado estable se configura por entorno o `backend/.env.local`, mínimo 32 caracteres y sin valores públicos conocidos. `PLATFORM_ADMIN_USER_IDS` está vacío por defecto. No copiar secretos de esta máquina a documentación. El `.env` histórico rastreado por raíz no debe recibir la nueva clave privada. No arrancar migraciones o seed automáticos como supuesto paso de instalación.

## 7. Histórico: cierre financiero de fase 3

Leer [FASE_3_CIERRE.md](../auditoria_software/FASE_3_CIERRE.md) y [FASE_3_PLAN.md](FASE_3_PLAN.md). Se agregó cotización de servidor (`core/money.py`), PaymentIntent persistido y flujo de PayPal que verifica identidad/importe/moneda y aplica o compensa una vez. Wallet usa clave privada y firma ligada a empresa/usuario/saldo/retenido/nonce; recargas y débitos tienen bloqueo, ledger y claves de operación. BILLETERA se distingue de PAYPAL en ventas/reportes.

El usuario confirmó expresamente: diferencia a favor en cambios → crédito a billetera y cliente identificado obligatorio. Catálogo/oferta/reserva/cupón fijan precio; no volver a aceptar importes del cliente para resolver colas con conflictos.

Aceptación definitiva: **191 runtime aprobados**, 0 fallos/omitidos, 151,57 s; incluye 58 escenarios financieros y 6 concurrentes monetarios, además de los comerciales anteriores. Los 3 tests de seed aprobaron en la ejecución completa de la fase. Total: 194 backend distintos acreditados entre ejecuciones, no una única corrida de 194. Web: build y 9 tests; Flutter: analyze limpio y 13 tests. SQLite pasa a versión 4 preservando pendientes y añade cupón/retenido. Demo migrada: 18 controles sin diferencias.

Las claves privadas locales siguen en el archivo ignorado; no copiar sus valores. Para una base anterior ensayar `backend/migrations/phase3_payment_integrity.sql`. La conciliación de firmas es explícita: `backend/scripts/reconcile_wallet_signatures.py` toma WALLET_RECONCILIATION_DATABASE_URL, dry-run por defecto. Rechaza saldos sin respaldo y recargas PayPal históricas sin prueba de captura. No habilitar historia con una firma nueva solamente porque sume. No se aplicó nada a producción. PostgreSQL de pruebas se detuvo al finalizar.

La investigación offline posterior está resuelta en el cierre de fase 4; el próximo trabajo se describe en la sección 9.

Las verificaciones antiguas de secciones 3/4 son históricas y quedan ampliadas por este cierre. No reabrir fases completas sin evidencia nueva. Los recorridos UI generales y el despliegue conservan sus fases; PayPal se probó con dobles del proveedor, sin cargos reales.

## 8. Pendientes que no deben perderse

| Fase | Investigación pendiente |
|---|---|
| 3 | Cerrada: ver FASE_3_CIERRE.md. Mantener regresiones de importes/capturas/compensación y clave privada. |
| 4 | Cerrada: ver FASE_4_CIERRE.md. Mantener huella/UUID, separación venta/reserva, auditoría atómica, fuente heredada intacta y snapshot monetario separado de pendientes. |
| 5 | Cerrada dentro de FASE_5_MATRIZ.md. Mantener guardas de sesión, permisos de cupones, ofertas coherentes y outbox de favoritos; sin certificar UI de APIs no consumidas ni proveedores reales. |
| 6 | Reportes complejos, IA/voz y fallos de proveedores con datos conocidos; entrenamiento sintético no prueba exactitud real. |
| 7 | Diseño profesional y accesibilidad después de estabilizar lógica, usando skills de interfaz. |
| 8 | Despliegue, migraciones existentes, restauración integral V3 y recuperación/compatibilidad. Exportar un snapshot no acredita restauración completa. |

## 9. Cómo informar y conservar contexto

Cada fase deja un `.md` de cierre con alcance, hallazgos reproducidos, causa, correcciones, pruebas/comandos/resultados, límites y pendientes trasladados. Actualizar plan maestro, registro de validación y estos puntos de continuidad. Registrar intentos fallidos de forma histórica, sin reemplazar evidencia final por expectativas.

Dar actualizaciones breves al usuario durante el trabajo. Resolver decisiones rutinarias dentro del alcance autorizado y preguntar solo si falta una regla que cambia el comportamiento comercial. Usar skills cuando aportan; leer sus instrucciones, no limitarse a nombrarlas. El usuario prefiere correcciones comprobadas por fases y preservación del trabajo, no rediseños masivos ni promesas de «100 % sin errores».


## 10. Histórico: cierre offline de fase 4

Leer FASE_4_CIERRE.md y FASE_4_PLAN.md. Backend: **209 runtime aprobados**, 280,57 s, sin fallos/omitidos; no se repitieron los tres tests de seed. Web: build y **23 tests** con runner-config=vitest.config.ts (un worker). Móvil: analyze limpio y **28 tests**. Migración repetida en copia, registro antiguo preservado sin huella inventada y conciliación demo **18/18 sin discrepancias**.

SyncOperation guarda huella, propietario, resultado y antecesor opcional. Bloqueo compartido antes de usuario/sucursal; no invertir ese orden. VENTA_CONTADO_OFFLINE usa venta manual con permiso de caja; RESERVA_OFFLINE crea reserva propia y conserva su plazo original. Billetera persiste también sus rechazos: el mismo UUID no puede aceptarse después porque cambió el stock. La entidad comercial, respuesta y auditoría estricta se confirman juntas; errores técnicos conservan pendientes reintentables.

IndexedDB y SQLite validan el lote completo antes de confirmar, usan almacenamiento fijo por propietario y evitan sincronizaciones simultáneas desde el primer await. Respuestas tardías no llegan a otra cuenta. Reintentos con espera creciente y pausa de autenticación. POS espera el guardado antes del comprobante provisional.

SQLite versión 5: el saldo central/firma/nonce permanece intacto al encolar; disponible descuenta retenidos y pendientes. Pedido y movimiento provisional son atómicos. La respuesta central aplica estados y saldo juntos, ignorando snapshots viejos. El caché anterior se conserva pero no financia nuevas compras hasta validarse online. No volver al descuento local independiente de la cola.

Recuperación explícita: /sync/recovery/preview, IndexedDB FashionStoreOfflineDB y SQLite fashion_store.db/fashion_store_v1.db. Importa únicamente filas del propietario verificado sin sobrescribir IDs y sin tocar el origen. Filas desconocidas o dinero histórico sin prueba quedan para revisión; no asignar al usuario actual ni firmar saldos automáticamente. El historial permite exportar operaciones propias y reintentar un rechazo manual/reserva con un UUID nuevo enlazado, conservando el original. Compras rechazadas de billetera se ven en ese historial; una compra nueva requiere nueva intención.

Migración pendiente fuera de pruebas: backend/migrations/phase4_sync_integrity.sql, además de las anteriores según versión. Respaldar, ensayar y coordinar API/clientes en fase 8; no desplegar automáticamente. PostgreSQL desechable está detenido al entregar. No se hicieron commits, push ni cargos reales.

**Trabajo posterior ya completado en fase 5:** preparar FASE_5_PLAN.md, revisar INVENTARIO_FUNCIONAL.md/INVENTARIO_CANALES.md y completar la matriz de contratos/recorridos web y móvil. Probar login → catálogo → variante → reserva/compra → pago → historial y funcionalidades restantes, con éxito/error/permisos y evidencia. Volver a una regla de fases cerradas solo ante un fallo nuevo demostrado. Usar las skills locales pertinentes y generar FASE_5_CIERRE.md al cumplir sus criterios.


## 11. Cierre histórico de fase 5, anterior a fase 6

Lectura actual: FASE_5_CIERRE.md, FASE_5_MATRIZ.md, FASE_5_ACCIONES.md y FASE_5_PLAN.md. **Fase 5 completa, incluida la ampliación pedida por el usuario**. Resultados finales: **223 backend runtime** (410,98 s; excluye 3 tests de seed no repetidos), **32 web** con build y **54 móvil** con analyze limpio (9,1 s). Chrome real: **20 recorridos con acciones** contra API/DB local y 0 errores JS; incluye CRUD, permisos, inventario, reservas, caja/cambios/anulación/recarga, perfil, contraseña y registro. Android API 34: **1 recorrido completo, 12 comprobaciones**, 1 min 18 s; reserva/cancelación, favorito, compra/billetera/historial, cola, perfil/notificaciones, logout y registro con empresa explícita. Las 24 pantallas +3 flujos del cierre anterior siguen siendo evidencia histórica. No confundir navegación, consumidor, Android emulado y aceptación de proveedores/teléfono físico.

Proteger: AuthService no debe hacer HTTP en su constructor; authGuard espera perfil antes de permisos y ofrece recuperación ante fallo transitorio. El interceptor descarta respuestas de otra cuenta; las notificaciones limpian estado por propietario. API móvil comprueba ámbito antes y después de GET/PUT/PATCH/DELETE. Carrito cambia de cuenta sin arrastrar prendas, usa oferta+recargo y verifica propietario antes de pagar tras diálogos. Mantener guardas de doble envío.

Servidor: crear cupones exige productos.update; cliente valida, no crea sus propios descuentos. Reserva y disponibilidad usan catalog_price; stock de prenda/variante/sucursal inactiva no se ofrece. Favoritos devuelven producto anidado conservando campos planos. Marcar todas las notificaciones actualiza solo filas del usuario con ORM; no relajar el rechazo general a bulk updates. Correo opcional de proveedor admite null explícito para limpiar.

Ampliación: mutex de usuario de reserva/billetera usa **NO KEY UPDATE**, conservando serialización y permitiendo FK KEY SHARE de ventas. FOR UPDATE producía un deadlock real entre usuario y sucursal; dos regresiones coordinadas lo reproducen y protegen. No quitar bloqueos de inventario ni cambiar el orden de fases 2–4. Notificaciones móviles exponen error/reintento y no anuncian lectura exitosa si falla. La inicialización nativa se comparte y empieza después del primer cuadro; compra/recarga **no esperan** al permiso o aviso para mostrar su resultado. Perfil tiene Material en accesos y bordes redondeados de color compatible. Seguridad y Permisos es información de sesión, no una pantalla administrativa móvil.

SQLite **v6**: outbox favorite_mutations, revisión de última intención y sincronización por propietario; no borrar cambios pendientes al cargar snapshot remoto. Catálogo completo se reemplaza solo con respuesta completa autorizada, no con búsquedas parciales ni con datos de otra cuenta. Vacío online no activa una restauración de prendas viejas. La migración v5 preservó saldo validado/retenido, nonce, colas y catálogo; no requiere migración PostgreSQL adicional a fase 4.

Reproducir: web/e2e/README.md, web/e2e/phase5-actions.mjs, mobile/integration_test/phase5_journeys_test.dart y backend/scripts/phase5_browser_fixture.py. El fixture se niega a usar otra base y a sobreescribir una existente. Android/consumidor Dart rechazan otra URL; la recarga de preparación es sintética y solo usa esa API local, sin guardar tokens. Esperar sys.boot_completed=1 y usar GPU del equipo en esta máquina. No copiar JWT ni claves a informes. Se detuvieron API 58001, Angular 54205, emulador, Gradle propio y PostgreSQL; datos desechables conservados. No hubo commits, push, despliegues ni cobros reales.

**Paso histórico ya ejecutado en fase 6:** crear FASE_6_PLAN.md desde el plan maestro. Validar IA/probador, voz, recomendaciones, reportes complejos y proveedores con datos conocidos, permisos de empresa y respuestas vacías/erróneas/timeouts. Precisar qué se prueba con dobles y qué requiere credenciales reales, sin efectuar cargos. UI profesional se conserva para fase 7 y restauración/despliegue para fase 8. Las tarifas de envío tienen API pero no consumidor UI identificado: no anunciar delivery operativo por existir la ruta.

## 12. Estado vigente: fase 6 cerrada; siguiente fase 7

Leer FASE_6_CIERRE.md, FASE_6_MATRIZ.md y FASE_6_PLAN.md. Resultado final: **260 backend** (182,51 s, 0 fallos/omitidos; 3 advertencias, seed excluido), **35 web/build**, **58 móvil/analyze limpio**, **4 recorridos Chrome** de reportes y ML con 0 errores inesperados. Los recorridos Android de fase 5 no se repitieron en fase 6.

Proteger: SQL exige tenant y lista permitida de tablas/columnas/funciones, limita filas exteriores y usa SET LOCAL statement_timeout. Fallo de interpretación no sustituye la pregunta por otro reporte. Constructor valida filtros y campos reales; CSV/Excel tratan texto potencialmente ejecutable como dato. Métricas por ventas.reports; aplicar/deshacer ofertas por productos.update. Autoaplicar ofertas confirma todos los elementos o revierte el lote completo.

Chat web/móvil invalida respuestas por cambio de ámbito y no inventa saldos/tarifas/direcciones al fallar. Efecto Angular usa untracked en sus mutaciones. TTS conserva capturas reales de regex. Recomendaciones descuentan stock reservado e ignoran sucursales/variantes inactivas; precio_base conserva su significado y precio_desde usa catalog_product_price/catalog_price con ofertas vigentes y recargos. Caja cotiza la variante elegida.

RF/KMeans funcionan con SINTETICO_DEMOSTRACION, no con transacciones reales de cada empresa: mantener etiquetas API/UI. Sugerencias de markdown son reglas comerciales, no inferencia certificada. Probador autenticado valida producto/variante e imagen; proveedor tiene timeout y fallback expresamente referencial. No certificar calidad visual, precisión comercial ni audio físico por los tests controlados. Períodos mensuales reconocidos usan UTC; otros intervalos requieren validación semántica propia o filtros explícitos.

Reproducir: backend/tests/test_phase6.py (37 escenarios), web/e2e/phase6-reports.mjs, backend/scripts/phase6_browser_api.py y tests Flutter phase6_*. La API QA usa base sintética phase5_browser existente y claves/modelos efímeros; no valida firmas financieras de otra ejecución. Las pruebas históricas test_channel_journeys regeneran FASE_5_OPENAPI.json y FASE_5_CONTRATOS_EJEMPLO.json con contratos actuales: son salidas automáticas, no nuevos recorridos de fase 5.

API 58001, Angular 54205 y PostgreSQL 55439 propios detenidos. No hubo commits, push, despliegues ni cargos. Cambios locales preservados en repos independientes y raíz; clonar remotos no los recupera.

**Próximo paso:** fase 7, diseño y accesibilidad. Preparar FASE_7_PLAN.md y usar frontend-design/ui-ux-pro-max/angular-developer según alcance; conservar personalización por empresa y repetir recorridos tras cambios visuales. No iniciar automáticamente fase 8 ni documentos académicos.

## 13. Estado vigente: fase 7 completada; siguiente fase 8

Leer FASE_7_CIERRE.md y FASE_7_MATRIZ.md. Web: 40 pruebas/build, móvil: 66/analyze, Chrome: 11 accesibilidad/layout y 20 comerciales, Android: 12 comprobaciones de la nueva compilación. Backend final: **271 aprobadas**, 277,53 s, 0 fallos/omitidos y 3 advertencias; FASE_7_BACKEND_REGRESION.log. Fase completada dentro de la matriz.

Conservar diálogo nativo con foco/Escape/backdrop y submenús inert; salto a contenido sin navegar a la portada; filtros etiquetados y error/reintento del catálogo; color de marca separado de contraste de acciones. No volver a panel oculto con esperas arbitrarias: fallaba de forma intermitente en Chrome. Flutter ShopProductTile y PurchaseSummaryBar crecen con texto al 200%; filas de ficha/carrito usan distribución adaptable.

Perfil GET/PUT reutiliza UserService.build_user_response para conservar branding al restaurar sesión. Tema web compara empresa del usuario con suscripción antes de aplicar colores. Tests nuevos de backend phase7_branding; test_demo_reset limpia la base tras sus commits explícitos para no contaminar la regresión. Ningún reset de pruebas apunta a Railway.

QA local: phase7_browser_api.py admite únicamente su base fija, puerto 55499; --reuse no siembra pero renueva claves. No probar billeteras antiguas tras reiniciar con nuevas claves. Capturas y comandos en web/e2e/README.md. Estado de procesos y aprobación final en cierre; no iniciar fase 8 automáticamente.

Entrega definitiva fase 7: todas las regresiones aprobadas. API/web/PostgreSQL/emulador/Gradle propios detenidos. El test de reset demo tiene limpieza por caso y el esquema de trabajo no se contaminó. Cierre/matriz/plan/registro actualizados; sin commits, push ni despliegues del asistente. Sigue fase 8: preparar su plan, compatibilidad, variables, respaldo/restauración y aceptación de despliegues independientes, respetando el carácter descartable de Railway demo y los límites de IA. No reutilizar ejemplos de secretos del chat en informes ni archivos.

Nota 5/11: notificaciones de reserva dañadas corregidas LOCALMENTE en backend; 5 pruebas unitarias aprobadas. Leer docs/auditoria_software/RONDA_1_NOTIFICACIONES_CODIFICACION.md. No publicar todavía: fresh Railway borraría datos de la compra física pendiente. APK de billetera no incluye esta corrección de servidor.


**Contrato técnico S6:** `scripts/migrate_saas.py --apply` es mantenimiento explícito, transaccional, sin seed/settings; `scripts/verify_saas_scope.py` es read-only y requiere concesión UUID válida para certificar operador. `app/saas_integrity.py` es puro (no moverlo a app.core sin evitar import de settings). Seed operador optativo por DEMO_OPERATOR_USER_ID/PASSWORD, distinto de la concesión PLATFORM_ADMIN_USER_IDS; nunca reusar cuenta comercial. Snapshot 4.4 conserva planes/revisiones/contratos como referencias centrales; 4.3 falla antes de mutar. Mantener firma privada de billetera estable; rollback no resigna saldo. El arnés histórico fase 8 se detiene por su supuesto anterior de admin global; usar el arnés SaaS solo sobre sus dos bases locales vacías. APK S6 apunta al emulador QA y no está instalado: no sustituir el del teléfono pendiente.
