# S4 — Reproducción y continuidad

Trabajo local, sin publicación. Leer SAAS_S4_CIERRE.md y SAAS_S4_MATRIZ.md antes de modificar colas o políticas.

## Entorno de prueba

PostgreSQL local desechable del proyecto, puerto 55439, base `fashionstore_test_saas_s4_20261105`. `tests/conftest.py` rechaza destinos no locales/no identificados como test antes de crear/borrar tablas. Se usaron contratos explícitos también en fixtures comerciales históricos. Los casos de concurrencia tienen esquemas `commercial_concurrency_<uuid>` que eliminan solo su propio esquema al finalizar; subprocesos de conciliación reciben el mismo search_path de prueba.

```powershell
# Solo en backend, con ese PostgreSQL de prueba disponible.
$env:TEST_DATABASE_URL='postgresql://audit@127.0.0.1:55439/fashionstore_test_saas_s4_20261105'
$env:OMP_NUM_THREADS='1'
$env:OPENBLAS_NUM_THREADS='1'
.venv/Scripts/python.exe -m pytest tests -q --tb=short -p no:cacheprovider
```

No ejecutar procesos pytest simultáneos contra esa misma base. No ejecutar pytest sin `tests`: existen scripts históricos de raíz que contactan proveedores al importar. No usar DATABASE_URL de Railway para pruebas.

Web: `npm test -- --watch=false`, `npm run build`. Móvil: `flutter test --no-pub`, `flutter analyze --no-pub`. No generar/instalar APK por estos comandos.

## Contratos que consumirá S5

- Perfil incorpora `service_restricted` y `subscription_capabilities`. No conceden permisos por sí mismos; servidor vuelve a validar.
- `/subscriptions/current` distingue `estado_efectivo`, licencia y términos actuales. Precio legado desconocido es NULL. S5 debe mostrarlo como referencia desconocida, no como pago aceptado ni precio cero.
- `/sync/authorizations`: POST `{channel: SYNC|WALLET, count: 1..20}`. Devuelve UUID, prueba opaca y vencimiento. No registrar JWT en informes. No insertar prueba nueva en una fila antigua que tenía otro UUID.
- `/sync/batch` y `/wallet/sync-offline-orders` aceptan `offline_authorization`. `requires_review=true` con REINTENTAR conserva fila y exige revisión; no tratarlo como rechazo terminal ni enviar indefinidamente.
- `/wallet/pay` acepta una operación individual online; no exige beneficio offline. Pagos pendientes históricos continúan por su protocolo de conciliación, nunca como venta en efectivo. Un resultado incierto no autoriza otra compra.
- `/payments/paypal/orders/{id}/status` permite consultar orden propia. POST `/resume` concilia la orden existente; no crea otra. Las órdenes sin autorización contractual previa suficiente no inician cargos con licencia retirada. Las capturas verificadas conservan aplicación/compensación idempotente.
- POST `/sucursales/{id}/deactivate` es remediación limitada del administrador contractual con sucursales.delete. No es permiso general de edición vencida.

## Preservación y publicación

SQLite v7 e IndexedDB v2 son ampliaciones aditivas del mismo almacenamiento. No borrar datos/colas para resolver una denegación de licencia y no atribuir automáticamente filas antiguas a otra cuenta. No reinstalar/downgradear el APK del teléfono pendiente. Pruebas de migración usan bases temporales sintéticas, no su base física.

No se aplicó migración ni se modificaron variables remotas. No nueva clave de wallet; la autorización contractual deriva una clave de propósito específico de SECRET_KEY y no reemplaza WALLET_SIGNING_KEY. Cambiar las claves sin conciliación puede invalidar evidencias pendientes.

Los cambios locales anteriores de notificaciones/billetera y los repos independientes siguen intactos. Sin commit/push autorizado para SaaS. El fresh de Railway sigue bloqueado por la compra pendiente del teléfono; la autorización histórica de demo no permite descartar esa operación ahora.
