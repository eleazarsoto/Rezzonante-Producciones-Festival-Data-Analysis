Turned 9 years of my own business data into a live BI dashboard — and found the 
real story only after auditing the data.

I run Rezzonante Producciones, a concert and festival production company in 
Ajijic, Mexico. This year I started learning data analysis from scratch, and I 
used my own 9-year operational dataset — captured by hand from posters, flyers, 
and a calendar of dates — as the real-world project: not a tutorial, an actual 
business.

The pipeline: Google Sheets → SQL → Google BigQuery → Looker Studio.

Before trusting the numbers enough to dashboard them, I audited the data and 
found 5 real capture errors — a fixed cost misapplied across satellite venues, 
a duplicated event, a phantom charge, two attendance mismatches. Before the fix, 
net margin looked like it had collapsed from ~19% to ~7% in two years. After the 
fix, margin turned out to be stable between 19-33% every year since 2018 — a 
completely different read on the business.

The dashboard also surfaced something I hadn't seen with my own eyes running 
this business for 9 years: attendance nearly quadrupled since 2021, reaching a 
record in 2025 — almost entirely without VIP ticketing. That's a revenue lever 
sitting unused.

Full write-up, SQL queries, and the live dashboard link are in the repo.

#DataAnalytics #BigQuery #LookerStudio #SQL #DataQuality

Un diagrama entidad-relación del esquema, una Métrica Norte definida para el dashboard, scripts de Python para formalizar el pipeline de limpieza de datos, y hallazgos con nivel de confianza marcado (señalando qué insights son de alta certeza vs. direccionales — como la salvedad de muestra pequeña en el elenco internacional de arriba) conforme madure el análisis.

