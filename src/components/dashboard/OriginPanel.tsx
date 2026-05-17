import { C } from "../../tokens";
import { Card } from "../ui/Card";

// Mock data — needs "user_locations" table in Supabase
const TOP_COUNTRIES = [
  { name: "México",    flag: "🇲🇽", count: 1234 },
  { name: "Colombia",  flag: "🇨🇴", count: 987  },
  { name: "Perú",      flag: "🇵🇪", count: 654  },
  { name: "España",    flag: "🇪🇸", count: 432  },
  { name: "Argentina", flag: "🇦🇷", count: 321  },
];

export function OriginPanel() {
  const maxCount = Math.max(...TOP_COUNTRIES.map(c => c.count));

  return (
    <Card style={{ padding: "20px 24px" }}>
      <h3 style={{ fontSize: 16, fontWeight: 600, color: C.white, margin: "0 0 16px 0" }}>
        Top países
      </h3>

      <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
        {TOP_COUNTRIES.map((c, i) => (
          <div key={c.name} style={{ display: "flex", alignItems: "center", gap: 8 }}>
            <span style={{ fontSize: 11, color: C.mutedMid, width: 14 }}>{i + 1}</span>
            <span style={{ fontSize: 14 }}>{c.flag}</span>
            <span style={{ fontSize: 13, color: C.white, flex: 1, fontWeight: 500 }}>{c.name}</span>
            {/* Bar */}
            <div style={{
              width: 50, height: 4, background: "rgba(255,255,255,0.06)",
              borderRadius: 2, overflow: "hidden",
            }}>
              <div style={{
                height: "100%",
                width: `${(c.count / maxCount) * 100}%`,
                background: C.orange,
                borderRadius: 2,
              }} />
            </div>
            <span style={{
              fontSize: 12, color: C.mutedLight,
              width: 40, textAlign: "right", fontWeight: 500,
            }}>
              {c.count.toLocaleString()}
            </span>
          </div>
        ))}
      </div>
    </Card>
  );
}
