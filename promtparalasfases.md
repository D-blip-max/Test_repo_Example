## 📊 ESTRUCTURA DEL MENÚ WEB (AdminLTE)

```
📊 Dashboard
   ├── 📈 Panel Principal
   └── 🔐 Roles y Permisos

👥 Usuarios
   ├── 👤 Lista de Usuarios
   └── ➕ Crear Usuario

🏪 Sucursales
   ├── 📋 Lista de Sucursales
   └── ➕ Nueva Sucursal

👕 Catálogo
   ├── 📦 Productos
   ├── 🏷️ Categorías
   └── 📐 Tallas y Colores

📦 Inventario
   ├── 📊 Stock Global
   ├── 🏪 Stock por Sucursal
   └── 📋 Movimientos

📋 Reservas
   ├── 🕐 Reservas Pendientes
   ├── ✅ Reservas Preparadas
   └── 📊 Historial

💰 Ventas
   ├── 🏪 Ventas Presenciales
   ├── 📱 Ventas Digitales
   └── 📈 Reportes

⚙️ Configuración
   ├── 🔄 Temporadas
   └── 🏢 Proveedores
```

---

## 🟢 FASE 1: CRUDs BÁSICOS

### 1.1 GESTIÓN DE SUCURSALES

**Rutas:**
- Listar: `/api/sucursales/` (GET)
- Crear: `/api/sucursales/` (POST)
- Ver: `/api/sucursales/{id}/` (GET)
- Editar: `/api/sucursales/{id}/` (PUT)
- Eliminar: `/api/sucursales/{id}/` (DELETE)

**Permisos:**
- Ver: ADMIN, ENCARGADO
- Crear/Editar/Eliminar: ADMIN

**Validaciones:**
| Campo | Requerido | Tipo | Validaciones |
|-------|-----------|------|--------------|
| nombre | Sí | String | Máx 100, único, solo letras/números/espacios |
| ciudad | Sí | String | Máx 50, solo letras y espacios |
| direccion | Sí | String | Máx 200 |
| telefono | No | String | Máx 20, solo números y guiones |
| activa | No | Boolean | Default: true |

**Reglas de Negocio:**
- No se puede eliminar físicamente, solo desactivar (soft delete)
- Si tiene reservas o ventas activas, no se puede desactivar
- Al desactivar, todas las operaciones futuras se bloquean

---

### 1.2 GESTIÓN DE CATEGORÍAS

**Rutas:**
- Listar: `/api/categorias/` (GET)
- Crear: `/api/categorias/` (POST)
- Editar: `/api/categorias/{id}/` (PUT)
- Eliminar: `/api/categorias/{id}/` (DELETE)

**Permisos:** ADMIN

**Validaciones:**
| Campo | Requerido | Tipo | Validaciones |
|-------|-----------|------|--------------|
| nombre | Sí | String | Máx 50, único, solo letras/espacios |
| descripcion | No | String | Máx 200 |

**Reglas de Negocio:**
- No se puede eliminar si tiene productos asociados
- Se puede desactivar pero no eliminar (soft delete)

---

### 1.3 GESTIÓN DE PRODUCTOS

**Rutas:**
- Listar: `/api/productos/` (GET) - Con filtros
- Crear: `/api/productos/` (POST)
- Ver: `/api/productos/{id}/` (GET)
- Editar: `/api/productos/{id}/` (PUT)
- Eliminar: `/api/productos/{id}/` (DELETE)

**Permisos:** ADMIN

**Validaciones:**
| Campo | Requerido | Tipo | Validaciones |
|-------|-----------|------|--------------|
| nombre | Sí | String | Máx 100 |
| descripcion | No | Text | - |
| precio_base | Sí | Float | > 0, 2 decimales |
| categoria_id | Sí | UUID | Debe existir en BD |
| temporada | No | String | Máx 50 |
| proveedor | No | String | Máx 100 |
| activo | No | Boolean | Default: true |

**Filtros en Listado:**
- Por categoría
- Por temporada
- Por proveedor
- Por nombre (búsqueda)
- Por estado (activo/inactivo)

