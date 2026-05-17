/**
 * Conversión de monedas a USD usando tasas de cambio en tiempo real.
 * Usa la API gratuita de ExchangeRate-API con caché de 1 hora.
 * Si la API falla, usa tasas de respaldo.
 */

// Tasas de respaldo (se usan solo si la API falla)
const FALLBACK_RATES: Record<string, number> = {
  USD: 1,
  BRL: 0.18,
  COP: 0.00023,
  MXN: 0.058,
  ARS: 0.00088,
  CLP: 0.00105,
  PEN: 0.27,
  EUR: 1.09,
  GBP: 1.27,
  CAD: 0.74,
  AUD: 0.66,
  UYU: 0.024,
  PYG: 0.00013,
  BOB: 0.14,
  GTQ: 0.13,
  CRC: 0.0019,
  VES: 0.027,
  PAB: 1,
};

interface RatesCache {
  rates: Record<string, number>; // conversion_rates from API: 1 USD = X currency
  fetchedAt: number;
}

const CACHE_TTL = 60 * 60 * 1000; // 1 hora
let cache: RatesCache | null = null;
let fetchPromise: Promise<Record<string, number>> | null = null;

/**
 * Obtiene tasas de cambio actualizadas desde la API.
 * Usa caché de 1 hora para no sobrecargar la API.
 */
async function fetchRates(): Promise<Record<string, number>> {
  // Si tenemos caché válido, usarlo
  if (cache && Date.now() - cache.fetchedAt < CACHE_TTL) {
    return cache.rates;
  }

  // Evitar múltiples fetches simultáneos
  if (fetchPromise) return fetchPromise;

  fetchPromise = (async () => {
    try {
      // API gratuita: https://open.er-api.com/v6/latest/USD
      const res = await fetch("https://open.er-api.com/v6/latest/USD");
      if (!res.ok) throw new Error(`API error: ${res.status}`);

      const data = await res.json();
      if (data.result !== "success" || !data.rates) {
        throw new Error("Invalid API response");
      }

      // data.rates = { USD: 1, BRL: 5.5, COP: 4350, ... } (1 USD = X moneda)
      // Necesitamos invertir: 1 moneda = X USD
      const ratesToUsd: Record<string, number> = {};
      for (const [currency, rate] of Object.entries(data.rates)) {
        ratesToUsd[currency] = 1 / (rate as number);
      }
      ratesToUsd["USD"] = 1;

      cache = { rates: ratesToUsd, fetchedAt: Date.now() };
      console.log("✅ Tasas de cambio actualizadas:", new Date().toLocaleTimeString());
      return ratesToUsd;
    } catch (err) {
      console.warn("⚠️ Error obteniendo tasas de cambio, usando respaldo:", err);
      // Usar tasas de respaldo
      if (!cache) {
        cache = { rates: FALLBACK_RATES, fetchedAt: Date.now() - CACHE_TTL + 5 * 60 * 1000 };
        // Reintentar en 5 min si falla
      }
      return cache.rates;
    } finally {
      fetchPromise = null;
    }
  })();

  return fetchPromise;
}

// Pre-cargar tasas al importar el módulo
const initialFetch = fetchRates();

/**
 * Espera a que las tasas estén cargadas.
 * Llamar antes de hacer conversiones para garantizar precisión.
 */
export async function ensureRatesLoaded(): Promise<void> {
  await initialFetch;
}

/**
 * Convierte un monto de una moneda a USD usando tasas en tiempo real.
 * Usa caché o tasas de respaldo si la API no está disponible.
 */
export function toUSD(amount: number, currency: string | null | undefined): number {
  if (!amount || isNaN(amount)) return 0;
  if (!currency || currency === "USD") return amount;

  const upperCurrency = currency.toUpperCase();

  // Usar caché sincronizado si está disponible
  if (cache) {
    const rate = cache.rates[upperCurrency];
    if (rate) return Math.round(amount * rate * 100) / 100;
  }

  // Respaldo si no hay caché
  const fallback = FALLBACK_RATES[upperCurrency];
  if (fallback) return Math.round(amount * fallback * 100) / 100;

  // Moneda desconocida → asumir USD
  return amount;
}

/**
 * Versión async de toUSD que garantiza tener tasas actualizadas.
 * Usar en la capa de servicio para mayor precisión.
 */
export async function toUSDAsync(amount: number, currency: string | null | undefined): Promise<number> {
  if (!amount || isNaN(amount)) return 0;
  if (!currency || currency === "USD") return amount;

  const rates = await fetchRates();
  const upperCurrency = currency.toUpperCase();
  const rate = rates[upperCurrency];

  if (rate) return Math.round(amount * rate * 100) / 100;

  return amount; // moneda desconocida
}

/**
 * Formatea un número como dólares americanos.
 */
export function formatUSD(amount: number, decimals = 2): string {
  return `$${amount.toLocaleString("en-US", {
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals,
  })}`;
}

/**
 * Forzar recarga de tasas (útil para botón manual).
 */
export async function refreshRates(): Promise<void> {
  cache = null;
  await fetchRates();
}
