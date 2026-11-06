# S4 — Matriz de alcance y evidencia

5/11/2026. Ejecución local. Fuentes: SAAS_S4_PLAN.md y plan maestro SaaS. Esta matriz no sustituye la aceptación pendiente del teléfono ni certifica proveedores externos.

| Escenario | Implementación y evidencia automatizada |
|---|---|
| Término confirmado actual/futuro, precio y beneficios | EntitlementService.resolve; test_period_features_override_plan_without_anticipating_future. Solo rango actual y condiciones inmutables; precio legado desconocido permanece NULL. |
| Vencimiento sin renovación implícita | test_no_implicit_renewal_and_history_is_readable; lectura no crea términos. |
| Escrituras comerciales vencidas | test_no_license_all_commercial_writers_reject_before_body_or_effect recorre OpenAPI; distingue excepciones específicas de contrato, identidad y conciliación. Prueba adicional de catálogo vencido. |
| Recuperación administrativa suspendida | Login real HTTP del administrador verificado, perfil service_restricted y contrato propio; escritura comercial rechazada. Cajero/cliente no reciben gestión contractual. |
| Permiso además de capacidad | Cliente con plan que permite analítica sigue sin permiso de personal; propósito/feature desconocidos rechazados. |
| Cupo futuro con crecimiento posterior | Tres sucursales bajo cupo cuatro; futuro cupo dos informa exceso uno, bloquea alta y permite desactivar una propia. No eliminación automática. |
| Remediación sin cambios laterales | Desactivación propia únicamente; otra empresa 404; PUT comercial vencido 403 y datos conservados. |
| Autorización previa offline | JWT de propósito separado, UUID/actor/empresa/canal/término, vencimiento; emisión exige licencia y permiso. Pruebas de identidad, canal y vencimiento. |
| Pendiente sin evidencia y licencia retirada | REINTENTAR + requires_review, sin rechazo durable, venta ni débito. Fecha local no acredita licencia. |
| Billetera con licencia previamente autorizada | Retiro de licencia y empresa suspendida, UUID firmado confirmado una vez; replay mismo recibo/saldo; validación monetaria anterior conservada. |
| Caja offline previamente autorizada | SYNC firmado confirma venta en efectivo y replay sin duplicar; no se convierte en billetera ni crea saldo. |
| Orden PayPal previa | Resume propio separado; intención registrada con término puede continuar hasta 24 h; legado sin prueba no inicia cargo; orden ajena 404. Dobles de proveedor, no PayPal real. |
| Recuperación monetaria ya capturada | Máquina durable previa conservada: captura verificada se aplica/compensa; no se equipara un permiso contractual con pago. Regresión payment_invariants. |
| SQLite | Migración aditiva v6→v7 preserva saldo 290/nonce 4 sintéticos, ambas colas y outbox de favoritos; autorización de un solo consumo local; v5→v7 también probado. |
| IndexedDB | v1→v2 en el mismo nombre de base conserva pendiente; autorización consumida transaccionalmente una vez. |
| Identidad/respuesta tardía/revisión | Pruebas Angular y Flutter de descarte de respuesta ajena y pausa sin borrar pendiente ni reintentar constantemente. |
| Identificador de comprobante provisional | Angular devuelve y muestra UUID realmente guardado con autorización, no otro UUID local. |

## Límites explícitos

- Son pruebas locales de API/servicios, almacenamiento SQLite/IndexedDB y clientes automatizados; build/analyze no equivalen a un recorrido físico.
- No desplegado en Railway/Vercel, sin APK nuevo, sin migración del teléfono. Su operación pendiente permanece intacta y aún requiere conciliación de la ronda 1.
- S5 construirá paneles y flujos visuales contractuales; S4 entrega API/capacidades y compatibilidad de colas. No se certifica la UI contractual antigua como completa.
- Alta nueva sigue bloqueada hasta correo verificable, según acuerdo S3. No cobro automático SaaS.
- Autorización offline preasigna UUID; no prueba cuándo se digitó la compra ni firma contenido/precio/pago. Cada lote admite 1–20; no es cupo económico ni límite global de emisión. Permiso comercial actual, cotización, existencias, nonce y trazabilidad siguen obligatorios.
- Ventana de cada permiso: máximo 24 h desde emisión, acotada también por fin de término +24 h. Permisos vencidos o legados ambiguos permanecen para revisión. Se requiere sesión válida; suspensión no concede login/refresh comercial a clientes sin permiso contractual.
