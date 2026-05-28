# Data Visualization in R: Webinar Materials

A 90-minute webinar on data visualization in R: static figures, maps,
and accessibility. The theory section follows *R for Data Science (2e)*,
chapters 1–11.

## Contents

- `slides/r-dataviz-slides.qmd`: the slide deck (Quarto revealjs)
- `slides/custom.scss`: the deck theme (house greens)
- `live-coding/live-coding.qmd`: companion document, every chunk runnable
- `cheatsheet/cheatsheet.qmd`: one-page reference
- `demos/`: 21 standalone `.R` scripts, one concept each
- `R/helpers.R`: shared functions used by the demos

## Setup

Open `r-dataviz-webinar.Rproj` in RStudio, then install packages:

```r
install.packages(c(
  "tidyverse", "scales", "patchwork", "viridis", "colorspace",
  "sf", "tigris", "tidycensus", "ggspatial", "crsuggest", "ggrepel",
  "terra", "tidyterra", "ragg", "here", "gapminder", "plotly"
))

# Optional: only needed if you uncomment those sections:
#   leaflet (demo 20, interactive maps), colorBlindness (demo 08),
#   rnaturalearth (slides, world-map data example)
install.packages(c("leaflet", "colorBlindness", "rnaturalearth"))

# Optional: enables code-linking (functions link to their docs) when
# rendering the live-coding companion. Rendering works without them.
install.packages(c("downlit", "xml2"))
```

The map demos download shapefiles from the Census Bureau (needs
internet). Demo 19 also needs a free Census API key:
`tidycensus::census_api_key("YOUR_KEY", install = TRUE)`.

## Render

```bash
quarto render slides/r-dataviz-slides.qmd
quarto render live-coding/live-coding.qmd
quarto render cheatsheet/cheatsheet.qmd
```

For a printable PDF of the slides, open the rendered HTML, append
`?print-pdf` to the URL, and print from the browser.

## Demos

Each file in `demos/` is self-contained, open and run line by line.
The demos build on one another, ending with a capstone that chains the
whole pipeline into one shareable figure.

```
01-tidy-data            12-map-faceted-comparison
02-long-vs-wide         13-map-polish
03-first-ggplot         14-patchwork
04-layered-improvement  15-ggsave-export
05-color-palettes       16-common-pitfalls
06-themes-and-fonts     17-reproducibility
07-faceting             18-raster-basics
08-accessibility        19-census-wv-counties
09-map-basics-sf        20-interactive-plotly
10-map-choropleth       21-infographic   (capstone)
11-map-projections
```

Six demos (04, 07, 08, 14, 17, 21) source `R/helpers.R`, which provides
`life_exp_sample()`, `theme_webinar()`, and the `okabe_ito` palette.

## License

MIT. Use, modify, and redistribute freely. See [LICENSE](LICENSE).
