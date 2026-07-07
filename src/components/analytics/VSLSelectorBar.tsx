import { useState, useMemo } from "react";
import { C, FONT } from "../../tokens";
import type { VSLData } from "../../services/analytics";

interface VSLSelectorBarProps {
  vsls:       VSLData[];
  selectedId: string | null;
  compareId:  string | null;
  onSelect:   (id: string) => void;
  onCompare:  (id: string | null) => void;
}

export function VSLSelectorBar({ vsls, selectedId, compareId, onSelect, onCompare }: VSLSelectorBarProps) {
  const canCompare = vsls.length >= 2;
  const [open,   setOpen]   = useState(false);
  const [query,  setQuery]  = useState("");

  const selected = vsls.find(v => v.videoId === selectedId) ?? null;

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return vsls;
    return vsls.filter(v => v.videoName.toLowerCase().includes(q));
  }, [vsls, query]);

  const handleOpen = () => { setOpen(true); setQuery(""); };
  const handlePick = (id: string) => { onSelect(id); setOpen(false); setQuery(""); };

  return (
    <div style={{
      display: "flex", alignItems: "center", height: 44,
      background: C.bgSecondary,
      borderBottom: `1px solid ${C.border}`,
      flexShrink: 0,
    }}>
      <div style={{
        display: "flex", alignItems: "center", gap: 12,
        flex: 1, minWidth: 0, padding: "0 16px 0 24px",
      }}>
        <span style={{
          fontSize: 10, fontWeight: 700, color: C.muted,
          textTransform: "uppercase", letterSpacing: "0.08em", flexShrink: 0,
        }}>VSL</span>

        <div style={{ position: "relative" }}>
          <button
            onClick={handleOpen}
            style={{
              display: "flex", alignItems: "center", gap: 8,
              padding: "4px 14px", borderRadius: 20, maxWidth: 360,
              fontSize: 12, fontWeight: 700,
              border: `1px solid ${C.orange}`, background: "rgba(254,128,63,0.18)",
              color: C.orange, cursor: "pointer", fontFamily: FONT,
            }}
          >
            <span style={{ overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
              {selected?.videoName ?? "Selecciona un VSL..."}
            </span>
            <span style={{ color: C.mutedMid, fontSize: 10, flexShrink: 0 }}>▾</span>
          </button>

          {open && (
            <>
              <div style={{ position: "fixed", inset: 0, zIndex: 149 }} onClick={() => setOpen(false)} />
              <div style={{
                position: "absolute", top: "calc(100% + 6px)", left: 0, zIndex: 150,
                background: C.panel, border: `1px solid ${C.border}`, borderRadius: 12,
                width: "min(320px, 90vw)", maxHeight: 360, display: "flex", flexDirection: "column",
                boxShadow: "0 8px 24px rgba(0,0,0,0.4)", overflow: "hidden",
              }}>
                <input
                  autoFocus
                  value={query}
                  onChange={e => setQuery(e.target.value)}
                  placeholder="Buscar VSL..."
                  style={{
                    margin: 10, padding: "8px 10px", borderRadius: 8,
                    background: C.bgSecondary, border: `1px solid ${C.border}`,
                    color: C.white, fontSize: 12, fontFamily: FONT, outline: "none",
                  }}
                />
                <div style={{ overflowY: "auto", padding: "0 6px 6px" }}>
                  {filtered.map(v => {
                    const isSelected = v.videoId === selectedId;
                    return (
                      <button
                        key={v.videoId}
                        onClick={() => handlePick(v.videoId)}
                        style={{
                          display: "block", width: "100%", textAlign: "left",
                          padding: "8px 10px", borderRadius: 6, border: "none",
                          background: isSelected ? "rgba(254,128,63,0.14)" : "transparent",
                          color: isSelected ? C.orange : C.mutedLight,
                          fontWeight: isSelected ? 700 : 400,
                          fontSize: 12, fontFamily: FONT, cursor: "pointer",
                          overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap",
                        }}
                      >
                        {v.videoName}
                      </button>
                    );
                  })}
                  {filtered.length === 0 && (
                    <div style={{ padding: "16px 10px", textAlign: "center", fontSize: 12, color: C.mutedMid }}>
                      Sin resultados para "{query}"
                    </div>
                  )}
                </div>
              </div>
            </>
          )}
        </div>
      </div>

      {/* Compare — siempre visible a la derecha */}
      {canCompare && (
        <div style={{
          display: "flex", alignItems: "center", gap: 8,
          flexShrink: 0, padding: "0 24px 0 12px",
          borderLeft: `1px solid ${C.border}`, height: "100%",
        }}>
          {compareId ? (
            <button
              onClick={() => onCompare(null)}
              style={{
                padding: "4px 12px", borderRadius: 20, fontSize: 11, fontWeight: 600,
                border: `1px solid ${C.border}`, background: "transparent",
                color: C.yellow, cursor: "pointer", whiteSpace: "nowrap",
              }}
            >
              × VS {vsls.find(v => v.videoId === compareId)?.videoName}
            </button>
          ) : (
            <>
              <span style={{ fontSize: 11, color: C.muted, whiteSpace: "nowrap" }}>VS</span>
              <select
                value=""
                onChange={e => e.target.value && onCompare(e.target.value)}
                style={{
                  background: C.bgSecondary, border: `1px solid ${C.border}`,
                  borderRadius: 8, padding: "3px 8px", color: C.mutedLight,
                  fontSize: 11, cursor: "pointer", maxWidth: 200,
                }}
              >
                <option value="">Comparar con…</option>
                {vsls
                  .filter(v => v.videoId !== selectedId)
                  .map(v => (
                    <option key={v.videoId} value={v.videoId}>{v.videoName}</option>
                  ))}
              </select>
            </>
          )}
        </div>
      )}
    </div>
  );
}
