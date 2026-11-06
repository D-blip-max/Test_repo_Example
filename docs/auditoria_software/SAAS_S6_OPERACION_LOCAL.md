# S6 — Operación y recuperación local

Fecha: 6/11/2026. Solo entornos desechables locales. Este procedimiento NO autoriza publicar ni reemplazar el APK del teléfono con una compra pendiente.

## Cambios y comandos

Desde backend, `scripts/migrate_saas.py --apply` requiere DATABASE_URL explícita del proceso. Aplica saas_01, saas_02 y saas_03 dentro de una única transacción, con bloqueo asesor y tiempos máximos. Imprime nombres/SHA de las SQL; no ejecuta seed ni importa settings/.env. Sin `--allow-nonlocal-database`, solo admite localhost y nombres fashionstore_test_. La bandera remota es una guarda deliberada; no sustituye autorización, respaldo ni revisión del destino. Requiere la migración previa de pertenencia de roles ya aplicada. Un esquema incompatible falla sin inventar valores.

`python scripts/verify_saas_scope.py` utiliza la DATABASE_URL explícita y PLATFORM_ADMIN_USER_IDS (lista JSON). Ejecuta transacción READ ONLY y devuelve contadores agregados, no usuarios ni claves. Para habilitar el panel se exige operator_grants_configured=true y todos los contadores cero. Sin lista configurada puede verificar un entorno sin operador; eso no certifica un operador funcional. La importación del comando se probó sin cargar app.config. `/health/ready` comprueba columnas de modelos y presencia/habilitación de cinco triggers SaaS; no prueba permisos, definiciones completas de constraints, cobros ni disponibilidad de proveedores.

El seed ordinario sigue creando empresas comerciales sin operador global. El fresh demo admite opcionalmente DEMO_OPERATOR_USER_ID y DEMO_OPERATOR_PASSWORD (privada, al menos 12 caracteres); crea un operador dedicado en empresa técnica, con rol reservado sin permisos comerciales. PLATFORM_ADMIN_USER_IDS debe conceder por separado ese mismo UUID en el servidor. No se habilita por correo/nombre, no se reasigna una cuenta comercial y no se cambia su contraseña al repetir seed. El UUID debe ser estable entre fresh; el fresh sigue siendo destructivo y no preserva cambios fuera de seeders.

`python scripts/reset_demo_database.py --confirm-disposable-demo` conserva su transacción única y la repetición exacta de seed. Ahora concilia 26 invariantes: 18 comerciales y 8 SaaS. La validación de contraseña/UUID ocurre antes de borrar el esquema. El bootstrap de plataforma existente continúa siendo explícito; no hace falta ejecutarlo automáticamente sobre una identidad comercial.

## Dos ámbitos de respaldo

Backup comercial 4.4.0: solo datos propios; Subscription, términos, solicitudes y revisiones de planes son referencias al estado central vigente. Incluye planes futuros distintos al actual. No importa catálogo ni auditoría SaaS; compara referencias antes de borrar/reinsertar. Las banderas de operadora/revisión administrativa no se toman del archivo. Importar 4.3.0 falla con mensaje de formato incompatible antes de mutar: generar un respaldo nuevo con el servidor vigente. No editar la versión/checksum para forzarlo.

Restaurar una billetera exige la misma WALLET_SIGNING_KEY privada. Una clave diferente provoca rechazo/rollback, no una firma nueva para legitimar el saldo. Las claves no van en el JSON de respaldo ni en los informes. El dump global se custodia aparte: contiene información sensible de toda la base y hashes de contraseña.

## Ensayo realizado

`python scripts/saas_s6_recovery_drill.py --run-local-disposable` solo utiliza PostgreSQL local 127.0.0.1:55439, bases fijas fashionstore_test_saas_s6_source_20261106 y fashionstore_test_saas_s6_restored_20261106. Ambas deben estar vacías al iniciar; se niega a sobreescribirlas. Las claves y contraseña sintéticas se generan en memoria; proveedores vacíos. No usar este comando para restaurar una base remota.

El arnés crea seed repetido y operador dedicado, publica oferta, acepta/aprueba renovación futura sin atribuir pago, recarga sintética en efectivo, restaura JSON propio y compara la otra empresa. Luego pg_dump custom y pg_restore transaccional a la segunda base; compara huellas de las 35 tablas, concilia y verifica firma de billetera. El dump temporal se elimina al salir. Una segunda reconstrucción de la base source demuestra UUID estable del operador y administración comercial separada. La igualdad global fue comprobada antes de ese segundo fresh intencional, no después.

