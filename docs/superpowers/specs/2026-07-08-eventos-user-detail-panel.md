# Spec: Panel de detalle por usuario en Eventos

**Fecha:** 2026-07-08
**Estado:** Aprobado

---

## Contexto

En `EventosView.tsx` la tabla de usuarios solo muestra Nombre/Email/Estado/Registrado. El usuario quiere poder ver, por persona, qué hizo específicamente: uso de cada uno de los 13 módulos (ADN Creator, Analista, Carrusel, etc.), cuántas veces, y cuándo fue la última vez — todo ya viene en `EventUserRow`, solo falta mostrarlo.

Patrón elegido: panel lateral (como el master-detail de `UsersView.tsx`), no modal ni fila expandible.

---

## Solución

### 1. Layout: de una columna a lista + detalle

El contenedor de contenido (hoy un solo `<div>` vertical con KPIs/gráficos/tabla) pasa a ser un layout de dos columnas en desktop/tablet:
- **Columna principal** (flex, scroll propio): KPIs, gráficos de estado y de módulo, tabla de usuarios — sin cambios de contenido, solo se angosta.
- **Panel de detalle** (ancho fijo ~340px, borde izquierdo, scroll propio): visible solo cuando hay un usuario seleccionado.

En mobile: siguiendo el patrón ya usado en `UsersView.tsx`, un estado `mobileView: "list" | "detail"` alterna entre ver la columna principal o el panel de detalle a pantalla completa (con botón "Volver").

### 2. Selección de usuario

Nuevo estado `selectedUser: EventUserRow | null`. Clic en una fila de la tabla de usuarios: `setSelectedUser(u)` (+ `setMobileView("detail")` en mobile). La fila seleccionada se resalta (mismo tratamiento visual que `UsersView.tsx`: borde izquierdo naranja + fondo tenue).

### 3. Contenido del panel de detalle

- **Header**: nombre, email, badge de Estado (mismo componente/colores que ya existen), botón cerrar (✕) en desktop o flecha "Volver" en mobile.
- **Datos generales**: Plan, Estado del plan, Registrado el, Tokens consumidos (ciclo / total).
- **Uso por módulo** (lo central del pedido): lista de los 13 módulos con, por cada uno, veces usado y última vez — ordenada de mayor a menor uso; los módulos con 0 usos se muestran atenuados (gris, sin fecha) al final.

---

## Lo que NO cambia

- Los KPIs, los gráficos de evento (estado / uso por módulo agregado), el selector de evento y la carga de CSV — sin cambios.
- No se agrega edición desde el panel — es de solo lectura.

---

## Archivos a modificar

| Archivo | Cambio |
|---|---|
| `src/views/EventosView.tsx` | Layout de dos columnas, estado de selección, panel de detalle por usuario, mobileView toggle |

---

## Criterios de éxito

- Clic en un usuario de la tabla abre su panel de detalle (lateral en desktop/tablet, pantalla completa en mobile con botón volver).
- El panel muestra los 13 módulos con veces usado y última fecha, ordenados de mayor a menor uso.
- La fila seleccionada se resalta visualmente en la tabla.
