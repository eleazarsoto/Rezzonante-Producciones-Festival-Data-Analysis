-- ============================================================
-- REZZONANTE PRODUCCIONES — Análisis de Datos
-- Análisis 2 de 4 — Economía unitaria: margen real por concierto
-- Eleazar Soto | 2017-2026
-- ============================================================
-- Base de datos: Rezzonante_Producciones.db (SQLite)
-- Versión: base final v54, auditada y corregida
-- ============================================================
--
-- CoNVO (Shron — Thinking with Data)
--   Contexto: el Análisis 1 mostró que el ingreso crece más rápido
--             que el número de eventos — pero nunca se había restado
--             el costo real (pago a artistas + gastos de producción).
--   Necesidad: ¿el crecimiento de ingreso se traduce en más ganancia
--              real, o el costo por evento crece a la par?
--   Visión: margen % por año, y su causa (eventos de alto costo fijo).
--   Outcome: insumo para decisiones de tarifas de cara a 2027.
--
-- NOTA DE PROCESO: gastos_produccion_mxn y pago_artistas_mxn fueron
-- corregidos exhaustivamente junto con el dueño del negocio —
-- tarifas por categoría/sede, fórmulas rotas por edición manual,
-- errores de captura, y casos donde un patrocinador cubrió el costo
-- del evento directamente (esos conciertos muestran margen exacto
-- de $0 por diseño, no por coincidencia).
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
-- 2018 | 317,300  |   147,500     | 118,000 |  51,800 |   16.3
-- 2019 | 354,700  |   146,550     | 104,000 | 104,150 |   29.4   <- mejor margen histórico
-- 2020 | 167,350  |    61,500     |  61,000 |  44,850 |   26.8
-- 2021 | 124,050  |    64,500     |  32,000 |  27,550 |   22.2
-- 2022 | 289,600  |   168,000     |  49,000 |  72,600 |   25.1
-- 2023 | 252,100  |   152,000     |  46,000 |  54,100 |   21.5
-- 2024 | 480,150  |   266,000     | 169,000 |  45,150 |    9.4
-- 2025 | 519,400  |   257,750     | 166,010 |  95,640 |   18.4
-- 2026 | 229,050  |   103,000     | 112,000 |  14,050 |    6.1   (parcial)


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
-- alto costo que cualquier año entre 2020 y 2023 (1-2 cada uno).


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

-- Resultado: 24 de 132 conciertos con dato completo (18.2%) operan
-- con pérdida individual — bajó de 32 (24.2%) tras corregir tarifas
-- y errores de captura. El mayor caso: Cienfuegos (2018, Plaza
-- Principal Ajijic, -$20,000).


-- ============================================================
-- HALLAZGO
-- ============================================================
-- "Ningún año de Rezzonante cierra en números rojos — pero el
--  margen se comprime justo en los años de mayor ingreso bruto."
--
-- Con la base de datos ya depurada por completo, el panorama
-- financiero de Rezzonante es más sano de lo que sugerían las
-- primeras estimaciones: los 9 años completos muestran margen
-- positivo, con un histórico de 18.6%. Sin embargo, el patrón de
-- fondo se sostiene: 2019 (29.4%) y 2020 (26.8%) — años de menor
-- ingreso bruto — superan por mucho a 2024 (9.4%), el año de mayor
-- facturación histórica. La causa es la misma de siempre: 2024 y
-- 2025 concentran más eventos de alto costo fijo (8 y 7) que
-- cualquier año anterior a la pandemia.
--
-- Casi 1 de cada 5 conciertos (18.2%) sigue perdiendo dinero de
-- forma individual, aunque la proporción bajó tras la limpieza de
-- datos — la mayoría son shows pequeños donde el costo de
-- producción o el pago a artistas supera la taquilla real.
--
-- Pregunta abierta para 2027: ¿vale la pena seguir aumentando la
-- frecuencia de eventos internacionales de alto costo si diluyen
-- el margen, o conviene volver a una mezcla más parecida a 2019-2020?
-- ============================================================
