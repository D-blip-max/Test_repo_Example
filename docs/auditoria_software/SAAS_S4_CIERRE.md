# S4 — Beneficios efectivos y continuidad comercial

5/11/2026. Trabajo local autorizado por «metele» después de S3. Skills writing-plans y systematic-debugging; angular-developer en compatibilidad web. Sin commits, push, publicación, reset remoto ni nueva fase automática.

## Hallazgos y correcciones

Se reproducían escrituras después del vencimiento y lectura de condiciones del catálogo legado en lugar del término contratado. EntitlementService ahora resuelve período CONFIRMADO actual, estado administrativo/efectivo, capacidades, cupo y exceso. Sin término no concede licencia y ninguna lectura renueva. Las escrituras comerciales HTTP requieren vigencia además del rol; voz y analítica aplican capacidad y permiso.

Login/refresh del administrador verificado con subscriptions.manage permiten recuperación en empresa suspendida, con perfil restringido. No reactivan empresa ni habilitan negocio. El historial propio y conciliación tienen dependencias específicas; plataforma continúa excluida. Sucursales usa cupo efectivo bajo bloqueo de empresa y permite remediar por desactivación propia sin borrar recursos.

Se distingue pago online de billetera (`/wallet/pay`) de conciliación offline. Nuevas autorizaciones offline se emiten por servidor para UUID/actor/empresa/canal/término, con propósito y clave derivada separados. Si se retira licencia y no hay prueba, la operación queda para revisión sin efecto financiero ni rechazo durable. Precio, stock, saldo, nonce y huellas monetarias anteriores siguen vigentes. La prueba no acredita dinero ni la fecha declarada por el dispositivo.

PayPal registra el término al iniciar intención y dispone de `/payments/paypal/orders/{id}/resume` para su propietario. Sin licencia actual solo puede iniciar captura dentro de la autorización previa acotada; una captura ya realizada conserva recuperación/compensación. Sin evidencia se detiene antes del cargo. Comprobado con proveedor simulado.

SQLite v7 e IndexedDB v2 añaden prueba contractual preservando bases/colas existentes. Clientes mantienen pendientes en revisión y pausan reintentos automáticos; descartan permisos tardíos de otra identidad. Se corrigió además el comprobante provisional Angular para usar el UUID efectivamente guardado.

## Pruebas y reproducción

Base exclusiva local: `fashionstore_test_saas_s4_20261105`, PostgreSQL 127.0.0.1:55439, validada por conftest. Sin datos remotos. pytest se ejecuta sobre `tests`, nunca sobre scripts históricos de raíz que pueden contactar proveedores.

Rojo inicial: SAAS_S4_RED.log. Corridas intermedias conservaron fallos de arneses legados: fixtures sin término, suscripción duplicada en journey y conexiones concurrentes sin contrato. Se hicieron explícitos sus contratos de prueba; concurrencia histórica pasó a esquema aislado desechable para preservar restricciones de historial inmutable. No se añadió fallback permisivo en producto.


| Verificación final | Resultado | Evidencia |
|---|---|---|
| Backend completo | 446 aprobadas, 0 fallidas/omitidas, 3 advertencias, 361,30 s | SAAS_S4_BACKEND_FINAL.log |
| Angular | 43 aprobadas / 19 archivos; build correcto | SAAS_S4_WEB_TESTS_FINAL.log, SAAS_S4_WEB_BUILD_2.log |
| Flutter | 75 aprobadas generales + 1 identidad nueva = 76 casos verificados | SAAS_S4_MOBILE_TESTS_2.log, SAAS_S4_MOBILE_IDENTIDAD.log |
| Flutter analyze final | Sin incidencias, 6,7 s | SAAS_S4_MOBILE_ANALYZE_FINAL.log |
| Diff de aplicaciones | --check correcto en los tres repos; avisos LF/CRLF conservados | SAAS_S4_DIFF_*_AVISOS.log |

Advertencias backend: deprecaciones previas Starlette/httpx y on_event; web conserva aviso CommonJS html2canvas/jsPDF. No son pruebas fallidas ni se actualizaron dependencias para silenciarlas.

S4 completada dentro de esta matriz local. Pruebas móviles verificadas entre dos corridas; no se declara una sola corrida de 76. La suite backend final incluye los cinco casos añadidos tras la primera corrida general. La matriz adjunta separa comprobación y límites.

Comandos backend: TEST_DATABASE_URL a la base anterior; OMP_NUM_THREADS=1 y OPENBLAS_NUM_THREADS=1; `.venv/Scripts/python.exe -m pytest tests -q --tb=short -p no:cacheprovider`. Foco adicional: test_saas_entitlements, test_channel_journeys, test_offline_invariants, test_payment_invariants, test_commercial_invariants y test_auth. Web: `npm test -- --watch=false`, `npm run build`. Móvil: `flutter test --no-pub`, `flutter analyze --no-pub`.

## Siguiente paso y límites

S5: paneles separados, gestión visual de empresas/planes/solicitudes y aceptación contractual. No iniciada automáticamente. Alta nueva deshabilitada hasta canal de verificación. Ver SAAS_S4_MATRIZ.md para ventana de autorizaciones, sesión válida y límites de pruebas.

No se generó/instaló APK ni se repitió compra del teléfono. La ronda 1 mantiene su pendiente sin conciliar; publicar hoy activaría fresh demo y lo perdería. S0–S3 y fases originales 0–8 conservan sus cierres; esta ampliación no equivale a certificar todo el software.

## Continuidad final

Plan S4 y maestro SaaS, REGISTRO_VALIDACION, AGENTS.md, CONTINUAR_AQUI y contexto actualizados. PostgreSQL propio detenido tras confirmar cero conexiones de cliente ajenas. Repos conservan cambios locales previos; no commit/push/deploy. Siguiente etapa S5, pendiente de petición.
