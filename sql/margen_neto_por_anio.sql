-- Net margin by year — total and % over revenue
-- margin = estimated_revenue - artist_payments - production_costs
SELECT
  anio,
  SUM(ingreso_estimado_mxn) AS ingreso_total_mxn,
  SUM(pago_artistas_mxn) AS pago_artistas_total_mxn,
  SUM(gastos_produccion_mxn) AS gastos_produccion_total_mxn,
  SUM(ingreso_estimado_mxn - pago_artistas_mxn - gastos_produccion_mxn) AS margen_neto_mxn,
  SAFE_DIVIDE(
    SUM(ingreso_estimado_mxn - pago_artistas_mxn - gastos_produccion_mxn),
    SUM(ingreso_estimado_mxn)
  ) AS margen_neto_pct
FROM `rezzonante-producciones.rezzonante.conciertos`
GROUP BY anio
ORDER BY anio;
