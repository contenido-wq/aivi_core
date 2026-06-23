import { useState } from "react";
import { C } from "../../tokens";
import { saveVSLMapping, deleteVSLMapping } from "../../services/analytics";
import type { VSLMapping } from "../../services/analytics";

interface Props {
  open:      boolean;
  onClose:   () => void;
  mappings:  VSLMapping[];
  campaigns: string[];
  onSaved:   () => void;
}

export function CampaignMappingModal({ open, onClose, mappings, campaigns, onSaved }: Props) {
  const [newCampaign,  setNewCampaign]  = useState("");
  const [newVideoId,   setNewVideoId]   = useState("");
  const [newVideoName, setNewVideoName] = useState("");
  const [saving,       setSaving]       = useState(false);

  if (!open) return null;

  const unmapped = campaigns.filter(c => !mappings.find(m => m.campaignName === c));

  const handleSave = async () => {
    if (!newCampaign || !newVideoId) return;
    setSaving(true);
    try {
      await saveVSLMapping({ campaignName: newCampaign, videoId: newVideoId, videoName: newVideoName || newVideoId });
      setNewCampaign(""); setNewVideoId(""); setNewVideoName("");
      onSaved();
    } finally { setSaving(false); }
  };

  const handleDelete = async (campaignName: string) => {
    await deleteVSLMapping(campaignName);
    onSaved();
  };

  return (
    <div style={{ position: "fixed", inset: 0, background: "rgba(0,0,0,0.7)", display: "flex", alignItems: "center", justifyContent: "center", zIndex: 200 }}
      onClick={onClose}>
      <div style={{ background: C.panel, border: `1px solid ${C.border}`, borderRadius: 16, width: 560, maxHeight: "80vh", overflowY: "auto", padding: 28 }}
        onClick={e => e.stopPropagation()}>
        <div style={{ fontSize: 16, fontWeight: 700, color: C.white, marginBottom: 20 }}>Configurar Campaña → VSL</div>

        {mappings.map(m => (
          <div key={m.campaignName} style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "10px 12px", background: C.card, borderRadius: 8, marginBottom: 6 }}>
            <div>
              <div style={{ fontSize: 13, color: C.white }}>{m.campaignName}</div>
              <div style={{ fontSize: 11, color: C.mutedMid }}>{m.videoName} ({m.videoId})</div>
            </div>
            <button onClick={() => handleDelete(m.campaignName)} style={{ background: "rgba(255,65,59,0.12)", border: "none", color: "#FF413B", borderRadius: 6, padding: "4px 10px", fontSize: 11, cursor: "pointer" }}>
              Eliminar
            </button>
          </div>
        ))}
        {mappings.length === 0 && <div style={{ fontSize: 12, color: C.mutedMid, textAlign: "center", padding: 16 }}>Sin mapeos configurados</div>}

        <div style={{ borderTop: `1px solid ${C.border}`, paddingTop: 16, marginTop: 8 }}>
          <div style={{ fontSize: 13, color: C.mutedLight, marginBottom: 12 }}>Añadir nuevo mapeo</div>
          <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
            <select value={newCampaign} onChange={e => setNewCampaign(e.target.value)}
              style={{ background: C.bgSecondary, border: `1px solid ${C.border}`, borderRadius: 8, padding: "8px 12px", color: C.white, fontSize: 12 }}>
              <option value="">Selecciona campaña...</option>
              {unmapped.map(c => <option key={c} value={c}>{c}</option>)}
            </select>
            <input placeholder="Video ID de VTurb" value={newVideoId} onChange={e => setNewVideoId(e.target.value)}
              style={{ background: C.bgSecondary, border: `1px solid ${C.border}`, borderRadius: 8, padding: "8px 12px", color: C.white, fontSize: 12 }} />
            <input placeholder="Nombre del VSL (opcional)" value={newVideoName} onChange={e => setNewVideoName(e.target.value)}
              style={{ background: C.bgSecondary, border: `1px solid ${C.border}`, borderRadius: 8, padding: "8px 12px", color: C.white, fontSize: 12 }} />
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
