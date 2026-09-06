# 🚀 Guía Rápida de Pruebas del Sistema (Fases 1 a 5)

Esta guía explica de forma **sencilla, directa y paso a paso** cómo levantar el proyecto y probar todas las funcionalidades implementadas.

---

## ⚙️ 1. Cómo Iniciar el Proyecto

### 1.1 Iniciar el Backend (FastAPI)

Abre una terminal en la carpeta `backend`:

```bash
# 1. Entrar a la carpeta backend
cd backend

# 2. Activar entorno virtual
# En Windows (PowerShell):
.venv\Scripts\Activate.ps1
# En Windows (CMD):
.venv\Scripts\activate.bat

# 3. Aplicar migraciones a la base de datos
alembic upgrade head

# 4. Sembrar roles, permisos base y temporadas
python -m app.seed_permissions

# 5. Iniciar el servidor
uvicorn app.main:app --reload --port 8000
```

> 🌐 **Backend API:** `http://127.0.0.1:8000`  
> 📖 **Documentación Swagger interactiva:** `http://127.0.0.1:8000/docs`

---

### 1.2 Iniciar el Frontend Web (Angular 19)

Abre una segunda terminal en la carpeta `web`:

```bash
# 1. Entrar a la carpeta web
cd web

# 2. Iniciar servidor de desarrollo
npm start
# O también: ng serve
```

> 💻 **Frontend Web:** `http://localhost:4200`

---

### 1.3 Acceso Inicial (Crear Usuario Administrador)

1. Ingresa a `http://localhost:4200/auth/register`.
2. Registra tu cuenta (ejemplo: `admin@tienda.com` / `Admin123!`).
3. 💡 *El primer usuario registrado en el sistema obtiene automáticamente el rol `admin` con todos los permisos del sistema.*
4. Inicia sesión en `http://localhost:4200/auth/login`.

---

## 🧪 2. Ejecutar Pruebas Automatizadas (Pytest)

Para verificar que todos los endpoints y la lógica de negocio funcionan al 100%:

```bash
cd backend
.venv\Scripts\python -m pytest tests/ -v
```
*(Deberán pasar los 17 tests de integración sin errores).*

---

## 📋 3. Guía de Pruebas por Fases

---

### 🟢 FASE 1: CRUDs Básicos (Sucursales, Categorías, Catálogo)

#### A. Sucursales (`/sucursales`)
1. Ve al menú **Sucursales** ➡️ **➕ Nueva Sucursal**.
2. Crea una sucursal:
   - **Nombre:** `Sucursal Central`
   - **Ciudad:** `La Paz`
   - **Dirección:** `Av. 16 de Julio #1234`
   - **Teléfono:** `70011223`
3. Verifica que aparezca en la lista con su estado activo. Puedes editarla o desactivarla.

#### B. Categorías (`/categorias`)
1. Ve al menú **Categorías** ➡️ **➕ Nueva Categoría**.
2. Crea categorías como: `Poleras`, `Pantalones`, `Chaquetas`.

#### C. Catálogo de Productos y Variantes (`/productos`)
1. Ve a **Catálogo de Productos** ➡️ **➕ Nuevo Producto**.
2. Completa los datos:
   - **Código:** `POL-001` | **Nombre:** `Polera Oversize Cotton`
   - **Categoría:** Selecciona `Poleras`
   - **Precio Base:** `120.00`
3. Agrega las **Variantes** (Tallas y Colores):
   - Variante 1: Talla `M`, Color `Negro`, SKU `POL-001-M-NEG`, Precio Extra `0`
   - Variante 2: Talla `L`, Color `Blanco`, SKU `POL-001-L-BLA`, Precio Extra `10`
4. Guarda el producto y observa cómo se listan sus variantes en la tabla.

---

### 🟢 FASE 2: Proveedores y Temporadas

#### A. Proveedores (`/proveedores`)
1. Ve al menú **Proveedores** ➡️ **➕ Nuevo Proveedor**.
2. Registra:
   - **Nombre:** `Textiles del Altiplano`
   - **Contacto:** `Juan Pérez` | **Teléfono:** `76543210`
   - **Email:** `contacto@altiplano.com`

#### B. Temporadas (`/temporadas`)
1. Ve al menú **Temporadas**.
2. Observa las temporadas predefinidas sembradas (`Primavera-Verano 2025`, `Otoño-Invierno 2025`, `Escolar 2025`).
3. Activa una temporada y comprueba que desactiva automáticamente las otras del mismo año (regla de negocio: *solo 1 activa por año*).

---

### 🟡 FASE 3: Inventario y Control de Stock

#### A. Recepción de Mercadería / Lote (`/inventario/recepcion`)
1. Ve a **Recepción de Mercadería**.
2. Selecciona la **Sucursal Central**.
3. Ingresa una referencia de factura: `FAC-2026-001`.
4. En las líneas de variantes:
   - Selecciona `Polera Oversize (M / Negro)` ➡️ Cantidad: `25`
   - Selecciona `Polera Oversize (L / Blanco)` ➡️ Cantidad: `15`
5. Presiona **📥 Confirmar Recepción**.

#### B. Consulta de Stock y Alertas (`/inventario`)
1. Ve a **Inventario / Stock**.
2. Selecciona tu sucursal y observa las tarjetas:
   - **Stock Total:** `40`
   - **Stock Reservado:** `0`
   - **Stock Disponible:** `40`
3. En la tabla verás los productos con estado **OK**.
4. **Prueba de Ajuste Manual (+/-):**
   - Haz clic en **⚖️ Ajustar** sobre una prenda.
   - Ingresa `-22` (motivo: `Mermas por daño`).
   - El stock baja a `3` y su badge cambia automáticamente a **Bajo** o **Crítico** por estar debajo del stock mínimo.