El arnés histórico phase8_recovery_drill.py asumía admin comercial global: ahora se detiene sin contactar una base y dirige al ensayo SaaS. No reutilizarlo como certificación de privilegios actuales.

## Puerta de publicación PENDIENTE

1. Conciliar primero la compra física pendiente de ronda 1, conservando SQLite/cola/UUID/huella del teléfono. No repetirla, borrar datos, instalar el APK nuevo o desplegar/resetear Railway para probar.
2. Obtener autorización específica de commit/push/deploy SaaS. La autorización de fase 8 antigua no se extiende a estos cambios.
3. Revisar, sin imprimir valores: DATABASE_URL/destino, SECRET_KEY, WALLET_SIGNING_KEY estable, PLATFORM_ADMIN_USER_IDS, credenciales optativas de demo, CORS/origen web, flags de startup desactivados y configuración de proveedores. Nunca copiar secretos a un informe.
4. Respaldar según ámbito y demostrar restauración con código compatible. Un rollback de código antiguo no revierte un fresh ni garantiza leer el esquema SaaS; la evidencia local aquí es restaurar datos con el código vigente. Para Railway demo se acordó fresh por deploy, pero sigue bloqueado mientras la compra física esté pendiente.
5. Publicación coordinada de servidor/web y eventual APK compatible, con huellas finales. El APK S6 generado apunta al emulador local de pruebas y usa la firma debug existente del proyecto: no es una distribución final ni debe instalarse en el teléfono pendiente.
6. Después de autorización/despliegue: probar identidad/ámbito por API, operador sin negocio, admin A sin B/plataforma, contrato/aceptación/cuotas/colas y pantallas reales. Health 200 no sustituye esos recorridos. Alta de nuevas empresas sigue bloqueada hasta verificación de correo.

Los recorridos reales Chrome/API de S5 y las pruebas previas de migración de clientes son evidencia local heredada, identificada como tal. S6 no repite una prueba física ni certifica PayPal/Gemini/VTOn por dobles.

## Comandos de la verificación registrada

Desde backend, TEST_DATABASE_URL se estableció solo para el proceso a `postgresql://audit@127.0.0.1:55439/fashionstore_test_saas_s6_20261106`, validada por tests/conftest.py; OMP_NUM_THREADS y OPENBLAS_NUM_THREADS a 1. No cambiar archivos .env para repetir estas pruebas.

- `.venv/Scripts/python.exe -m pytest tests -q --tb=short -p no:cacheprovider` → SAAS_S6_BACKEND_TESTS.log.
- `.venv/Scripts/python.exe -m pytest tests/test_demo_reset.py tests/test_saas_maintenance_verifier.py tests/test_saas_migration_seed.py tests/test_saas_backup_contracts.py -q --tb=short -p no:cacheprovider` → SAAS_S6_REGRESION_FINAL.log.
- Desde web: `npx ng test --watch=false`, después `npm run build` → WEB_TESTS/WEB_BUILD.
- Desde mobile, secuencialmente: `flutter test --no-pub`, `flutter analyze --no-pub`. El build release final usa `flutter build apk --release --dart-define=API_URL=http://10.0.2.2:58016` → APK_BUILD_RELEASE. Los intentos con --no-pub conservaron un registrante Android de integration_test; quedaron registrados como fallidos. `flutter pub get --offline` actualizó metadatos sin cambiar lockfiles, pero el build sin --no-pub fue necesario para regenerar la lista de plugins apropiada para release. No editar GeneratedPluginRegistrant.java manualmente ni elevar integration_test a dependencia de producción para esconderlo.
- `.venv/Scripts/python.exe scripts/saas_s6_artifact_manifest.py` → manifiesto de fuentes/artefactos; repetir tras cualquier cambio de fuentes antes de usar sus huellas.

Para el ensayo global se crearon expresamente las dos bases QA source/restored antes de invocarlo. El arnés no crea ni borra bases por su cuenta y no puede repetirse sobre las que ya contienen la evidencia: preparar nuevamente bases QA vacías después de comprobar el destino y su carácter descartable. No añadir un DROP automático para evitar la guarda.


**Entorno al cerrar:** PostgreSQL propio 55439 detenido después de comprobar cero conexiones de cliente ajenas; SAAS_S6_ENTORNO.log confirma server stopped. No se iniciaron servidores web/API S6 ni se instalaron APK; fuentes y cambios previos preservados.
