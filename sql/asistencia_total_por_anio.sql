-- Total attendance (general + VIP) by year
SELECT
  anio,
  SUM(asistencia_general) AS asistencia_general_total,
  SUM(asistencia_vip) AS asistencia_vip_total,
  SUM(asistencia_total) AS asistencia_total,
  SAFE_DIVIDE(SUM(asistencia_vip), SUM(asistencia_total)) AS pct_asistencia_vip
FROM `rezzonante-producciones.rezzonante.conciertos`
GROUP BY anio
ORDER BY anio;
