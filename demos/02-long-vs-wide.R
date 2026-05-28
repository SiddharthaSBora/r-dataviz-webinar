# =============================================================
# Demo 02: Long vs Wide Data (pivot_longer / pivot_wider)
# =============================================================
# Goal: Move data between long and wide form using the tidyr pivot
# functions. Long form is what ggplot wants; wide form is sometimes
# easier for humans to read or for certain summary tables.
# =============================================================

library(tidyr)
library(dplyr)

# ---- Start with the untidy/wide form from demo 01 ----------------------

scores_wide <- tibble::tibble(
  student_id = c(1, 2, 3),
  english    = c(70, 78, 82),
  math       = c(87, 65, 91),
  science    = c(100, 83, 88)
)
scores_wide

# ---- pivot_longer: WIDE -> LONG ----------------------------------------
# We tell pivot_longer which columns to gather. Everything not listed
# stays as identifying columns.

scores_long <- scores_wide |>
  pivot_longer(
    cols      = c(english, math, science),  # columns to gather
    names_to  = "subject",                  # new column for old col names
    values_to = "score"                     # new column for the values
  )
scores_long

# Equivalent and often cleaner: use a negative selector for what to KEEP.
scores_long2 <- scores_wide |>
  pivot_longer(cols = -student_id, names_to = "subject", values_to = "score")
identical(scores_long, scores_long2)

# ---- pivot_wider: LONG -> WIDE -----------------------------------------
# The inverse. Useful when building summary tables for humans.

scores_back_to_wide <- scores_long |>
  pivot_wider(names_from = subject, values_from = score)
scores_back_to_wide

# ---- Rule of thumb -----------------------------------------------------
# - Storing and analyzing data? Keep it long.
# - Plotting with ggplot? Long.
# - Printing a final table for a human reader? Wide is often nicer.
