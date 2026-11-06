# SaaS S5 — Paneles separados y compatibilidad móvil

6/11/2026. Fase solicitada expresamente por el usuario; implementación nativa y secuencial. Skills writing-plans, systematic-debugging, angular-developer y frontend-design, con reglas del repositorio para preservar datos y no publicar. No agentes delegados ni dependencias/frameworks actualizados.

## Cambios y causas corregidas

El login enviaba a todas las cuentas al dashboard comercial. Ahora usa el ámbito confirmado de servidor y guardas para plataforma/empresa; el operador entra en `/plataforma/empresas`. El layout de plataforma solo instancia navegación y paneles propios. Una cuenta de empresa no entra por URL directa en plataforma; el administrador suspendido conserva contrato/perfil en un layout de recuperación sin consultas comerciales.

La prueba de navegador encontró una carrera: companyIdentityGuard interpretaba un perfil aún no restaurado como acceso inválido y la navegación acababa en dashboard. Se hizo esperar la restauración y se añadió una regresión específica. La suite original de restauración sigue pasando. La construcción de SubscriptionService ya no inicia HTTP; las respuestas de contrato/branding se descartan si cambió propietario y el estado se limpia por identidad.

Paneles propios: empresas con confirmación de estado/motivo/revisión e idempotencia; planes con identidad, borradores y publicación/retiro inmutables; solicitudes con condiciones aceptadas y decisión manual; auditoría paginada sin uniones a datos comerciales. No contraseñas de propietario, impersonación ni acceso al negocio. Alta nueva continúa bloqueada y la UI pública lo informa.

Mi suscripción muestra términos/versiones/fechas/precio y beneficios reales. Un precio histórico desconocido no se rellena con el precio de catálogo. Solicitar requiere cotización válida y aceptación expresa; no autoactiva ni renueva. Solicitudes/cancelaciones preservan historial. Se conserva edición de identidad empresarial bajo su permiso. Portada pública sustituyó precios/beneficios fijos por ofertas publicadas; los códigos de plan no otorgan capacidades. Respaldo y restauración visibles corresponden a permisos empresariales S1.

Flutter reconoce el ámbito de servidor, rechaza plataforma antes de guardar sus credenciales o activar una empresa y ofrece continuar en la web. Conserva bases/colas de otros propietarios. Se invalida una respuesta de login pendiente al cerrar sesión; una respuesta antigua no reactiva la cuenta. No panel de plataforma móvil ni APK nuevo.

## Resultados finales

| Comprobación | Resultado | Evidencia |
|---|---|---|
| Backend completo | 446 aprobadas, 0 fallidas/omitidas, 3 advertencias, 928,13 s | SAAS_S5_BACKEND.log |
| Web | 64 aprobadas / 24 archivos | SAAS_S5_WEB_CIERRE_2.log |
| Build Angular | Correcto; layouts nuevos diferidos | SAAS_S5_WEB_BUILD_CIERRE.log |
| Flutter | 81 aprobadas | SAAS_S5_MOBILE_VALIDACION_FINAL.log |
| Flutter analyze | Sin incidencias, 9,7 s | SAAS_S5_MOBILE_ANALYZE_FINAL.log |
| Chrome + API real aislada | 17 recorridos: 9 principales + 5 acciones + 3 transiciones/teclado, sin errores JS | SAAS_S5_E2E.json, SAAS_S5_E2E_ACCIONES.json, SAAS_S5_TRANSICION_E2E.json |
| Diff aplicaciones | --check correcto; avisos LF/CRLF habituales | Verificación local |

Rojos: SAAS_S5_RED_2.log reproduce HTTP en constructor; SAAS_S5_MOBILE_RED.log reproduce admisión/restauración del operador. El primer intento de arnés web tenía localStorage sin stub y fue corregido antes de usar su resultado como evidencia. Corridas intermedias conservadas: error de tipado de mocks, carrera de guarda y una recarga HMR durante edición, corregidos/repetidos. No se cambió una aserción comercial para ocultar el fallo. El análisis Flutter inicial señaló un super parámetro del test; corregido y análisis final limpio.

Advertencias existentes: FastAPI on_event/Starlette-httpx; CSS de analítica 15,66 kB sobre aviso de 15 kB y CommonJS jsPDF/canvg/html2canvas. El primer build mostraba presupuesto inicial excedido; se difirieron los dos layouts nuevos, y el build final no conserva ese exceso inicial. No se elevaron presupuestos para silenciarlo.

## Reproducción y límites

Fixture `backend/scripts/saas_s5_browser_api.py`: base local fija `fashionstore_test_saas_s5_browser_20261106`, puerto API 58015; se niega a reemplazar tablas existentes. Claves de prueba solo en memoria y sin proveedores. pytest usó otra base fija validada `fashionstore_test_saas_s5_20261106` en PostgreSQL 55439, independiente del fixture de navegador. Comandos y alcance en SAAS_S5_OPERACION_LOCAL.md y SAAS_S5_MATRIZ.md.

No prueba física ni publicación de clientes; no certificar proveedores/hardware por dobles, unit tests o build. La ronda 1 del teléfono continúa pendiente e intacta. Sin commit/push/deploy/reset remoto. S6 — migración, seed, recuperación y aceptación final — es el siguiente trabajo, no iniciado automáticamente.

## Revisión final de identidad y teclado

Se añadió regresión de cambio empresa→operador dentro de la misma SPA: los servicios singleton de notificaciones y sincronización sobreviven al layout. TokenService.scope ahora es NULL para plataforma (almacenamiento comercial desactivado, JWT válido); no se crean ámbitos técnicos de outbox. Notificaciones descarta resultados de propietario anterior y no consulta sin ámbito comercial. SAAS_S5_TRANSICION_RED.log reprodujo ambos fallos antes de corregir; la suite final de 64 casos está aprobada.

Los enlaces de salto de los dos layouts nuevos resolvían el fragmento contra base href y salían a la portada. Se corrigieron con preventDefault y foco explícito, como exige la regla preservada de fase 7. Tres recorridos finales prueban cambio de cuenta sin reload, salto que mantiene ruta, Tab/Enter y foco a 375px; ambas identidades quedan en su ámbito correcto.

El arnés intermedio que sustituía window afectó pruebas de IndexedDB; se eliminó ese reemplazo y se restauran mocks tras cada caso. También se corrigieron un selector ambiguo de motivo y una recodificación cp1252 de archivos de prueba; los arneses usan UTF-8 explícito. La repetición final completa de los 17 escenarios pasa sobre el código vigente, con campos comerciales sin modificar para obtener un resultado favorable. Las rutas de prueba ignoran cierres de contexto, y los logs se revisaron/redactaron para no conservar JWT/cabeceras privadas.

## Continuidad final

Plan S5, plan maestro SaaS, registro y tres puntos de continuidad actualizados. API local 58015 y Angular 54215 detenidos tras comprobar sus comandos/PID; PostgreSQL propio detenido tras cero conexiones de cliente ajenas. Sin commits/push/despliegues ni APK instalado; todos los cambios previos preservados. S6 queda pendiente de petición.
