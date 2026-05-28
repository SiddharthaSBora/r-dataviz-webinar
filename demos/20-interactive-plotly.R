# =============================================================
# Demo 20: Beyond Static: Interactive Plots
# =============================================================
# Goal: Pair with the "When static isn't enough" slide. Show the
# quickest paths from a ggplot to an interactive figure, and be
# honest about when interactivity actually helps.
#
# Requires:
#   - plotly   (CRAN, ggplotly + native plotly)
#   - leaflet  (CRAN, interactive tile maps), optional
#   - ggplot2, dplyr
#
# Note: interactive output only renders in HTML (a browser, RStudio
# Viewer, or a Quarto HTML doc), not in a static PDF or PNG.
# =============================================================

library(ggplot2)
library(dplyr)
library(plotly)
# library(leaflet)  # for the map example below

# ---- 1. ggplotly(): the one-liner ---------------------------------------
# Build a normal ggplot, then wrap it. You get hover tooltips, zoom,
# and pan for free.

p <- ggplot(economics, aes(date, unemploy)) +
  geom_line(color = "#2c5f2d", linewidth = 0.8) +
  labs(title = "US unemployment over time", x = NULL, y = "Unemployed (thousands)") +
  theme_minimal()

ggplotly(p)

# ---- 2. Control the tooltip --------------------------------------------
# Map a `text` aesthetic and tell ggplotly to use it.

mtcars2 <- mtcars |>
  tibble::rownames_to_column("model")

p2 <- ggplot(mtcars2, aes(wt, mpg, text = model)) +
  geom_point(color = "#2c5f2d", size = 2) +
  labs(title = "Weight vs MPG (hover for model)",
       x = "Weight (1000 lbs)", y = "Miles per gallon") +
  theme_minimal()

ggplotly(p2, tooltip = c("text", "x", "y"))

# ---- 3. Native plotly (when you outgrow ggplotly) ----------------------
# plotly has its own grammar; useful for things ggplotly can't express.

plot_ly(mtcars2, x = ~wt, y = ~mpg, type = "scatter", mode = "markers",
        text = ~model, marker = list(color = "#2c5f2d", size = 8)) |>
  layout(title = "Weight vs MPG (native plotly)")

# ---- 4. Interactive maps with leaflet (optional) -----------------------
# leaflet draws tile-based slippy maps (like Google Maps). Great for
# letting users pan/zoom a spatial dataset.
#
# library(leaflet)
# library(sf)
# library(tigris)
# options(tigris_use_cache = TRUE)
#
# wv <- counties(state = "WV", cb = TRUE, year = 2022) |>
#   sf::st_transform(4326)              # leaflet wants lon/lat (WGS84)
#
# pal <- colorNumeric("viridis", domain = NULL)
#
# leaflet(wv) |>
#   addProviderTiles("CartoDB.Positron") |>
#   addPolygons(
#     fillColor   = ~pal(ALAND),        # color by land area, as an example
#     fillOpacity = 0.7,
#     weight      = 1,
#     color       = "white",
#     label       = ~NAME
#   )

# ---- When to use interactive vs static ---------------------------------
# Use INTERACTIVE when:
#   - The output lives on the web / in an HTML report
#   - Users genuinely need to explore: hover for exact values, zoom,
#     toggle series, pan a map
#   - The dataset is dense and a static view would overplot
#
# Stick with STATIC when:
#   - The output is a PDF, a printed report, or a slide
#   - You're making a specific point (a good static figure is a finished
#     argument; interactivity can be a way of avoiding the edit)
#   - Reproducibility and archival matter, a PNG always looks the same
#
# Rule of thumb: interactive for exploration, static for explanation.

# ---- Where to go further -----------------------------------------------
# - Interactive web-based viz with R, plotly, shiny (Sievert): https://plotly-r.com/
# - leaflet for R:  https://rstudio.github.io/leaflet/
# - Shiny (full apps): https://mastering-shiny.org/
