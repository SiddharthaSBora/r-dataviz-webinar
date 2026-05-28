# =============================================================
# Demo 12: Faceted Comparison Map
# =============================================================
# Goal: Show "small multiples for maps", putting two or more
# regions side by side in panels using facet_wrap.
#
# This is the workflow for "compare region A to region B" maps.
# =============================================================

library(sf)
library(tigris)
library(ggplot2)
library(dplyr)
library(tibble)
library(scales)

options(tigris_use_cache = TRUE)

# ---- Get geometry for two states' counties ------------------------------
two_states <- counties(state = c("WV", "OH"), cb = TRUE, year = 2024)

# Add the state name as a clean column for faceting
two_states <- two_states |>
  mutate(state_name = if_else(STATEFP == "39", "Ohio", "West Virginia"))

# ---- Fake some data to color by -----------------------------------------
# In real work this is your CSV of indicator values by county GEOID.
set.seed(42)
fake_indicator <- tibble(
  GEOID = two_states$GEOID,
  value = runif(nrow(two_states), 5, 25)   # e.g., a percentage 5-25%
)

mapped <- two_states |>
  left_join(fake_indicator, by = "GEOID")

# ---- The faceted comparison map -----------------------------------------
ggplot(mapped) +
  geom_sf(aes(fill = value), color = "white", linewidth = 0.1) +
  scale_fill_viridis_c(option = "D",
                       labels = label_number(suffix = "%")) +
  facet_wrap(~ state_name) +
  labs(title    = "County-level indicator comparison",
       subtitle = "Ohio vs West Virginia, fake demonstration data",
       caption  = "Source: simulated data; geometry from US Census TIGER/Line",
       fill     = NULL) +
  theme_void(base_size = 13) +
  theme(plot.title    = element_text(face = "bold"),
        plot.subtitle = element_text(color = "grey40"),
        plot.caption  = element_text(color = "grey50", hjust = 0),
        strip.text    = element_text(face = "bold", size = 13),
        legend.position = "bottom",
        legend.key.width  = unit(2, "cm"),
        legend.key.height = unit(0.4, "cm"))

# ---- A few notes -------------------------------------------------------
# - geom_sf() uses coord_sf(), and ggplot2 does not allow scales =
#   "free" with coord_sf(): all panels share one coordinate range. For
#   adjacent, similarly sized states like OH and WV this reads fine. To
#   size each panel to its own region, draw separate maps and combine
#   them with patchwork (see demo 14) instead of faceting.
# - Shared color scale (the legend at the bottom) lets readers compare
#   values across panels directly.
# - Use a SEQUENTIAL palette (viridis) when comparing "more vs less".
#   Use a DIVERGING palette (RdBu) when comparing "above vs below a
#   midpoint" (e.g., national average).
