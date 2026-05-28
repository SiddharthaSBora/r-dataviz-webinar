# =============================================================
# Demo 06: Themes, Type, and Polish
# =============================================================
# Goal: Compare built-in themes and customize via theme(). Also
# introduce scales::label_*() functions which most beginners miss.
# =============================================================

library(ggplot2)
library(dplyr)
library(scales)
library(patchwork)

# ---- A demonstration plot ----------------------------------------------
df <- economics |> dplyr::filter(date >= as.Date("2000-01-01"))

base_plot <- ggplot(df, aes(date, unemploy * 1000)) +
  geom_line(linewidth = 1, color = "#2c5f2d") +
  labs(title = "US unemployed persons", x = NULL, y = NULL)

# ---- Built-in themes compared ------------------------------------------
(base_plot + theme_gray()    + ggtitle("theme_gray (default)")) +
(base_plot + theme_minimal() + ggtitle("theme_minimal")) +
(base_plot + theme_bw()      + ggtitle("theme_bw")) +
(base_plot + theme_classic() + ggtitle("theme_classic"))

# theme_minimal() and theme_classic() are safe defaults for most
# published work. theme_void() drops nearly everything, useful for maps.

# ---- Customizing via theme() -------------------------------------------
base_plot +
  theme_minimal(base_size = 13) +
  theme(
    # Titles and captions
    plot.title    = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(color = "grey40"),
    plot.caption  = element_text(color = "grey50", hjust = 0),

    # Axes
    axis.title = element_text(size = 12),
    axis.text  = element_text(size = 10),

    # Legend
    legend.position = "bottom",
    legend.title    = element_blank(),

    # Panel
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_blank()
  )

# ---- Set a project-wide theme once -------------------------------------
# Put this at the top of your script and every plot inherits it.

theme_set(
  theme_minimal(base_size = 13) +
    theme(
      plot.title       = element_text(face = "bold"),
      plot.subtitle    = element_text(color = "grey40"),
      panel.grid.minor = element_blank(),
      legend.position  = "bottom"
    )
)

# ---- scales:: label_* functions for axis text --------------------------
# This is the part most beginners miss. Default axis labels are usually
# wrong for the audience: scientific notation, raw integers, etc.

# Big numbers as "5M" instead of "5000000"
base_plot +
  scale_y_continuous(labels = label_number(scale = 1e-6, suffix = "M"))

# Dates with custom breaks
base_plot +
  scale_x_date(date_breaks = "5 years", date_labels = "%Y") +
  scale_y_continuous(labels = label_number(scale = 1e-6, suffix = "M"))

# Other useful formatters:
#   label_percent(accuracy = 0.1)
#   label_comma()
#   label_dollar()
#   label_log()