#### C. Kardex de Movimientos (`/inventario/movimientos`)
1. Ve a **Movimientos de Stock**.
2. Observa el historial completo registrado: entradas, ajustes, fecha, usuario responsable y variaciones de stock antes y después.

---

### 🟡 FASE 4: Reservas de Clientes

#### A. Crear una Reserva (`/reservas/nueva`)
1. Ve a **Nueva Reserva**.
2. Selecciona la sucursal de retiro (`Sucursal Central`).
3. Selecciona la fecha y hora esperada de recogida (ej. mañana a las 15:00).
4. Agrega las prendas que deseas apartar:
   - `Polera Oversize (L / Blanco)` ➡️ Cantidad: `2`
5. Observa el cálculo del total estimado en tiempo real.
6. Presiona **🔒 Confirmar Reserva**.

#### B. Verificar Impacto en Inventario
1. Ve a **Inventario / Stock**:
   - Para la variante reservada, observa que **Stock Reservado** subió a `2` y **Stock Disponible** bajó en `2`.

#### C. Flujo de Atención en Sucursal (`/reservas`)
1. Ve a **Gestión de Reservas**:
   - En la pestaña **🕒 Pendientes**, verás la reserva con su código único (ej. `RES-20260904-A1B2C3`).
   - Haz clic en **👁️** para ver el desglose completo de prendas apartadas.
   - Haz clic en **📦 Preparar** ➡️ La reserva pasa a la pestaña **📦 Preparadas**.
   - Si el cliente recoge su pedido, puedes hacer clic en **🛍️ Entregar** o cobrarla directamente en la caja (Fase 5).

---

### 🟠 FASE 5: Ventas y Punto de Venta (POS)

#### A. Cobro en Terminal de Caja POS (`/ventas/pos`)
1. Ve a **Caja / POS**.
2. **Caso 1: Cobro directo de una Reserva Preparada:**
   - En el desplegable *"Cargar Reserva Preparada"*, selecciona la reserva que preparaste en la Fase 4.
   - El carrito se cargará automáticamente con las prendas reservadas.
   - Elige método de pago:
     - **💵 Efectivo:** Escribe el monto recibido (o usa los botones rápidos `+50`, `+100`, `Monto Exacto`) y mira el cálculo automático del vuelto/cambio.
     - **📱 QR:** Ingresa la referencia de pago.
   - Presiona **✅ COMPLETAR VENTA**.
   - Aparecerá el **recibo térmico imprimible** con el desglose de productos, número de recibo `VTA-...` y botón para imprimir.
   - En **Reservas**, comprueba que la reserva ahora tiene estado **COMPLETADA** y en **Inventario** el stock reservado y actual se descontaron correctamente.

3. **Caso 2: Venta rápida de mostrador:**
   - Busca productos en el catálogo visual izquierdo (puedes filtrar por nombre o SKU).
   - Haz clic sobre las prendas para agregarlas al carrito.
   - Cobra con Efectivo, QR o Tarjeta.

#### B. Historial de Transacciones y Anulación (`/ventas`)
1. Ve a **Historial de Ventas**.
2. Observa todas las transacciones realizadas con número de recibo, cajero, método de pago y monto.
3. Puedes hacer clic en **👁️** para reimprimir cualquier recibo.
4. **Anulación de Venta:**
   - Haz clic en **🚫 Anular** en una venta completada.
   - Escribe el motivo (ej. `Devolución por cambio de talla`).
   - Confirma la anulación ➡️ La venta cambia a estado **CANCELADA** y las unidades vendidas **regresan automáticamente al inventario** registrando un movimiento `DEVOLUCION` en el Kardex.

#### C. Reportes y Métricas de Ventas (`/ventas/reportes`)
1. Ve a **Reportes de Ventas**.
2. Revisa las métricas en vivo:
   - **Ingresos Totales (Bs.)**
   - **Cantidad de Ventas Realizadas**
   - **Ticket Promedio**
   - **Desglose porcentual por Método de Pago** (Efectivo vs QR vs Tarjeta)
   - **Ranking de las 10 Prendas Más Vendidas** (con medallas 🥇, 🥈, 🥉, unidades e ingresos generados).

---

## 🎯 Resumen de URLs Principales del Frontend

| Módulo / Funcionalidad | URL |
| :--- | :--- |
| 📊 Dashboard Principal | `http://localhost:4200/dashboard` |
| 🔐 Roles y Permisos | `http://localhost:4200/roles` |
| 🏪 Sucursales | `http://localhost:4200/sucursales` |
| 🏷️ Categorías | `http://localhost:4200/categorias` |
| 📦 Catálogo de Productos | `http://localhost:4200/productos` |
| 🚚 Proveedores | `http://localhost:4200/proveedores` |
| 🔄 Temporadas | `http://localhost:4200/temporadas` |
| 📊 Stock por Sucursal | `http://localhost:4200/inventario` |
| 📥 Recepción de Mercadería | `http://localhost:4200/inventario/recepcion` |
| 📜 Movimientos de Stock | `http://localhost:4200/inventario/movimientos` |
| 📋 Gestión de Reservas | `http://localhost:4200/reservas` |
| ➕ Nueva Reserva | `http://localhost:4200/reservas/nueva` |
| 💳 Terminal de Caja (POS) | `http://localhost:4200/ventas/pos` |
| 🧾 Historial de Ventas | `http://localhost:4200/ventas` |
| 📈 Reportes de Ventas | `http://localhost:4200/ventas/reportes` |
