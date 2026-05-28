# =============================================================
# Demo 14: Combining Plots with patchwork
# =============================================================
# Goal: Show that combining ggplots is as simple as adding them
# together with `+`. patchwork is the modern standard, replacing
# gridExtra::grid.arrange() for new work.
# =============================================================

library(here)
library(ggplot2)
library(dplyr)
library(tibble)
library(patchwork)

source(here("R", "helpers.R"))

# ---- Build a few plots to compose --------------------------------------

life_exp <- life_exp_sample()

p_trend <- ggplot(life_exp, aes(year, life_exp, color = country)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_viridis_d(end = 0.85) +
  labs(title = "Trend", x = NULL, y = "Years") +
  theme_minimal() +
  theme(legend.position = "bottom")

p_2020 <- ggplot(life_exp |> filter(year == 2020),
                 aes(reorder(country, life_exp), life_exp, fill = country)) +
  geom_col() +
  scale_fill_viridis_d(end = 0.85, guide = "none") +
  labs(title = "2020 snapshot", x = NULL, y = "Years") +
  theme_minimal()

p_1990 <- ggplot(life_exp |> filter(year == 1990),
                 aes(reorder(country, life_exp), life_exp, fill = country)) +
  geom_col() +
  scale_fill_viridis_d(end = 0.85, guide = "none") +
  labs(title = "1990 snapshot", x = NULL, y = "Years") +
  theme_minimal()

# ---- The operators -----------------------------------------------------

# Side by side
p_trend + p_2020

# Stacked
p_trend / p_2020

# Three plots: trend on top, two snapshots below
p_trend / (p_1990 + p_2020)

# Explicit pipe operator (same as +)
p_1990 | p_2020 | p_trend

# ---- Annotation across the composition ---------------------------------

(p_1990 + p_2020 + p_trend) +
  plot_annotation(
    title    = "Life expectancy: snapshots and trend",
    subtitle = "Three illustrative countries, 1990-2020",
    caption  = "Source: illustrative data",
    tag_levels = "A"        # auto-labels panels A, B, C...
  )

# ---- Collecting duplicated legends -------------------------------------
# When multiple panels share a legend, collapse them with guides = "collect".

p_a <- p_trend
p_b <- ggplot(life_exp, aes(year, life_exp, color = country)) +
  geom_smooth(se = FALSE, method = "lm", linewidth = 1) +
  scale_color_viridis_d(end = 0.85) +
  labs(title = "Linear trend", x = NULL, y = "Years") +
  theme_minimal()

(p_a + p_b) + plot_layout(guides = "collect") &
  theme(legend.position = "bottom")

# ---- A more elaborate layout -------------------------------------------
# One "hero" plot on top spanning two columns, two smaller plots below.
layout <- "
AA
BC
"
p_trend + p_1990 + p_2020 +
  plot_layout(design = layout) +
  plot_annotation(title = "Composed layout via `design`",
                  tag_levels = "A")

# ---- Why patchwork over gridExtra --------------------------------------
# - Cleaner syntax (`+` and `/` instead of grid.arrange(p1, p2, ncol=2))
# - Better automatic alignment of axes across panels
# - Shared legends, shared annotations
# - Composable: a patchwork is itself a ggplot, you can keep adding to it
#
# You'll still see gridExtra::grid.arrange() in older code. It works.
# But new code should use patchwork.
