# Migración, seed y recuperación SaaS — Implementation Plan

6/11/2026. S6 solicitada por el usuario. Ejecución nativa/secuencial con writing-plans y systematic-debugging; sin delegación, commit/push/deploy ni instalación de APK. La compra física pendiente no se repite ni borra; cualquier aceptación remota permanece bloqueada por esa conciliación y autorización específica.

**Goal:** preparar y comprobar actualización explícita poblada, seed de operador optativo repetible, snapshots por empresa y recuperación PostgreSQL de ambos ámbitos.

**Architecture:** migración S1→S3 atómica y repetible, sin startup ni seed en base existente; inspección de esquema/invariantes en lectura; aprovisionamiento demo por UUID explícito y contraseña suministrada, independiente de la concesión del servidor. Snapshot comercial versionado conserva catálogo/contratos como referencias centrales, nunca importables. Recuperación global usa herramientas PostgreSQL, separada del operador SaaS y del import empresarial.

**Tech Stack:** FastAPI/SQLAlchemy/PostgreSQL 16, pytest, pg_dump/pg_restore; Angular/Flutter existentes. **Spec:** PLAN_SAAS_SUPERADMIN_SUSCRIPCIONES.md S6, ESPECIFICACION_SAAS_SUPERADMIN.md y cierres S1–S5.

## Restricciones y revisión

- Solo PostgreSQL local desechable validado. No leer/copiar secretos a informes, no proveedores/cargos. No aumentar privilegios por nombre/correo ni alterar roles personalizados.
- No inventar aceptación/precio legado: NULL, REFERENCIA_LEGADA y analítica anterior conservada. Rango histórico intacto; rollback ante datos inválidos o fallo DDL.
- No revertir contratos/catálogo/operador mediante import de empresa ni aceptar checksum/firma inválidos. Formato anterior: lectura segura o error claro antes de mutar.
- Matriz distingue revisión estática, automatización, restauración real local, artefactos y publicación NO ejecutada. No cerrar aceptación remota por readiness/build.
- Caso especial: IDs de operador inexistentes, identidad con historia comercial y clave de billetera equivocada: fallar sin efectos ni resignar saldos.

### 1. Migración explícita y readiness
Files: scripts/migrate_saas.py, app/saas_integrity.py, api/health.py; tests/test_saas_migration_seed.py.
- [x] Prueba roja sobre esquema poblado anterior a S1; aplicar las tres SQL dentro de una transacción con exclusión, repetir y comprobar datos/fechas/analítica/NULL sin cambios.
- [x] Comando con destino explícito, guardas locales y autorización no local deliberada; sin importar configuración privada ni ejecutar seed. Validar estructuras/triggers y rollback inducido.
- [x] Verificador read-only scripts/verify_saas_scope.py y readiness de estructuras SaaS, sin exponer UUID/claves públicamente ni confundir esquema con permisos/pagos.

### 2. Seed optativo de operador
Files: app/seed_database.py, seed_audit.py, scripts/reset_demo_database.py; tests/test_saas_migration_seed.py.
- [x] Operador demo dedicado por UUID y contraseña explícitos, empresa técnica/rol reservado sin permisos comerciales; sin concesión implícita PLATFORM_ADMIN_USER_IDS.
- [x] Repetición idéntica y admins comerciales intactos; el seed ordinario no configura operador. Colisiones/usuario existente con otro propósito se rechazan, no se reasignan.
- [x] Integrar inspección SaaS en conciliación de demo; fallos restauran esquema anterior dentro de transacción del reset. No ejecutar sobre Railway.

### 3. Snapshots empresariales
Files: services/backup_recovery.py; tests/test_saas_backup_contracts.py.
- [x] Agregar revisiones globales estrictamente referenciadas (incluye futuros planes distintos) y versión nueva; compatibilidad anterior mediante rechazo explícito o lectura segura, jamás import parcial.
- [x] Pruebas manipulación de catálogo/operador/empresa/contrato, integridad monetaria y rollback completo; otra empresa conservada y auditoría SaaS no importable.

### 4. Recuperación global y rollback local
Files: scripts/saas_s6_recovery_drill.py, scripts/phase8_recovery_drill.py y docs/auditoria_software/SAAS_S6_OPERACION_LOCAL.md.
- [x] Restaurar empresa propia separadamente; pg_dump/pg_restore a base vacía distinta con términos manuales y catálogo, operador, dos empresas y billetera firmada. Igualdad de todas las tablas/invariantes sin degradar el historial inmutable.
- [x] Fallo transaccional simulado conserva estado previo; no confundir rollback DDL/datos con volver a un código antiguo incompatible. El ensayo viejo debe advertir contrato S1 nuevo en vez de asumir admin comercial global.

### 5. Verificación y entrega local
- [x] Suites pertinentes → backend completo; web tests/build y móvil test/analyze/build secuenciales (APK de prueba sin instalar), SHA256/manifiesto de fuentes y artefactos, sin confundir HEAD previo con cambios locales.
- [x] Matriz final por rol/contrato/identidad/colas, evidencias S0–S5 diferenciadas y límites; reusar recorridos cuando no haya cambios relevantes, no presentarlos como repetidos.
- [x] Cierre, registro, planes y continuidad; detener procesos propios.
- [ ] Puerta EXTERNA pendiente: conciliar compra del teléfono, autorización commit/push/deploy, respaldo/revisión variables y validación remota posterior. No ejecutar ni declarar superada esta puerta en S6 local.

**Cierre local:** docs/auditoria_software/SAAS_S6_CIERRE.md y SAAS_S6_MATRIZ.md. Backend 466 únicas verificadas entre corridas (completa 456/1 expectativa corregida; dirigida final 24/24), web 64/build, móvil 81/analyze/APK QA sin instalar; recuperación global 35 tablas. Publicación/aceptación remota pendientes.
