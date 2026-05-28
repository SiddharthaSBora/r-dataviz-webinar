# =============================================================
# R/helpers.R: shared functions for the webinar demos
# =============================================================
# Sourced by several demos via:  source(here::here("R", "helpers.R"))
#
# Keeping shared data and styling in one place means every demo
# starts from the same baseline, and a tweak here propagates
# everywhere. Three things live here:
#
#   life_exp_sample(): a tiny, tidy life-expectancy data frame
#   theme_webinar():    the house ggplot theme used in slides
#   okabe_ito:          the Okabe-Ito colorblind-safe palette
# =============================================================

# ---- Sample data -------------------------------------------------------
# Life expectancy at birth for three countries, 1990-2020, at 10-year
# steps. Deliberately small so it is easy to read on a slide and prints
# in full when you type the object name. Values are illustrative
# (gapminder-style), not official statistics.

life_exp_sample <- function() {
  tibble::tribble(
    ~country,  ~year, ~life_exp,
    "Brazil",   1990,      65.7,
    "Brazil",   2000,      70.1,
    "Brazil",   2010,      73.4,
    "Brazil",   2020,      75.9,
    "India",    1990,      58.5,
    "India",    2000,      62.6,
    "India",    2010,      66.6,
    "India",    2020,      70.2,
    "USA",      1990,      75.2,
    "USA",      2000,      76.8,
    "USA",      2010,      78.5,
    "USA",      2020,      77.0
  )
}

# ---- House theme -------------------------------------------------------
# A light wrapper over theme_minimal() with the choices we make over and
# over in the slides: bold title, grey subtitle, no minor grid, legend on
# the bottom. Use it as a drop-in:  ... + theme_webinar()
#
# `base_size` scales every text element together, handy when a figure
# will be projected vs. printed.

theme_webinar <- function(base_size = 13) {
  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      plot.title       = ggplot2::element_text(face = "bold"),
      plot.subtitle    = ggplot2::element_text(color = "grey40"),
      plot.caption     = ggplot2::element_text(color = "grey50", size = ggplot2::rel(0.8)),
      legend.position  = "bottom",
      panel.grid.minor = ggplot2::element_blank()
    )
}

# ---- Okabe-Ito palette -------------------------------------------------
# An eight-color qualitative palette engineered to be distinguishable
# under the common forms of color vision deficiency (Okabe & Ito 2008).
# The first element is black; for fills you often start at index 2.
# See demo 08 (accessibility) for why this matters.

okabe_ito <- c(
  "#000000", # black
  "#E69F00", # orange
  "#56B4E9", # sky blue
  "#009E73", # bluish green
  "#F0E442", # yellow
  "#0072B2", # blue
  "#D55E00", # vermillion
  "#CC79A7"  # reddish purple
)

# ---- House colors (used in slides + capstone) --------------------------
# The two greens that brand the deck. Exposed here so the capstone
# infographic (demo 21) and any custom plot can reuse them.

webinar_green      <- "#2c5f2d"  # dark green, primary
webinar_green_lite <- "#97bc62"  # light green, secondary / accents
webinar_ink        <- "#1a3a2e"  # near-black green, section backgrounds
