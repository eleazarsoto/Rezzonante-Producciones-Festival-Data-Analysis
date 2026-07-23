-- ============================================================
-- REZZONANTE PRODUCCIONES — Análisis de Datos
-- Análisis 4 de 4 — Sedes y géneros: qué formato rinde más
-- Eleazar Soto | 2017-2026
-- ============================================================
-- Base de datos: Rezzonante_Producciones.db (SQLite)
-- Tabla principal: conciertos
-- ============================================================
--
-- CoNVO (Shron — Thinking with Data)
--   Contexto: Rezzonante ha operado en más de 20 sedes y 9 géneros
--             musicales en 9 años, pero nunca se ha visto
--             sistemáticamente qué combinación rinde mejor.
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
-- La Cochera Cultural     | 89 eventos | $1,895,600 | $21,299/evento  <- tu casa, volumen
-- Auditorio de la Ribera  |  7 eventos |   $483,300 | $69,043/evento  <- sede premium
-- Garden of Dreams        |  5 eventos |   $217,000 | $43,400/evento  <- sede premium
--
-- La Cochera genera el 69% del ingreso histórico por volumen, pero
-- el Auditorio de la Ribera rinde 3.2x más ingreso por evento —
-- son modelos de negocio distintos (frecuencia vs. eventos grandes).


-- ------------------------------------------------------------
-- Query 2 — Margen % por género (solo géneros con 5+ conciertos,
-- para evitar que un género de 1-2 conciertos distorsione el ranking)
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
-- Jazz Tradicional                 | 17 conciertos | $352,400 | 43.5%  <- el más rentable
-- Improvisación libre - Free Jazz  |  8 conciertos | $168,250 | 23.4%
-- Jazz Contemporáneo Original      | 50 conciertos | $1,138,850 | 18.1%  <- el más frecuente
-- Flamenco Tradicional             | 32 conciertos | $850,600 | 15.5%
--
-- El género dominante en volumen (Jazz Contemporáneo Original, 38%
-- de la programación) NO es el más rentable — rinde menos de la
-- mitad de margen que Jazz Tradicional, que representa solo el 13%.


-- ------------------------------------------------------------
-- Query 3 — El reto: mejor combinación sede + género
-- (mínimo 3 conciertos, para descartar combinaciones anecdóticas)
-- ------------------------------------------------------------
SELECT
    sede,
    genero,
    COUNT(*) AS conciertos,
    ROUND(100.0 * (SUM(ingreso_estimado_mxn) - SUM(pago_artistas_mxn) - SUM(gastos_produccion_mxn))
          / SUM(ingreso_estimado_mxn), 1) AS margen_pct
FROM conciertos
WHERE ingreso_estimado_mxn IS NOT NULL AND ingreso_estimado_mxn > 0
GROUP BY sede, genero
HAVING COUNT(*) >= 3
ORDER BY margen_pct DESC
LIMIT 8;

-- Resultado (top 3):
-- Auditorio de la Ribera + Jazz Tradicional        | 3 conciertos | 57.4%  <- el combo ganador
-- La Cochera Cultural + Jazz Tradicional            | 12 conciertos | 34.0%
-- La Cochera Cultural + Improvisación libre         |  7 conciertos | 25.8%
--
-- Nota de rigor: el combo ganador tiene solo 3 conciertos — dato
-- direccional, no concluyente. Pero el patrón se sostiene: en
-- ambas sedes, Jazz Tradicional es el género de mejor margen.


-- ============================================================
-- HALLAZGO
-- ============================================================
-- "El género que más programas no es el que más rinde — Jazz
--  Tradicional genera 43.5% de margen con solo el 13% de tus
--  conciertos, mientras tu género insignia rinde 18.1%."
--
-- La Cochera Cultural es el motor de volumen de Rezzonante (89 de
-- 132 conciertos, 69% del ingreso histórico), y seguirá siéndolo.
-- Pero el Auditorio de la Ribera y Garden of Dreams —sedes que usas
-- con poca frecuencia— generan 3-3.2x más ingreso por evento, y la
-- combinación Auditorio + Jazz Tradicional es, con la muestra
-- disponible, tu configuración más rentable (57.4%).
--
-- Esto no sugiere abandonar Jazz Contemporáneo Original —sigue
-- siendo el corazón artístico del proyecto— sino una pregunta
-- concreta para 2027: ¿aumentar la frecuencia de programación de
-- Jazz Tradicional, y explorar más eventos en sedes premium como el
-- Auditorio, mejoraría el margen general sin sacrificar identidad?
-- ============================================================
