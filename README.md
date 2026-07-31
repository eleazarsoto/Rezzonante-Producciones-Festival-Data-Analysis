# From Spreadsheets to Business Intelligence: the Rezzonante Producciones Journey

## Context

Rezzonante Producciones is my own cultural production business, based in Ajijic,
Jalisco, Mexico. Since 2014 I've produced concerts, festivals, and artist
residencies across three lines: Rezzonante Estudio (music education), La Cochera
Cultural (my main concert venue), and El Lago Suena, an international jazz and
improvised music festival.

This document summarizes the technical journey that took this business's
operational data — captured event by event since 2017 — from a spreadsheet to a
production Business Intelligence dashboard.

## The dataset

- **135 concerts** (2017–2026)
- **571 artist appearances** across concerts
- **143 unique artists** in the catalog, from 15 different countries
- **9 educational activities**, plus production and artist payment rate tables

## Stage 1 — Google Sheets

Where it all started: years of manual, event-by-event capture of revenue, artist
payments, production costs, attendance (general and VIP), and artist data. A source
of truth built from the real operation of the business, not a practice dataset.

## Stage 2 — SQL

Structuring the information into a relational schema (SQLite): `conciertos`
(concerts), `artistas` (artists), `catalogo_artistas` (artist catalog),
`actividades_academicas` (educational activities), and rate tables, related through
`concierto_id` and `artista_id`. First analysis queries and publication of the SQL
capstone project.

## Stage 3 — Data quality audit

Before building any dashboard, I audited the `gastos_produccion_mxn` (production
cost) column and the attendance fields, comparing each event against its own
production's pattern across years. This uncovered **5 real data capture errors**:

1. A fixed production cost ($20,000 MXN) applied equally to small satellite venues
   of "Encuentro Internacional de Jazz," unrelated to their actual revenue —
   corrected per venue ($0–$10,000 depending on the case)
2. A duplicated row for "Ciclo de Conciertos Internacionales 2019" at La Cochera
   Cultural, which had doubled the production cost
3. A phantom $20,000 production cost on an online event with no real production
   costs
4. and 5. Two inconsistencies between `asistencia_general` and `asistencia_total`
   in 2022 concerts

**The finding was significant**: before the correction, net margin appeared to have
collapsed from ~19% (2023) to ~7% (2025). After the correction, margin revealed
itself to be **stable between 19% and 33% since 2018** — a completely different
read on the business's performance.

## Stage 4 — BigQuery

Migration of all 7 tables to BigQuery (`rezzonante-producciones.rezzonante`),
including resolving a header-detection issue on the `catalogo_artistas` upload
(columns misread as `string_field_0`–`string_field_3`, fixed with
`ALTER TABLE ... RENAME COLUMN`).

## Stage 5 — Looker Studio

A multi-page dashboard built on top of the BigQuery tables:

| Page | Content |
|---|---|
| Index | Navigation to the other pages |
| General Report | # concerts, # attendees, # artists, # venues, net revenue |
| Artists | Nationalities and participations |
| Net Margin | Revenue, artist payments, and production costs by year |
| Estimated Revenue | Revenue by production and venue |
| Total Attendance | General + VIP attendance by year |
| Nationality | National vs. international composition and its relationship to attendance |

**Star metrics:**
1. Net margin (amount and %) by year
2. Total estimated revenue by production/venue
3. Total attendance (general + VIP) by year
4. National vs. international artists (unique count)

