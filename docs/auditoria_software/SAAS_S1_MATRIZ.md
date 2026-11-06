# SaaS S1 — matriz de verificación

Fecha: 5/11/2026. Ámbito: backend local, HTTP con TestClient y PostgreSQL real desechable. No equivale a navegador, APK ni proveedores externos.

| Contrato | Evidencia automatizada | Resultado |
|---|---|---|
| Operador con permisos comerciales heredados no accede al negocio | test_saas_platform_boundary.py: GET parametrizados y recorrido de métodos/path del OpenAPI comercial (más de 120 rutas) | Aprobado en integración |
| Login/refresh/perfil/contraseña propios; revocación sin fallback y logout | test_saas_platform_boundary.py | Aprobado en integración |
| Admin comercial sin privilegios globales y empresa A aislada de B | test_saas_platform_boundary.py | Aprobado en integración |
| UUID + rol reservado + operadora; registro/rol comercial sin escalamiento | test_saas_platform_boundary.py | Aprobado en integración |
| DTO empresarial cerrado; alta sin contraseñas, usuarios ni suscripciones | test_saas_platform_boundary.py | Aprobado en integración |
| Suspensión explícita, reintento, versión obsoleta, clave con otro payload | test_saas_platform_boundary.py | Aprobado en integración |
| Auditoría separada y rollback al fallar; operadora no se suspende | test_saas_platform_boundary.py | Aprobado en integración |
| Conteos ORM y SQL de Session no abren modelos comerciales | test_saas_provisioning.py; regresión del count que eludía all_mappers | Aprobado en integración |
| Migración SQL repetida sobre esquema legado conserva empresas/roles | test_saas_provisioning.py | Aprobado en integración |
| Bootstrap dry-run/apply/repetición, rechazo de historia y slug comercial | test_saas_provisioning.py | Aprobado en integración |
| Empresa no lee/escribe auditoría SaaS global | test_saas_provisioning.py | Aprobado en repetición final |
| Perfil operador conserva unicidad global del correo | test_saas_provisioning.py | Aprobado en integración |
| Respaldo propio comercial, grafo, checksum, rollback, firmas | test_phase8_backup.py | Aprobado en integración |
| Respaldo no rebobina revisión/estado SaaS ni condiciones de suscripción; v4.0 rechazado | test_phase8_backup.py | Aprobado en integración |
| Dos transacciones simultáneas, mismo/diferente operation_id | test_saas_concurrency.py | Aprobado en suite general y repetición focalizada |
| Regresión global de backend y seed repetido | SAAS_S1_REGRESION_TESTS.log y SAAS_S1_CIERRE_FOCALIZADO.log | 350 aprobadas generales + contratos actualizados y bloque afectado: 89 aprobadas |

Integración: **51 aprobadas**, 3 advertencias de deprecación, 20,96 s. Log SAAS_S1_INTEGRACION_2.log. Baseline inicial: 27 fallos; primera corrección: 27 aprobadas. Ensayo ampliado detectó el conteo ORM y el arnés de rutas diferidas; corregidos y repetidos.

## No ejecutado / etapas posteriores

- Migración, bootstrap y rutas SaaS en Railway: no ejecutados. No despliegue/reset ni cambios en teléfono.
- Panel Angular y recorrido visual del operador: S5; el backend no demuestra ese recorrido.
- Catálogo inmutable y condiciones históricas: S2. Solicitudes/aprobación manual: S3. Beneficios/vencimiento/colas: S4. Seed canónico operadora y compatibilidad integral: S6.
- La cuenta operadora sintética de los tests no equivale a una cuenta remota aprovisionada.
- Suite interrumpida sin seleccionar tests: no es evidencia válida. La recogida alcanzó scripts históricos de raíz con efectos externos al importarse; se detuvo y se configuró pytest.ini con testpaths=tests. No incluir resultados de esos scripts en esta matriz. Se restituyó únicamente test_output_gemini.png generado por esa recogida a su versión limpia previa; no se restauraron cambios del usuario.


## Resultado de cierre

COMPLETADA en alcance local. Corrida general: 350 aprobadas y dos expectativas históricas fallidas, actualizadas explícitamente por S1. Repetición del archivo de contrato empresarial, todas las pruebas SaaS y respaldos: **89 aprobadas**, 0 fallidas/omitidas, 3 advertencias, 61,31 s. Los 353 casos actuales quedan verificados entre ambas corridas; no se afirma que existió una única corrida general íntegramente verde. Código de producto sin modificaciones entre la corrida general y esta repetición; se actualizaron dos tests y añadió rechazo de auditoría global a empresa. Concurrencia real PostgreSQL aprobada. Seed repetido, interrupción y conciliación aprobaron en la corrida general. Sin pruebas web/APK ni validación remota SaaS.
