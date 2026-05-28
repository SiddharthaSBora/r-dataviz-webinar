# =============================================================
# Demo 03: Your First ggplot
# =============================================================
# Goal: Build a plot from data + aesthetic mapping + geom.
#
# The grammar of graphics in one sentence:
#   "Map data variables to visual properties (aesthetics) and
#    pick a geometric object (geom) to represent each row."
#
# Every ggplot has at least these three things:
#   1. data      - a data frame
#   2. mapping   - aes(x = ..., y = ..., color = ..., fill = ...)
#   3. geom      - geom_point(), geom_line(), geom_col(), ...
# =============================================================

library(ggplot2)
library(dplyr)

# Use a built-in dataset everyone has: economics (US economic time series)
glimpse(economics)

# ---- Plot 1: the absolute minimum --------------------------------------
ggplot(data = economics, mapping = aes(x = date, y = unemploy)) +
  geom_line()

# ---- Plot 2: same thing, more idiomatic --------------------------------
# Pipe the data in, drop the argument names.
economics |>
  ggplot(aes(x = date, y = unemploy)) +
  geom_line()

# ---- Plot 3: change the geom -------------------------------------------
# Same aesthetic mapping, different visual representation.
economics |>
  ggplot(aes(x = date, y = unemploy)) +
  geom_point(alpha = 0.3)

# ---- Plot 4: map another variable to color -----------------------------
# economics_long has multiple economic indicators stacked in long form.
glimpse(economics_long)

economics_long |>
  ggplot(aes(x = date, y = value01, color = variable)) +
  geom_line()

# Note: notice we use long form here. Each row is one observation
# (date, variable, value), and `color = variable` does the rest.