**Reglas de Negocio:**
- No se puede eliminar si tiene variantes con stock
- Soft delete: solo desactivar
- Al desactivar, no debe permitir reservas ni ventas futuras

---

### 1.4 GESTIÓN DE VARIANTES (TALLAS Y COLORES)

**Rutas (dentro de producto):**
- Listar: `/api/productos/{id}/variantes/` (GET)
- Crear: `/api/productos/{id}/variantes/` (POST)
- Editar: `/api/variantes/{id}/` (PUT)
- Eliminar: `/api/variantes/{id}/` (DELETE)

**Permisos:** ADMIN

**Validaciones:**
| Campo | Requerido | Tipo | Validaciones |
|-------|-----------|------|--------------|
| talla | Sí | String | Valores permitidos: S, M, L, XL, XXL |
| color | Sí | String | Máx 30, solo letras |
| sku | Sí | String | Máx 50, único, formato: PRODUCTO-TALLA-COLOR |
| precio_extra | No | Float | Default: 0, >= 0 |

**Reglas de Negocio:**
- No se puede eliminar si tiene stock en alguna sucursal
- No se pueden duplicar talla+color para el mismo producto
- SKU debe ser único en todo el sistema

---

## 🟢 FASE 2: PROVEEDORES Y TEMPORADAS

### 2.1 GESTIÓN DE PROVEEDORES

**Rutas:**
- Listar: `/api/proveedores/` (GET)
- Crear: `/api/proveedores/` (POST)
- Editar: `/api/proveedores/{id}/` (PUT)
- Eliminar: `/api/proveedores/{id}/` (DELETE)

**Permisos:** ADMIN

**Validaciones:**
| Campo | Requerido | Tipo | Validaciones |
|-------|-----------|------|--------------|
| nombre | Sí | String | Máx 100, único |
| contacto | No | String | Máx 100 |
| telefono | No | String | Máx 20 |
| email | No | Email | Formato email válido |
| direccion | No | String | Máx 200 |

**Reglas de Negocio:**
- No se puede eliminar si tiene productos asociados

---

### 2.2 GESTIÓN DE TEMPORADAS

**Rutas:**
- Listar: `/api/temporadas/` (GET)
- Crear: `/api/temporadas/` (POST)
- Editar: `/api/temporadas/{id}/` (PUT)
- Eliminar: `/api/temporadas/{id}/` (DELETE)

**Permisos:** ADMIN

**Validaciones:**
| Campo | Requerido | Tipo | Validaciones |
|-------|-----------|------|--------------|
| nombre | Sí | String | Máx 50, único |
| año | Sí | Integer | Formato YYYY |
| fecha_inicio | Sí | Date | Debe ser fecha válida |
| fecha_fin | Sí | Date | Debe ser posterior a fecha_inicio |
| activa | No | Boolean | Default: false |

**Reglas de Negocio:**
- Solo puede haber una temporada activa por año
- Si se activa una temporada, se desactiva automáticamente la anterior del mismo año
- No se puede eliminar una temporada con productos asociados

**Temporadas Predefinidas:**
- Primavera-Verano 2025
- Otoño-Invierno 2025
- Escolar 2025
- Colección Especial 2025

---

## 🟡 FASE 3: INVENTARIO Y STOCK

### 3.1 GESTIÓN DE STOCK POR SUCURSAL

**Rutas:**
- Ver stock: `/api/inventario/sucursal/{id}/` (GET)
- Actualizar stock: `/api/inventario/{id}/` (PUT)
- Ver alertas: `/api/inventario/alertas/` (GET)

**Permisos:** ADMIN, ENCARGADO

**Validaciones:**
| Campo | Requerido | Tipo | Validaciones |
|-------|-----------|------|--------------|
| stock_actual | Sí | Integer | >= 0 |
| stock_reservado | No | Integer | Default: 0, >= 0 |
| stock_minimo | No | Integer | Default: 5, >= 0 |
| ubicacion | No | String | Máx 50 |

