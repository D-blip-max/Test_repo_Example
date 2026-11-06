# SaaS S5 — Operación local y continuidad

6/11/2026. Solo QA aislado; no ejecutar estos recorridos contra Railway/Vercel ni contra la cuenta del teléfono.

## Backend de pruebas y UI real

PostgreSQL preparado en 127.0.0.1:55439 (`fashionstore-phase0-pg`). Bases usadas:

- `fashionstore_test_saas_s5_20261106`: pytest completo, sujeto al validador de conftest. Sus tablas se recrean; no ejecutar dos pytest contra la misma base.
- `fashionstore_test_saas_s5_browser_20261106`: fixture de navegador independiente. Solo tablas vacías inicialmente; el script rechaza una base poblada en vez de borrarla. Se conservaron los datos sintéticos al cerrar.

Comando de suite, desde backend:

```powershell
$env:TEST_DATABASE_URL='postgresql://audit@127.0.0.1:55439/fashionstore_test_saas_s5_20261106'
$env:OMP_NUM_THREADS='1'
$env:OPENBLAS_NUM_THREADS='1'
.venv/Scripts/python.exe -m pytest tests -q --tb=short -p no:cacheprovider
```

No usar pytest sobre la raíz: scripts históricos pueden contactar proveedores al importar. No sustituir TEST_DATABASE_URL por una base de trabajo.

Para un fixture inicial vacío, desde backend:

```powershell
.venv/Scripts/python.exe scripts/saas_s5_browser_api.py
```

El script usa únicamente la base local fija y puerto 58015, crea cuentas sintéticas de operador/admin/cliente/otra empresa, contratos legados explícitos y claves efímeras en memoria. No se imprimen claves ni JWT. No copiar su configuración a producción. El operador cumple UUID + rol reservado + empresa técnica; no se omite la autorización real de S1.

Desde web, en terminal separada:

```powershell
npm exec ng serve -- --host 127.0.0.1 --port 54215
```

Con ambos servidores listos y sin recargas HMR pendientes:

```powershell
node e2e/saas-platform.mjs
node e2e/saas-platform-actions.mjs
node e2e/saas-platform-transition.mjs
```

Los interceptores del arnés reenvían toda API a 58015 y bloquean servicios externos. No simulan el catálogo, contratos, aprobación, aislamiento ni conflicto 409: se usa FastAPI/PostgreSQL real. Únicamente se inyecta un 503 deliberado para probar reintento. Los dos primeros recorridos crean revisiones/solicitudes sintéticas: ejecutarlos en orden; para repetir desde cero se requiere preparar explícitamente otro fixture local vacío. No borrar automáticamente una base que el script rechazó.

La tercera prueba cambia empresa→operador→empresa en la misma SPA, sin refrescar para limpiar servicios globales; comprueba ausencia de consultas comerciales del operador y salto/teclado en ambos layouts. Las rutas al cerrar el navegador descartan errores de contexto cerrado para no volcar cabeceras al log.

## Comprobaciones de clientes

Web: `npm test -- --watch=false`; `npm run build` (obligatorio por skill Angular). Flutter: `flutter test --no-pub` y `flutter analyze --no-pub`. No actualizar SDK/dependencias ni generar APK para estas comprobaciones.

`TokenService.scope` ahora representa únicamente almacenamiento comercial: para plataforma es NULL aunque exista un JWT autenticado. No usar ese NULL como prueba de logout; las rutas de plataforma usan AuthService/ámbito confirmado y los servicios capturan identidad/token. Esto detiene notificaciones y outbox compartidos sin borrar filas anteriores. Perfil legado sin ámbito conserva COMPANY únicamente cuando no reclama privilegios de plataforma.

## Lo que no se hizo

Sin commit/push/deploy, nuevos permisos en Railway, reinicio/reset remoto, pago ni proveedor externo. Sin instalación/reinstalación/downgrade del APK. La fila del teléfono sigue sin conciliar; su borrado no está autorizado. S6 debe empezar leyendo los cierres de S1–S5 y esta restricción; no publicar por inferencia de que las pruebas locales pasan.

Al cierre se detienen solo API 58015, Angular 54215 y PostgreSQL propios tras revisar conexiones. Los repos independientes conservan todos sus cambios anteriores. Ver SAAS_S5_CIERRE.md y SAAS_S5_MATRIZ.md para resultados y límites.
