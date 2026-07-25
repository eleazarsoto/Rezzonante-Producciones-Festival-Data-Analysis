-- ============================================================
-- REZZONANTE PRODUCCIONES — Análisis de Datos
-- Análisis 2 de 4 — Economía unitaria: margen real por concierto
-- Eleazar Soto | 2017-2026
-- ============================================================
-- Base de datos: Rezzonante_Producciones.db (SQLite)
-- Versión: v57 — incluye patrocinios en efectivo sumados al
-- ingreso, y corrección de gastos de producción reales.
-- ============================================================
--
-- CoNVO (Shron — Thinking with Data)
--   Contexto: el Análisis 1 mostró que el ingreso crece más rápido
--             que el número de eventos.
--   Necesidad: ¿el crecimiento de ingreso se traduce en más ganancia
--              real, o el costo por evento crece a la par?
--   Visión: margen % por año, y su causa (eventos de alto costo fijo).
--   Outcome: insumo para decisiones de tarifas de cara a 2027.
--
-- NOTA DE PROCESO: esta versión incorpora patrocinios en efectivo
-- (LCS, La Cochera Cultural, Lakeside News) que no estaban
-- capturados en versiones anteriores de la base, y una corrección
-- de gasto de producción real (Kako Brenes Quintet, de $20,000
-- estimados a $10,000 reales). Ambos cambios fueron confirmados con
-- el dueño del negocio antes de aplicarse.
--
-- ============================================================


-- ------------------------------------------------------------
-- Query 1 — Margen y % de margen por año
-- ------------------------------------------------------------
SELECT
    anio,
    ROUND(SUM(ingreso_estimado_mxn), 2) AS ingreso,
    SUM(pago_artistas_mxn) AS pago_artistas,
    SUM(gastos_produccion_mxn) AS gastos,
    ROUND(SUM(ingreso_estimado_mxn) - SUM(pago_artistas_mxn) - SUM(gastos_produccion_mxn), 2) AS margen,
    ROUND(100.0 * (SUM(ingreso_estimado_mxn) - SUM(pago_artistas_mxn) - SUM(gastos_produccion_mxn))
          / SUM(ingreso_estimado_mxn), 1) AS margen_pct
FROM conciertos
GROUP BY anio
ORDER BY anio ASC;

-- Resultado:
-- anio | ingreso  | pago_artistas | gastos  | margen  | margen_pct
-- 2017 |   5,200  |     5,200     |     0   |      0  |    0.0
-- 2018 | 357,300  |   147,500     | 118,000 |  91,800 |   25.7
-- 2019 | 358,550  |   147,550     | 102,500 | 108,500 |   30.3   <- mejor margen histórico
-- 2020 | 167,350  |    61,500     |  61,000 |  44,850 |   26.8
-- 2021 | 132,450  |    64,500     |  32,000 |  35,950 |   27.1
-- 2022 | 299,000  |   168,000     |  49,000 |  82,000 |   27.4
-- 2023 | 270,400  |   152,000     |  46,000 |  72,400 |   26.8
-- 2024 | 493,650  |   266,000     | 169,000 |  58,650 |   11.9
-- 2025 | 519,400  |   257,750     | 156,010 | 105,640 |   20.3
-- 2026 | 294,300  |   103,000     | 112,000 |  79,300 |   26.9   (parcial)


-- ------------------------------------------------------------
-- Query 2 — Causa raíz: eventos de alto costo fijo por año
-- (gasto de producción >= $10,000)
-- ------------------------------------------------------------
SELECT
    anio,
    COUNT(*) AS eventos_alto_costo
FROM conciertos
WHERE gastos_produccion_mxn >= 10000
GROUP BY anio
ORDER BY anio ASC;

-- Resultado: 2024 (8) y 2025 (7) siguen concentrando más eventos de
-- alto costo que cualquier año 2020-2023 (1-2 cada uno).


-- ------------------------------------------------------------
-- Query 3 — Conciertos individuales con margen negativo (pérdida)
-- ------------------------------------------------------------
SELECT
    concierto_id, concierto, anio, sede,
    ROUND(ingreso_estimado_mxn - pago_artistas_mxn - gastos_produccion_mxn, 2) AS margen
FROM conciertos
WHERE ingreso_estimado_mxn IS NOT NULL
  AND (ingreso_estimado_mxn - pago_artistas_mxn - gastos_produccion_mxn) < 0
ORDER BY margen ASC;

-- Resultado: 18 de 133 conciertos con dato completo (13.5%) — bajó
-- de 24 (18.2%) tras sumar patrocinios y corregir gastos reales.
-- Los dos casos de mayor pérdida (Cienfuegos y Zambomba Flamenca,
-- -$20,000 cada uno) son shows de sede externa sin patrocinio
-- documentado — candidatos naturales para buscar patrocinio futuro.
-- Nota: C002 (Triálogo) aparece con -$7,000 por diseño — su ingreso
-- de taquilla vive en C001 (misma noche de festival); su costo
-- individual no debe leerse aislado del evento completo.


-- ============================================================
-- HALLAZGO
-- ============================================================
-- "Con los patrocinios ya capturados, ningún año tiene margen bajo
--  15% — pero 2024 sigue siendo el año de menor eficiencia (11.9%),
--  justo el de mayor volumen de eventos de alto costo (8)."
--
-- Antes de capturar patrocinios, el panorama financiero de
-- Rezzonante parecía más débil de lo que realmente es: dos de los
-- eventos que antes figuraban como pérdidas (Michele Tino Sexteto y
-- Kako Brenes Quintet) en realidad eran rentables — solo faltaba
-- registrar el patrocinio recibido. El margen histórico total subió
-- de 18.6% a 23.4% con la base ya corregida.
--
-- El patrón de fondo se mantiene: 2019 (30.3%) sigue siendo el año
-- de mejor margen, y 2024 el de menor eficiencia relativa, por la
-- misma causa de siempre — concentración de eventos de alto costo.
--
-- Pregunta abierta para 2027: dado que el patrocinio puede revertir
-- por completo un evento de "pérdida" a "ganancia", ¿conviene buscar
-- patrocinio específicamente para los eventos de alto costo antes de
-- programarlos, en vez de descubrir el patrocinio después?
-- ============================================================