**Reglas de Negocio:**
- stock_reservado nunca debe ser mayor a stock_actual
- stock_disponible = stock_actual - stock_reservado (calculado automáticamente)
- Si stock_actual < stock_minimo, mostrar alerta
- Solo ENCARGADO de esa sucursal puede modificar stock

**Alertas de Stock:**
- Stock bajo: cuando stock_actual <= stock_minimo
- Stock crítico: cuando stock_actual = 0
- Stock excedente: cuando stock_actual > stock_minimo * 10

---

### 3.2 RECEPCIÓN DE PRODUCTOS

**Ruta:** `/api/inventario/recepcion/` (POST)

**Permisos:** ADMIN, ENCARGADO

**Campos Requeridos:**
- sucursal_id: UUID
- productos: Lista de {variante_id, cantidad}
- factura: String (opcional)
- nota: String (opcional)

**Validaciones:**
- Todos los productos deben existir
- Las variantes deben estar activas
- Cantidad debe ser > 0
- No se puede recibir productos inactivos

**Reglas de Negocio:**
- Actualiza stock_actual sumando la cantidad
- Registra movimiento tipo 'ENTRADA'
- Si es primera vez que se recibe, crear registro de inventario automáticamente

---

### 3.3 MOVIMIENTOS DE INVENTARIO

**Ruta:** `/api/inventario/movimientos/` (GET)

**Permisos:** ADMIN, ENCARGADO

**Filtros:**
- sucursal_id
- tipo (ENTRADA, SALIDA_VENTA, SALIDA_RESERVA, LIBERACION_RESERVA, AJUSTE, DEVOLUCION)
- fecha_desde
- fecha_hasta
- producto_id

**Tipos de Movimiento:**
| Tipo | Descripción | Modifica Stock |
|------|-------------|----------------|
| ENTRADA | Recepción de productos | + stock_actual |
| SALIDA_VENTA | Venta de productos | - stock_actual, - stock_reservado |
| SALIDA_RESERVA | Reserva de productos | + stock_reservado |
| LIBERACION_RESERVA | Cancelación de reserva | - stock_reservado |
| AJUSTE | Corrección manual | +/- stock_actual |
| DEVOLUCION | Devolución de cliente | + stock_actual |

---

### 3.4 CONSULTA DE DISPONIBILIDAD (API PÚBLICA)

**Ruta:** `/api/inventario/disponibilidad/` (GET)

**Parámetros:**
- producto_id: UUID (opcional)
- sucursal_id: UUID (opcional)
- categoria_id: UUID (opcional)
- talla: String (opcional)
- color: String (opcional)
- ciudad: String (opcional)

**Respuesta:**
```json
[
  {
    "producto_id": "uuid",
    "producto_nombre": "Camisa Polo",
    "talla": "M",
    "color": "Azul",
    "sucursal": "La Paz",
    "ciudad": "La Paz",
    "stock_disponible": 5,
    "precio": 150.00,
    "imagen": "url"
  }
]
```

**Reglas de Negocio:**
- Solo muestra productos con stock_disponible > 0
- No muestra productos inactivos
- El precio es precio_base + precio_extra de la variante

---

## 🟡 FASE 4: RESERVAS

### 4.1 RESERVAS PARA CLIENTES (APP MÓVIL)

**Rutas (Clientes):**
- Crear: `/api/reservas/` (POST)
- Mis reservas: `/api/reservas/cliente/` (GET)
- Detalle: `/api/reservas/{id}/` (GET)
- Cancelar: `/api/reservas/{id}/cancelar` (DELETE)

**Permisos:** CLIENTE

**Creación de Reserva - Campos Requeridos:**
- sucursal_id: UUID
- fecha_hora_esperada: DateTime
- items: Lista de {variante_id, cantidad}

**Validaciones:**
- El cliente debe estar activo
- La sucursal debe estar activa
- Todos los productos deben existir y estar activos
- Stock_disponible >= cantidad solicitada (para cada item)
- fecha_hora_esperada debe ser futura (mínimo 2 horas)
- No se pueden reservar más de 10 productos por reserva
- No se pueden reservar más de 3 unidades del mismo producto

