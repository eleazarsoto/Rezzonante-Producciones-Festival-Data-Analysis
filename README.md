# Rezzonante Producciones — De Excel disperso a inteligencia de negocio

**Autor:** Eleazar Soto · [github.com/eleazarsoto](https://github.com/eleazarsoto)

*[English](#english) | [Español](#español)*

---

## English

### The story

For 9 years, **Rezzonante Producciones** has been producing jazz and improvised-music events in Ajijic, Mexico — booking artists, managing venues, tracking attendance and payments, one spreadsheet at a time. I founded Rezzonante and lead it as artistic director, and a small team helps bring every event to life. In 2026 I started learning data analysis from scratch. This project is where those two paths meet: I took Rezzonante's own real, 9-year business dataset — originally captured by hand, event by event, from a calendar of dates and graphic materials like event posters and flyers — and turned it into a live, cloud-based BI system.

Every number in this project came from an actual concert Rezzonante produced. Every data-quality issue found and fixed was a real decision, confirmed with the people who actually run the business before a single change was applied.

### What this project demonstrates

| Layer | What it shows |
|---|---|
| **Data modeling** | Built a spreadsheet database designed from the ground up as a normalized relational schema — a fact table (`conciertos`), a bridge table (`artistas`), a master catalog (`catalogo_artistas`), and rate-reference tables — mirroring the star-schema thinking taught in data warehousing |
| **Data quality & governance** | A documented, multi-round audit process, extending into the BigQuery stage: identified and corrected 5 real capture errors (a fixed cost misapplied across satellite venues, a duplicated event record, a phantom cost, two attendance inconsistencies) — each confirmed against the actual business owner before applying |
| **Cloud data warehousing** | Migrated the full relational schema to Google BigQuery, resolving real-world ingestion issues (header-detection failures, schema mismatches) along the way |
| **SQL analysis** | 4 business-question-driven queries answering: what's our real net margin, which productions and venues drive revenue, how has attendance grown, and does international programming actually pay off |
| **BI dashboarding** | Built a 6-page interactive dashboard in Looker Studio, connected live to BigQuery, with cross-page navigation and business-question-driven page titles |
| **Data storytelling** | Every chart has a conclusion as its title, not a description — following Cole Nussbaumer Knaflic's *Storytelling with Data* |

### Project structure

```
rezzonante-data-analysis/
├── README.md
├── sql/
│   ├── margen_neto_por_anio.sql
│   ├── ingreso_por_produccion_sede.sql
│   ├── asistencia_total_por_anio.sql
│   └── nacionalidad_artistas.sql
└── charts/
    ├── b1_resumen_general.png
    ├── b2_margen_neto_por_anio.png
    ├── b3_nacionalidad_asistencia.png
    └── b4_asistencia_total_por_anio.png
```

### The four analyses

**1 — General overview: how is the business doing?**

![General overview](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/b1_resumen_general.png)

Attendance has grown faster than the number of events since 2021 — 135 concerts, 9,378 total attendees, 143 artists, and 20 venues across a 9-year history.

**2 — Net margin: how much are we really keeping per event?**

![Net margin by year](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/b2_margen_neto_por_anio.png)

Before a data-quality audit, net margin appeared to have collapsed from ~19% (2023) to ~7% (2025) — a false signal traced to 5 real capture errors. Corrected, margin proved **stable between 19% and 33% every year since 2018**.

**3 — Nationality: does international programming pay off?**

![Attendance by lineup nationality](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/b3_nacionalidad_asistencia.png)

Concerts with a fully international lineup draw more than double the average attendance of fully domestic shows — though on a small sample (3 concerts), a limitation worth flagging rather than hiding.

**4 — Attendance: how is our audience growing?**

![Total attendance by year](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/b4_asistencia_total_por_anio.png)

Attendance nearly quadrupled from its 2021 low, reaching a record 1,744 in 2025 — almost entirely without VIP ticketing, which points to an untapped revenue lever.

### Live dashboard

The same BigQuery tables feed a 6-page interactive dashboard in Looker Studio — Index, General Report, Artists, Net Margin, Estimated Revenue, Attendance, and Nationality, each page framed around a specific business question.

🔗 **[View the live dashboard on Looker Studio](https://datastudio.google.com/reporting/9743acdc-7607-48e6-bacd-4db00c438d0b)**

### Tools

Google Sheets · Google BigQuery · Looker Studio · SQL · Python (pandas, Matplotlib)

### What's next

An entity-relationship diagram of the schema, a defined North Star Metric for the dashboard, Python scripts to formalize the data-cleaning pipeline, and confidence-rated findings (flagging which insights are high-certainty vs. directional — like the small-sample caveat on international lineups above) as the analysis matures.

---

## Español

### La historia

Desde hace 9 años, **Rezzonante Producciones** produce eventos de jazz y música improvisada en Ajijic, México — contratando artistas, gestionando sedes, registrando asistencia y pagos, una hoja de cálculo a la vez. Fundé Rezzonante y la dirijo como director artístico, con un equipo pequeño que ayuda a que cada evento suceda. En 2026 empecé a aprender análisis de datos desde cero. Este proyecto es donde esos dos caminos se encuentran: tomé la propia base de datos real de Rezzonante, de 9 años —capturada originalmente a mano, evento por evento, a partir de un calendario de fechas y material gráfico como pósters y publicidad— y la convertí en un sistema de BI en la nube, en vivo.

Cada número de este proyecto viene de un concierto que Rezzonante produjo de verdad. Cada problema de calidad de dato que se encontró y corrigió fue una decisión real, confirmada con quienes de verdad dirigen el negocio antes de aplicar un solo cambio.

### Qué demuestra este proyecto

| Capa | Qué muestra |
|---|---|
| **Modelado de datos** | Construí una base de datos en hojas de cálculo diseñada desde cero como un esquema relacional normalizado — una tabla de hechos (`conciertos`), una tabla puente (`artistas`), un catálogo maestro (`catalogo_artistas`), y tablas de referencia de tarifas — con la misma lógica de esquema estrella que se enseña en modelado de datos |
| **Calidad y gobernanza de datos** | Un proceso de auditoría documentado en varias rondas, extendido hasta la etapa de BigQuery: identifiqué y corregí 5 errores reales de captura (un costo fijo mal aplicado a sedes satélite, un registro de evento duplicado, un costo fantasma, dos inconsistencias de asistencia) — cada uno confirmado con el dueño real del negocio antes de aplicarlo |
| **Data warehousing en la nube** | Migré el esquema relacional completo a Google BigQuery, resolviendo problemas reales de ingesta (fallas de detección de encabezados, desajustes de esquema) en el camino |
| **Análisis SQL** | 4 consultas guiadas por preguntas de negocio que responden: ¿cuál es nuestro margen neto real?, ¿qué producciones y sedes generan más ingreso?, ¿cómo ha crecido la asistencia?, y ¿la programación internacional realmente rinde? |
| **Dashboards de BI** | Construí un dashboard interactivo de 6 páginas en Looker Studio, conectado en vivo a BigQuery, con navegación entre páginas y títulos guiados por preguntas de negocio |
| **Storytelling de datos** | Cada gráfica lleva una conclusión como título, no una descripción — siguiendo *Storytelling with Data* de Cole Nussbaumer Knaflic |

### Estructura del proyecto

```
rezzonante-data-analysis/
├── README.md
├── sql/
│   ├── margen_neto_por_anio.sql
│   ├── ingreso_por_produccion_sede.sql
│   ├── asistencia_total_por_anio.sql
│   └── nacionalidad_artistas.sql
└── charts/
    ├── b1_resumen_general.png
    ├── b2_margen_neto_por_anio.png
    ├── b3_nacionalidad_asistencia.png
    └── b4_asistencia_total_por_anio.png
```

### Los cuatro análisis

**1 — Resumen general: ¿cómo va el negocio?**

![Resumen general](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/b1_resumen_general.png)

La asistencia ha crecido más rápido que el número de eventos desde 2021 — 135 conciertos, 9,378 asistentes totales, 143 artistas y 20 sedes a lo largo de 9 años de historia.

**2 — Margen neto: ¿cuánto estamos reteniendo realmente por evento?**

![Margen neto por año](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/b2_margen_neto_por_anio.png)

Antes de una auditoría de calidad de datos, el margen neto parecía haberse desplomado de ~19% (2023) a ~7% (2025) — una señal falsa rastreada hasta 5 errores reales de captura. Ya corregido, el margen resultó **estable entre 19% y 33% cada año desde 2018**.

**3 — Nacionalidad: ¿la programación internacional rinde?**

![Asistencia por nacionalidad del elenco](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/b3_nacionalidad_asistencia.png)

Los conciertos con elenco 100% internacional convocan más del doble de asistencia promedio que las formaciones 100% nacionales — aunque sobre una muestra pequeña (3 conciertos), una limitación que vale la pena señalar en vez de esconder.

**4 — Asistencia: ¿cómo está creciendo nuestro público?**

![Asistencia total por año](https://github.com/eleazarsoto/Rezzonante-Producciones-Festival-Data-Analysis/raw/main/charts/b4_asistencia_total_por_anio.png)

La asistencia casi se cuadruplicó desde su mínimo en 2021, alcanzando un récord de 1,744 en 2025 — casi por completo sin venta de boletos VIP, lo que apunta a una palanca de ingreso todavía sin explotar.

### Dashboard en vivo

Las mismas tablas de BigQuery alimentan un dashboard interactivo de 6 páginas en Looker Studio — Índice, Reporte General, Artistas, Margen Neto, Ingreso Estimado, Asistencia y Nacionalidad, cada una enmarcada en torno a una pregunta de negocio específica.

🔗 **[Ver el dashboard en vivo en Looker Studio](https://datastudio.google.com/reporting/9743acdc-7607-48e6-bacd-4db00c438d0b)**

### Herramientas

Google Sheets · Google BigQuery · Looker Studio · SQL · Python (pandas, Matplotlib)

### Lo que sigue

Un diagrama entidad-relación del esquema, una Métrica Norte definida para el dashboard, scripts de Python para formalizar el pipeline de limpieza de datos, y hallazgos con nivel de confianza marcado (señalando qué insights son de alta certeza vs. direccionales — como la salvedad de muestra pequeña en el elenco internacional de arriba) conforme madure el análisis.

