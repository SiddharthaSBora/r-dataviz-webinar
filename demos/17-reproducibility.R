# =============================================================
# Demo 17: Reproducibility
# =============================================================
# Goal: Demonstrate the minimum-viable reproducibility setup that
# makes your project runnable on someone else's laptop.
#
# The five things every analysis script should have:
#   1. Library loads at the top
#   2. set.seed() if any randomness is involved
#   3. Paths via here::here() (never hardcoded, never setwd())
#   4. renv::snapshot() to lock package versions
#   5. sessionInfo() at the bottom
# =============================================================

# ---- 1. Library loads at the top ---------------------------------------
library(here)
library(tidyverse)
# library(sf); library(tigris)  # add as needed

# ---- 2. Set a random seed if anything stochastic --------------------
set.seed(42)

# ---- 3. Paths via here() -----------------------------------------------
# here() resolves paths from the project root. So instead of:
#
#   read_csv("/Users/sid/Documents/projects/dataviz/data/raw/file.csv")
#
# You write:
#
#   read_csv(here("data", "raw", "file.csv"))
#
# This works on every machine, regardless of where the user opened the
# project. It also keeps working when you move the project folder.

# Example (in this project, helpers.R lives at R/helpers.R):
example_path <- here("R", "helpers.R")
print(example_path)

# Source it the same way every demo in this project does:
source(here("R", "helpers.R"))

# To set up a project: open RStudio -> File -> New Project -> ...
# This creates a .Rproj file at the project root. here() uses that
# .Rproj file (or .git, etc.) to find the root automatically.
#
# This webinar's repo IS an R project. Open r-dataviz-webinar.Rproj
# and notice that here() always resolves from the project root,
# no matter which subdirectory you opened the demo file from.

# NEVER use setwd() in an analysis script. It makes your code only run
# on YOUR machine.

# ---- 4. Lock package versions with renv -------------------------------
# Run these once per project, in the R console:
#
#   renv::init()      # set up renv for this project; creates renv.lock
#   # ... do your analysis, install packages as needed ...
#   renv::snapshot()  # update renv.lock to current package versions
#
# When someone else clones your project:
#   renv::restore()   # install the exact versions you used
#
# renv.lock plays the role of requirements.txt in Python.

# ---- 5. sessionInfo() at the bottom of every notebook -----------------
sessionInfo()

# This prints your R version, OS, locale, and ALL loaded package
# versions. If something stops working in 2 years, this is your
# forensic record of what was working today.

# Modern alternative: sessioninfo::session_info() (note the underscore)
# provides a cleaner, more structured printout.

# ---- A minimal README.md for your project -----------------------------
# In addition to the script-level practices above, EVERY project needs
# a README.md at the project root that answers:
#
#   1. What does this project do?
#   2. How do I install dependencies?
#      install.packages("renv")
#      renv::restore()
#   3. How do I run it?
#      source("analysis/01-clean.R")
#      source("analysis/02-figures.R")
#   4. Where do the data come from?
#      Cite the source. Link to it.
#   5. Where do the outputs go?
#      output/figures/, output/tables/

# ---- The takeaway -----------------------------------------------------
# Future-you, in three months, has forgotten everything about this
# project. Reviewer-you, on a different OS, has none of your local
# state. Code for both.
#
# If you can't hand your project folder to a stranger and have them
# run your analysis in 10 minutes, it's not done yet.
