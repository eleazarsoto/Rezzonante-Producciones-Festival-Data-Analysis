-- Unique artists by nationality, and whether international lineups
-- draw more attendance than domestic-only ones
WITH concierto_nacionalidad AS (
  SELECT
    c.concierto_id,
    c.asistencia_total,
    CASE
      WHEN SUM(CASE WHEN ca.pais != 'México' THEN 1 ELSE 0 END) = 0 THEN 'Solo nacional'
      WHEN SUM(CASE WHEN ca.pais = 'México' THEN 1 ELSE 0 END) = 0 THEN 'Solo extranjero'
      ELSE 'Mixto'
    END AS tipo_nacionalidad
  FROM `rezzonante-producciones.rezzonante.conciertos` c
  JOIN `rezzonante-producciones.rezzonante.artistas` a ON c.concierto_id = a.concierto_id
  JOIN `rezzonante-producciones.rezzonante.catalogo_artistas` ca ON a.artista_id = ca.artista_id
  GROUP BY c.concierto_id, c.asistencia_total
)
SELECT
  tipo_nacionalidad,
  COUNT(*) AS num_conciertos,
  SUM(asistencia_total) AS asistencia_total,
  AVG(asistencia_total) AS asistencia_promedio_por_concierto
FROM concierto_nacionalidad
GROUP BY tipo_nacionalidad
ORDER BY asistencia_promedio_por_concierto DESC;
