---
title: Projects
---

Open source projects from Rocky Branches.

This site and the project web apps share one brand kit, rb-brand: the same logo, colors, icons, and layout patterns, defined in one place and inherited everywhere else. The rb-road-network map page and the rb-rimrock site carry the same mark and colors as this site, and rb-viz uses the brand's neutral colors for chart grid lines and annotations.

## rb-road-network

**rb-road-network** produces market area reports by road distance. Give it a start point and a distance by road: it finds the area that can be reached within that distance, lists the U.S. counties the area touches, and reports their population from 2010 to 2030 with the tons of material that population implies.

The analysis runs as a Python Worker on Cloudflare, reading its road, county, and population data from a D1 database. It replaced the project's earlier C++ program in November 2026. There are two ways to use it:

- **The map page**, served by the Worker: click a start point, run, and see the reachable area and the county table.
- **The command-line client**, which sends the same requests and saves the report files.

### How it works

Roads and county boundaries are stored on one national grid of 250 m cells. The roads are OpenStreetMap data for the whole contiguous United States, from the November 2026 Geofabrik state extracts.

A request loads the grid tiles around the start point. If the point is not on a road, it is moved to the nearest road cell, up to 2 km away. A shortest-path search then runs across road cells and keeps every cell within the distance budget: 75 km by default, and anywhere from 1 km to 300 km. The same input always gives the same answer. The earlier program traced random walks along the roads, so two runs could reach different counties.

A county is included when the reachable area touches it; an option leaves out counties with less reachable area than a given figure. The report sums the included counties' population for 2010, 2015, 2020, 2025, and 2030, then derives the increase from 2015 to 2030 and the tons of material at a set rate per person (4.5 by default). These are whole-county totals, not population clipped to the reachable part of each county. Counties without a figure for every year are listed separately rather than dropped.

### The map page

- **Analyze:** set the start point by clicking the map or typing coordinates, then run. The reachable area is drawn in five bands of road distance, with a legend, a label on the start point, and a button that zooms to the area.
- **Downloads:** the population table in LaTeX, the reachable area as GeoJSON, and the map as a PNG image. A fully detailed GeoJSON, with every reached 250 m cell, is built in the background and offered when it is ready.
- **Saved:** every analysis is stored, and each has a link that opens it again.
- **Batches:** upload a CSV with `site`, `lat`, and `lon` columns, up to 500 sites. Sites run one at a time, so a batch can be stopped and resumed, and it ends with a summary CSV of one line per site.

The deployed Worker is private: it sits behind Cloudflare Access, so the map page and the API both need a sign-in.

### Command-line client

```shell
rb-road-network status
rb-road-network run --lat 33.732 --lon -84.4166 --name Atlanta
rb-road-network batch --csv batch_inputs.csv
```

`run` prints the county table and saves the LaTeX table, the full result as JSON, and the reachable area as GeoJSON. `batch` does the same for every site in a CSV, and an interrupted batch continues with `--resume`.

### Example maps

These two maps come from the earlier C++ program. The Worker reports the same kind of county coverage, drawn on the map page instead of as an image file.

![Example market area around Atlanta: included counties are highlighted in green, with surrounding county boundaries shown in gray.](/images/projects/rb-road-network/justPopResult.png)

*Atlanta-area county coverage from a sample run of the earlier program.*

![Road-network market-area output for the Pigeon Point sample site.](/images/projects/rb-road-network/PigeonPointResult.png)

*A second sample result from the earlier program, for another site.*

