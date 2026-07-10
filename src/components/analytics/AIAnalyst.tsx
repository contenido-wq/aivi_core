import { C } from "../../tokens";

interface Props {
  result:    string | null;
  loading:   boolean;
  onAnalyze: () => void;
}

export function AIAnalyst({ result, loading, onAnalyze }: Props) {
  const sections = result
    ? result.split(/(?=## )/).filter(Boolean).map(s => {
        const nl = s.indexOf("\n");
        return { title: s.slice(0, nl).replace(/^## /, "").trim(), body: s.slice(nl).trim() };
      })
    : [];

  return (
    <div style={{ background: C.card, border: `1px solid ${C.border}`, borderRadius: 14, padding: 20 }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
        <div>
          <div style={{ fontSize: 14, fontWeight: 600, color: C.white }}>Inteligencia Accionable</div>
          <div style={{ fontSize: 12, color: C.mutedMid, marginTop: 2 }}>Claude analiza el período y te dice exactamente qué hacer</div>
        </div>
        <button onClick={onAnalyze} disabled={loading} style={{
          background: loading ? C.cardHover : C.orange,
          border: "none", borderRadius: 10, padding: "10px 20px",
          color: C.white, fontSize: 13, fontWeight: 600,
          cursor: loading ? "default" : "pointer", opacity: loading ? 0.7 : 1,
        }}>
          {loading ? "Analizando..." : "Regenerar análisis"}
        </button>
      </div>

      {loading && (
        <div style={{ display: "flex", alignItems: "center", gap: 10, padding: 16 }}>
          <div style={{ width: 20, height: 20, borderRadius: "50%", border: `2px solid ${C.border}`, borderTopColor: C.orange, animation: "spin 0.8s linear infinite" }} />
          <span style={{ fontSize: 13, color: C.mutedMid }}>Claude está analizando tus datos...</span>
          <style>{`@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`}</style>
        </div>
      )}

      {sections.length > 0 && !loading && (
        <div style={{ position: "relative" }}>
          <div style={{ background: C.bgSecondary, borderRadius: 10, padding: 16 }}>
            {sections.map((s, i) => (
              <div key={i} style={{ marginBottom: i < sections.length - 1 ? 20 : 0 }}>
                <div style={{ fontSize: 14, fontWeight: 700, color: C.orange, marginBottom: 8 }}>## {s.title}</div>
                <div style={{ fontSize: 13, color: C.mutedLight, lineHeight: 1.7, whiteSpace: "pre-wrap" }}>{s.body}</div>
              </div>
            ))}
          </div>
          <button onClick={() => result && navigator.clipboard.writeText(result)} style={{
            position: "absolute", top: 10, right: 10,
            background: C.card, border: `1px solid ${C.border}`,
            borderRadius: 6, padding: "4px 10px", fontSize: 11, color: C.mutedMid, cursor: "pointer",
          }}>Copiar</button>
        </div>
      )}

      {!result && !loading && (
        <div style={{ fontSize: 13, color: C.muted, textAlign: "center", padding: "20px 0" }}>
          El análisis se genera automáticamente al cambiar de período
        </div>
      )}
    </div>
  );
}
