# =============================================================
# Demo 01: Tidy Data Principles
# =============================================================
# Goal: Illustrate the three rules of tidy data with a small example.
#
# Tidy data rules (Wickham 2014; r4ds chapter 5):
#   1. Each variable is a column.
#   2. Each observation is a row.
#   3. Each value is a cell.
#
# Why we care: ggplot2 (and most of tidyverse) is designed for tidy data.
# If your data isn't tidy, you'll spend more time fighting ggplot than
# actually making plots.
# =============================================================

library(tibble)

# ---- An UNTIDY example -------------------------------------------------
# Test scores stored with one row per student and a column per subject.
# Looks reasonable to a human, but "subject" is encoded in column names
# instead of being a value of a "subject" variable.

untidy <- tibble(
  student_id = c(1, 2, 3),
  english    = c(70, 78, 82),
  math       = c(87, 65, 91),
  science    = c(100, 83, 88)
)
untidy

# ---- A TIDY version ----------------------------------------------------
# One row per (student, subject) observation. Three variables: student_id,
# subject, score. This is what ggplot wants.

tidy <- tibble(
  student_id = rep(1:3, each = 3),
  subject    = rep(c("english", "math", "science"), times = 3),
  score      = c(70, 87, 100,
                 78, 65, 83,
                 82, 91, 88)
)
tidy

# ---- Quick test: which form lets you "color by subject" easily? --------
# The tidy version. In the untidy version, there is no "subject" column
# to map to a color aesthetic.
