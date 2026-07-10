# Filtro de VSL en "Configurar Campaña → VSL"

**Fecha:** 2026-07-05
**Estado:** Aprobado

## Resumen

El modal `CampaignMappingModal` muestra siempre la lista completa de mapeos campaña→VSL, sin forma de ver solo los de un VSL específico. Se agrega un selector "Filtrar por VSL" arriba de esa lista: sin selección muestra todo (comportamiento actual sin cambios); con un VSL elegido, muestra solo las campañas ya mapeadas a ese VSL. El formulario "Añadir nuevo mapeo" (crear un mapeo campaña→VSL uno a la vez) no cambia.

## Diseño

**Archivo:** `src/components/analytics/CampaignMappingModal.tsx`

- Nuevo estado local `filterVideoId: string` (default `""`).
- Nuevo `<select>` "Filtrar por VSL" entre el título del modal y la lista de mapeos, con opciones: "Todos los VSLs" (value `""`) + una opción por cada VSL en `videos` (ya se obtiene vía `getAvailableVideos()` al abrir el modal — mismo estado `videos` que ya usa el selector de "Añadir nuevo mapeo").
- La lista de mapeos existentes pasa de `mappings.map(...)` a `visibleMappings.map(...)`, donde `visibleMappings = filterVideoId ? mappings.filter(m => m.videoId === filterVideoId) : mappings`.
- Mensaje de "sin mapeos" se ajusta: si `filterVideoId` está activo y `visibleMappings` queda vacío, mostrar "Sin campañas mapeadas a este VSL" en vez del genérico "Sin mapeos configurados".
- El filtro se resetea a `""` cada vez que el modal se cierra y se vuelve a abrir (mismo patrón ya usado para `newCampaign`/`newVideoId` — aunque esos se resetean solo al guardar; el filtro se resetea al cerrar).

## Criterios de éxito

- Sin filtro seleccionado, el modal se comporta exactamente igual que hoy.
- Con un VSL elegido en el filtro, solo se ven sus campañas mapeadas.
- El formulario de abajo ("Añadir nuevo mapeo") sigue funcionando sin cambios, independiente del filtro de arriba.
- Elegir un VSL en el filtro que no tiene ninguna campaña mapeada muestra un mensaje claro, no una lista vacía sin explicación.
