# =============================================================
# Demo 13: Map Polish
# =============================================================
# Goal: The details that separate a competent map from a great one.
#   - Right scale type (sequential vs diverging)
#   - Direct region labels
#   - Drop chrome (axes, grids), theme_void
#   - Scale bar and north arrow (only when needed)
#   - Always caption the data source
#
# Requires:
#   - ggspatial (CRAN, for scale bar and north arrow)
#   - ggrepel (CRAN, for non-overlapping labels)
# =============================================================

library(sf)
library(tigris)
library(ggplot2)
library(dplyr)
library(tibble)
library(scales)
library(ggspatial)
# library(ggrepel)  # use for non-overlapping labels with geom_text_repel

options(tigris_use_cache = TRUE)

# ---- Sample data: WV counties with fake values --------------------------
wv <- counties(state = "WV", cb = TRUE, year = 2024)

# Build a fake value with a meaningful midpoint (e.g., change from
# state average) so we can demonstrate a diverging palette.
set.seed(42)
wv <- wv |>
  mutate(deviation = runif(n(), -10, 10))   # percent deviation from average

# ---- 1. Diverging palette (because data has a midpoint of 0) -----------
ggplot(wv) +
  geom_sf(aes(fill = deviation), color = "white", linewidth = 0.2) +
  scale_fill_distiller(
    palette   = "RdBu",
    direction = -1,                              # red for negative deviation
    limits    = c(-10, 10),
    labels    = label_number(suffix = "pp")      # "percentage points"
  ) +
  labs(title = "Deviation from state average: diverging palette",
       fill  = NULL) +
  theme_void()

# ---- 2. Direct labels for regions --------------------------------------
# Use geom_sf_text() for centered labels, or geom_sf_label() for
# labels with a background box. For non-overlapping labels use
# ggrepel::geom_text_repel(stat = "sf_coordinates").

ggplot(wv) +
  geom_sf(aes(fill = deviation), color = "white", linewidth = 0.2) +
  geom_sf_text(aes(label = NAME), size = 2.2, color = "grey15") +
  scale_fill_distiller(palette = "RdBu", direction = -1, limits = c(-10, 10)) +
  labs(title = "Direct labels on each county", fill = NULL) +
  theme_void()

# Labels can crowd. Two strategies:
#   (a) Only label "key" regions: filter the data passed to geom_sf_text
#   (b) Use ggrepel::geom_text_repel(stat = "sf_coordinates") to push
#       labels apart automatically.

# ---- 3. Drop axes and gridlines with theme_void ------------------------
# For choropleths, the axes are just noise. theme_void removes them all.
# Compare:

ggplot(wv) + geom_sf(aes(fill = deviation)) +
  scale_fill_distiller(palette = "RdBu", direction = -1) +
  labs(title = "Default theme (axes, grid)") +
  theme_gray()

ggplot(wv) + geom_sf(aes(fill = deviation)) +
  scale_fill_distiller(palette = "RdBu", direction = -1) +
  labs(title = "theme_void (clean)") +
  theme_void()

# ---- 4. Scale bar and north arrow --------------------------------------
# Only when geographic precision matters. For "compare region A to B"
# choropleths, often SKIP these, they add chrome without adding info.

ggplot(wv) +
  geom_sf(aes(fill = deviation), color = "white", linewidth = 0.2) +
  scale_fill_distiller(palette = "RdBu", direction = -1, limits = c(-10, 10)) +
  annotation_scale(location = "br",
                   bar_cols = c("grey20", "white")) +
  annotation_north_arrow(location = "tr",
                         style = north_arrow_minimal()) +
  labs(title = "With scale bar and north arrow", fill = NULL) +
  theme_void()

# ---- 5. Always caption the data source ---------------------------------
ggplot(wv) +
  geom_sf(aes(fill = deviation), color = "white", linewidth = 0.2) +
  scale_fill_distiller(palette  = "RdBu",
                       direction = -1,
                       limits   = c(-10, 10),
                       labels   = label_number(suffix = "pp")) +
  labs(title    = "West Virginia counties",
       subtitle = "Deviation from state average",
       caption  = "Source: simulated data; geometry from US Census TIGER/Line, 2024",
       fill     = NULL) +
  theme_void(base_size = 13) +
  theme(plot.title    = element_text(face = "bold"),
        plot.subtitle = element_text(color = "grey40"),
        plot.caption  = element_text(color = "grey50", hjust = 0))
