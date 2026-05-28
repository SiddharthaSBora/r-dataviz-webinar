# =============================================================
# Demo 04: Layer-by-Layer Plot Improvement
# =============================================================
# Goal: Start with a crude plot and improve it one layer at a time.
# This is the workflow that makes ggplot click. Each step adds a
# single, named improvement.
# =============================================================

library(here)
library(ggplot2)
library(dplyr)

# Shared helpers: life_exp_sample(), theme_webinar(), okabe_ito()
source(here("R", "helpers.R"))

# ---- Sample data: life expectancy in three countries -------------------
life_exp <- life_exp_sample()

# ---- Step 1: the crudest possible plot ---------------------------------
# This works, but it's ugly, no title, no axis labels, default colors.

p1 <- life_exp |>
  ggplot(aes(x = year, y = life_exp, color = country)) +
  geom_line()
p1

# ---- Step 2: treat the plot as an object, add a title and labels -------
# KEY IDEA: ggplot objects can be saved and added to. Each `+` is a layer.

p2 <- p1 +
  labs(
    title    = "Life Expectancy at Birth, 1990-2020",
    subtitle = "Brazil, India, and the United States",
    x        = NULL,                # year is self-explanatory
    y        = "Life expectancy (years)",
    color    = "Country",
    caption  = "Source: illustrative example data"
  )
p2

# ---- Step 3: thicker lines, end-point markers --------------------------
p3 <- p2 +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2.5)
p3

# ---- Step 4: pick a deliberate color palette ---------------------------
# More on color choices in demo 05. For now: viridis is colorblind-safe.

p4 <- p3 +
  scale_color_viridis_d(option = "D", end = 0.85)
p4

# ---- Step 5: apply a clean theme ---------------------------------------
p5 <- p4 +
  theme_minimal(base_size = 13) +
  theme(
    plot.title    = element_text(face = "bold"),
    plot.subtitle = element_text(color = "grey40"),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )
p5

# ---- Step 6: tweak axis breaks -----------------------------------------
p6 <- p5 +
  scale_x_continuous(breaks = seq(1990, 2020, 10)) +
  scale_y_continuous(limits = c(55, 80))
p6

# ---- The takeaway ------------------------------------------------------
# You did not write a 50-line plotting function. You added six small
# layers, each named and self-explanatory. If you change your mind
# about color later, you change one line.
