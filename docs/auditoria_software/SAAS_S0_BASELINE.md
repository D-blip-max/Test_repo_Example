# SaaS S0 — baseline y cierre

Fecha: 5/11/2026. Estado: COMPLETADA dentro del alcance de preparación; S1 iniciada posteriormente por autorización «ya, metele».

- Repos y cambios previos registrados en SAAS_S0_BASELINE.json sin contenido privado. Mantener cambios de billetera, notificaciones y arneses separados.
- 143 endpoints inventariados por AST: 124 comerciales, 5 de identidad, 10 públicos/alta, 1 público o comercial opcional y 3 de plataforma. Son destinos de autorización, no pruebas E2E aprobadas.
- Fixtures locales en backend/tests/support_saas.py: operadora y empresas A/B; operador con permisos admin heredados, operador revocado, admin, cajero, cliente y admin de B. JWT sintéticos de esas cuentas.
- PostgreSQL 16 local existente iniciado en 127.0.0.1:55439; base NUEVA fashionstore_test_saas_s1_20261105. Ninguna conexión Railway ni reset remoto. conftest valida host/nombre antes de recrear tablas.
- Reproducción: pytest tests/test_saas_platform_boundary.py, 27 fallos/0 aprobadas en 68,84 s. Log SAAS_S0_RED.log. Esto demuestra la diferencia con el contrato nuevo; no falla una base de trabajo.
- Próxima corrección S1: separación de identidad/ámbitos, proyección SaaS cerrada y bloqueo comercial. S2–S6 no iniciadas.

Compra física pendiente sigue intacta y bloquea publicación. No commits/push/despliegues autorizados ni ejecutados.
