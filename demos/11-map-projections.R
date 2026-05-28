# =============================================================
# Demo 11: Map Projections
# =============================================================
# Goal: Show why a default US map looks "stretched" and how to fix it
# in one line. Plus the trick for fitting Alaska and Hawaii on a
# national map.
#
# A projection is a mathematical recipe for flattening the curved
# Earth onto a flat 2D page. Different projections preserve different
# properties (area, shape, distance, direction), you cannot preserve
# all of them simultaneously.
#
# For thematic choropleths, you almost always want an EQUAL AREA
# projection so that region sizes are proportional to their actual
# ground area.
# =============================================================

library(sf)
library(tigris)
library(ggplot2)
library(dplyr)
library(patchwork)

options(tigris_use_cache = TRUE)

us_states <- states(cb = TRUE, year = 2024, resolution = "20m")
conus <- us_states |>
  filter(!STUSPS %in% c("AK", "HI", "PR", "GU", "VI", "MP", "AS"))

# ---- Three projections side by side ------------------------------------

# 1. Default: unprojected lon/lat (EPSG:4269 / NAD83). Looks stretched.
p_default <- ggplot(conus) +
  geom_sf(fill = "#97bc62", color = "white", linewidth = 0.2) +
  labs(title = "Default (lon/lat: stretched)") +
  theme_void()

# 2. Albers Equal Area Conic (EPSG:5070). The standard for continental US.
p_albers <- ggplot(conus) +
  geom_sf(fill = "#97bc62", color = "white", linewidth = 0.2) +
  coord_sf(crs = "EPSG:5070") +
  labs(title = "Albers Equal Area (EPSG:5070)") +
  theme_void()

# 3. Web Mercator (EPSG:3857). The Google Maps projection.
# Areas are NOT proportional, Greenland is the size of Africa.
# Almost never the right choice for a thematic map.
p_mercator <- ggplot(conus) +
  geom_sf(fill = "#97bc62", color = "white", linewidth = 0.2) +
  coord_sf(crs = "EPSG:3857") +
  labs(title = "Web Mercator (don't use for choropleths)") +
  theme_void()

p_default / p_albers / p_mercator

# ---- The Alaska/Hawaii problem -----------------------------------------
# Alaska and Hawaii are far from the continental US. Plotting them
# at their true positions gives you a mostly-empty map. The fix:
# tigris::shift_geometry() rescales and moves them so the whole
# country fits on one page.

us_shifted <- us_states |>
  shift_geometry(position = "below", preserve_area = FALSE)

ggplot(us_shifted) +
  geom_sf(fill = "#97bc62", color = "white", linewidth = 0.2) +
  labs(title = "shift_geometry(): Alaska and Hawaii rescaled to fit") +
  theme_void()

# Options for shift_geometry():
#   position = "below" or "outside"
#   preserve_area = TRUE or FALSE  (TRUE keeps area proportional;
#                                   FALSE makes them more visible)

# ---- Picking a projection for somewhere else --------------------------
# For non-US data, the crsuggest package can recommend a projection.
#
# library(crsuggest)
# suggest_crs(my_sf_object, type = "projected")
#
# A few useful CRSs:
#   World maps:          EPSG:8857 (Equal Earth)  or "+proj=robin" (Robinson)
#   Continental US:      EPSG:5070 (Albers Equal Area)
#   State-level (US):    EPSG:5070 or a state plane (varies by state)
#   Whole globe (web):   EPSG:3857 (only for tile-based web maps)

# ---- The takeaway ------------------------------------------------------
# - ALWAYS set a projection deliberately; the default is rarely right.
# - For continental US: coord_sf(crs = "EPSG:5070").
# - For national US (with AK/HI): + shift_geometry() before plotting.
# - Areas must be proportional for a choropleth to be honest.
