-- ============================================================
-- REZZONANTE PRODUCCIONES — Análisis de Datos
-- Análisis 1 de 4 — Trayectoria histórica: eventos e ingreso
-- Eleazar Soto | 2017-2026
-- ============================================================
-- Base de datos: Rezzonante_Producciones.db (SQLite)
-- Versión: v57 — incluye ingresos por patrocinio (efectivo)
-- sumados al ingreso de taquilla en los eventos donde aplicó.
-- ============================================================
--
-- CoNVO (Shron — Thinking with Data)
--   Contexto: Rezzonante opera desde 2017; la pandemia interrumpió
--             la operación de forma visible en 2020-2021.
--   Necesidad: ¿cómo evolucionaron el volumen de eventos y el ingreso
--              a lo largo de 9 años, y ya se recuperó el nivel
--              pre-pandemia?
--   Visión: eventos e ingreso por año, indexados a 2019 = 100
--           (último año completo antes de la pandemia).
--   Outcome: apertura de la presentación de Open Circle (9-ago-2026)
--            y pieza central del portafolio de Data Analyst.
--
-- ============================================================


-- ------------------------------------------------------------
-- Query 1 — Eventos, ingreso total e ingreso promedio por evento, por año
-- ------------------------------------------------------------
SELECT
    anio,
    COUNT(DISTINCT evento_id) AS eventos,
    ROUND(SUM(ingreso_estimado_mxn), 2) AS ingreso_total,
    ROUND(SUM(ingreso_estimado_mxn) * 1.0 / COUNT(DISTINCT evento_id), 0) AS ingreso_por_evento
FROM conciertos
GROUP BY anio
ORDER BY anio ASC;

-- Resultado:
-- anio | eventos | ingreso_total
-- 2017 |    1    |     5,200
-- 2018 |   13    |   357,300
-- 2019 |   17    |   358,550
-- 2020 |   16    |   167,350
-- 2021 |    7    |   132,450
-- 2022 |   14    |   299,000
-- 2023 |   11    |   270,400
-- 2024 |   21    |   493,650
-- 2025 |   22    |   519,400
-- 2026 |    7    |   294,300  (año parcial, corte a junio)


-- ------------------------------------------------------------
-- Query 2 — Eventos e ingreso indexados a 2019 = 100
-- ------------------------------------------------------------
WITH por_anio AS (
    SELECT anio,
           COUNT(DISTINCT evento_id) AS eventos,
           SUM(ingreso_estimado_mxn) AS ingreso
    FROM conciertos
    GROUP BY anio
),
base AS (
    SELECT eventos AS eventos_base, ingreso AS ingreso_base
    FROM por_anio
    WHERE anio = 2019
)
SELECT
    p.anio,
    ROUND(100.0 * p.eventos / b.eventos_base) AS indice_eventos,
    ROUND(100.0 * p.ingreso / b.ingreso_base) AS indice_ingreso
FROM por_anio p
CROSS JOIN base b
ORDER BY p.anio ASC;

-- Resultado (índice, 2019 = 100):
-- anio | indice_eventos | indice_ingreso
-- 2017 |       6        |      1
-- 2018 |      76        |    100
-- 2019 |     100        |    100
-- 2020 |      94        |     47
-- 2021 |      41        |     37
-- 2022 |      82        |     83
-- 2023 |      65        |     75
-- 2024 |     124        |    138
-- 2025 |     129        |    145
-- 2026 |      41        |     82   (año parcial)


-- ------------------------------------------------------------
-- Query 3 — Transparencia de dato: conciertos con ingreso NULL por diseño
-- ------------------------------------------------------------
SELECT concierto_id, concierto, produccion, anio
FROM conciertos
WHERE ingreso_estimado_mxn IS NULL;

-- Resultado: C003 (mismo evento que C001, festival 2018 — el ingreso
-- de esa noche vive en C001 y C002), C133 (acto abridor del mismo
-- evento que C007, 2022).


-- ============================================================
-- HALLAZGO
-- ============================================================
-- "El ingreso de Rezzonante crece más rápido que su número de
--  eventos — la brecha se amplía año con año desde 2022."
--
-- 2018 alcanzó 100% del nivel de ingreso de 2019 gracias a
-- patrocinios en efectivo documentados ese año. La recuperación de
-- eventos post-pandemia fue gradual y con altibajos (82% en 2022,
-- 65% en 2023, recién superó el 100% en 2024). El ingreso, en
-- cambio, alcanzó 145% del nivel 2019 en 2025 con solo 129% de los
-- eventos — la brecha entre ambas líneas es la historia central.
--
-- Nota de proceso: los ingresos de 2018 y 2023-2026 incluyen
-- patrocinios en efectivo (LCS, La Cochera Cultural, Lakeside News)
-- que antes no estaban capturados en la base — se sumaron al
-- ingreso de taquilla tras confirmar con el dueño del negocio que
-- eran recursos adicionales, no ya contados.
-- ============================================================