**Reglas de Negocio:**
- Al crear, estado = 'PENDIENTE'
- fecha_expiracion = ahora + 24 horas
- Incrementa stock_reservado
- Crea movimiento tipo 'SALIDA_RESERVA'
- Múltiples reservas activas por cliente (máx 5)
- No se puede reservar si tiene deudas pendientes

**Cancelación de Reserva:**
- Solo se puede cancelar si estado = 'PENDIENTE'
- Libera stock_reservado
- Crea movimiento tipo 'LIBERACION_RESERVA'
- Estado cambia a 'CANCELADA'

---

### 4.2 RESERVAS PARA ENCARGADOS (WEB)

**Rutas (Encargados):**
- Pendientes: `/api/reservas/sucursal/pendientes/` (GET)
- Preparadas: `/api/reservas/sucursal/preparadas/` (GET)
- Preparar: `/api/reservas/{id}/preparar` (PATCH)
- Recoger: `/api/reservas/{id}/recoger` (PATCH)

**Permisos:** ADMIN, ENCARGADO

**Preparar Reserva:**
- Validar que estado = 'PENDIENTE'
- Validar que la reserva pertenece a su sucursal
- Cambiar estado a 'PREPARADA'
- Opcional: enviar notificación al cliente

**Recoger Reserva:**
- Validar que estado = 'PREPARADA'
- Validar que la reserva pertenece a su sucursal
- Cambiar estado a 'RECOGIDA'
- Registrar hora de recogida

**Reglas de Negocio:**
- No se puede preparar una reserva expirada
- No se puede recoger una reserva no preparada
- Una vez recogida, no se puede cancelar

---

### 4.3 EXPIRACIÓN AUTOMÁTICA DE RESERVAS

**Job Programado (cada hora):**

**Reglas:**
- Buscar reservas con estado 'PENDIENTE' y fecha_expiracion < ahora
- Por cada reserva:
  - Liberar stock_reservado de todos sus detalles
  - Cambiar estado a 'EXPIRADA'
  - Crear movimiento tipo 'LIBERACION_RESERVA'
  - Notificar al cliente (opcional)

---

## 🟠 FASE 5: VENTAS

### 5.1 VENTAS PRESENCIALES (CAJERO - WEB)

**Rutas:**
- Crear: `/api/ventas/presencial/` (POST)
- Listar: `/api/ventas/sucursal/{id}/` (GET)
- Detalle: `/api/ventas/{id}/` (GET)
- Cancelar: `/api/ventas/{id}/cancelar` (PATCH)

**Permisos:** ADMIN, CAJERO

**Creación de Venta - Campos Requeridos:**
- cliente_id: UUID (opcional, puede ser null para venta anónima)
- sucursal_id: UUID
- items: Lista de {variante_id, cantidad, precio, reserva_id?}
- pago: {metodo: EFECTIVO/TARJETA/QR, referencia: String (opcional)}

**Validaciones:**
- El cajero debe pertenecer a la sucursal
- Si cliente_id proporcionado, debe existir y estar activo
- Todos los productos deben existir y estar activos
- Stock_disponible >= cantidad solicitada
- Si viene de reserva (reserva_id):
  - La reserva debe pertenecer al cliente
  - La reserva debe estar en estado 'PREPARADA'
  - La reserva debe ser de la misma sucursal
- El total debe coincidir con la suma de los items
- Precio de venta debe ser >= precio_base

**Reglas de Negocio:**
- Si cliente_id = null, venta anónima
- Si viene de reserva:
  - Descontar stock_reservado
  - Cambiar reserva a estado 'COMPLETADA'
- Descontar stock_actual
- Crear movimiento tipo 'SALIDA_VENTA'
- Registrar pago
- Estado venta = 'COMPLETADA'
- Generar comprobante (opcional)

**Métodos de Pago:**
| Método | Validaciones |
|--------|--------------|
| EFECTIVO | Monto recibido >= total |
| TARJETA | Número de autorización (opcional) |
| QR | Código de referencia |

