# =============================================================
# Demo 08: Accessibility (ADA / Section 508)
# =============================================================
# Goal: Show how to (1) simulate color vision deficiency on a plot,
# (2) use redundant encoding so figures survive grayscale and
# colorblindness, and (3) add alt text for screen readers.
#
# Packages used:
#   - colorspace (CRAN, already a ggplot2 dependency, basically free)
#   - colorBlindness (CRAN, optional, for 6-panel grid simulations)
# =============================================================

library(here)
library(ggplot2)
library(dplyr)
library(tibble)
library(patchwork)
library(colorspace)
# library(colorBlindness)  # optional

source(here("R", "helpers.R"))

# ---- A bad-on-purpose plot ---------------------------------------------
# Uses close reds and greens, exactly what fails for the most common
# color vision deficiency (deuteranopia).

bad_df <- tibble(
  x = rep(1:10, 4),
  y = c(1:10, 2:11, 3:12, 4:13),
  g = rep(c("Apples", "Pears", "Plums", "Grapes"), each = 10)
)

bad_p <- ggplot(bad_df, aes(x, y, color = g)) +
  geom_line(linewidth = 1.2) +
  scale_color_manual(values = c("red", "darkred", "orange", "green")) +
  labs(title = "Original (problematic colors)") +
  theme_minimal()

# ---- Simulating color vision deficiency --------------------------------
# colorspace provides three simulation functions:
#   deutan(), deuteranopia (red-green, ~6% of men)
#   protan(), protanopia (red-green, ~1% of men)
#   tritan(), tritanopia (blue-yellow, rare)

# Apply the simulation to the SCALE VALUES, not the data:
bad_p_deutan <- ggplot(bad_df, aes(x, y, color = g)) +
  geom_line(linewidth = 1.2) +
  scale_color_manual(
    values = deutan(c("red", "darkred", "orange", "green"))
  ) +
  labs(title = "What a deuteranope sees") +
  theme_minimal()

bad_p + bad_p_deutan

# Single-color simulation on the fly:
deutan("red")     # what red looks like
protan("green")   # what green looks like

# Interactive emulator (opens browser):
# colorspace::cvd_emulator()

# ---- The fix: redundant encoding ---------------------------------------
# Don't encode meaning in color alone. Pair color with linetype and/or
# shape so the figure survives grayscale printing and colorblindness.

life_exp <- life_exp_sample()

ggplot(life_exp, aes(year, life_exp,
                     color = country,
                     linetype = country,
                     shape = country)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2.5) +
  scale_color_viridis_d(end = 0.85) +
  labs(title = "Color + linetype + shape: three ways to tell groups apart",
       x = NULL, y = "Years") +
  theme_minimal()

# ---- The grayscale test ------------------------------------------------
# Open your saved figure in any image viewer and convert to grayscale.
# Can you still read it? If no, redesign.

# In R, you can simulate grayscale by applying desaturation:
desaturate(c("red", "blue", "green"))   # everything becomes shades of gray

# ---- For Quarto / HTML: alt text and tables ----------------------------
# In Quarto chunks, the magic comments are:
#
#   #| label: fig-my-figure
#   #| fig-cap: "Visible caption shown under the figure"
#   #| fig-alt: "Alt text for screen readers, describe the TAKEAWAY,
#   #|   not the chart type."
#
# Good alt text: "Life expectancy rose steadily in Brazil and India
# but plateaued in the US between 1990 and 2020."
#
# Bad alt text: "A line chart with three colored lines."

# ---- Quick accessibility checklist -------------------------------------
# [ ] Used viridis / Okabe-Ito (not ggplot defaults)
# [ ] Encoded categories with color + shape/linetype (not color alone)
# [ ] Tested with colorspace::deutan() or cvd_emulator()
# [ ] Readable when printed in grayscale
# [ ] Font sizes >= 10pt captions, >= 12pt body, >= 14pt for projection
# [ ] Added fig-alt describing the TAKEAWAY
# [ ] Caption identifies the data source
# [ ] Diverging palette only when data has a meaningful midpoint