🔗 **[Dashboard on Looker Studio](https://datastudio.google.com/reporting/9743acdc-7607-48e6-bacd-4db00c438d0b)**

## Full stack

`Google Sheets` → `SQLite/SQL` → `Google BigQuery` → `Looker Studio`

## Reflection

This project didn't start from a practice dataset — it's the real operation of a
business I've built from the ground up since 2014. Applying the full data analytics
process — from capture to dashboard, including a rigorous quality audit — to my own
information changed how I understand my own business: I found errors that had gone
undetected for years, and discovered a margin stability that intuition alone hadn't
shown me.

---

<br>

# De hojas de cálculo a Business Intelligence: el camino de Rezzonante Producciones

## Contexto

Rezzonante Producciones es mi propio negocio de producción cultural, con sede en
Ajijic, Jalisco. Desde 2014 he producido conciertos, festivales y residencias
artísticas a través de tres líneas: Rezzonante Estudio (enseñanza musical), La
Cochera Cultural (mi sede principal de conciertos), y El Lago Suena, un festival
internacional de jazz y música improvisada.

Este documento resume el recorrido técnico que llevó los datos operativos de este
negocio —capturados evento por evento desde 2017— desde una hoja de cálculo hasta
un dashboard de Business Intelligence en producción.

## El dataset

- **135 conciertos** (2017–2026)
- **571 apariciones de artistas** en concierto
- **143 artistas únicos** en catálogo, de 15 países distintos
- **9 actividades académicas**, más tablas de tarifas de producción y pago a artistas

## Etapa 1 — Google Sheets

El origen de todo: años de captura manual, evento por evento, de ingreso, pago a
artistas, gastos de producción, asistencia (general y VIP) y datos de artistas. Una
fuente de verdad construida desde la operación real del negocio, no un dataset de
práctica.

## Etapa 2 — SQL

Estructuración de la información en un esquema relacional (SQLite): tablas de
`conciertos`, `artistas`, `catalogo_artistas`, `actividades_academicas` y tarifas,
relacionadas por `concierto_id` y `artista_id`. Primeras consultas de análisis y
publicación del proyecto integrador de SQL.

## Etapa 3 — Auditoría de calidad de datos

Antes de construir cualquier dashboard, se auditó la columna `gastos_produccion_mxn`
y los campos de asistencia, comparando cada evento contra el patrón de su propia
producción a través de los años. Se encontraron y corrigieron **5 errores reales de
captura**:

1. Costo fijo de producción ($20,000) aplicado por igual a sedes satélite pequeñas
   de "Encuentro Internacional de Jazz", sin relación con su ingreso real —
   corregido por sede ($0–$10,000 según el caso)
2. Fila duplicada del "Ciclo de Conciertos Internacionales 2019" en La Cochera
   Cultural, que había duplicado el gasto de producción
3. Gasto fantasma de $20,000 en un evento online sin costos reales de producción
4. y 5. Dos inconsistencias entre `asistencia_general` y `asistencia_total` en
   conciertos de 2022

**El hallazgo fue significativo**: antes de corregir, el margen neto parecía haberse
desplomado de ~19% (2023) a ~7% (2025). Después de la corrección, el margen se
reveló **estable entre 19% y 33% desde 2018** — una lectura completamente distinta
del desempeño del negocio.

## Etapa 4 — BigQuery

Migración de las 7 tablas a BigQuery (`rezzonante-producciones.rezzonante`),
incluyendo la resolución de un problema de detección de encabezados en la carga de
`catalogo_artistas` (columnas mal detectadas como `string_field_0`–`string_field_3`,
corregidas con `ALTER TABLE ... RENAME COLUMN`).

## Etapa 5 — Looker Studio

Dashboard multipágina construido sobre las tablas de BigQuery:

| Página | Contenido |
|---|---|
| Índice | Navegación a las demás páginas |
| Reporte General | # conciertos, # asistentes, # artistas, # sedes, ingreso neto |
| Artistas | Nacionalidades y participaciones |
| Margen neto | Ingreso, pago a artistas y gastos de producción por año |
| Ingreso estimado | Ingreso por producción y sede |
| Asistencia total | Asistencia general + VIP por año |
| Nacionalidad | Composición nacional vs. internacional y su relación con la asistencia |

**Métricas estrella:**
1. Margen neto (monto y %) por año
2. Ingreso estimado total por producción/sede
3. Asistencia total (general + VIP) por año
4. Artistas nacionales vs. extranjeros (conteo único)

🔗 **[Dashboard en Looker Studio](https://datastudio.google.com/reporting/9743acdc-7607-48e6-bacd-4db00c438d0b)**

## Stack completo

`Google Sheets` → `SQLite/SQL` → `Google BigQuery` → `Looker Studio`

## Reflexión

Este proyecto no partió de un dataset de práctica: es la operación real de un
negocio que he construido desde cero desde 2014. Aplicar el proceso completo de
analítica de datos —desde la captura hasta el dashboard, pasando por una auditoría
de calidad rigurosa— sobre mi propia información cambió cómo entiendo mi propio
negocio: encontré errores que llevaban años sin detectarse, y descubrí una
estabilidad de margen que la intuición sola no me había dejado ver.

Scripts de Python para formalizar el proceso de limpieza (hoy ad-hoc), un diagrama entidad-relación del esquema, un dashboard de Looker Studio construido alrededor de una North Star Metric definida, y hallazgos con nivel de certeza marcado (distinguiendo qué conclusiones son sólidas de cuáles son direccionales) conforme el análisis madure.

---

*De gestionar un proyecto cultural con hojas de cálculo, a convertir esos mismos datos en decisiones — este es el proyecto que documenta esa transición.*
