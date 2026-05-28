# =============================================================
# Demo 16: Common Pitfalls: Misleading Visualizations
# =============================================================
# Goal: Show the most common viz mistakes side-by-side with their
# correct alternatives. Each example is intentionally bad first,
# then fixed.
# =============================================================

library(ggplot2)
library(dplyr)
library(tibble)
library(patchwork)

# ---- Pitfall 1: Truncated y-axis on a bar chart -----------------------
# Bars represent magnitude. If you truncate the y-axis, bar lengths no
# longer reflect the underlying values. This is one of the most common
# ways to mislead with charts.

df <- tibble(group = c("A", "B"), value = c(102, 105))

bad <- ggplot(df, aes(group, value, fill = group)) +
  geom_col() +
  coord_cartesian(ylim = c(100, 106)) +     # <-- the lie
  scale_fill_viridis_d(guide = "none") +
  labs(title = "BAD: looks like B is 2x A", x = NULL, y = "Value") +
  theme_minimal()

good <- ggplot(df, aes(group, value, fill = group)) +
  geom_col() +
  scale_fill_viridis_d(guide = "none") +
  labs(title = "GOOD: bars start at zero", x = NULL, y = "Value") +
  theme_minimal()

bad + good

# Exception: line charts and dot plots are fine with truncated y-axes,
# because position (not length) carries the meaning.

# ---- Pitfall 2: Pie charts beyond 3 slices -----------------------------
# Humans are bad at comparing angles. A bar chart almost always
# communicates better.

pie_df <- tibble(
  category = c("A", "B", "C", "D", "E", "F", "G"),
  value    = c(15, 22, 8, 18, 12, 14, 11)
)

bad_pie <- ggplot(pie_df, aes(x = "", y = value, fill = category)) +
  geom_col() +
  coord_polar(theta = "y") +
  scale_fill_viridis_d() +
  labs(title = "BAD: 7-slice pie", x = NULL, y = NULL) +
  theme_void() +
  theme(legend.position = "right")

good_bar <- ggplot(pie_df, aes(reorder(category, value), value, fill = category)) +
  geom_col() +
  scale_fill_viridis_d(guide = "none") +
  labs(title = "GOOD: sorted bar chart", x = NULL, y = "Value") +
  coord_flip() +
  theme_minimal()

bad_pie + good_bar

# ---- Pitfall 3: Rainbow/jet colormap -----------------------------------
# Not perceptually uniform, the eye doesn't see equal changes in value
# as equal changes in color. Also fails under colorblindness.

heat_df <- expand.grid(x = 1:20, y = 1:20)
heat_df$value <- heat_df$x * heat_df$y

bad_rainbow <- ggplot(heat_df, aes(x, y, fill = value)) +
  geom_tile() +
  scale_fill_gradientn(colors = rainbow(7)) +
  labs(title = "BAD: rainbow colormap") +
  theme_minimal() + theme(legend.position = "bottom")

good_viridis <- ggplot(heat_df, aes(x, y, fill = value)) +
  geom_tile() +
  scale_fill_viridis_c() +
  labs(title = "GOOD: viridis (perceptually uniform)") +
  theme_minimal() + theme(legend.position = "bottom")

bad_rainbow + good_viridis

# ---- Pitfall 4: 3D anything -------------------------------------------
# Perspective distorts area and angle. There's almost no situation where
# a 3D chart communicates better than a 2D one. R doesn't make 3D
# charts easy on purpose. Resist when colleagues ask.

# ---- Pitfall 5: size aesthetic on lines (deprecated) ------------------
# As of ggplot2 3.4.0 (2022), use linewidth, not size, for line widths.

#   geom_line(size = 1.1)        # deprecated, throws a warning
#   geom_line(linewidth = 1.1)   # current

# The change was made to separate "stroke width" (linewidth) from
# "area" (size, still used for point sizes).

# ---- Pitfall 6: Default ggplot fill on bars when comparing -----------
# When you have one variable mapped to color/fill, ggplot defaults can
# produce a confusing rainbow. Pick a deliberate palette.

# ---- Pitfall 7: Tiny axis labels on big figures -----------------------
# A figure looks fine at 12-inch laptop display, then gets pasted into
# a journal at 3-inch column width and the axis labels become unreadable.
# Build at the final display size. Increase base_size in the theme if
# you're projecting to a room.

# Sized for projection (room of 50 people):
#   theme_minimal(base_size = 16)
# Sized for a journal column at 3 inches wide:
#   theme_minimal(base_size = 9)
