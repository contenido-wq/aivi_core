# Spec: Rediseño con gráficos de EventosView (estado de usuarios, uso por módulo)

**Fecha:** 2026-07-08
**Estado:** Aprobado

---

## Contexto

`EventosView.tsx` (spec `2026-07-08-eventos-dashboard-design.md`) hoy muestra el uso por módulo y la lista de usuarios como tablas planas de texto. El usuario quiere poder ver, con gráficos, en qué estado quedó cada asistente de un evento (si se activó, si gastó tokens) y una vista más clara del total de asistentes / activados / no activados, con barras.

Se aplicó el método del skill `dataviz` (Sección "choosing-a-form" + "color-formula"): la paleta y los colores semánticos (`C.green`/`C.yellow`/`C.red` para estado, `C.orange` para magnitud) ya existen y están validados por uso extensivo en la app — no se introducen colores nuevos, siguiendo la guía de "plugging in a design system" del skill.

---

## Solución

### 1. Modelo de "estado del usuario" (3 estados)

Nuevo cálculo derivado (no hay columna nueva en Supabase, se deriva client-side de `usuario_activo` y `tokens_plan_consumidos_total`, ya presentes en `event_users`):

| Estado | Condición | Color |
|---|---|---|
| No activado | `usuario_activo === false` | `C.red` (crítico) |
| Activado, sin gastar tokens | `usuario_activo === true && tokens_plan_consumidos_total === 0` | `C.yellow` (atención) |
| Activado y gastó tokens | `usuario_activo === true && tokens_plan_consumidos_total > 0` | `C.green` (bien) |

Esto es un "status" en el sentido del skill (estado con significado fijo, no identidad de serie) — usa los tokens de color ya reservados para ese propósito en toda la app.

### 2. KPI row (4 tarjetas, reemplaza las 3 actuales)

Total asistentes · Activados (n + %) · No activados (n + %) · Gastaron tokens (n + %). Se quita "Verificados" del resumen principal (sigue disponible en la tabla) para mantener el foco en lo que se pidió.

### 3. Gráfico "Estado de usuarios" (nuevo)

Barra horizontal (`recharts`, `layout="vertical"`), 3 categorías fijas (arriba), una barra por estado con su color fijo (`<Cell>` por barra, no una rampa continua — es un status de 3 valores fijos, no una magnitud). Valor en la punta de la barra. Sin leyenda aparte (las categorías van en el eje Y). Tooltip con conteo y %. Mismo `Card`/`ChartTip` que ya usa `ChartPanel.tsx` (fondo `#18181B`, borde `C.border`, radio 10px).

### 4. Gráfico "Uso por módulo" (reemplaza la tabla actual)

Barra horizontal, 13 módulos, un solo color (`C.orange`, magnitud = un solo hue, nunca una barra por magnitud individual). Ordenado descendente por usuarios que lo usaron. Valor en la punta. Tooltip con usuarios + usos totales + %. Reemplaza la tabla "Uso por módulo" existente en `EventosView.tsx`.

### 5. Tabla de usuarios

Se mantiene para detalle. Las columnas sueltas "Activo" / "Verificado" (Sí/No) se reemplazan por un único badge "Estado" (mismos 3 estados y colores de arriba) para lectura más rápida. Verificado se conserva como un ícono pequeño junto al nombre si aplica, sin columna dedicada.

---

## Lo que NO cambia

- El esquema de `event_users` en Supabase — todo se deriva client-side de columnas existentes.
- El selector de evento, el botón "Subir CSV", el buscador de la tabla.
- La paleta de colores — se reutilizan `C.green`/`C.yellow`/`C.red`/`C.orange` ya existentes, sin validación adicional (ya están probados en producción en `statusBadge` y otros componentes).

---

## Archivos a modificar

| Archivo | Cambio |
|---|---|
| `src/services/events.ts` | Agregar `userStatus(u: EventUserRow)` helper + `getStatusBreakdown` (cuenta por estado) |
| `src/views/EventosView.tsx` | KPI row de 4 tarjetas, gráfico de estado, gráfico de uso por módulo (reemplaza tabla), badge de estado en la tabla de usuarios |

---

## Criterios de éxito

- El dashboard de un evento muestra, con gráficos de barras: distribución de estado de usuarios (3 colores fijos) y uso por módulo (naranja, ordenado).
- Los 4 KPIs de arriba coinciden con los totales de los gráficos.
- La tabla de usuarios muestra el estado de cada uno con un badge claro en vez de dos columnas booleanas sueltas.
- Los colores usados ya existen en `tokens.ts` — ninguno nuevo.
