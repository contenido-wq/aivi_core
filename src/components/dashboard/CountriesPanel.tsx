import { C } from "../../tokens";
import { Card } from "../ui/Card";
import type { CountryRow } from "../../services/dashboard";

interface CountriesPanelProps { countries: CountryRow[]; }

export function CountriesPanel({ countries }: CountriesPanelProps) {
  const maxSales = Math.max(...countries.map(c => c.sales), 1);

  return (
    <Card style={{ padding: "16px 18px", display: "flex", flexDirection: "column", overflow: "hidden", minHeight: 0 }}>
      <div style={{ fontWeight: 800, fontSize: 12, marginBottom: 10, color: C.white, flexShrink: 0 }}>
        🌎 Compradores por País
        <span style={{ color: C.muted, fontWeight: 400, fontSize: 10, marginLeft: 6 }}>
          ({countries.length})
        </span>
      </div>

      {countries.length === 0 ? (
        <div style={{ color: C.muted, fontSize: 12, textAlign: "center", padding: "20px 0" }}>Sin datos</div>
      ) : (
        <div style={{ overflow: "auto", flex: 1, minHeight: 0 }}>
          {countries.map((c, i) => (
            <div key={i} style={{ marginBottom: 11 }}>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 4 }}>
                <div style={{ display: "flex", alignItems: "center", gap: 7 }}>
                  <span style={{ fontSize: 15 }}>{c.flag}</span>
                  <span style={{ fontSize: 11, fontWeight: 700, color: C.white }}>{c.country}</span>
                </div>
                <div style={{ textAlign: "right" }}>
                  <span style={{ fontSize: 11, fontWeight: 800, color: C.green }}>${c.total.toFixed(2)}</span>
                  <span style={{ fontSize: 8, color: C.muted, marginLeft: 2 }}>USD</span>
                  <span style={{ fontSize: 9, color: C.muted, marginLeft: 5 }}>{c.sales}</span>
                </div>
              </div>
              <div style={{ height: 3, background: "rgba(255,255,255,0.06)", borderRadius: 2, overflow: "hidden" }}>
                <div style={{
                  height: "100%",
                  width: `${(c.sales / maxSales) * 100}%`,
                  background: C.orange,
                  borderRadius: 2,
                  transition: "width 0.5s ease",
                }} />
              </div>
            </div>
          ))}
        </div>
      )}
    </Card>
  );
}
