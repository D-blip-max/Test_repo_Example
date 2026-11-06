# Planificación de ampliación SaaS — 5/11/2026

Estado histórico de planificación. Actualización posterior: el usuario autorizó «ya, metele»; S0 y S1 completadas en su matriz local. Consultar SAAS_S1_CIERRE.md y su matriz. S2–S6 no iniciadas; sin publicación. Solicitud del usuario: usar las skills para preparar el plan y mejorar la separación superadministrador/empresas y gestión de precios/beneficios.

## Entregables

- docs/planes_cu/ESPECIFICACION_SAAS_SUPERADMIN.md: reglas, diagnóstico, privacidad, contratos, límites y recomendaciones.
- docs/planes_cu/PLAN_SAAS_SUPERADMIN_SUSCRIPCIONES.md: siete etapas con tareas, archivos, interfaces, pruebas previstas y condiciones de cierre.

## Decisiones confirmadas por el usuario

1. Aprobación manual primero para activar/renovar suscripciones.
2. Conservar precio y beneficios contratados hasta vencer; renovación con aceptación de nuevas condiciones.

Otras decisiones del diseño (empresa operadora, mensualidad inicial, no prorrateos, permiso de restauración propia y control de downgrade) están propuestas y explicitadas para revisión, no implementadas ni presentadas como acuerdos previos.

## Skills consultadas y revisión

writing-plans para plan verificable y autorrevisión; systematic-debugging para partir de diagnósticos y no asumir que habilitar UUID resuelve privacidad; angular-developer para alcance del panel Angular 21 sin actualización de framework. No se invocaron skills de diseño para producir una UI en esta planificación.

Se inspeccionaron modelos/esquemas/rutas de suscripción, autorización y roles, aislamiento, seed, recuperación y fuentes de clientes. Hallazgos nuevos de inspección: cambio de plan autoextiende 365 días, catálogo mutable, desajuste mensual/anual y payload de creación con credenciales. No se ejecutaron esas escrituras en Railway.

Autorrevisión: requisitos cubiertos por etapas, interfaces/propósitos consistentes, 7 etapas y fuentes existentes; bloques Markdown equilibrados. No se ejecutaron pytest, pruebas web/móvil, migraciones o seed para planificar. No se certifica que el diseño esté implementado ni que las pruebas previstas aprueben.

## Protección del trabajo actual

Repos de aplicación siguen con los cambios locales anteriores de billetera, notificaciones y arneses. No se modificaron archivos de producto. No commit/push/deploy ni variables privadas. Compra física de billetera pendiente de conciliación; antes de publicar hay que resolverla y conservar su evidencia, porque Railway hace fresh demo por deploy.

Próximo paso propuesto: revisar el alcance con el usuario; tras instrucción de ejecución, comenzar solo S0 y luego S1, documentando cierre antes de avanzar. Las fases 0–8 conservan sus cierres; no se inició automáticamente una fase 9.