---

### 5.2 VENTAS DIGITALES (APP MÓVIL)

**Rutas:**
- Crear: `/api/ventas/digital/` (POST)
- Historial: `/api/ventas/cliente/` (GET)
- Detalle: `/api/ventas/{id}/` (GET)

**Permisos:** CLIENTE

**Creación de Venta - Campos Requeridos:**
- items: Lista de {variante_id, cantidad, sucursal_id}
- pago_info: {metodo: TARJETA, token: String}

**Flujo de Venta Digital:**

**PASO 1: Validación Inicial**
- Todos los productos tienen stock disponible
- Cliente está activo

**PASO 2: Creación de Venta**
- Estado = 'PENDIENTE_PAGO'
- Reserva stock temporalmente (incrementa stock_reservado)
- tiempo_reserva = ahora + 15 minutos

**PASO 3: Procesamiento de Pago**
- Integrar con pasarela (Stripe/PayPal/Libélula)
- Si pago exitoso:
  - Estado = 'COMPLETADA'
  - Descontar stock_actual
  - Liberar stock_reservado
  - Crear movimiento 'SALIDA_VENTA'
  - Registrar pago
  - Enviar confirmación email
- Si pago fallido o tiempo expirado:
  - Estado = 'CANCELADA'
  - Liberar stock_reservado
  - Crear movimiento 'LIBERACION_RESERVA'

**Validaciones del Pago:**
- Monto debe coincidir con total venta
- Token debe ser válido
- Pasarela debe confirmar transacción

---

### 5.3 REPORTES Y ESTADÍSTICAS DE VENTAS

**Rutas:**
- Resumen: `/api/ventas/reportes/resumen/` (GET)
- Detallado: `/api/ventas/reportes/detallado/` (GET)
- Top Productos: `/api/ventas/reportes/top-productos/` (GET)

**Permisos:** ADMIN

**Filtros:**
- sucursal_id (opcional)
- fecha_desde
- fecha_hasta
- tipo_venta (PRESENCIAL/DIGITAL)

**Métricas:**
- Total de ventas (cantidad)
- Ingresos totales
- Ingreso promedio por venta
- Producto más vendido
- Categoría más vendida
- Sucursal con más ventas
- Ventas por día/semana/mes

**Reglas de Negocio:**
- Solo mostrar ventas COMPLETADAS
- No incluir ventas canceladas
- Los precios deben ser en moneda local (Bolivianos)

---

### 5.4 CANCELACIÓN DE VENTAS

**Ruta:** `/api/ventas/{id}/cancelar` (PATCH)

**Permisos:** ADMIN

**Validaciones:**
- La venta debe existir
- No se puede cancelar si estado = 'CANCELADA'
- No se puede cancelar si estado = 'PENDIENTE_PAGO'

**Reglas de Negocio:**
- Revertir stock_actual (sumar lo vendido)
- Si tenía reserva asociada, revertir stock_reservado
- Estado cambia a 'CANCELADA'
- Crear movimiento tipo 'DEVOLUCION'
- Registrar motivo de cancelación

---

## 📱 APP MÓVIL - REQUISITOS FUNCIONALES

### Pantallas y Funcionalidades

**1. Login/Registro**
- Validar email formato correcto
- Validar password mínimo 6 caracteres
- Confirmar password en registro
- Mostrar errores amigables

**2. Catálogo**
- Búsqueda en tiempo real (mínimo 3 caracteres)
- Filtros: categoría, talla, color
- Scroll infinito o paginación
- Mostrar stock disponible por sucursal
- Imágenes de productos

**3. Reservas**
- Selección múltiple de productos
- Selector de sucursal con búsqueda
- Selector de fecha/hora (mínimo 2 horas)
- Mostrar productos reservados
- Estado visual de cada reserva
- Cancelación con confirmación

**4. Compras**
- Carrito de compras
- Actualizar cantidades
- Eliminar productos del carrito
- Checkout con resumen
- Integración pasarela de pago
- Historial de compras

