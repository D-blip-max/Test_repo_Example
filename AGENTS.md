# Continuidad del trabajo en FashionStore

**Estado vigente de publicación — 6/11/2026:** commit y push S0–S6 realizados en main: backend 0b5f32b, web 7fd979d, móvil d14b237. Tres árboles de aplicaciones limpios; fuentes coinciden con evidencia S6. Backups privados anteriores al fresh guardados fuera de Git; evidencia central 290 Bs, SQLite físico no recuperado. Usuario autorizó expresamente publicar/reiniciar demo aun con esa incidencia; bloqueos inferiores son históricos. Despliegue/operador/aceptación remota aún deben comprobarse, APK Railway no generado por este push. Nuevas fases P1–P4 PayPal propuestas, sin implementar. Ver docs/auditoria_software/SAAS_PUSH_S0_S6.md.

**Autorización posterior vigente — 6/11/2026:** usuario pide completar publicación y pruebas, autoriza commit/push/despliegue y fresh demo Railway aun sin conciliar compra física anterior. Conservar evidencia disponible; no certificar esa compra ni borrar datos del teléfono. Ver docs/planes_cu/SAAS_PUBLICACION_PLAN.md. Los bloqueos de publicación inferiores son históricos y quedan reemplazados por esta autorización; configurar/permisos/respaldos y aceptación real siguen siendo trabajo pendiente.

**Ampliación SaaS (6/11/2026): S0–S5 y trabajo LOCAL S6 completados dentro de sus matrices.** Cierre vigente: docs/auditoria_software/SAAS_S6_CIERRE.md, SAAS_S6_MATRIZ.md y SAAS_S6_OPERACION_LOCAL.md. Backend 466 únicas verificadas entre corridas (completa 456/1 expectativa de seed corregida, dirigida final 24/24); web 64/build; móvil 81/analyze/APK QA local sin instalar. Migración poblada/rollback, seed optativo de operador dedicado, snapshot 4.4 y pg_dump/restore de 35 tablas aprobados; 26 invariantes demo. Fuentes/bundle/APK en SAAS_S6_ARTEFACTOS.json, con HEAD base y cambios locales. Publicación/aceptación remota PENDIENTES: compra física sin conciliar, sin autorización SaaS de commit/push/deploy; no repetir/borrar/instalar/resetear. Alta nueva bloqueada por verificación de correo. Sin otra etapa de código SaaS automática; siguiente paso es conciliar teléfono y preparar publicación autorizada, conservando UUID/huellas/contratos/colas.

**Ronda de aceptación 1 EN CURSO — incidencia de billetera.** Teléfono: reserva/cancelación y compra online verificadas; servidor en 290 Bs/nonce 4. Segunda compra offline no confirmada centralmente: no repetir, borrar datos ni desplegar/resetear. El asistente reprodujo y corrigió contador/envío manual que omitían billetera; 73 pruebas móviles aprobadas. Leer docs/auditoria_software/RONDA_1_INCIDENCIA_BILLETERA.md y RONDA_ACEPTACION_1.md. Falta conciliar cola del teléfono y verificar APK instalado. Sin commits/push/despliegues autorizados en esta ronda; fases 0–8 permanecen cerradas.

Estado vigente (4/11/2026): FASES 0–8 COMPLETADAS dentro de sus matrices. Leer docs/auditoria_software/FASE_8_CIERRE.md y FASE_8_MATRIZ.md. Backend 68987c8 publicado/healthy, 297 pruebas; web 644d62a, 40/build; móvil b07bb6f, 66/analyze y APK nuevo instalado. Voz/chat Gemini reales aceptados en Railway/Vercel; resumen monetario corregido. Comprador PayPal sandbox autorizado: primera confirmación 200, un recibo/captura, reintento idempotente y stock -1, recibo VTA-20261104-62EF05. No hay credenciales de comprador en archivos. QA propio detenido; tres repos de aplicaciones limpios y main remoto coincidente. Usuario autorizó commits/push de fase 8 y fresh demo por deploy. No iniciar otra fase ni extrapolar a cambios futuros sin petición.

Estas instrucciones son para cualquier IA que abra esta carpeta, incluso desde otra cuenta. Las instrucciones nuevas del usuario prevalecen. Leer primero `CONTINUAR_AQUI.md` y después `docs/planes_cu/CONTEXTO_CONTINUIDAD_SOFTWARE.md`.

## Objetivo y estado

Prioridad actual: software, lógica de negocio y pruebas reales. No trabajar en los documentos académicos salvo petición expresa. Fases 0–7 cerradas dentro de sus criterios y matrices; fase 8 completada dentro de su matriz. Fuente de estado: `docs/planes_cu/PLAN_MAESTRO_ESTABILIZACION.md` y los cierres de cada fase en `docs/auditoria_software/`; cierre vigente `FASE_8_CIERRE.md` y `FASE_8_MATRIZ.md`. Los planes históricos no demuestran que una función esté probada.

