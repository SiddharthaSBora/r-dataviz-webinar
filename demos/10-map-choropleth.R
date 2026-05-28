# =============================================================
# Demo 10: Choropleth Maps: Join Data to Geometry
# =============================================================
# Goal: A complete minimum example. Get geometry, get a value per
# region, join them, plot.
#
# This is "the workflow", once you have it, every other map is
# a variation on these six steps.
# =============================================================

library(sf)
library(tigris)
library(ggplot2)
library(dplyr)
library(tibble)
library(scales)

options(tigris_use_cache = TRUE)

# ---- Step 1: get geometry ----------------------------------------------
us_states <- states(cb = TRUE, year = 2024, resolution = "20m")

# Limit to continental US for this demo
conus <- us_states |>
  filter(!STUSPS %in% c("AK", "HI", "PR", "GU", "VI", "MP", "AS"))

# ---- Step 2: get data --------------------------------------------------
# In real work this comes from a CSV. Here we generate fake values
# for illustration only.
set.seed(42)
my_data <- tibble(
  state_abbr = state.abb,
  value      = runif(50, 0, 100)
)

# ---- Step 3: join data to geometry -------------------------------------
# Notice this is just a regular dplyr left_join, sf objects work like
# data frames for joins. The key is matching the right columns.
states_with_data <- conus |>
  left_join(my_data, by = c("STUSPS" = "state_abbr"))

# ---- Step 4: plot ------------------------------------------------------
ggplot(states_with_data) +
  geom_sf(aes(fill = value), color = "white", linewidth = 0.2) +
  scale_fill_viridis_c(option = "D", labels = label_number(suffix = "%")) +
  labs(title = "US states: example choropleth (random data)",
       fill  = "Value") +
  theme_void(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

# ---- Step 5: improve with the right CRS --------------------------------
# Albers Equal Area for continental US, areas are proportional
ggplot(states_with_data) +
  geom_sf(aes(fill = value), color = "white", linewidth = 0.2) +
  scale_fill_viridis_c(option = "D", labels = label_number(suffix = "%")) +
  coord_sf(crs = "EPSG:5070") +    # set the projection
  labs(title = "Same map, Albers Equal Area projection",
       fill  = "Value") +
  theme_void(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

# ---- Step 6: caption your data source ----------------------------------
# Every public-facing map needs a source caption. No exceptions.
ggplot(states_with_data) +
  geom_sf(aes(fill = value), color = "white", linewidth = 0.2) +
  scale_fill_viridis_c(option = "D", labels = label_number(suffix = "%")) +
  coord_sf(crs = "EPSG:5070") +
  labs(title    = "US states: example choropleth",
       subtitle = "Random demonstration data",
       caption  = "Source: simulated data; geometry from US Census Bureau TIGER/Line",
       fill     = "Value") +
  theme_void(base_size = 13) +
  theme(plot.title    = element_text(face = "bold"),
        plot.subtitle = element_text(color = "grey40"),
        plot.caption  = element_text(color = "grey50", hjust = 0))
