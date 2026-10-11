---
title: Projects
---

Open source projects from Rocky Branches.

## rb-road-network

**rb-road-network** is a GIS toolkit for estimating market areas and the population they serve. Its C++ engine combines road data with U.S. county boundaries and demographic tables; a Python command-line interface runs analyses and renders their results as maps.

### How it works

The analysis projects the input location, roads, and county boundaries into metric coordinates, then lays a regular grid over the study area. Road segments mark the grid cells they cross. The engine explores repeated paths through adjacent road-bearing cells, limiting each step and the accumulated path length by the requested distance, and marks the cells it can reach. This grid-based traversal approximates a road-distance market area rather than calculating an exact shortest-path isochrone.

County boundaries are checked against the reachable grid: a county is included when a reachable cell center falls inside it, and the county containing the starting point is identified separately. The population table then sums the included counties' available values for 2010, 2015, 2020, 2025, and 2030, and derives growth and market-demand estimates from those totals. These are whole-county totals, not population clipped to the reachable part of each county.

### Example maps

![Example market area around Atlanta: included counties are highlighted in green, with surrounding county boundaries shown in gray.](/images/projects/rb-road-network/justPopResult.png)

*Atlanta-area county coverage from a sample rb-road-network run.*

![Road-network market-area output for the Pigeon Point sample site.](/images/projects/rb-road-network/PigeonPointResult.png)

*A second sample result, illustrating the mapped output for another site.*

### Work underway

The [project changelog](https://github.com/rockybranches/rb-road-network/blob/8ce9dbedf2d4db8b2b93dfb4f39116f6f35493aa/CHANGELOG.md#unreleased) tracks the current direction: making analyses easier to run at multiple locations with a CSV-driven batch command, and automatically rendering a Plotly map after each run (with an option to skip rendering). The same work adds CLI tests and improves error handling for missing or unreadable GIS data.

+ [Source Code](https://github.com/rockybranches/rb-road-network)

## rb-viz

Visualization tooling for spatial and scientific data.

+ [Source Code](https://github.com/rockybranches/rb-viz)

## docker-qgis-postgis

Docker-based setup for QGIS and PostGIS, enabling reproducible geospatial analysis environments.

+ [Source Code](https://github.com/rockybranches/docker-qgis-postgis)

## terrachem

3D terrain and geochemistry generator. Procedural world-building with simulated mineral distribution and erosion.

+ [Source Code](https://github.com/rockybranches/terrachem)

## Forks & Contributions

All projects available on [GitHub](https://github.com/rockybranches).
