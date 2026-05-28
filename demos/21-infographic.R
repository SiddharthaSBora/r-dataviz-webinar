# =============================================================
# Demo 21: Capstone: From Pipeline to a Shareable Figure
# =============================================================
# Chain the whole webinar into one self-contained figure: tidy data ->
# a trend + a ranked bar + a US map -> composed with patchwork,
# branded with the house theme, exported at a fixed size/DPI.
#
# Requires: ggplot2, dplyr, tibble, patchwork, scales, ragg
#           sf + tigris for the map panel (optional, guarded)
# =============================================================

library(here)
library(ggplot2)
library(dplyr)
library(tibble)
library(patchwork)
library(scales)

source(here("R", "helpers.R"))   # theme_webinar(), webinar_* colors

# ---- 1. Tidy data (demos 01-02) ----------------------------------------
# Illustrative state-level values over time. One row per (state, year):
# tidy, so each panel below is a different view of the same table.
states_focus <- c("West Virginia", "Ohio", "Pennsylvania")

state_data <- tribble(
  ~state,           ~year, ~value,
  "West Virginia",   2000,   42.1,
  "West Virginia",   2010,   45.8,
  "West Virginia",   2020,   48.3,
  "Ohio",            2000,   51.4,
  "Ohio",            2010,   54.0,
  "Ohio",            2020,   57.2,
  "Pennsylvania",    2000,   53.9,
  "Pennsylvania",    2010,   56.6,
  "Pennsylvania",    2020,   60.1
)

state_pal <- c(
  "West Virginia" = webinar_green,
  "Ohio"          = webinar_green_lite,
  "Pennsylvania"  = "#E69F00"
)

# ---- 2. Panel A: the trend (demos 03-06) -------------------------------
# The headline: values rising across all three states.
p_trend <- ggplot(state_data, aes(year, value, color = state)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2.4) +
  scale_color_manual(values = state_pal) +
  scale_x_continuous(breaks = seq(2000, 2020, 10)) +
  labs(title = "Values are rising", subtitle = "Illustrative, 2000-2020",
       x = NULL, y = NULL, color = NULL) +
  theme_webinar()

# ---- 3. Panel B: a ranked snapshot (demos 04, 14) ----------------------
# Same data, different question: ranked bars answer "who's highest?" fast.
p_rank <- state_data |>
  filter(year == 2020) |>
  ggplot(aes(reorder(state, value), value, fill = state)) +
  geom_col(width = 0.65) +
  geom_text(aes(label = number(value, accuracy = 0.1)),
            hjust = -0.15, size = 3.5, color = "grey20") +
  scale_fill_manual(values = state_pal, guide = "none") +
  scale_y_continuous(limits = c(0, 70), expand = expansion(mult = c(0, 0.05))) +
  coord_flip() +
  labs(title = "2020 snapshot", x = NULL, y = NULL) +
  theme_webinar() +
  theme(panel.grid.major.y = element_blank())

# ---- 4. Panel C: a US locator map (demos 09-13) ------------------------
# Highlights the three states on a national map. Uses tigris (same as the
# earlier map demos). Guarded so the script still produces A + B without
# the spatial stack or an internet connection.
p_map <- NULL
if (requireNamespace("sf", quietly = TRUE) &&
    requireNamespace("tigris", quietly = TRUE)) {

  options(tigris_use_cache = TRUE)

  us <- tigris::states(cb = TRUE, year = 2024, resolution = "20m") |>
    filter(!STUSPS %in% c("AK", "HI", "PR", "GU", "VI", "MP", "AS")) |>
    mutate(focus = ifelse(NAME %in% states_focus, "focus", "other"))

  p_map <- ggplot(us) +
    geom_sf(aes(fill = focus), color = "white", linewidth = 0.15) +
    scale_fill_manual(values = c(focus = webinar_green, other = "grey88"),
                      guide = "none") +
    coord_sf(crs = "EPSG:5070") +            # Albers equal area for the US
    labs(title = "Where") +
    theme_void(base_size = 13) +
    theme(plot.title = element_text(face = "bold", hjust = 0))
} else {
  message("sf / tigris not available, skipping the map panel.")
}

# ---- 5. Compose with patchwork (demo 14) -------------------------------
# Trend on top (the headline gets the most room); snapshot + map below.
figure <- if (!is.null(p_map)) {
  (p_trend) / (p_rank | p_map) + plot_layout(heights = c(1.4, 1))
} else {
  (p_trend) / (p_rank) + plot_layout(heights = c(1.4, 1))
}

figure <- figure +
  plot_annotation(
    title = "Two decades of gains across three states",
    subtitle = "A worked example: one tidy table, three complementary views",
    caption = "Illustrative data · ggplot2 + patchwork · geometry from US Census TIGER/Line",
    theme = theme(
      plot.title    = element_text(face = "bold", size = 18, color = webinar_ink),
      plot.subtitle = element_text(color = "grey40", size = 12),
      plot.caption  = element_text(color = "grey50", size = 9)
    )
  )

figure

# ---- 6. Export at a known size + DPI (demo 15) -------------------------
# ragg::agg_png() gives crisp text; fixed size + DPI = identical everywhere.
# ggsave(
#   here("figures", "capstone-infographic.png"), figure,
#   device = ragg::agg_png,
#   width = 9, height = 7.5, units = "in", dpi = 300, bg = "white"
# )

# ---- The takeaway ------------------------------------------------------
# Nothing here is new, every layer came from an earlier demo. Communication
# is assembly: choose the views that answer the reader's question, then make
# the result stand on its own.
