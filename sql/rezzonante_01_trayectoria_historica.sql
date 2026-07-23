-- ============================================================
-- REZZONANTE PRODUCCIONES — Análisis de Datos
-- Análisis 1 de 4 — Trayectoria histórica: eventos e ingreso
-- Eleazar Soto | 2017-2026
-- ============================================================
-- Base de datos: Rezzonante_Producciones.db (SQLite)
-- Versión: base final, auditada y corregida (fórmulas, tarifas,
-- catálogo de artistas consolidado, ver historial de commits)
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
-- Nota: COUNT(DISTINCT evento_id), no COUNT(*) sobre conciertos —
-- una misma velada puede agrupar varios conciertos bajo un solo evento_id.
-- El * 1.0 antes de la división evita el truncamiento de enteros.
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
-- anio | eventos | ingreso_total | ingreso_por_evento
-- 2017 |    1    |     5,200     |   5,200
-- 2018 |   13    |   317,300     |  24,408
-- 2019 |   17    |   354,700     |  20,865
-- 2020 |   16    |   167,350     |  10,459
-- 2021 |    7    |   124,050     |  17,721
-- 2022 |   14    |   289,600     |  20,686
-- 2023 |   11    |   252,100     |  22,918
-- 2024 |   21    |   480,150     |  22,864
-- 2025 |   22    |   519,400     |  23,609
-- 2026 |    7    |   229,050     |  32,721  (año parcial, corte a junio)


-- ------------------------------------------------------------
-- Query 2 — Eventos e ingreso indexados a 2019 = 100
-- Patrón: un CTE agrega por año, un segundo CTE aísla la fila base
-- (2019), y un CROSS JOIN une cada año con ese único valor de
-- referencia para calcular el índice.
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
-- 2018 |      76        |     89
-- 2019 |     100        |    100
-- 2020 |      94        |     47
-- 2021 |      41        |     35
-- 2022 |      82        |     82
-- 2023 |      65        |     71
-- 2024 |     124        |    135
-- 2025 |     129        |    146
-- 2026 |      41        |     65   (año parcial)


-- ------------------------------------------------------------
-- Query 3 — Transparencia de dato: conciertos con ingreso NULL por diseño
-- No son datos faltantes: el ingreso vive en otro concierto de la
-- misma velada (mismo evento_id), evitando contar el mismo boleto
-- más de una vez.
-- ------------------------------------------------------------
SELECT concierto_id, concierto, produccion, anio
FROM conciertos
WHERE ingreso_estimado_mxn IS NULL;

-- Resultado: C002 y C003 (mismo evento que C001, festival 2018),
-- C133 (acto abridor del mismo evento que C007, 2022).


-- ============================================================
-- HALLAZGO
-- ============================================================
-- "El ingreso de Rezzonante crece más rápido que su número de
--  eventos — la brecha se amplía año con año desde 2022."
--
-- La pandemia golpeó ambas métricas por igual (2021: eventos al
-- 41%, ingreso al 35% de 2019). La recuperación de eventos fue
-- gradual y con altibajos (82% en 2022, 65% en 2023, recién superó
-- el 100% en 2024). El ingreso, en cambio, ya rondaba el 82-89%
-- desde 2018 y 2022, y en 2025 alcanzó 146% del nivel 2019 con
-- solo 129% de los eventos — la brecha entre ambas líneas es la
-- historia central de este análisis.
--
-- Pregunta que abre para el Análisis 2: si el ingreso crece más
-- rápido que el volumen, ¿se traduce en más ganancia real, o el
-- costo por evento también está subiendo?
-- ============================================================
