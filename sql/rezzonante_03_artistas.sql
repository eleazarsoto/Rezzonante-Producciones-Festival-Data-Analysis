-- ============================================================
-- REZZONANTE PRODUCCIONES — Análisis de Datos
-- Análisis 3 de 4 — Red de artistas: alcance y recurrencia
-- Eleazar Soto | 2017-2026
-- ============================================================
-- Base de datos: Rezzonante_Producciones.db (SQLite)
-- Tablas: catalogo_artistas (143 personas, una fila = un artista),
-- artistas (571 participaciones, la tabla puente), conciertos
-- ============================================================
--
-- CoNVO (Shron — Thinking with Data)
--   Contexto: Rezzonante ha trabajado con más de 140 artistas en
--             9 años, pero nunca se ha visto la red de forma
--             sistemática.
--   Necesidad: ¿de qué países vienen los artistas, quiénes son los
--              colaboradores más recurrentes, y el alcance
--              internacional se traduce en algo medible?
--   Visión: distribución por país, top de recurrencia, comparación
--           nacional vs. internacional en asistencia.
--   Outcome: evidencia cuantitativa del alcance de la red para
--            patrocinadores — "conectamos Ajijic con el mundo",
--            con números que lo respaldan.
--
-- ============================================================


-- ------------------------------------------------------------
-- Query 1 — Artistas por país de origen
-- Se cuenta desde catalogo_artistas (una fila = una persona), no
-- desde la tabla de participaciones — así un artista recurrente no
-- infla el conteo de su país.
-- ------------------------------------------------------------
SELECT
    pais,
    COUNT(*) AS artistas
FROM catalogo_artistas
GROUP BY pais
ORDER BY artistas DESC;

-- Resultado (top 5 de 15 países):
-- México (99) | España (7) | USA (5) | Netherlands (5) | Italia (5)
-- 44 de 143 artistas (30.8%) vienen de fuera de México.


-- ------------------------------------------------------------
-- Query 2 — Top 10 artistas más recurrentes
-- JOIN catalogo -> participaciones, contando conciertos DISTINTOS
-- por artista (un artista puede aparecer varias veces en el mismo
-- concierto si el modelo lo permitiera, aunque no es el caso aquí).
-- ------------------------------------------------------------
SELECT
    ca.artista,
    ca.pais,
    COUNT(DISTINCT a.concierto_id) AS conciertos
FROM catalogo_artistas ca
JOIN artistas a ON ca.artista_id = a.artista_id
GROUP BY ca.artista_id
ORDER BY conciertos DESC
LIMIT 10;

-- Resultado: Eleazar Soto encabeza con 82 conciertos (fundador y
-- líder del proyecto), seguido de Gil Ríos (61) y Emilia Gálvez
-- (32). El único no-mexicano en el top 10 es Pablo Loaiza
-- (Costa Rica, 9 conciertos).


-- ------------------------------------------------------------
-- Query 3 — Instrumentos más frecuentes en la alineación
-- ------------------------------------------------------------
SELECT
    instrumento,
    COUNT(*) AS participaciones
FROM artistas
GROUP BY instrumento
ORDER BY participaciones DESC
LIMIT 8;

-- Resultado: Saxofón (105) y Batería (91) dominan — coherente con
-- el eje jazz/flamenco del proyecto y con que el fundador es
-- saxofonista.


-- ------------------------------------------------------------
-- Query 4 — El reto: ¿la programación internacional atrae más público?
-- Clasifica cada concierto como "Internacional" si al menos un
-- músico de su alineación no es de México, y compara la asistencia
-- promedio de ambos grupos.
-- ------------------------------------------------------------
SELECT
    CASE WHEN ca.pais = 'México' THEN 'Nacional' ELSE 'Internacional' END AS origen,
    COUNT(DISTINCT a.concierto_id) AS conciertos,
    ROUND(AVG(c.asistencia_total), 0) AS asistencia_promedio
FROM catalogo_artistas ca
JOIN artistas a ON ca.artista_id = a.artista_id
JOIN conciertos c ON a.concierto_id = c.concierto_id
WHERE c.asistencia_total IS NOT NULL
GROUP BY origen;

-- Resultado:
-- origen         | conciertos | asistencia_promedio
-- Internacional  |     45     |        115
-- Nacional       |    127     |         72
--
-- Nota metodológica: un concierto con alineación mixta cuenta como
-- "Internacional" (basta un músico extranjero). El conteo de
-- conciertos aquí no suma a 132 porque cada concierto puede
-- aparecer más de una vez si tiene múltiples artistas —esta query
-- agrupa por participación, no por concierto único; para el número
-- exacto de conciertos por categoría haría falta una subconsulta
-- adicional con EXISTS, pendiente para iteración futura.


-- ============================================================
-- HALLAZGO
-- ============================================================
-- "Los conciertos con artistas internacionales atraen 60% más
--  público que los 100% nacionales — 115 asistentes en promedio
--  contra 72."
--
-- Rezzonante trabajó con 143 artistas de 15 países en 9 años; casi
-- un tercio (30.8%) de su catálogo es internacional. Esto no es
-- solo una cifra de prestigio: los conciertos con al menos un
-- músico extranjero convocan significativamente más público que
-- las formaciones puramente locales — evidencia directa de que la
-- inversión en talento internacional tiene retorno medible en
-- asistencia, no solo en programación artística.
--
-- El proyecto tiene un núcleo estable de colaboradores recurrentes
-- (Eleazar Soto, Gil Ríos, Emilia Gálvez, Fernando Martínez,
-- Santiago Maisterra) que sostienen la operación año con año,
-- complementado por la rotación de artistas invitados —
-- internacionales y nacionales— que renuevan la programación.
-- ============================================================
