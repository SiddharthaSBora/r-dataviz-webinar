# =============================================================
# Demo 07: Faceting: Small Multiples
# =============================================================
# Goal: Show how facet_wrap and facet_grid turn one crowded plot
# into several clear panels. The Tufte principle of small multiples
# in a few lines of code.
# =============================================================

library(here)
library(ggplot2)
library(dplyr)
library(tibble)

source(here("R", "helpers.R"))

# ---- Demo data: a slice of gapminder-style life expectancy -------------
# We extend the shared sample with a few more countries for richer
# faceting examples.

life_exp <- tribble(
  ~country,    ~year, ~life_exp,
  "Brazil",     1990,  65.7,
  "Brazil",     2000,  70.1,
  "Brazil",     2010,  73.4,
  "Brazil",     2020,  75.9,
  "India",      1990,  58.5,
  "India",      2000,  62.6,
  "India",      2010,  66.6,
  "India",      2020,  70.2,
  "USA",        1990,  75.2,
  "USA",        2000,  76.8,
  "USA",        2010,  78.5,
  "USA",        2020,  77.0,
  "Argentina",  1990,  71.8,
  "Argentina",  2000,  74.0,
  "Argentina",  2010,  75.6,
  "Argentina",  2020,  76.4,
  "Mexico",     1990,  71.0,
  "Mexico",     2000,  74.6,
  "Mexico",     2010,  76.6,
  "Mexico",     2020,  74.0,
  "Chile",      1990,  73.6,
  "Chile",      2000,  77.0,
  "Chile",      2010,  79.0,
  "Chile",      2020,  80.7
)

# ---- The "crowded" version ---------------------------------------------
ggplot(life_exp, aes(year, life_exp, color = country)) +
  geom_line(linewidth = 1) +
  scale_color_viridis_d(end = 0.9) +
  labs(title = "Crowded: six lines, hard to read individual countries")

# ---- facet_wrap: one variable wrapped into a grid ----------------------
ggplot(life_exp, aes(year, life_exp)) +
  geom_line(linewidth = 1, color = "#2c5f2d") +
  geom_point(size = 2, color = "#2c5f2d") +
  facet_wrap(~ country) +
  labs(title = "Faceted: each country on its own panel",
       x = NULL, y = "Years")

# ---- facet_grid: cross two variables -----------------------------------
# Useful when you have two grouping variables. Rows are one variable,
# columns are the other. Here we make up a "region" variable.

life_exp_grid <- life_exp |>
  mutate(region = case_when(
    country %in% c("USA")                              ~ "North America",
    country %in% c("Brazil", "Argentina", "Mexico", "Chile") ~ "Latin America",
    country %in% c("India")                            ~ "Asia"
  ))

ggplot(life_exp_grid, aes(year, life_exp)) +
  geom_line(linewidth = 1, color = "#2c5f2d") +
  facet_grid(region ~ country) +
  labs(title = "facet_grid: region in rows, country in columns",
       x = NULL, y = "Years")

# ---- Tweaks worth knowing ----------------------------------------------

# Free scales, let each panel pick its own y range
ggplot(life_exp, aes(year, life_exp)) +
  geom_line(linewidth = 1, color = "#2c5f2d") +
  facet_wrap(~ country, scales = "free_y") +
  labs(title = "scales = 'free_y': each panel picks its own y range")

# Better facet labels via labeller
ggplot(life_exp, aes(year, life_exp)) +
  geom_line(linewidth = 1, color = "#2c5f2d") +
  facet_wrap(~ country, labeller = label_both) +
  labs(title = "labeller = label_both shows 'country: Brazil' etc.")

# Number of columns
ggplot(life_exp, aes(year, life_exp)) +
  geom_line(linewidth = 1, color = "#2c5f2d") +
  facet_wrap(~ country, ncol = 2) +
  labs(title = "ncol = 2: two columns instead of default wrapping")
