# =============================================================
# Demo 09: Map Basics with sf
# =============================================================
# Goal: Show that a "map" in modern R is just a data frame with a
# special geometry column. Once you accept that, mapping is just
# ggplot with one extra geom (geom_sf).
#
# Requires:
#   - sf      (CRAN, spatial foundation)
#   - tigris  (CRAN, US Census shapefiles)
# =============================================================

library(sf)
library(ggplot2)
library(dplyr)

# Optional but highly recommended, caches shapefiles between sessions
# so you don't re-download 50MB every time you re-run.
# Add to your .Rprofile if you use tigris often.
# options(tigris_use_cache = TRUE)

# ---- Where geometry comes from ------------------------------------------
library(tigris)
options(tigris_use_cache = TRUE)

# US states. cb = TRUE returns cartographic boundary files (simplified,
# smaller, perfect for choropleths). cb = FALSE gets full TIGER lines.
us_states <- states(cb = TRUE, year = 2024, resolution = "20m")

# Inspect: it's literally just a data frame with a geometry column.
glimpse(us_states)
class(us_states)        # [1] "sf" "data.frame"
st_geometry_type(us_states) |> table()    # MULTIPOLYGON, mostly

# ---- The minimum viable map --------------------------------------------
ggplot(us_states) +
  geom_sf() +
  theme_minimal()

# That's it. Five characters of new ggplot syntax: geom_sf().

# ---- Limit to the continental US ---------------------------------------
# Easy filter, Alaska is "02", Hawaii is "15", Puerto Rico is "72"
conus <- us_states |>
  filter(!STUSPS %in% c("AK", "HI", "PR", "GU", "VI", "MP", "AS"))

ggplot(conus) +
  geom_sf(fill = "#97bc62", color = "white", linewidth = 0.3) +
  theme_void()

# ---- County-level geometry ---------------------------------------------
wv_counties <- counties(state = "WV", cb = TRUE, year = 2024)

ggplot(wv_counties) +
  geom_sf(fill = "#97bc62", color = "white", linewidth = 0.3) +
  labs(title = "West Virginia counties") +
  theme_void()

# ---- Two states' counties ----------------------------------------------
two_states <- counties(state = c("WV", "OH"), cb = TRUE, year = 2024)

ggplot(two_states) +
  geom_sf(fill = "#97bc62", color = "white", linewidth = 0.2) +
  labs(title = "Ohio + West Virginia counties") +
  theme_void()
