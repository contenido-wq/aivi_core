import { useState, useEffect } from "react";
import { C } from "../../tokens";
import { saveVSLMapping, deleteVSLMapping, getAvailableVideos, DEFAULT_VSL_CAMPAIGN } from "../../services/analytics";
import type { VSLMapping, VTurbVideo } from "../../services/analytics";

interface Props {
  open:      boolean;
  onClose:   () => void;
  mappings:  VSLMapping[];
  campaigns: string[];
  onSaved:   () => void;
}

export function CampaignMappingModal({ open, onClose, mappings, campaigns, onSaved }: Props) {
  const [newCampaign, setNewCampaign] = useState("");
  const [newVideoId,  setNewVideoId]  = useState("");
  const [saving,       setSaving]      = useState(false);
  const [videos,       setVideos]      = useState<VTurbVideo[]>([]);
  const [videosState,  setVideosState] = useState<"idle" | "loading" | "ready" | "error">("idle");
  const [filterVideoId, setFilterVideoId] = useState("");

  useEffect(() => {
    if (open) {
      setVideosState("loading");
      getAvailableVideos()
        .then(v => { setVideos(v); setVideosState("ready"); })
        .catch(() => { setVideos([]); setVideosState("error"); });
    } else {
      setFilterVideoId("");
    }
  }, [open]);

  if (!open) return null;

  const unmapped        = campaigns.filter(c => !mappings.find(m => m.campaignName === c));
  const selectedName    = videos.find(v => v.videoId === newVideoId)?.videoName ?? newVideoId;
  const visibleMappings = filterVideoId ? mappings.filter(m => m.videoId === filterVideoId) : mappings;

  const handleSave = async () => {
    if (!newCampaign || !newVideoId) return;
    setSaving(true);
    try {
      await saveVSLMapping({ campaignName: newCampaign, videoId: newVideoId, videoName: selectedName });
      setNewCampaign(""); setNewVideoId("");
      onSaved();
    } finally { setSaving(false); }
  };

  const handleDelete = async (campaignName: string) => {
    await deleteVSLMapping(campaignName);
    onSaved();
  };

  const sel = {
    background: C.bgSecondary, border: `1px solid ${C.border}`,
    borderRadius: 8, padding: "8px 12px", color: C.white, fontSize: 12, width: "100%",
  } as const;

  return (
    <div style={{ position: "fixed", inset: 0, background: "rgba(0,0,0,0.7)", display: "flex", alignItems: "center", justifyContent: "center", zIndex: 200 }}
      onClick={onClose}>
      <div style={{ background: C.panel, border: `1px solid ${C.border}`, borderRadius: 16, width: 560, maxHeight: "80vh", overflowY: "auto", padding: 28 }}
        onClick={e => e.stopPropagation()}>
        <div style={{ fontSize: 16, fontWeight: 700, color: C.white, marginBottom: 20 }}>Configurar Campaña → VSL</div>

        <select value={filterVideoId} onChange={e => setFilterVideoId(e.target.value)} style={{ ...sel, marginBottom: 16 }}>
          <option value="">Todos los VSLs</option>
          {videos.map(v => (
            <option key={v.videoId} value={v.videoId}>{v.videoName}</option>
          ))}
        </select>

        {visibleMappings.map(m => (
          <div key={m.campaignName} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "10px 12px", background: C.card, borderRadius: 8, marginBottom: 6 }}>
            <div>
              <div style={{ fontSize: 13, color: C.white }}>
                {m.campaignName === DEFAULT_VSL_CAMPAIGN ? "🔹 VSL por defecto (todo el tráfico sin mapear)" : m.campaignName}
              </div>
              <div style={{ fontSize: 11, color: C.mutedMid }}>{m.videoName}</div>
            </div>
            <button onClick={() => handleDelete(m.campaignName)} style={{ background: "rgba(255,65,59,0.12)", border: "none", color: "#FF413B", borderRadius: 6, padding: "4px 10px", fontSize: 11, cursor: "pointer" }}>
              Eliminar
            </button>
          </div>
        ))}
        {visibleMappings.length === 0 && (
          <div style={{ fontSize: 12, color: C.mutedMid, textAlign: "center", padding: 16 }}>
            {filterVideoId ? "Sin campañas mapeadas a este VSL" : "Sin mapeos configurados"}
          </div>
        )}

        <div style={{ borderTop: `1px solid ${C.border}`, paddingTop: 16, marginTop: 8 }}>
          <div style={{ fontSize: 13, color: C.mutedLight, marginBottom: 12 }}>Añadir nuevo mapeo</div>
          <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
            <select value={newCampaign} onChange={e => setNewCampaign(e.target.value)} style={sel}>
              <option value="">Selecciona campaña...</option>
              {!mappings.find(m => m.campaignName === DEFAULT_VSL_CAMPAIGN) && (
                <option value={DEFAULT_VSL_CAMPAIGN}>— VSL por defecto (todo el tráfico sin mapear) —</option>
              )}
              {unmapped.map(c => <option key={c} value={c}>{c}</option>)}
            </select>

            <select value={newVideoId} onChange={e => setNewVideoId(e.target.value)} style={sel}>
              <option value="">Selecciona video VSL...</option>
              {videos.map(v => (
                <option key={v.videoId} value={v.videoId}>{v.videoName}</option>
              ))}
            </select>
            {videosState === "loading" && (
              <div style={{ fontSize: 11, color: C.mutedMid }}>Cargando videos disponibles…</div>
            )}
            {videosState === "error" && (
              <div style={{ fontSize: 11, color: C.red }}>No se pudieron cargar los videos de VTurb</div>
            )}
            {videosState === "ready" && videos.length === 0 && (
              <div style={{ fontSize: 11, color: C.mutedMid }}>Sin videos registrados en VTurb aún</div>
            )}

            <button onClick={handleSave} disabled={saving || !newCampaign || !newVideoId}
              style={{ background: C.orange, border: "none", borderRadius: 8, padding: "10px 0", color: C.white, fontSize: 13, fontWeight: 600, cursor: "pointer", opacity: !newCampaign || !newVideoId ? 0.5 : 1 }}>
              {saving ? "Guardando..." : "Guardar Mapeo"}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
