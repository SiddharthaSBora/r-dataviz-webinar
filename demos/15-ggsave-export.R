# =============================================================
# Demo 15: Exporting Publication-Quality Output
# =============================================================
# Goal: Show how to save figures so they look right in print, on
# screen, in Word, and on a projector. The graphics device matters.
#
# Modern best practice (as of 2026):
#   PNG -> ragg::agg_png  (fastest, best fonts, cross-platform consistent)
#   PDF -> grDevices::cairo_pdf  (embeds fonts properly)
#   SVG -> grDevices::svg or svglite::svglite (vector, scalable)
#
# The old `ggsave(..., type = "cairo")` syntax NO LONGER WORKS.
# =============================================================

library(ggplot2)
library(dplyr)
library(ragg)

# ---- A figure to save --------------------------------------------------
p <- ggplot(economics, aes(date, unemploy * 1000)) +
  geom_line(linewidth = 1, color = "#2c5f2d") +
  scale_y_continuous(labels = scales::label_number(scale = 1e-6, suffix = "M")) +
  scale_x_date(date_breaks = "10 years", date_labels = "%Y") +
  labs(title    = "US unemployed persons",
       subtitle = "Monthly, 1967 onward",
       caption  = "Source: ggplot2::economics dataset",
       x = NULL, y = NULL) +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold"))

p

# ---- Save as PNG via the ragg device -----------------------------------
# Build at the size you actually want to display. Don't make a giant
# figure and shrink it later, the text proportions will be wrong.

ggsave(
  filename = "fig-unemployment.png",
  plot     = p,
  width    = 7,
  height   = 4,
  units    = "in",
  dpi      = 300,                  # 300 for print, 150 for screen
  device   = ragg::agg_png         # the modern recommendation
)

# Why ragg over base png():
#   - Faster (~33-40% vs anti-aliased cairo)
#   - Better font handling (finds system fonts automatically)
#   - Consistent output across Mac / Linux / Windows
#   - Adopted by RStudio as the IDE's default

# ---- Save as PDF -------------------------------------------------------
# cairo_pdf is essential if you use non-default fonts.
ggsave(
  filename = "fig-unemployment.pdf",
  plot     = p,
  width    = 7,
  height   = 4,
  units    = "in",
  device   = cairo_pdf             # embeds fonts properly
)

# ---- Save as SVG -------------------------------------------------------
# Vector format, scales infinitely without blur. Best for web display
# and Adobe Illustrator editing.
ggsave(
  filename = "fig-unemployment.svg",
  plot     = p,
  width    = 7,
  height   = 4,
  units    = "in"
)

# ---- For a Quarto / RMarkdown document --------------------------------
# Set the device once in the YAML or chunk options:
#
# In YAML:
#   knitr:
#     opts_chunk:
#       dev: "ragg_png"
#       fig.retina: 2
#
# In a chunk:
#   #| dev: "cairo_pdf"
#   #| fig-width: 7
#   #| fig-height: 4
#   #| dpi: 300

# ---- Common pitfalls ---------------------------------------------------
# 1. RESIZING IN WORD/POWERPOINT after export.
#    The text gets warped. Build at final size in ggsave.
#
# 2. FONTS SUBSTITUTING IN PDF.
#    Use device = cairo_pdf, not the default pdf().
#
# 3. PNG BLURRY WHEN ZOOMED.
#    Either bump dpi to 300+ for high-DPI display, or use SVG/PDF for
#    truly scalable output.
#
# 4. DIFFERENT OUTPUT ON DIFFERENT OS.
#    ragg minimizes this. The old png(type = "cairo") trick is no
#    longer needed.
#
# 5. "LOOKS FINE ON MY LAPTOP, TERRIBLE ON THE PROJECTOR."
#    Project a test slide before the talk. Bump base_size in the theme
#    if titles or axis text are small at the back of the room.

# ---- Cleanup -----------------------------------------------------------
# Uncomment to remove the demo output files:
# file.remove("fig-unemployment.png", "fig-unemployment.pdf", "fig-unemployment.svg")
