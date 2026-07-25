-- ============================================================
-- REZZONANTE PRODUCCIONES — Análisis de Datos
-- Análisis 4 de 4 — Sedes y géneros: qué formato rinde más
-- Eleazar Soto | 2017-2026
-- ============================================================
-- Base de datos: Rezzonante_Producciones.db (SQLite)
-- Versión: v57 — incluye patrocinios en efectivo
-- ============================================================
--
-- CoNVO (Shron — Thinking with Data)
--   Contexto: Rezzonante ha operado en más de 20 sedes y 9 géneros
--             musicales en 9 años.
--   Necesidad: ¿qué sede genera más ingreso, qué género tiene mejor
--              margen, y hay una combinación que se destaque?
--   Visión: ranking de sedes por ingreso, ranking de géneros por
--           margen %, y el cruce sede+género.
--   Outcome: recomendación concreta de dónde y qué programar en
--            2027 para maximizar impacto financiero.
--
-- ============================================================


-- ------------------------------------------------------------
-- Query 1 — Ingreso y eventos por sede
-- ------------------------------------------------------------
SELECT
    sede,
    COUNT(DISTINCT evento_id) AS eventos,
    ROUND(SUM(ingreso_estimado_mxn), 2) AS ingreso,
    ROUND(SUM(ingreso_estimado_mxn) * 1.0 / COUNT(DISTINCT evento_id), 0) AS ingreso_por_evento
FROM conciertos
GROUP BY sede
ORDER BY ingreso DESC
LIMIT 8;

-- Resultado (top 3):
-- La Cochera Cultural     | 89 eventos | $2,000,300 | $22,475/evento
-- Auditorio de la Ribera  |  7 eventos |   $471,050 | $67,293/evento  <- sede premium
-- Garden of Dreams        |  5 eventos |   $262,250 | $52,450/evento  <- sede premium


-- ------------------------------------------------------------
-- Query 2 — Margen % por género (solo géneros con 5+ conciertos)
-- ------------------------------------------------------------
SELECT
    genero,
    COUNT(*) AS conciertos,
    ROUND(SUM(ingreso_estimado_mxn), 2) AS ingreso,
    ROUND(100.0 * (SUM(ingreso_estimado_mxn) - SUM(pago_artistas_mxn) - SUM(gastos_produccion_mxn))
          / SUM(ingreso_estimado_mxn), 1) AS margen_pct
FROM conciertos
WHERE ingreso_estimado_mxn IS NOT NULL AND ingreso_estimado_mxn > 0
GROUP BY genero
HAVING COUNT(*) >= 5
ORDER BY margen_pct DESC;

-- Resultado:
-- Jazz Tradicional                 | 17 conciertos | $360,200   | 44.8%  <- el más rentable
-- Jazz Contemporáneo Original      | 51 conciertos | $1,267,150 | 25.4%
-- Improvisación libre - Free Jazz  |  8 conciertos | $172,150   | 25.1%
-- Flamenco Tradicional             | 32 conciertos | $869,300   | 17.3%
--
-- Nota de proceso: el margen de Jazz Contemporáneo Original subió de
-- 18.1% a 25.4% al capturar el patrocinio de Lakeside News para el
-- Francesco Diodati Quinteto ($35,000) — un solo patrocinio bien
-- documentado puede mover el margen de un género completo.


-- ------------------------------------------------------------
-- Query 3 — El reto: mejor combinación sede + género (mínimo 3 conciertos)
-- ------------------------------------------------------------
SELECT
    sede, genero, COUNT(*) AS conciertos,
    ROUND(100.0 * (SUM(ingreso_estimado_mxn) - SUM(pago_artistas_mxn) - SUM(gastos_produccion_mxn))
          / SUM(ingreso_estimado_mxn), 1) AS margen_pct
FROM conciertos
WHERE ingreso_estimado_mxn IS NOT NULL AND ingreso_estimado_mxn > 0
GROUP BY sede, genero
HAVING COUNT(*) >= 3
ORDER BY margen_pct DESC
LIMIT 8;


-- ============================================================
-- HALLAZGO
-- ============================================================
-- "Jazz Tradicional sigue siendo el género más rentable (44.8%),
--  pero la brecha con el género insignia (Jazz Contemporáneo
--  Original, 25.4%) se cerró bastante al capturar patrocinios reales
--  — una señal de que parte de la brecha original era un problema
--  de datos incompletos, no solo de mezcla de programación."
--
-- La Cochera Cultural sigue siendo el motor de volumen (89 de 133
-- eventos), y el Auditorio de la Ribera y Garden of Dreams generan
-- 2.3-3x más ingreso por evento cuando se usan. La pregunta de 2027
-- se mantiene: ¿aumentar la frecuencia de Jazz Tradicional y de
-- sedes premium mejoraría el margen general?
-- ============================================================
