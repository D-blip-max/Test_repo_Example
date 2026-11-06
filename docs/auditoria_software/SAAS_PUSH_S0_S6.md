# S0–S6 — commits y push autorizados

6/11/2026. Usuario pidió expresamente commit y push antes de iniciar P1–P4 de pagos. Se conservaron las fuentes verificadas por el manifiesto S6; no se implementó la separación nueva de cobros en estos commits.

- backend: main `0b5f32baee56ca792cb185df9c1edf8913e7bbb8`, push confirmado y árbol limpio.
- web: main `7fd979df839296ee7f466ea9422ecf1c2f1ccb44`, push confirmado y árbol limpio.
- mobile: main `d14b2376599ad6177ccf21de006b92efcb11f272`, push confirmado y árbol limpio.

Backups privados anteriores al push: UrbanStyle y Moda Express descargados correctamente mediante /backups/download, guardados fuera del workspace bajo LOCALAPPDATA/FashionStore-private-backups/pre-saas-20261106. No se publican contenido ni credenciales. El primer intento /export dio 404 y se corrigió al endpoint real. Huellas/tamaños y evidencia central en SAAS_PUBLICACION_PRE_PUSH.json: cuenta física central conservaba 290 Bs. La operación SQLite del teléfono no fue recuperada ni se certifica por este respaldo.

Pruebas anteriores S6: 466 casos backend verificados entre corridas, dirigida final 24/24; web 64/build y móvil 81/analyze. Se compararon todas las entradas de fuentes del manifiesto antes de commit: sin diferencias. Revisión de patrones de secretos en archivos candidatos: sin coincidencias; entornos privados y APK no incluidos.

La raíz tiene 579 entradas previas en staging y una historia diferente a origin/main, con copias históricas de aplicaciones/entornos. Para preservarla, los informes SaaS se publican en codex/saas-s0-s6-docs basada en origin/main, mediante índice temporal; no se hace push de los commits locales antiguos de la raíz ni se modifica su staging. No se altera la rama main de la raíz.

Push confirmado no equivale a aceptación remota ni a APK publicado. Railway ejecutará fresh demo de su predeploy. Comprobar hash en /health/ready y bundle real de Vercel; operador depende de variables configuradas. APK disponible S6 sigue siendo QA local, no fue reemplazado ni instalado por este trabajo de Git. P1–P4 de separación PayPal siguen propuestas, no implementadas.
