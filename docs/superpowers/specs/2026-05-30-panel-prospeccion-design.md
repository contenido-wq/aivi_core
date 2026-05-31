# Panel de Prospección AIVI — Diseño

**Fecha:** 2026-05-30  
**Autor:** Jhei Trujillo (@elsolucionador)  
**Vista afectada:** `src/views/UsersView.tsx`  
**Servicio afectado:** `src/services/dashboard.ts`

---

## Objetivo

Transformar el panel derecho de "Trazabilidad de Usuarios" en un panel de inteligencia de prospección que permita:

1. Ver todos los productos del ecosistema que ha comprado cada estudiante (agrupados por familia)
2. Identificar quiénes han comprado el mismo producto más de una vez
3. Calcular un score de prospección para AIVI con las razones concretas del por qué ofrecerlo
4. Filtrar el listado de usuarios para ver solo quienes tienen múltiples productos

El producto objetivo de venta es **AIVI** (con sus diferentes planes de precio). El filtro `sinAIVI` ya existente sigue siendo útil como punto de partida.

---

## Cambios por área

### 1. Agrupación de familias de productos (`productFamily`)

Se define una función `getProductFamily(planName: string): string` que mapea cualquier `plan_name` de Hotmart a una familia legible:

| Palabra clave en `plan_name` | Familia |
|---|---|
| `AIVI` | `AIVI` |
| `Método V3`, `MV3` | `Método V3` |
| `Master Creator` | `Master Creator` |
| `Reto 11`, `11D` | `Reto 11D` |
| `Cero a Viral`, `De Cero` | `De Cero a Viral` |
| `Clon`, `Clon te haga` | `Haz que tu Clon te haga Viral` |
| `Contenido que vende`, `vende con IA` | `Contenido que Vende con IA` |
| Cualquier otro | nombre original del plan (fallback) |

La coincidencia es case-insensitive. Se aplica en el frontend sobre `selected.transactions` — sin nueva consulta a Supabase.

---

### 2. Card "Productos del Ecosistema" (nueva, panel derecho)

**Posición:** Entre el LTV hero y el score de prospección.

**Datos mostrados por fila de familia:**
- Nombre de la familia
- Cantidad de compras activas/delayed (`×N`)
- Badge 🔁 si `N >= 2` (repeat buyer)
- Badge ✓ verde si la familia está actualmente activa (basado en la suscripción activa del usuario)
- Indicador de qué familia es AIVI (para resaltar la oportunidad)

**Pie de la card:**
- Total de familias distintas compradas
- Total de compras activas en el ecosistema

**Lógica:**
```
familias = agrupar selected.transactions (solo active/delayed) por getProductFamily()
ordenar: AIVI primero, luego por count desc
```

**No requiere nueva consulta a Supabase** — usa `selected.transactions` ya cargado.

---

### 3. Card "Prospección AIVI" (reemplaza "Score de Retención", panel derecho)

Tiene dos estados mutuamente excluyentes:

#### Estado A — No tiene AIVI activo

Muestra:
- **Score numérico** 0–100
- **Etiqueta de calidad** del score
- **Lista de razones** ("Por qué ofrecerle AIVI") — texto dinámico basado en los datos reales del usuario
- **Botón "Contactar"** (mailto al email del usuario)
- **Botón "Copiar razones"** (copia las razones al portapapeles para usar en mensajes de WhatsApp/email)

**Cálculo del score:**

| Condición | Puntos |
|---|---|
| Tiene al menos 1 producto del ecosistema | +30 |
| Tiene Método V3 específicamente | +20 |
| 2 familias distintas compradas | +10 |
| 3+ familias distintas compradas | +15 (en lugar de +10) |
| Repeat buyer en alguna familia (×2+) | +15 |
| Estado activo en suscripción | +10 |
| LTV $300–$499 | +5 |
| LTV $500+ | +10 |
| 90+ días en el ecosistema | +5 |

**Máximo posible:** 100 pts (se normaliza si supera 100).

**Etiquetas:**
| Rango | Label | Color |
|---|---|---|
| 80–100 | 🔥 Listo para comprar | Verde |
| 55–79 | Buen prospecto | Naranja |
| 30–54 | Calentar primero | Amarillo |
| < 30 | No priorizar | Muted |

**Razones generadas dinámicamente** (se muestran solo las que aplican):
- `"Sin AIVI todavía — oportunidad directa de upsell"` (siempre, si no tiene AIVI)
- `"Tiene Método V3 activo — ya conoce el ecosistema"` (si tiene MV3)
- `"Ha comprado X productos distintos — confía en la marca"` (si familias >= 2)
- `"Ha renovado [familia] ×N — disposición de pago probada"` (si hay repeat buyer)
- `"Lleva X días en el ecosistema — relación establecida"` (si daysActive >= 30)
- `"LTV de $XXX — cliente de alto valor"` (si LTV >= 200)
- `"Suscripción activa — momento ideal para upsell"` (si status === active)

#### Estado B — Ya tiene AIVI activo

Muestra:
- Badge "✓ Ya es cliente AIVI"
- Plan de AIVI activo
- Foco en retención (mantiene el score de retención original: churn risk)

---

### 4. Filtro "Multi-producto" en el listado izquierdo

**Posición:** Nueva pestaña en la barra de filtros de programa, junto a `[Todos] [AIVI] [MV3] [Sin AIVI]`.

**Comportamiento:**
- Al activar, muestra solo usuarios con **2+ familias distintas** en su historial de transacciones activas
- Los usuarios se ordenan de mayor a menor cantidad de familias
- En la fila de cada usuario (listado izquierdo) se muestra un badge `N⬡` indicando cuántas familias distintas tiene

**Implementación:**
- El conteo de familias se calcula en el frontend sobre `users` ya cargados
- No requiere nueva consulta a Supabase
- El filtro `sinAIVI` y `Multi-producto` pueden coexistir (el combo "sin AIVI + multi-producto" es el segmento de mayor prioridad de prospección)

**Nota de UI:** El badge `N⬡` aparece en TODOS los modos de filtro, no solo en Multi-producto, para que siempre sea visible cuántos productos tiene cada usuario.

---

## Archivos a modificar

| Archivo | Cambio |
|---|---|
| `src/views/UsersView.tsx` | Agregar filtro multi-producto, badge N⬡ en listado, cards nuevas en panel derecho |
| `src/services/dashboard.ts` | Agregar función `getProductFamily()` y tipo `ProductFamily` |
| `src/types.ts` | Agregar `ProductFilter` actualizado con `"multiProducto"` |

---

## Lo que NO cambia

- La consulta a Supabase en `getUsersTraceability()` permanece igual
- El LTV hero (panel derecho superior) permanece igual
- El historial de pagos y calendario de actividad (panel central) permanecen igual
- El filtro `sinAIVI` existente permanece como está

---

## Criterios de éxito

1. Dado un usuario con MV3 ×3 y sin AIVI → score >= 75 y razones descriptivas visibles
2. Dado un usuario con AIVI activo → se muestra "Ya es cliente AIVI" y no el score
3. El filtro Multi-producto muestra solo usuarios con 2+ familias y los ordena correctamente
4. El badge `N⬡` es visible en todas las filas del listado
5. El botón "Copiar razones" funciona en mobile y desktop
