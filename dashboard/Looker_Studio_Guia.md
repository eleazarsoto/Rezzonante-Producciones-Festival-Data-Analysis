# Dashboard en Looker Studio — Guía de construcción

**Rezzonante Producciones · De Excel disperso a inteligencia de negocio**

Looker Studio es 100% web (no genera un archivo descargable como Power BI) — así que esta guía + los mockups de referencia son la forma de saber exactamente qué construir antes de armarlo en vivo.

---

## 1. Conectar los datos

Looker Studio no se conecta directo a un archivo `.db` de SQLite. La ruta más simple, dado que ya trabajas en Excel/Google Sheets:

1. Exporta cada tabla de `Rezzonante_Producciones.db` a una hoja de Google Sheets (una hoja por tabla: `conciertos`, `artistas`, `catalogo_artistas`)
2. En **Looker Studio** (lookerstudio.google.com) → **Crear** → **Fuente de datos** → **Hojas de cálculo de Google**
3. Selecciona el archivo y la hoja `conciertos` como fuente principal
4. Repite para `artistas` y `catalogo_artistas`
5. En el reporte, ve a **Recurso → Gestionar fuentes de datos añadidas** y crea las uniones (joins) necesarias entre `conciertos` y `artistas` (por el campo que los relaciona, probablemente `id_concierto`)

## 2. Campos calculados a crear

En la fuente de datos `conciertos`, agrega estos campos calculados (**Añadir un campo**):

```
Margen_pct = (ingreso_total - costo_total) / ingreso_total

Ingreso_Indexado_2019 = ingreso_total / [ingreso promedio de 2019] * 100
```

En la fuente `artistas`:
```
Es_Internacional = CASE WHEN pais_origen != "México" THEN 1 ELSE 0 END
```
(ajusta el nombre de columna `pais_origen` al que uses realmente en tu tabla)

## 3. Página 1 — Trayectoria histórica (ingreso vs. eventos)

- **Visual:** gráfica de series de tiempo (Time series chart)
- **Dimensión:** año
- **Métricas:** `Ingreso_Indexado_2019` y conteo de eventos (indexado igual, base 2019 = 100)
- **Título:** "El ingreso creció más rápido que el volumen de eventos desde 2022"

## 4. Página 2 — Economía unitaria (margen por año)

- **Visual:** gráfica de columnas
- **Dimensión:** año
- **Métrica:** `Margen_pct` (promedio)
- **Título:** "El margen se comprime justo en los años de mayor ingreso"
- **Tabla de apoyo:** año, ingreso total, costo total, margen % — para que se pueda auditar el número

## 5. Página 3 — Red de artistas (nacional vs. internacional)

- **Visual:** gráfica de barras
- **Dimensión:** `Es_Internacional` (Sí/No)
- **Métrica:** asistencia promedio
- **Título:** "Los conciertos con artistas internacionales convocan 58% más público"

## 6. Página 4 — Sedes y géneros

- **Visual:** gráfica de barras horizontales, ordenada por margen
- **Dimensión:** género
- **Métricas:** número de conciertos (barra) + margen % (línea o color)
- **Título:** "El género insignia no es el más rentable"

## 4 mockups de referencia

Ver los 4 PNG adjuntos (`mockup_pagina1.png` a `mockup_pagina4.png`) — construidos con las mismas cifras que ya están en tus 4 análisis SQL, en la identidad visual de Rezzonante (terracota/turquesa/crema).
