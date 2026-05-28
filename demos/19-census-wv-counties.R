# =============================================================
# Demo 19: Working with Census Data: WV County Choropleth
# =============================================================
# Goal: Pair with the "Real census data, WV counties" slide.
# Show the canonical workflow: pull geometry + ACS data in one
# call with tidycensus, then drop it straight into ggplot.
#
# Requires:
#   - tigris      (CRAN, Census TIGER shapefiles)
#   - tidycensus  (CRAN, ACS / decennial via the Census API)
#   - sf, dplyr, ggplot2, scales
#
# Setup: get a free Census API key at
#   https://api.census.gov/data/key_signup.html
# then add it to your project .Renviron as:
#   CENSUS_API_KEY="your_key_here"
# =============================================================

library(tigris)
library(tidycensus)
library(sf)
library(dplyr)
library(ggplot2)
library(scales)

options(tigris_use_cache = TRUE)

# Register the key from the environment (set in .Renviron).
census_api_key(Sys.getenv("CENSUS_API_KEY"))

# ---- Path A: geometry from tigris, data joined manually -----------------
# Useful when your data comes from a CSV or another source (not the
# Census API). This is the pattern any non-census variable will follow.

wv_counties <- counties(state = "WV", cb = TRUE, year = 2024)

# Pretend this is your CSV, keyed by GEOID (5-digit county FIPS).
my_csv <- tibble(
  GEOID = wv_counties$GEOID,
  value = runif(nrow(wv_counties), 0, 100)
)

wv_joined <- wv_counties |>
  left_join(my_csv, by = "GEOID")

ggplot(wv_joined) +
  geom_sf(aes(fill = value), color = "white", linewidth = 0.2) +
  scale_fill_viridis_c(option = "D") +
  labs(title = "WV counties: example variable",
       caption = "Geometry: tigris (Census TIGER)") +
  theme_void()

# ---- Path B: data + geometry in one call with tidycensus ----------------
# B19013_001 = median household income, ACS 5-year estimates.
# Browse variables with:  load_variables(2022, "acs5", cache = TRUE)

wv_income <- get_acs(
  geography = "county",
  state     = "WV",
  variables = "B19013_001",
  year      = 2022,
  survey    = "acs5",
  geometry  = TRUE              # returns an sf object (no manual join)
)

glimpse(wv_income)              # estimate, moe (margin of error), geometry

ggplot(wv_income) +
  geom_sf(aes(fill = estimate), color = "white", linewidth = 0.2) +
  scale_fill_viridis_c(
    option = "D",
    labels = label_dollar(scale = 1e-3, suffix = "k")
  ) +
  labs(
    title    = "Median household income: West Virginia counties",
    subtitle = "ACS 5-year estimates, 2018–2022",
    fill     = NULL,
    caption  = "Source: US Census Bureau, ACS via tidycensus"
  ) +
  theme_void(base_size = 12)

# ---- Polish: county labels for the top/bottom ---------------------------
# County name is in NAME, e.g. "Monongalia County, West Virginia"
wv_income <- wv_income |>
  mutate(short = sub(" County, West Virginia$", "", NAME))

top_bot <- bind_rows(
  slice_max(wv_income, estimate, n = 3),
  slice_min(wv_income, estimate, n = 3)
)

ggplot(wv_income) +
  geom_sf(aes(fill = estimate), color = "white", linewidth = 0.2) +
  geom_sf_text(data = top_bot, aes(label = short),
               size = 3, color = "grey15") +
  scale_fill_viridis_c(
    option = "D",
    labels = label_dollar(scale = 1e-3, suffix = "k")
  ) +
  labs(
    title    = "Median household income: WV counties",
    subtitle = "Highest and lowest three labelled",
    fill     = NULL,
    caption  = "Source: ACS 5-year, 2018–2022 (tidycensus)"
  ) +
  theme_void(base_size = 12)

# ---- Notes -------------------------------------------------------------
# - Use `survey = "acs1"` for annual estimates (only large geographies).
# - For decennial counts, use `get_decennial(year = 2020, sumfile = "dhc", ...)`.
# - For tract- or block-group-level WV maps, just change `geography`.
# - `tidycensus::load_variables(year, "acs5")` is your variable catalog.
