# Fuente de Tráfico con CAC/ROAS/Veredicto en VSLIntelligencePanel

**Fecha:** 2026-07-04
**Estado:** Aprobado

## Resumen

Hoy la decisión "¿escalar o apagar este anuncio?" vive en dos componentes separados y duplicados (`ScaleRadar`, `AdsRankingTable`) fuera del panel del VSL, y muestran el portafolio completo de anuncios de todos los VSLs a la vez. La pestaña "Fuente de tráfico" dentro de `VSLIntelligencePanel` solo muestra conversiones por campaña, sin inversión/CAC/ROAS.

Este cambio fusiona las 3 cosas que se necesitan ver por VSL — retención, de qué anuncio llegó el tráfico, y si es viable escalarlo o apagarlo — dentro de un solo lugar: el panel del VSL seleccionado. Se elimina la vista de portafolio (todos los VSLs a la vez); la navegación siempre parte de seleccionar un VSL en `VSLSelectorBar`.

No requiere cambios de base de datos ni de Edge Functions — todos los datos (inversión, CAC, ROAS, ventas, score, videoId por campaña) ya existen en `AdRankRow` vía `getAdsRanking`.

---

## 1. Lógica de clasificación (nueva fuente única de verdad)

Hoy `classify` (`ScaleRadar.tsx`) y `classifyRow` (`AdsRankingTable.tsx`) son copias idénticas. Se extrae una sola vez:

```typescript
// src/services/analytics.ts
export type AdAction = "ESCALAR" | "PAUSAR" | "MONITOREAR";

export function classifyAd(r: AdRankRow, cacTarget: number, ticketMin: number): AdAction {
  const avgTicket = r.sales > 0 && r.investment > 0 ? (r.investment * r.roas) / r.sales : 0;
  const ticketOk  = ticketMin === 0 || avgTicket >= ticketMin;
  if (r.sales >= 1 && r.cac > 0 && r.cac <= cacTarget && r.roas >= 2.0 && ticketOk) return "ESCALAR";
  if ((r.cac > 0 && r.cac > cacTarget * 1.5) || (r.roas < 1.0 && r.investment > 0)) return "PAUSAR";
  return "MONITOREAR";
}
```

Umbrales sin cambios: mismo comportamiento que hoy, solo se deja de duplicar.

---

## 2. `VSLIntelligencePanel.tsx`

### Props nuevas

```typescript
interface Props {
  primary:    VSLData | null;
  compare?:   VSLData | null;
  range:      DateRange | null;
  ranking:    AdRankRow[];   // nuevo — ranking completo (todos los VSLs), ya cargado en AnalyticsView
  cacTarget:  number;        // nuevo
  ticketMin:  number;        // nuevo
}
```

### Pestaña "Fuente de tráfico" (reemplaza `SourceView`)

- Se deja de llamar `getVSLBySource` (fetch async) para este tab. En su lugar:
  ```typescript
  const adsForThisVsl = useMemo(
    () => ranking.filter(r => r.videoId === primary.videoId),
    [ranking, primary.videoId],
  );
  ```
- Nuevo subcomponente `AdSourceView({ rows: AdRankRow[], cacTarget, ticketMin })`, adaptado del look de `AdsRankingTable` pero compacto para caber en el ancho del panel. Por cada anuncio: nombre de campaña, inversión, ventas, CAC, ROAS, score, y badge de veredicto (`ESCALAR`/`PAUSAR`/`MONITOREAR` con los mismos colores/estilo que hoy).
- Como los datos ya están en memoria (vienen de `ranking`, cargado por `AnalyticsView`), este tab ya no dispara `dimLoading` ni usa `DimSkeleton` — el cambio de tab es instantáneo.
- Vacío: si `adsForThisVsl.length === 0`, reusar el patrón `DimEmpty` con mensaje "Sin anuncios atribuidos a este VSL en el período. Verifica el mapeo campaña→VSL arriba."

### Pestaña "Retención general"

Sin cambios — ya corresponde a la curva de retención tipo VTurb que se mostró como referencia.

### Limpieza

- Se elimina `SourceView` (función local).
- Se elimina el caso `source` dentro de `fetchTab`'s `fetchers` record y su import de `getVSLBySource`.

---

## 3. `AnalyticsView.tsx`

### Se elimina

- Imports y renders de `<ScaleRadar />` y `<AdsRankingTable />`.
- El memo `filteredRanking` (queda sin uso tras borrar los dos componentes — `VSLIntelligencePanel` ahora filtra `ranking` internamente por `primary.videoId`).

### Se mueve a la barra superior (junto a los pills de periodo)

- Input "CAC objetivo $" (`cacTarget` / `setCacTarget`, ya existe como estado).
- Input "Ticket mín. $" (`ticketMin` / `setTicketMin`, ya existe como estado).
- Botón "Configurar VSLs" → sigue abriendo `CampaignMappingModal` (`mappingOpen`/`setMappingOpen`, sin cambios).

### Se pasa a `VSLIntelligencePanel`

```tsx
<VSLIntelligencePanel
  primary={selectedVsl}
  compare={compareVsl}
  range={range}
  ranking={ranking}
  cacTarget={cacTarget}
  ticketMin={ticketMin}
/>
```

`ranking` se pasa completo (sin filtrar) — el filtrado por VSL ahora vive dentro del panel.

---

## 4. Archivos eliminados

| Archivo | Motivo |
|---|---|
| `src/components/analytics/ScaleRadar.tsx` | Lógica fusionada en `VSLIntelligencePanel` |
| `src/components/analytics/AdsRankingTable.tsx` | Lógica fusionada en `VSLIntelligencePanel` |

## 5. Archivos modificados

| Archivo | Cambio |
|---|---|
| `src/services/analytics.ts` | Agrega `AdAction` + `classifyAd` exportado. Elimina `getVSLBySource` si no tiene otros consumidores (verificar con grep antes de borrar). |
| `src/components/analytics/VSLIntelligencePanel.tsx` | Nuevas props (`ranking`, `cacTarget`, `ticketMin`), nuevo `AdSourceView`, elimina `SourceView` y el fetch de `source`. |
| `src/views/AnalyticsView.tsx` | Elimina renders de `ScaleRadar`/`AdsRankingTable` y `filteredRanking`; mueve controles de CAC/Ticket/Configurar VSLs a la barra superior; pasa `ranking`/`cacTarget`/`ticketMin` al panel. |

---

## Criterios de éxito

- Seleccionar un VSL en `VSLSelectorBar` y abrir la pestaña "Fuente de tráfico" muestra exactamente los mismos anuncios/valores que hoy muestra `AdsRankingTable` filtrado por ese `videoId` (paridad de datos antes de borrar los componentes viejos).
- Cambiar de pestaña dentro del panel no dispara loading para "Fuente de tráfico" (los datos ya están en memoria).
- Cambiar "CAC objetivo $" / "Ticket mín $" en la barra superior actualiza el veredicto en la pestaña sin recargar la página.
- Sin VSL seleccionado, el panel muestra su placeholder existente ("Selecciona un VSL...") — ya no existe una vista de portafolio de todos los anuncios.
- No quedan referencias muertas a `ScaleRadar`, `AdsRankingTable`, `getVSLBySource`, ni a `classify`/`classifyRow` duplicados.