+ [Source code](https://github.com/rockybranches/rb-road-network)

## rb-rimrock

A collaborative project supporting the Rimrock-Snowstorm mining project in Nevada, USA. **rb-rimrock** is a Python pipeline and command-line tool (`rimrock`) that loads drill-hole assay data, correlates element concentrations against gold (Au), and produces bar plots, pie charts, and interactive map popups using `geopandas`, `plotly`, and `folium`. A FastAPI web interface serves the results, and the data can be packaged into a database for Cloudflare D1.

+ [Project site](https://rb-rimrock.rockybranches.com)
+ [Source code](https://github.com/rockybranches/rb-rimrock)

## rb-viz

**rb-viz** is the shared data visualization library of the Rocky Branches projects: one set of colors, charts, maps, and page blocks, so that a strip log or a correlation matrix looks and behaves the same in rb-rimrock, rb-assay, rb-road-network, and in a notebook.

It has two halves that share one color definition:

- **JavaScript and CSS**, for web apps and generated dashboards. Charts are drawn with Plotly and maps with Leaflet.
- **Python** (`rb_viz`), for notebooks, reports, and static images, built on matplotlib with Plotly and folium as extras.

The components cover drill-hole strip logs, correlation and matrix heatmaps, ranked bars, cross-plots, histograms, 3D drill holes, and plan views; Leaflet layers for graded sample points, drill collars, and reachable areas in distance bands; and page blocks such as stat tiles, sortable tables, and an image lightbox.

### Walkthrough

The screenshots below are from the component gallery, which draws every component with made-up data. To run it from a checkout of rb-viz:

```shell
npm install
npm run gallery        # then open http://localhost:8765/examples/
```

**1. Draw a strip log.** Chart functions return a plain `{ data, layout, config }` object, and `draw()` puts it on the page. A strip log takes a list of tracks, each a set of depth intervals: categories for lithology, values for assays.

```html
<link rel="stylesheet" href="rb-viz.css">
<script src="https://cdn.jsdelivr.net/npm/plotly.js-dist-min@2.35.2/plotly.min.js"></script>
<div id="strip" class="plot" style="height:640px"></div>
<script type="module">
  import { draw, stripLog, onDepthPick, lithologyColor } from "./rb-viz.esm.js";

  draw("strip", stripLog([
    { type: "category", title: "Lithology", color: lithologyColor,
      intervals: [{ from: 0, to: 40, label: "Shale" }, { from: 40, to: 100, label: "Chert" }] },
    { type: "value", title: "Au (g/t)", name: "Au", log: true,
      intervals: [{ from: 0, to: 5, value: 0.02 }, { from: 5, to: 10, value: 1.4 }] },
  ], { depthTitle: "Depth (ft)" }));
  onDepthPick("strip", (depth) => console.log("picked", depth));
</script>
```

`onDepthPick` reports the depth a reader clicks, which the gallery uses to fill the detail card beside the log. `rankedBars` takes a mapping of names to values and sorts it.

![A strip log with a lithology column and four value tracks against depth, a selected depth marked in red, a card of element values for that depth, and a ranked bar chart of correlation with gold.](/images/projects/rb-viz/drill-hole.png)

*`stripLog` with a selected depth, and `rankedBars`.*

**2. Add the geochemistry charts.** Every chart is drawn the same way, so a page is mostly a list of `draw()` calls:

```js
draw("corr", correlationHeatmap({ labels, matrix }));
draw("cross", crossPlot(
  [{ name: "Other holes", points: others }, { name: "H1", points: mine }],
  { xTitle: "Ag g/t", yTitle: "Au g/t" }));
draw("hist", logHistogram(
  [{ name: "Other holes", values: otherAu }, { name: "H1", values: mineAu }],
  { title: "Au (g/t)", binSize: 0.15 }));
```

![A correlation heatmap of ten elements, a matrix heatmap of correlation with gold by hole, a cross-plot of gold against silver with one hole highlighted, a histogram of gold values, and two overlaid line scans.](/images/projects/rb-viz/geochemistry.png)

*`correlationHeatmap`, `matrixHeatmap`, `crossPlot`, `logHistogram`, and `lineOverlay`.*

**3. Switch themes.** The stylesheet holds the color tokens for light and dark. Charts read their colors when they are drawn, so draw them again after a switch:

```js
bindThemeToggle(button, { onChange: redraw });
```

![The same strip log, detail card, and ranked bar chart in the dark theme.](/images/projects/rb-viz/drill-hole-dark.png)

*The drill-hole components in the dark theme.*

**4. Use the same look from Python.** Figure functions take data and return a figure:

```python
import pandas as pd
from rb_viz import figures

fig = figures.ranked_bars(pd.Series({"As": 0.41, "Sb": 0.37, "Hg": 0.12}), xlabel="R² with Au", annotate_from=0.1)
fig.savefig("r2.png")
```

`rb_viz.web.standalone_page()` goes one step further and writes a dashboard as a single HTML file, with the JavaScript components and your data inlined.

+ [Source code](https://github.com/rockybranches/rb-viz)

## docker-qgis-postgis

Docker-based setup for QGIS and PostGIS, enabling reproducible geospatial analysis environments.

+ [Source code](https://github.com/rockybranches/docker-qgis-postgis)

## terrachem

3D terrain and geochemistry generator. Procedural world-building with simulated mineral distribution and erosion.

+ [Source code](https://github.com/rockybranches/terrachem)

---

All of our projects, forks, and contributions are on [GitHub](https://github.com/rockybranches).
