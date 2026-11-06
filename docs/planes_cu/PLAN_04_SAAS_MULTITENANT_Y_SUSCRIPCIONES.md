# 📑 PLAN 04: TRANSFORMACIÓN A SAAS MULTITENANT Y PLANES DE SUSCRIPCIÓN
**Nivel de Complejidad:** ⭐⭐⭐⭐⭐ (Alta / Arquitectura Nuclear)  
**Desafío Asociado:** Desafío VI — Transformación a SaaS Multitenant (Sección 9 y RNF02 del Examen)  
**Estado:** Requisito Fundamental / Columna Vertebral del Sistema  

---

## 🎯 1. Objetivo y Alcance

Evolucionar la plataforma de una cadena de tiendas monousuario a un sistema **SaaS Multitenant** donde múltiples empresas independientes operan en una única base de datos PostgreSQL con **estricto aislamiento lógico por tenant**. Cada empresa dispone de sus propias sucursales, empleados, catálogo, inventario, ventas y reservas, reguladas por un **Plan de Suscripción (Básico o Profesional)** que determina sus límites operativos y acceso a funciones avanzadas (como IA).

---

## 🏗️ 2. Arquitectura de Aislamiento y Componentes

```
                               ┌────────────────────────────────┐
                               │     JWT / Sesión de Usuario     │
                               │  { user_id, tenant_id, role }  │
                               └───────────────┬────────────────┘
                                               │
                                               ▼
                               ┌────────────────────────────────┐
                               │ FastAPI Dependency Injection   │
                               │   deps.get_current_tenant()    │
                               └───────────────┬────────────────┘
                                               │
               ┌───────────────────────────────┴───────────────────────────────┐
               ▼                                                               ▼
 ┌───────────────────────────┐                                   ┌───────────────────────────┐
 │   Empresa A (Tenant A)    │                                   │   Empresa B (Tenant B)    │
 │ Plan: PROFESIONAL         │                                   │ Plan: BÁSICO              │
 │ - Hasta 10 Sucursales     │                                   │ - Hasta 2 Sucursales      │
 │ - Reportes IA Habilitados │                                   │ - Reportes IA Bloqueados  │
 │ - Sus propios productos   │                                   │ - Sus propios productos   │
 └───────────────────────────┘                                   └───────────────────────────┘
```

---

## 🗄️ 3. Modelo de Datos y Migraciones (PostgreSQL)

