import { C } from "../../tokens";
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

  return (
    <div style={{
      display: "flex", alignItems: "center", gap: 8,
      padding: "0 24px", height: 44,
      background: C.bgSecondary,
      borderBottom: `1px solid ${C.border}`,
      flexShrink: 0, overflowX: "auto",
    }}>
      <span style={{
        fontSize: 10, fontWeight: 700, color: C.muted,
        textTransform: "uppercase", letterSpacing: "0.08em", flexShrink: 0,
      }}>VSL</span>

      <div style={{ display: "flex", gap: 4, alignItems: "center" }}>
        {vsls.map(v => {
          const isSelected = v.videoId === selectedId;
          const isCompare  = v.videoId === compareId;
          return (
            <button
              key={v.videoId}
              onClick={() => onSelect(v.videoId)}
              style={{
                padding: "4px 14px", borderRadius: 20,
                fontSize: 12, fontWeight: isSelected ? 700 : 400,
                border: `1px solid ${isSelected ? C.orange : isCompare ? C.yellow : C.border}`,
                background: isSelected ? `rgba(254,128,63,0.18)` : isCompare ? `rgba(255,194,82,0.12)` : "transparent",
                color: isSelected ? C.orange : isCompare ? C.yellow : C.mutedLight,
                cursor: "pointer", whiteSpace: "nowrap", transition: "all 0.15s",
              }}
            >
              {v.videoName}
            </button>
          );
        })}
      </div>

      {canCompare && (
        <>
          <div style={{ width: 1, height: 20, background: C.border, flexShrink: 0 }} />
          {compareId ? (
            <button
              onClick={() => onCompare(null)}
              style={{
                padding: "4px 12px", borderRadius: 20, fontSize: 11, fontWeight: 600,
                border: `1px solid ${C.border}`, background: "transparent",
                color: C.mutedMid, cursor: "pointer", whiteSpace: "nowrap",
              }}
            >
              × Comparación
            </button>
          ) : (
            <div style={{ display: "flex", gap: 4, alignItems: "center" }}>
              <span style={{ fontSize: 11, color: C.muted, whiteSpace: "nowrap" }}>
                + Comparar con:
              </span>
              {vsls
                .filter(v => v.videoId !== selectedId)
                .map(v => (
                  <button
                    key={v.videoId}
                    onClick={() => onCompare(v.videoId)}
                    style={{
                      padding: "4px 12px", borderRadius: 20, fontSize: 11,
                      border: `1px solid ${C.border}`, background: "transparent",
                      color: C.mutedMid, cursor: "pointer", whiteSpace: "nowrap",
                      transition: "all 0.15s",
                    }}
                  >
                    {v.videoName}
                  </button>
                ))}
            </div>
          )}
        </>
      )}
    </div>
  );
}
