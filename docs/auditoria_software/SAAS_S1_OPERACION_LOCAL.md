# SaaS S1 — operación y publicación pendiente

Fecha: 5/11/2026. Implementación backend local. No ejecutar estas instrucciones en Railway mientras siga pendiente la compra offline física.

## Cambio de autorización

Una cuenta de plataforma necesita simultáneamente usuario activo, empresa operadora activa, rol `superadmin_plataforma` de esa empresa y UUID en `PLATFORM_ADMIN_USER_IDS`. Una concesión incoherente se rechaza, no se transforma en acceso comercial. El rol comercial `admin` no es un superadministrador SaaS.

El aprovisionamiento no se basa en correo. `scripts/bootstrap_platform_operator.py --operator-user-id UUID --dry-run` muestra la selección sin modificarla. Requiere `DATABASE_URL` suministrada explícitamente, sin cargar `.env`; solo acepta PostgreSQL local `fashionstore_test_` por defecto. Aplicar requiere `--apply --confirm-user UUID`; no activa el UUID del servidor automáticamente. La opción para bases no locales NO es autorización para usarla ahora.

La cuenta elegida debe existir y no tener referencias históricas si cambia de empresa. El comando conserva sus credenciales, rechaza convertir una empresa comercial, crea/reutiliza la empresa técnica y su rol sin permisos comerciales, y registra auditoría. Transacción administrada por el comando. Para la futura demo canónica, seed y migración integral se ensayarán en S6; S1 no mueve cuentas remotas ni inventa contraseñas.

## Migración

`backend/migrations/saas_01_platform_scope.sql`: dos columnas de empresa, unicidad parcial de la operadora, tabla de auditoría separada y dos permisos de respaldos para el admin base compartido. Ejecutar explícitamente dentro de una transacción de mantenimiento revisada; no se incorpora al arranque automático. Ensayo local ejecuta el SQL dos veces sobre esquema legado y conserva sus filas/roles personalizados.

Un backend con estos modelos necesita esa migración o esquema fresco antes de utilizarse. No publicar solo el Python contra un esquema anterior. El bootstrap debe realizarse después. El panel web separado llega en S5; un operador nuevo todavía no tiene recorrido visual SaaS terminado.

## Contratos de API

- `GET /api/v1/platform/companies` y `GET /companies/{id}`: proyección administrativa cerrada; excluye operadora, usuarios, ventas, billeteras y claves de proveedores.
- `POST /api/v1/platform/companies`: metadatos exclusivamente; empresa inactiva sin usuario ni suscripción. Incluye `operation_id` UUID y motivo. No es onboarding de propietario terminado (S3).
- `PUT /api/v1/platform/companies/{id}/status`: `operation_id`, `activo`, `expected_version`, `reason`. Reintento idéntico devuelve resultado guardado. Clave reutilizada con contenido distinto o versión obsoleta: 409. Sin toggle ni extensión de vigencia.
- `GET /api/v1/platform/audit`: solo auditoría SaaS, campos permitidos y paginación. Las mutaciones y su auditoría son atómicas.
- Login/refresh/perfil exponen `access_scope`; plataforma devuelve permisos comerciales vacíos. Sus credenciales propias pueden cambiarse y su sesión cerrarse. Rutas comerciales rechazan plataforma en servidor.
- Alias anteriores de listado/alta SaaS usan estos DTO; toggle antiguo devuelve conflicto indicando la ruta explícita. El cliente antiguo de esa administración debe actualizarse en S5.

## Respaldos privados

La restauración deja de depender de privilegio de plataforma: exige ámbito comercial y `backups.restore` para la empresa propia. Descargar exige `backups.download`. Usuarios sin esos permisos y operadores SaaS no acceden.

Formato actual **4.1.0** por cambio de columnas. Un snapshot 4.0.0 se rechaza con 409; NO se simula compatibilidad ni se recalcula su checksum. Compatibilidad histórica se evaluará en S6. Restaurar preserva estado/revisión operados por plataforma y rechaza condiciones de suscripción distintas de las centrales. No permite crear operadora/rol reservado desde un respaldo. Siguen vigentes checksum, límites, grafo propio, rollback y firmas de billetera.

## Límites

S2–S6 no implementados: catálogo inmutable, solicitudes y aprobación manual contractual, beneficios por período, panel Angular y actualización integral de demo. Los endpoints comerciales antiguos de cambio de plan/alta conservan su deuda identificada hasta S3. Esta etapa no certifica esos flujos ni autoriza publicación parcial.

La protección descrita pertenece a la aplicación y a su sesión ORM, no a RLS de PostgreSQL. Un administrador directo de la base sigue teniendo sus facultades propias. No se tocaron credenciales, base ni colas del teléfono desde estas pruebas locales.