## Reglas comerciales acordadas

- Toda cuenta comercial pertenece a una empresa. No existe cliente global ni selección automática de la primera empresa.
- Un cliente puede comprar en cualquier sucursal activa de su empresa, sujeto a existencias y permisos.
- Empresa e identidad se obtienen del usuario autenticado y la base; nunca confiar en IDs del formulario para conceder acceso.
- Mantener aislamiento de empresa también en referencias indirectas, reportes, recibos, almacenamiento local y colas.
- Correo globalmente único según el esquema actual. No cambiar esta política silenciosamente.
- Privilegios de plataforma requieren conjuntamente UUID en `PLATFORM_ADMIN_USER_IDS`, rol reservado `superadmin_plataforma` perteneciente a empresa técnica con `es_operadora=true`, usuario/empresa activos. El correo/dominio no concede privilegios. Configuración incoherente se rechaza sin fallback comercial. Operador no usa rutas del negocio ni respalda/restaura sus datos; el admin de empresa usa permisos `backups.download`/`backups.restore` propios (contrato S1 posterior a fase 8).

- Crear cupones exige `productos.update`; el cliente puede validar un cupón autorizado, no crear sus propios descuentos.
- Precios, descuentos y totales se cotizan en servidor. Una referencia, firma o importe del cliente no acredita pago. No solucionar conflictos offline volviendo a confiar en ellos.
- Diferencia a favor en cambios: acreditar a billetera y exigir cliente identificado, según decisión expresa del usuario. Débito BILLETERA se distingue de captura PAYPAL.
- `WALLET_SIGNING_KEY` privada es obligatoria para operar con saldo. Historia sin captura/trazabilidad no se certifica por sumar correctamente; requiere conciliación explícita.

## Forma de trabajar

1. Leer el plan de la fase y el código afectado; reproducir el fallo antes de corregirlo.
2. Usar las skills locales pertinentes leyendo su `SKILL.md`: `.agents/skills/writing-plans/`, `systematic-debugging/` y `angular-developer/`. Reservar `frontend-design/` y `ui-ux-pro-max/` para trabajo de interfaz solicitado o la fase correspondiente. `find-skills/` sirve para descubrimiento, no sustituye la verificación.
3. Trabajar una fase por vez: diagnóstico → regla comercial → prueba de regresión → corrección de causa → pruebas del alcance → informe de cierre. Cambiar una regla importante requiere explicitarla; las reglas ya acordadas no requieren nueva confirmación.
4. Registrar comandos, resultados, hallazgos, correcciones y pendientes en un `.md` por fase dentro de `docs/auditoria_software/`. Actualizar el plan y `REGISTRO_VALIDACION.md` al cerrar.
5. Distinguir inspección estática, prueba automatizada, prueba manual y pendiente. No afirmar que todo está probado por compilar, existir una ruta o pasar un conjunto limitado de tests.
6. No reabrir fases cerradas por notas históricas; sí añadir regresión si aparece evidencia nueva. No resolver fases 2–8 de golpe.

## Repositorios y datos

- `backend/`, `web/` y `mobile/` son repositorios Git independientes; la raíz también tiene su repo. Revisar cada uno. Hay cambios locales previos: preservarlos, no restaurar/resetear/limpiar masivamente.
- No hacer commits, push o despliegues en nombre del usuario sin autorización correspondiente. El usuario autorizó expresamente commit/push de fase 8 el 4/11/2026 y se ejecutó; no extrapolar a otros cambios.
- No probar sobre datos de trabajo/producción ni hacer cobros reales. Las pruebas integradas eliminan y recrean tablas: usar exclusivamente PostgreSQL local desechable validado por `backend/tests/conftest.py`.
- No ejecutar seed ni migraciones automáticamente sobre bases existentes, salvo la excepción explícita siguiente. `RUN_STARTUP_MIGRATIONS` y `RUN_DEMO_SEED` permanecen desactivados por defecto.
- Acuerdo posterior del usuario (4/11/2026): la base Railway de este proyecto es exclusivamente demo y sus datos fuera de los seeders son descartables. Está autorizado fresh + seed antes de cada despliegue de ESA base mediante `scripts/reset_demo_database.py --confirm-disposable-demo`; reconstruye public y exige repetición idéntica del seeder y conciliación dentro de una transacción. No se ejecuta por reinicio del servidor. Esta autorización no se extiende a otras bases ni a una futura producción; no convertirla en borrado general sin confirmación del carácter descartable.
- No imprimir ni copiar `.env`, `.env.local`, tokens o claves a informes. `backend/.env.local` contiene configuración privada local ignorada por Git; el repo raíz conserva un `.env` histórico rastreado: evitar añadirle secretos.
- No borrar ni atribuir automáticamente colas antiguas sin propietario. La fase 4 implementó recuperación explícita verificada: conservar fuentes y cuarentena, UUID/huella, auditoría atómica y saldos centrales separados de pendientes. Ver su cierre antes de modificar estas reglas.