**5. Perfil**
- Ver datos personales
- Editar datos (nombre, teléfono)
- Cambiar contraseña
- Cerrar sesión
- Historial de reservas y compras

---

## 🔒 SISTEMA DE PERMISOS (LARAVEL SPATIE)

### Estructura de Permisos

**Módulos y Permisos:**
```
DASHBOARD:
  - ver_dashboard

USUARIOS:
  - ver_usuarios
  - crear_usuarios
  - editar_usuarios
  - eliminar_usuarios
  - asignar_roles

SUCURSALES:
  - ver_sucursales
  - crear_sucursales
  - editar_sucursales
  - eliminar_sucursales

PRODUCTOS:
  - ver_productos
  - crear_productos
  - editar_productos
  - eliminar_productos
  - ver_categorias
  - crear_categorias
  - editar_categorias
  - eliminar_categorias

VARIANTES:
  - ver_variantes
  - crear_variantes
  - editar_variantes
  - eliminar_variantes

INVENTARIO:
  - ver_inventario
  - gestionar_stock
  - registrar_recepcion
  - ver_movimientos

RESERVAS:
  - ver_reservas
  - preparar_reservas
  - recoger_reservas
  - cancelar_reservas

VENTAS:
  - ver_ventas
  - registrar_venta_presencial
  - ver_reportes_ventas

CONFIGURACION:
  - ver_proveedores
  - gestionar_proveedores
  - ver_temporadas
  - gestionar_temporadas
```

### Asignación por Rol

| Permiso | ADMIN | ENCARGADO | CAJERO | CLIENTE |
|---------|-------|-----------|--------|---------|
| ver_dashboard | ✅ | ✅ | ✅ | ❌ |
| ver_usuarios | ✅ | ❌ | ❌ | ❌ |
| crear_usuarios | ✅ | ❌ | ❌ | ❌ |
| ver_sucursales | ✅ | ✅ | ❌ | ❌ |
| crear_sucursales | ✅ | ❌ | ❌ | ❌ |
| ver_productos | ✅ | ✅ | ✅ | ✅ |
| crear_productos | ✅ | ❌ | ❌ | ❌ |
| ver_categorias | ✅ | ✅ | ❌ | ✅ |
| ver_variantes | ✅ | ✅ | ❌ | ✅ |
| ver_inventario | ✅ | ✅ | ✅ | ❌ |
| gestionar_stock | ✅ | ✅(solo sucursal) | ❌ | ❌ |
| registrar_recepcion | ✅ | ✅(solo sucursal) | ❌ | ❌ |
| ver_reservas | ✅ | ✅(solo sucursal) | ❌ | ❌ |
| preparar_reservas | ✅ | ✅(solo sucursal) | ❌ | ❌ |
| ver_ventas | ✅ | ✅(solo sucursal) | ✅ | ❌ |
| registrar_venta_presencial | ✅ | ❌ | ✅ | ❌ |
| ver_reportes_ventas | ✅ | ❌ | ❌ | ❌ |
| gestionar_proveedores | ✅ | ❌ | ❌ | ❌ |
| gestionar_temporadas | ✅ | ❌ | ❌ | ❌ |

### Verificación en Backend

```python
# Ejemplo de cómo se debe implementar
def verificar_permiso(usuario, permiso):
    # Verificar si el usuario tiene el permiso
    # Si es ADMIN, tiene todos los permisos
    # Si es ENCARGADO, verificar permisos específicos
    # Si es CAJERO, verificar permisos limitados
    # Si es CLIENTE, solo permisos de app
```

---

## 🧪 CASOS DE PRUEBA OBLIGATORIOS

### Pruebas de Stock y Concurrencia

**Caso 1: Doble Reserva**
```
Escenario: 2 clientes intentan reservar el último producto
Validar: Solo uno logra reservar, el otro recibe error "stock insuficiente"
```

**Caso 2: Reserva y Venta Simultánea**
```
Escenario: Cliente A reserva producto, Cliente B intenta comprar el mismo
Validar: Cliente B ve stock_disponible = 0, no puede comprar
```

