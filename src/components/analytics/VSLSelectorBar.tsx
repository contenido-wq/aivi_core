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
      display: "flex", alignItems: "center", height: 44,
      background: C.bgSecondary,
      borderBottom: `1px solid ${C.border}`,
      flexShrink: 0, overflow: "hidden",
    }}>
      {/* Chips — scrollable */}
      <div style={{
        display: "flex", alignItems: "center", gap: 8,
        flex: 1, overflowX: "auto", minWidth: 0,
        padding: "0 16px 0 24px",
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
