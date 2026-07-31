-- Estimated revenue by year, production, and venue
SELECT
  anio, produccion, sede,
  SUM(ingreso_estimado_mxn) AS ingreso_estimado_mxn
FROM `rezzonante-producciones.rezzonante.conciertos`
GROUP BY anio, produccion, sede
ORDER BY anio, ingreso_estimado_mxn DESC;