**Caso 3: Expiración de Reserva**
```
Escenario: Reserva no recogida en 24h
Validar: Stock se libera automáticamente, estado cambia a EXPIRADA
```

**Caso 4: Venta con Reserva**
```
Escenario: Cliente reserva, luego compra en tienda
Validar: stock_reservado y stock_actual se descuentan correctamente
```

### Pruebas de Permisos

**Caso 5: Acceso Restringido**
```
Escenario: Encargado intenta ver ventas de otra sucursal
Validar: Solo ve su sucursal, error de permisos
```

**Caso 6: Creación sin Permisos**
```
Escenario: Cajero intenta crear producto
Validar: Error 403 - Permiso denegado
```

### Pruebas de Flujo Completo

**Caso 7: Flujo Completo de Reserva**
```
1. Cliente ve catálogo
2. Cliente reserva 3 productos
3. Encargado ve reserva pendiente
4. Encargado prepara reserva
5. Cliente ve estado PREPARADA
6. Cliente va a tienda
7. Encargado recoge reserva
8. Cajero registra venta de 2 productos
9. Cliente no compra 1 producto
10. Stock se actualiza correctamente
```

**Caso 8: Flujo Completo de Venta Digital**
```
1. Cliente agrega productos al carrito
2. Cliente procede al checkout
3. Sistema valida stock
4. Sistema reserva stock (15 min)
5. Cliente paga con tarjeta
6. Pago exitoso
7. Stock descontado definitivamente
8. Confirmación enviada
```

---

## 📊 DASHBOARDS Y REPORTES

### Dashboard Administrador
```
📈 KPIs:
  - Ventas de hoy: cantidad y monto
  - Reservas pendientes: cantidad
  - Stock crítico: productos con stock bajo
  - Ingresos del mes

📊 Gráficos:
  - Ventas por día (últimos 7 días)
  - Ventas por sucursal (comparativa)
  - Top 5 productos más vendidos

📋 Tablas:
  - Últimas ventas (10 registros)
  - Alertas de stock bajo
  - Reservas por estado
```

### Dashboard Encargado
```
📈 KPIs:
  - Ventas de hoy (su sucursal)
  - Reservas pendientes (su sucursal)
  - Stock crítico (su sucursal)

📋 Tablas:
  - Reservas pendientes
  - Stock bajo
  - Últimos movimientos
```

---

## 📝 CONSIDERACIONES FINALES

### Buenas Prácticas a Seguir
1. **Validaciones en Backend y Frontend** (nunca confiar solo en frontend)
2. **Transacciones en BD** para operaciones que modifican stock
3. **Manejo de errores** con mensajes claros y específicos
4. **Logs** de todas las operaciones críticas
5. **Índices** en BD para consultas frecuentes
6. **Caché** para catálogo y disponibilidad (si es necesario)
7. **Rate Limiting** para APIs públicas

### Reglas de Negocio No Negociables
1. ✅ stock_disponible = stock_actual - stock_reservado (siempre)
2. ✅ Las reservas expiran en 24h automáticamente
3. ✅ No se puede reservar sin stock disponible
4. ✅ No se puede vender sin stock disponible
5. ✅ Todo movimiento de stock debe tener auditoría
6. ✅ Solo ADMIN puede crear/editar productos
7. ✅ Solo ENCARGADO puede preparar reservas de su sucursal
8. ✅ Solo CAJERO puede registrar ventas presenciales

### Entregables Mínimos para Cada Fase

**FASE 1:**
- CRUD completo de Sucursales, Categorías, Productos
- Gestión de Variantes

**FASE 2:**
- CRUD de Proveedores
- CRUD de Temporadas
- Integración con productos

**FASE 3:**
- Gestión de stock por sucursal
- Recepción de productos
- Movimientos de inventario
- Consulta de disponibilidad

**FASE 4:**
- Creación y gestión de reservas
- Flujo completo: pendiente → preparada → recogida
- Expiración automática

**FASE 5:**
- Venta presencial (cajero)
- Venta digital (app)
- Reportes básicos
- Cancelación de ventas
