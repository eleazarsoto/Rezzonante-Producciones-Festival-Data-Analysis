# Rezzonante Producciones — De Excel disperso a inteligencia de negocio

**Autor:** Eleazar Soto · [github.com/eleazarsoto](https://github.com/eleazarsoto)
**Análisis realizado con la metodología de Oráculo Analytics** · [oraculoanalytics.com](https://oraculoanalytics.com)

*[English](#english) | [Español](#español)*

---

## English

### The story

For 9 years, **Rezzonante Producciones** has been producing jazz and improvised-music events in Ajijic, Mexico — booking artists, managing venues, tracking attendance and payments, one spreadsheet at a time. I founded Rezzonante and lead it as artistic director, and a small team helps bring every event to life. In 2026 I started learning data analysis from scratch. This project is where those two paths meet: I took Rezzonante's own real, messy, 9-year business dataset and turned it into a proper analytical system — not a tutorial exercise, a real one.

This analysis was carried out using the same methodology I apply through **Oráculo Analytics** — this is a real, self-owned case, not a client engagement, and is presented as such.

Every number in this project came from an actual concert Rezzonante produced. Every data-quality issue found and fixed — broken formulas, mistyped attendance figures, sponsor-covered events that needed different accounting — was a real decision, confirmed with the people who actually run the business before a single change was applied.

### What this project demonstrates

| Layer                         | What it shows                                                                                                                                                                                            |
| ----------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Data modeling**             | Redesigned a flat spreadsheet into a normalized relational schema — a fact table (`conciertos`), a bridge table (`artistas`), a master catalog (`catalogo_artistas`), and rate-reference tables — mirroring the star-schema thinking taught in data warehousing |
| **Data quality & governance** | A documented, multi-round audit process: fixed misaligned formula references, consolidated duplicate catalog entries, resolved sponsor-funded events, corrected capture errors — all confirmed with the actual business owner before applying |
| **SQL analysis**              | 4 business-question-driven analyses, from CTEs and window-function-adjacent patterns to careful `HAVING`/`GROUP BY` logic, each one opens with a short problem framing — business context, the specific question, what a good answer looks like, the decision it unlocks — before a single query is written |
| **Data storytelling**         | Every chart has a conclusion as its title, not a description — following Cole Nussbaumer Knaflic's *Storytelling with Data*                                                                              |
| **BI Dashboard**               | Interactive Looker Studio dashboard (5 pages), connected live to the underlying data                                                                                                                    |
| **Decision documents**        | An executive decision document and a plain-language summary translate the SQL/BI findings into business recommendations for two different audiences                                                    |

### Project structure

```
rezzonante-data-analysis/
├── README.md
├── Documento_Decision.pdf
├── Resumen_Ejecutivo.html
├── Rezzonante_Producciones.db              # SQLite export, final version
├── sql/
│   ├── rezzonante_01_trayectoria_historica.sql
│   ├── rezzonante_02_economia_unitaria.sql
│   ├── rezzonante_03_artistas.sql
│   └── rezzonante_04_sedes_generos.sql
├── charts/
│   ├── a1_margen_por_anio.png
│   ├── a2_asistencia_por_anio.png
│   ├── a3_ingreso_produccion_sede.png
│   └── a4_margen_por_genero.png
└── dashboard/
    ├── Looker_Studio_Guia.md
    └── mockups/
```

### The four analyses

**1 — Unit economics: real margin per year**

[![Margin by year](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/a1_margen_por_anio.png)](/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/blob/main/charts/a1_margen_por_anio.png)

No year closed in the red — but margin compresses exactly in the highest-revenue years. Total net margin across all 9 years reached $795K MXN, yet the peak-revenue years (2024-2025, $494K-$519K in total revenue) show a visibly thinner spread between the revenue line and the margin line than earlier years — meaning a smaller share of that revenue is actually kept.

**2 — Attendance: how big is the audience, and how has it grown?**

[![Attendance by year](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/a2_asistencia_por_anio.png)](/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/blob/main/charts/a2_asistencia_por_anio.png)

Total attendance across 9 years: 9,400 people. From a nearly nonexistent 26 attendees in 2017, growth compounds to a peak of 1,744 in 2025 — but drops to 649 in the most recent partial year, a signal worth watching, not a straight line up and to the right.

**3 — Which productions and venues generate the most revenue?**

[![Revenue by production and venue](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/a3_ingreso_produccion_sede.png)](/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/blob/main/charts/a3_ingreso_produccion_sede.png)

The single highest-revenue production in Rezzonante's history is **Tablao Flamenco Internacional 2024** ($198,800 MXN) — and **La Cochera Cultural** dominates the top of the list as the primary revenue-generating venue, appearing in the majority of the top 20 productions by revenue.

**4 — Venues and genres: what actually performs**

[![Margin by genre](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/a4_margen_por_genero.png)](/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/blob/main/charts/a4_margen_por_genero.png)

The genre that dominates programming (Jazz Contemporáneo Original, the flagship genre) delivers 28% margin — solidly behind Clásica (63%), Jazz Tradicional (47%), and Blues (42%). The most-programmed genre is not the most profitable one.

**A fifth finding, without its own chart:** concerts featuring at least one international artist draw noticeably higher attendance than fully domestic lineups — a pattern confirmed in the underlying SQL analysis (`rezzonante_03_artistas.sql`) even though it isn't one of the four charts above. Revenue also grew faster than event volume in recent years (145% of the 2019 baseline by 2025, versus 129% in event count) — another finding from the original analysis without a dedicated chart in this version of the README.

### Dashboard

An interactive 5-page dashboard was built in Looker Studio, connected live to the underlying data — overview, margin, revenue by production/venue, attendance growth, and international vs. national impact. See `dashboard/Looker_Studio_Guia.md` for how it was built and how to reproduce it.

### Decision documents

- `Documento_Decision.pdf` — an executive recommendation translating the four analyses into a concrete business decision.
- `Resumen_Ejecutivo.html` — the same findings in plain language, for readers without a technical or financial background.

### Tools

SQLite · SQLiteViz · Google Sheets/Excel (openpyxl) · Python (pandas) · Matplotlib · Looker Studio

---

## Español

### La historia

Desde hace 9 años, **Rezzonante Producciones** produce eventos de jazz y música improvisada en Ajijic, México — contratando artistas, gestionando sedes, registrando asistencia y pagos, una hoja de cálculo a la vez. Fundé Rezzonante y la dirijo como director artístico, con un equipo pequeño que ayuda a que cada evento suceda. En 2026 empecé a aprender análisis de datos desde cero. Este proyecto es donde esos dos caminos se encuentran: tomé la propia base de datos real de Rezzonante, de 9 años, con todo su desorden, y la convertí en un sistema analítico de verdad — no un ejercicio de tutorial, uno real.

Este análisis se realizó con la misma metodología que aplico a través de **Oráculo Analytics** — es un caso propio y real, no un proyecto de cliente, y se presenta como tal.

Cada número de este proyecto viene de un concierto que Rezzonante produjo de verdad. Cada problema de calidad de dato que se encontró y corrigió —fórmulas rotas, cifras de asistencia mal tecleadas, eventos patrocinados que necesitaban una contabilidad distinta— fue una decisión real, confirmada con quienes de verdad dirigen el negocio antes de aplicar un solo cambio.

### Qué demuestra este proyecto

| Capa                              | Qué muestra                                                                                                                                                                                              |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Modelado de datos**             | Rediseñé una hoja de cálculo plana en un esquema relacional normalizado — una tabla de hechos (`conciertos`), una tabla puente (`artistas`), un catálogo maestro (`catalogo_artistas`), y tablas de referencia de tarifas — con la misma lógica de esquema estrella que se enseña en modelado de datos |
| **Calidad y gobernanza de datos** | Un proceso de auditoría documentado en varias rondas: reparé referencias de fórmula desalineadas, consolidé duplicados en el catálogo, resolví eventos patrocinados, corregí errores de captura — todo confirmado con el dueño real del negocio antes de aplicarlo |
| **Análisis SQL**                  | 4 análisis guiados por preguntas de negocio, desde CTEs hasta lógica cuidadosa de `HAVING`/`GROUP BY`, cada uno arranca con un encuadre breve —contexto de negocio, la pregunta específica, cómo se ve una buena respuesta, la decisión que habilita— antes de escribir una sola consulta |
| **Storytelling de datos**         | Cada gráfica lleva una conclusión como título, no una descripción — siguiendo *Storytelling with Data* de Cole Nussbaumer Knaflic                                                                        |
| **Dashboard de BI**                | Dashboard interactivo de 5 páginas en Looker Studio, conectado en vivo a los datos                                                                                                                       |
| **Documentos de decisión**        | Un documento de decisión ejecutivo y un resumen en lenguaje simple traducen los hallazgos de SQL/BI en recomendaciones de negocio, para dos audiencias distintas                                          |

### Estructura del proyecto

```
rezzonante-data-analysis/
├── README.md
├── Documento_Decision.pdf
├── Resumen_Ejecutivo.html
├── Rezzonante_Producciones.db              # Exportación SQLite, versión final
├── sql/
│   ├── rezzonante_01_trayectoria_historica.sql
│   ├── rezzonante_02_economia_unitaria.sql
│   ├── rezzonante_03_artistas.sql
│   └── rezzonante_04_sedes_generos.sql
├── charts/
│   ├── a1_margen_por_anio.png
│   ├── a2_asistencia_por_anio.png
│   ├── a3_ingreso_produccion_sede.png
│   └── a4_margen_por_genero.png
└── dashboard/
    ├── Looker_Studio_Guia.md
    └── mockups/
```

### Los cuatro análisis

**1 — Economía unitaria: margen real por año**

[![Margen por año](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/a1_margen_por_anio.png)](/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/blob/main/charts/a1_margen_por_anio.png)

Ningún año cerró en números rojos — pero el margen se comprime justo en los años de mayor ingreso. El margen neto acumulado en los 9 años llegó a $795 mil MXN, pero los años de ingreso pico (2024-2025, con $494 mil-$519 mil de ingreso total) muestran una separación visiblemente más angosta entre la línea de ingreso y la línea de margen que en años anteriores — es decir, se queda una porción menor de ese ingreso.

**2 — Asistencia: ¿qué tan grande es el público, y cómo ha crecido?**

[![Asistencia por año](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/a2_asistencia_por_anio.png)](/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/blob/main/charts/a2_asistencia_por_anio.png)

Asistencia total en 9 años: 9,400 personas. De apenas 26 asistentes en 2017, el crecimiento se acumula hasta un pico de 1,744 en 2025 — pero cae a 649 en el año más reciente (parcial), una señal que vale la pena vigilar, no una línea recta hacia arriba.

**3 — ¿Qué producciones y sedes generan más ingreso?**

[![Ingreso por producción y sede](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/a3_ingreso_produccion_sede.png)](/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/blob/main/charts/a3_ingreso_produccion_sede.png)

La producción de mayor ingreso en la historia de Rezzonante es **Tablao Flamenco Internacional 2024** ($198,800 MXN) — y **La Cochera Cultural** domina la parte alta de la lista como la sede que más ingreso genera, apareciendo en la mayoría de las 20 producciones principales por ingreso.

**4 — Sedes y géneros: qué rinde de verdad**

[![Margen por género](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/a4_margen_por_genero.png)](/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/blob/main/charts/a4_margen_por_genero.png)

El género que domina la programación (Jazz Contemporáneo Original, el género insignia) entrega 28% de margen — claramente por debajo de Clásica (63%), Jazz Tradicional (47%) y Blues (42%). El género más programado no es el más rentable.

**Un quinto hallazgo, sin gráfica propia:** los conciertos con al menos un artista internacional convocan notablemente más público que las formaciones 100% nacionales — un patrón confirmado en el análisis SQL correspondiente (`rezzonante_03_artistas.sql`), aunque no sea una de las 4 gráficas de arriba. El ingreso también creció más rápido que el volumen de eventos en los últimos años (145% del nivel de 2019 en ingreso para 2025, contra 129% en número de eventos) — otro hallazgo del análisis original que no tiene gráfica dedicada en esta versión del README.

### Dashboard

Se construyó un dashboard interactivo de 5 páginas en Looker Studio, conectado en vivo a los datos — panorama general, margen, ingreso por producción/sede, crecimiento de asistencia, e impacto de talento internacional vs. nacional. Ver `dashboard/Looker_Studio_Guia.md` para cómo se construyó y cómo reproducirlo.

### Documentos de decisión

- `Documento_Decision.pdf` — una recomendación ejecutiva que traduce los cuatro análisis en una decisión de negocio concreta.
- `Resumen_Ejecutivo.html` — los mismos hallazgos en lenguaje simple, para lectores sin formación técnica o financiera.

### Herramientas

SQLite · SQLiteViz · Google Sheets/Excel (openpyxl) · Python (pandas) · Matplotlib · Looker Studio

---

*De gestionar un proyecto cultural con hojas de cálculo, a convertir esos mismos datos en decisiones — este es el proyecto que documenta esa transición.*
