# S6 — Matriz de verificación

Fecha 6/11/2026. Alcance LOCAL. El estado final de publicación/aceptación remota sigue pendiente.

| Área / escenario | Evidencia | Resultado y límite |
|---|---|---|
| Esquema pre-SaaS poblado → tres SQL → repetición | test_saas_migration_seed.py | Usuario/hash/fechas/suscripción conservados; precio legado NULL, sin pago/aceptación inventados; analítica anterior conservada |
| Fallo DDL en tercera fase / extra SQL fallida | test_migration_failure_rolls_back_ddl_and_keeps_populated_data | La transacción elimina el DDL parcial, conserva usuario/esquema legado |
| Guardas de mantenimiento | test_saas_maintenance_verifier.py; MANTENIMIENTO_IMPORT.log | Destino explícito, remotos restringidos por flag, sin importar app.config/.env; claves no impresas |
| Verificador read-only | VERIFICADOR.log + test_saas_maintenance_verifier.py | Nueve contadores cero con operador dedicado; UUID desconocido/rol reservado sin propietario rechazados; sin mutar datos |
| Readiness con trigger ausente | test_readiness_rejects_missing_saas_guard_trigger | Incompatible; comprueba presencia/habilitación, no sustituye los permisos ni evalúa todos los cuerpos SQL |
| Seed ordinario y operador optativo | test_saas_migration_seed.py; RECUPERACION.json | Seed repetido idéntico; operador por UUID/contraseña explícitos sin concesión implícita del servidor; no cambia identidad comercial |
| Fallo de seed y rollback | test_demo_reset.py | Vuelve esquema/datos previos; la cuenta opcional no omite las comprobaciones |
| Snapshot de empresa / futuro plan distinto | test_saas_backup_contracts.py | Referencias del futuro catálogo incluidas; términos/precios centrales no se reinsertan ni se revierten |
| Catálogo manipulado / tablas SaaS adicionales | test_saas_backup_contracts.py | 409 o 400 antes de mutar; checksum recalculado no legitima import SaaS |
| Formato 4.3.0 anterior | test_saas_backup_contracts.py | Error claro de incompatibilidad antes de mutar; no compatibilidad silenciosa ni JSON editado |
| Billetera con clave diferente | test_saas_backup_contracts.py | 409 por firma; rollback completo sin resignar saldo |
| Operador permitido SaaS, denegado negocio/backup | suite test_saas_platform_boundary.py y RECUPERACION.json | Prueba API automatizada y servicios reales locales; no suplantación ni export comercial |
| Admin A propio, denegado B/plataforma | suites de tenant/backup/SaaS | Regresión backend sobre PostgreSQL; no basta el guard visual |
| Precio viejo/nuevo, manual/duplicado/rechazo/fechas | test_saas_plan_catalog.py y test_saas_subscription_contracts.py | Condiciones inmutables, aceptación expresa, aprobación manual sin captura ficticia |
| Cuotas, vencimiento, suspensión, pendientes | suites test_saas_entitlements.py y test_offline_invariants.py / S4 | Regresión del backend vigente; evidencia de migración de clientes de S4/S5 se conserva, no se declara prueba física nueva |
| Restauración comercial real + otra empresa | RECUPERACION.json | 26 conjuntos comerciales restaurados; otra empresa intacta; firma válida |
| pg_dump/pg_restore global | RECUPERACION.json | Huellas de las 35 tablas idénticas, incluidas auditoría SaaS, solicitudes, términos y catálogo; 26 invariantes cero |
| Repetición de migración en base restaurada poblada | MIGRACION_RESTAURADA.log | 35 tablas sin cambios; SQL identificadas por SHA; sin seed/reset |
| Web | WEB_TESTS.log, WEB_BUILD.log | 64 aprobadas y build; S6 no modifica interfaz. Los 17 recorridos Chrome/API de S5 son evidencia heredada, no repetida aquí |
| Móvil | MOBILE_TESTS.log, MOBILE_ANALYZE.log, APK_BUILD_RELEASE.log | 81 aprobadas, análisis limpio, APK release local generado; sin instalación/prueba física |
| Fuente/artefactos | ARTEFACTOS.json | Hash de fuentes con cambios locales, bundle web y APK; HEAD es base previa, no commit de estos cambios |
| Publicación y prueba real posterior | Sin ejecutar | Bloqueada por compra física pendiente y falta de autorización SaaS. No hay aceptación remota nueva |

Los nombres de log abreviados en esta tabla llevan prefijo SAAS_S6_ y están en esta misma carpeta. La batería completa y la regresión dirigida final se detallan en SAAS_S6_CIERRE.md; cantidades no equivalen a cobertura exhaustiva.
