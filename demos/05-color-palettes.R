# =============================================================
# Demo 05: Color Palettes: Pick the Type First
# =============================================================
# Goal: Demonstrate the three kinds of color scale and which one to
# use when. Then show that the ggplot defaults are not a great choice.
#
# Decision tree:
#   Is your color variable categorical (unordered)? -> QUALITATIVE
#   Is it ordered with one direction (low -> high)?  -> SEQUENTIAL
#   Is it ordered around a meaningful midpoint?      -> DIVERGING
# =============================================================

library(ggplot2)
library(dplyr)
library(tibble)
library(patchwork)
# Note: scale_*_viridis_d() / _c() are built into ggplot2 since 3.0.0.
# No need to load the viridis package separately.

# ---- Demonstration data sets -------------------------------------------
df_qual <- tibble(x = letters[1:6], y = c(3, 5, 2, 7, 4, 6))
df_seq  <- tibble(x = 1:10)
df_div  <- tibble(x = -5:5)

# ---- Qualitative: unordered categories ---------------------------------
p_qual <- ggplot(df_qual, aes(x, y, fill = x)) +
  geom_col() +
  scale_fill_brewer(palette = "Set2") +
  labs(title = "Qualitative: unordered categories") +
  theme_minimal() +
  theme(legend.position = "none")

# ---- Sequential: ordered, one direction --------------------------------
p_seq <- ggplot(df_seq, aes(x, y = 1, fill = x)) +
  geom_tile() +
  scale_fill_viridis_c() +
  labs(title = "Sequential: ordered, low to high") +
  theme_minimal() +
  theme(legend.position = "none",
        axis.text.y = element_blank(),
        axis.title.y = element_blank())

# ---- Diverging: ordered around a midpoint ------------------------------
p_div <- ggplot(df_div, aes(x, y = 1, fill = x)) +
  geom_tile() +
  scale_fill_distiller(palette = "RdBu", limits = c(-5, 5)) +
  labs(title = "Diverging: values around a midpoint") +
  theme_minimal() +
  theme(legend.position = "none",
        axis.text.y = element_blank(),
        axis.title.y = element_blank())

p_qual / p_seq / p_div

# ---- Default vs deliberate ----------------------------------------------
df <- tibble(g = LETTERS[1:5], y = c(4, 7, 3, 5, 6))

p_default <- ggplot(df, aes(g, y, fill = g)) + geom_col() +
  labs(title = "Default (hue_pal)") + theme_minimal() + theme(legend.position = "none")

p_viridis <- ggplot(df, aes(g, y, fill = g)) + geom_col() +
  scale_fill_viridis_d(end = 0.9) +
  labs(title = "Viridis (perceptually uniform)") +
  theme_minimal() + theme(legend.position = "none")

# Okabe-Ito: designed for colorblind accessibility.
# Abbreviated 5-color subset for this 5-category example; the full
# 8-color palette (starting with black) lives in R/helpers.R as `okabe_ito`.
okabe_ito <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2")

p_okabe <- ggplot(df, aes(g, y, fill = g)) + geom_col() +
  scale_fill_manual(values = okabe_ito) +
  labs(title = "Okabe-Ito (colorblind-safe)") +
  theme_minimal() + theme(legend.position = "none")

p_default + p_viridis + p_okabe

# ---- The functions you'll actually use ---------------------------------
#
# DISCRETE
#   scale_color_viridis_d()                       # perceptually uniform
#   scale_color_brewer(palette = "Set2")          # ColorBrewer
#   scale_color_manual(values = okabe_ito)        # exact control
#
# CONTINUOUS
#   scale_color_viridis_c()                       # perceptually uniform
#   scale_color_gradient(low = "white", high = "darkgreen")
#   scale_color_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0)
#
# Replace _color_ with _fill_ for fill aesthetics.
