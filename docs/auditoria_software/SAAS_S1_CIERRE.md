# SaaS S1 — separación de plataforma y negocio

Fecha: 5/11/2026. Estado: COMPLETADA DENTRO DE SU MATRIZ LOCAL. No publicado.

## Problema y regla aplicada

Antes, un UUID de plataforma podía convivir con el administrador comercial, y algunos procedimientos retiraban el ámbito de empresa para consultar globalmente. El alta SaaS aceptaba credenciales privadas de la empresa; el toggle no distinguía reintentos. La restauración privada dependía de un privilegio global que contradice el nuevo aislamiento.

Ahora AccessPolicy distingue PLATFORM, COMPANY y DENIED. Plataforma requiere empresa técnica activa, rol reservado de esa empresa y UUID autorizado; una configuración incompleta se rechaza. Ningún permiso comercial heredado habilita negocio para el operador. Retirar UUID invalida también tokens ya emitidos en la siguiente solicitud.

Se conserva la cuenta empresarial para todos; no existe cliente global. Los clientes continúan comprando en sucursales activas de su propia empresa. No se cambió la política de correo globalmente único.

## Cambios

- Dependencias separadas de identidad, negocio y plataforma. Login/refresh/perfil exponen ámbito; operador sin permisos comerciales. Conserva perfil, contraseña y logout propios.
- Servicios globales limitados a proyecciones administrativas. Rutas `/platform` para empresas, estado y auditoría; DTO sin claves, contraseñas, clientes, ventas ni billeteras.
- Alta de metadatos inactiva sin crear propietario ni regalar vigencia. El onboarding privado completo corresponde a S3.
- Estado explícito con versión, motivo e idempotencia. Bloqueos PostgreSQL de operación y fila; auditoría con el cambio en una transacción. El antiguo toggle no realiza una inversión implícita.
- Defensa ORM adicional contra consultas comerciales desde contexto de plataforma. La regresión de count reveló que `all_mappers` no detectaba el modelo dentro de una subconsulta; se comprueban además tablas recorridas en el árbol SQL. SQL crudo por Session no abre otra vía.
- Auditoría SaaS separada del historial comercial, sin secretos. Permisos de respaldo comercial propio `backups.download` y `backups.restore`; plataforma sin exportar/restaurar datos del negocio.
- Snapshot 4.1.0: conserva estado/revisión de plataforma, rechaza operador/rol reservado y suscripción distinta; mantiene rollback, grafo, checksum y firmas de billetera. v4.0.0 se rechaza explícitamente hasta ensayo de compatibilidad S6.
- Migración S1 explícita y repetible; bootstrap por UUID con dry-run, confirmación, rechazo de historia y sin concesión automática de servidor. No integración automática en arranque.
- pytest.ini limita la recogida predeterminada a tests: los scripts históricos de raíz hacen operaciones al importarse y no pertenecen a la suite aislada. Se interrumpió la primera recogida general al detectar ese efecto; no se cuenta como validación. Se restituyó el PNG generado por esa recogida, sin descartar cambios previos.

## Evidencia

Ver [matriz](SAAS_S1_MATRIZ.md), [baseline](SAAS_S0_BASELINE.md) y [operación local](SAAS_S1_OPERACION_LOCAL.md).

- Baseline S1: 27 fallos nuevos reproducidos. Primera corrección: 27 aprobadas.
- Integración ampliada final: 51 aprobadas, 3 advertencias, 20,96 s.
- Migración repetida y bootstrap probados contra PostgreSQL local, no con dobles.
- Pruebas concurrentes aprobadas: mismo operation_id devuelve dos éxitos con un cambio/auditoría; claves distintas con versión inicial compartida producen 200/409 y una sola mutación.
- El test histórico de UUID en administrador comercial cambia por la regla explícita nueva: UUID solo ya no concede plataforma ni fallback comercial. La identidad operadora válida se prueba en la suite SaaS.

Comandos desde backend, con TEST_DATABASE_URL apuntando exclusivamente a la base local validada indicada en S0 y OMP_NUM_THREADS/OPENBLAS_NUM_THREADS=1:

```powershell
.venv/Scripts/python.exe -m pytest tests -q --tb=short -p no:cacheprovider
.venv/Scripts/python.exe -m pytest tests/test_tenant_contract.py tests/test_saas_platform_boundary.py tests/test_saas_provisioning.py tests/test_saas_concurrency.py tests/test_phase8_backup.py -q --tb=short -p no:cacheprovider
.venv/Scripts/python.exe scripts/bootstrap_platform_operator.py --help
```

La corrida general ejecutó 352 casos: 350 aprobadas y dos expectativas históricas incompatibles con el nuevo contrato. Además del test de UUID, el inventario de modelos globales debía incluir PlatformAuditLog. Se explicitó que no es dato comercial y se añadió una regresión de rechazo de lectura/escritura desde empresa, sin relajar el acceso. Solo se actualizaron/agregaron pruebas después de esa corrida; el código de producto ya había pasado los otros 350 casos. Repetición focalizada final: **89 aprobadas**, 0 fallidas/omitidas, 3 advertencias, 61,31 s; log SAAS_S1_CIERRE_FOCALIZADO.log. Se verifican 353 casos actuales entre ambas corridas (350 originales aprobadas + dos contratos actualizados + una nueva regresión). No se ocultan los dos fallos ni se presenta una única corrida general verde inexistente.

## Alcance pendiente

S2–S6 no iniciados. No se implementaron revisiones de planes, solicitudes/aprobación contractual, período mensual, beneficios efectivos ni interfaz SaaS. El cambio de plan y onboarding legados con vigencia de 365 días siguen identificados para S3; no presentar S1 como solución de esos defectos.

El seed demo canónico de operadora y su despliegue coordinado quedan en S6. El ensayo S1 crea actores sintéticos locales y prueba bootstrap de cuenta explícita sin historia. En S1 se modificó seed_permissions; no seed_database. Se precisa aquí la lista inicialmente propuesta de archivos del plan.

No se recompiló APK, no se ejecutó recorrido visual web/móvil ni se certificaron proveedores en esta etapa. No commit/push/despliegue ni reset remoto. Preservados cambios locales anteriores de notificaciones, billetera y e2e. La compra offline del teléfono continúa pendiente y bloquea publicación; no repetirla ni borrar sus datos.


## Continuidad

Siguiente etapa: S2, catálogo de planes/precios/beneficios versionados, solo tras nueva instrucción. No iniciada automáticamente. Informes, plan, registro y archivos de continuidad actualizados. PostgreSQL local de esta sesión se detiene al finalizar; ninguna publicación autorizada.