### A. Nuevas Tablas
```sql
-- Empresas / Tenants
CREATE TABLE tenants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(150) NOT NULL,
    razon_social VARCHAR(200) NOT NULL,
    nit_rut VARCHAR(50) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL, -- identificador único URL/empresa
    logo_url VARCHAR(255),
    telefono VARCHAR(50),
    email_contacto VARCHAR(150),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Planes de Suscripción
CREATE TABLE subscription_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(50) UNIQUE NOT NULL, -- 'BASICO', 'PROFESIONAL'
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    max_sucursales INT NOT NULL, -- Básico: 2, Profesional: 10
    permite_reportes_ia BOOLEAN NOT NULL, -- Básico: FALSE, Profesional: TRUE
    permite_offline BOOLEAN NOT NULL DEFAULT TRUE,
    precio_mensual_bob NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

-- Suscripciones de Empresas
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    plan_id UUID NOT NULL REFERENCES subscription_plans(id),
    estado VARCHAR(50) NOT NULL DEFAULT 'ACTIVA', -- 'ACTIVA', 'VENCIDA', 'SUSPENDIDA'
    fecha_inicio DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_vencimiento DATE NOT NULL,
    notas TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### B. Inyección de `tenant_id` en Entidades Existentes
Se agrega la columna `tenant_id UUID NOT NULL REFERENCES tenants(id)` mediante migración Alembic a:
1. `branches` (sucursales)
2. `users` (usuarios / empleados)
3. `products` (productos del catálogo)
4. `categories` (categorías)
5. `seasons` (temporadas)
6. `suppliers` (proveedores)
7. `inventories` (inventarios de sucursales)
8. `sales` (ventas)
9. `reservations` (reservas)
10. `inventory_movements` (kardex)
11. `audit_logs` (bitácora de auditoría)

---

## 🔒 4. Seguridad y Aislamiento Multitenant (RNF02)

1. **Token JWT Enriquecido:**
   - El payload del JWT emitido en `/login` incluye `tenant_id` y `tenant_slug`.
2. **Inyección de Dependencia en FastAPI:**
   ```python
   def get_current_tenant(
       current_user: User = Depends(get_current_user),
       db: Session = Depends(get_db)
   ) -> Tenant:
       if not current_user.tenant_id:
           raise HTTPException(status_code=403, detail="Usuario no asociado a ninguna empresa")
       tenant = db.query(Tenant).filter(Tenant.id == current_user.tenant_id, Tenant.activo == True).first()
       if not tenant:
           raise HTTPException(status_code=403, detail="Empresa inactiva o no encontrada")
       return tenant
   ```
3. **Regla de Filtrado Universal en Servicios:**
   - Ninguna consulta a BD puede ejecutarse sin `.filter(Entity.tenant_id == tenant.id)`.
   - Se crea una clase base de repositorio/servicio o helper `tenant_filter(query, Model, tenant_id)` para garantizar que no existan fugas accidentales.
4. **Verificación de Límites del Plan:**
   - **Al crear Sucursal:**
     ```python
     sucursales_activas = db.query(Branch).filter(Branch.tenant_id == tenant.id, Branch.activo == True).count()
     if sucursales_activas >= plan.max_sucursales:
         raise HTTPException(
             status_code=400, 
             detail=f"Límite alcanzado: su plan {plan.nombre} solo permite hasta {plan.max_sucursales} sucursales activas."
         )
     ```
   - **Al consultar Reportes con IA:**
     ```python
     if not plan.permite_reportes_ia:
         raise HTTPException(
             status_code=403,
             detail=f"El plan {plan.nombre} no incluye reportes con IA. Requiere Plan Profesional."
         )
     ```

---

## 👥 5. Siembra de Datos de Prueba (Seeding)

El examen exige explícitamente: *"Deberán existir, como mínimo, dos empresas de prueba independientes."*

| Dato | Empresa 1 (Demostración Pro) | Empresa 2 (Demostración Límite Básico) |
|---|---|---|
| **Nombre** | **UrbanStyle Bolivia S.R.L.** | **Moda Express Tarija** |
| **Plan** | **Profesional** (Hasta 10 sucursales, con IA) | **Básico** (Máximo 2 sucursales, sin IA) |
| **Admin** | `admin@urbanstyle.com` / `Password123!` | `admin@modaexpress.com` / `Password123!` |
| **Cajero** | `cajero@urbanstyle.com` / `Password123!` | `cajero@modaexpress.com` / `Password123!` |
| **Sucursales** | 3 sucursales sembradas | 2 sucursales sembradas (al límite) |
| **Catálogo** | Prendas juveniles, hoodies, jeans | Camisas clásicas, trajes, vestidos |

---

## 💻 6. Interfaz Web (Angular)

1. **TopBar / SideNav:** Indicador visual de la empresa activa y badge con el plan contratado (`BÁSICO` o `PROFESIONAL`).
2. **Módulo "Mi Empresa & Suscripción" (`/admin/subscription`):**
   - Resumen del plan contratado, fecha de inicio y vencimiento.
   - Barra de consumo de sucursales: *"2 de 2 sucursales usadas (100%)"* o *"3 de 10 sucursales usadas (30%)"*.
   - Simulador administrativo de cambio de plan (para cambiar de Básico a Profesional y desbloquear las opciones de IA en vivo).

---

## 🚀 7. Pasos de Implementación

1. **Paso 1:** Crear modelos `Tenant`, `SubscriptionPlan` y `Subscription`.
2. **Paso 2:** Modificar modelos existentes agregando `tenant_id` y generar migración en Alembic.
3. **Paso 3:** Implementar middleware/dependencias de extracción de tenant y validaciones de plan en backend.
4. **Paso 4:** Actualizar `seed_database.py` para sembrar las dos empresas completas con sus planes, roles, usuarios, sucursales y catálogos independientes.
5. **Paso 5:** Desarrollar vistas de administración de suscripción en Angular.
6. **Paso 6:** Pruebas automatizadas de aislamiento (un usuario de Empresa 1 no puede ver ventas de Empresa 2).

---

## ✅ 8. Criterios de Aceptación
- [x] Existen al menos dos empresas independientes sembradas con datos reales (UrbanStyle Bolivia S.R.L. y Moda Express Tarija).
- [x] El aislamiento de datos es 100% efectivo a nivel de API/Backend (sucursales, productos, categorías, ventas aislados por `tenant_id`).
- [x] La empresa con Plan Básico no puede crear una 3ª sucursal (HTTP 400 por cupo agotado) ni usar reportes de IA (HTTP 403 Forbidden).
- [x] La empresa con Plan Profesional puede usar hasta 10 sucursales y reportes con IA sin problemas.
- [x] Simulador administrativo de cambio de plan (`POST /api/v1/subscriptions/change-plan`) activo en backend y frontend Angular.
- [x] Módulo visual Angular en `/empresa/suscripcion` con indicador en TopBar y SideNav.
- [x] Suite automatizada de pruebas `tests/test_multitenant_saas.py` con 100% de éxito (5/5 tests pasados).