Comandos reproducibles, evidencias y siguiente paso: `docs/planes_cu/CONTEXTO_CONTINUIDAD_SOFTWARE.md`. Al finalizar una fase, mantener actualizados estos puntos de continuidad.

Fase 5: authGuard espera perfil antes de permisos (no iniciar HTTP en constructor de AuthService); descartar respuestas de otra cuenta, preservar outbox de favoritos SQLite v6 y coherencia de precio de oferta/reservas. Leer FASE_5_MATRIZ.md antes de equiparar carga de página con un recorrido probado.

Ampliación fase 5: el mutex de usuario en reserva/billetera usa PostgreSQL NO KEY UPDATE para no bloquear FK KEY SHARE de ventas; conservar esa exclusión y los bloqueos de inventario. No volver a FOR UPDATE sobre ese mutex sin repetir la regresión coordinada de concurrencia. Notificaciones nativas son efectos opcionales: no bloquear runApp ni confirmación de compra/recarga esperando permisos; compartir su inicialización. Errores de bandeja se muestran con reintento y marcar todas no anuncia éxito si falla. Android emulado se probó, entrega push/teléfono físico no se certifican por ese test.

Fase 6: conservar ámbito obligatorio y lista permitida de SQL de reportes; no sustituir una pregunta fallida por otro reporte. Chat sin conexión no inventa cifras ni tarifas; cambios de identidad invalidan respuestas pendientes. Ofertas automáticas son atómicas y requieren productos.update. Recomendaciones exponen precio_base y precio_desde vigente de forma distinta; caja cotiza la variante. Predicción/segmentación actuales son demostraciones sintéticas etiquetadas; fallback del probador es referencial. No retirar esas etiquetas ni certificar calidad/precisión de proveedores por tests con dobles. Leer límites de FASE_6_MATRIZ.md antes de rediseñar.

Fase 7: conservar diálogo nativo del menú con foco/Escape/backdrop y submenús inert; enlace de salto de navegación no vuelve a la portada. Colores de marca originales separados del color accesible de acciones; suscripción de otra identidad no impone tema. Perfil GET/PUT usa UserService.build_user_response igual que login para preservar branding al recargar. ShopProductTile y PurchaseSummaryBar respetan texto ampliado; no volver a filas/flex fijos que recorten precios/acciones. test_demo_reset limpia el esquema tras sus commits explícitos; sin esa limpieza contamina tests posteriores. Pruebas móviles previas de fase 6 preservadas. No interpretar esta matriz como auditoría WCAG integral.

Nota 5/11: notificaciones de reserva dañadas corregidas LOCALMENTE en backend; 5 pruebas unitarias aprobadas. Leer docs/auditoria_software/RONDA_1_NOTIFICACIONES_CODIFICACION.md. No publicar todavía: fresh Railway borraría datos de la compra física pendiente. APK de billetera no incluye esta corrección de servidor.

Acuerdo de planificación SaaS 5/11: el usuario confirmó activación/renovación manual primero y conservación de condiciones hasta vencer, con aceptación para renovar. Especificación y PLAN_SAAS_SUPERADMIN_SUSCRIPCIONES.md en docs/planes_cu; S0–S5 y trabajo local S6 implementados tras autorización; publicación/aceptación remota pendientes. El diseño propone operador exclusivo de plataforma, sin datos comerciales. No convertir la planificación en autorización de código, migraciones, commit/push o despliegue. Revisar propuestas antes de ejecutar; compra física pendiente sigue bloqueando publicación.


**Contrato técnico S6:** `scripts/migrate_saas.py --apply` es mantenimiento explícito, transaccional, sin seed/settings; `scripts/verify_saas_scope.py` es read-only y requiere concesión UUID válida para certificar operador. `app/saas_integrity.py` es puro (no moverlo a app.core sin evitar import de settings). Seed operador optativo por DEMO_OPERATOR_USER_ID/PASSWORD, distinto de la concesión PLATFORM_ADMIN_USER_IDS; nunca reusar cuenta comercial. Snapshot 4.4 conserva planes/revisiones/contratos como referencias centrales; 4.3 falla antes de mutar. Mantener firma privada de billetera estable; rollback no resigna saldo. El arnés histórico fase 8 se detiene por su supuesto anterior de admin global; usar el arnés SaaS solo sobre sus dos bases locales vacías. APK S6 apunta al emulador QA y no está instalado: no sustituir el del teléfono pendiente.
