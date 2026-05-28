# =============================================================
# Demo 18: Raster Basics with terra + tidyterra
# =============================================================
# Goal: Pair with the "Rasters, when your data is a grid" slide.
# Vectors (points / lines / polygons) cover most thematic maps;
# rasters are the other half, a regular grid of cells, each holding
# a value (DEMs, satellite imagery, climate fields, land cover).
#
# Requires:
#   - terra     (CRAN, modern raster engine; successor to {raster})
#   - tidyterra (CRAN, geom_spatraster() for ggplot)
#   - sf        (CRAN, for the polygon used in crop/mask)
# =============================================================

library(terra)
library(tidyterra)
library(ggplot2)
library(sf)

# ---- 1. Read a raster ---------------------------------------------------
# terra ships a small example DEM (elevation, ~6 arc-minute resolution,
# clipped to Luxembourg). No download needed.
dem <- rast(system.file("ex/elev.tif", package = "terra"))

# A SpatRaster is essentially a grid + a CRS + cell values.
dem
res(dem)        # cell size in CRS units
ext(dem)        # bounding box
crs(dem, describe = TRUE)[, c("name", "code")]
nlyr(dem)       # number of layers ("bands")

# ---- 2. Quick look with base plot --------------------------------------
plot(dem, main = "Elevation (m): terra example DEM")

# ---- 3. Same raster in ggplot via tidyterra ----------------------------
ggplot() +
  geom_spatraster(data = dem) +
  scale_fill_viridis_c(name = "Elevation (m)", na.value = NA) +
  labs(title = "Elevation: Luxembourg (terra example)") +
  theme_minimal()

# ---- 4. Crop and mask to a polygon -------------------------------------
# Build a small AOI polygon inside the raster's extent.
aoi <- st_as_sf(
  data.frame(id = 1L),
  geometry = st_sfc(
    st_polygon(list(rbind(
      c(5.8, 49.7), c(6.3, 49.7), c(6.3, 50.0), c(5.8, 50.0), c(5.8, 49.7)
    ))),
    crs = 4326
  )
)

dem_aoi <- dem |>
  crop(aoi) |>        # trim extent to the polygon's bbox
  mask(aoi)           # set cells outside the polygon to NA

ggplot() +
  geom_spatraster(data = dem_aoi) +
  scale_fill_viridis_c(name = "Elevation (m)", na.value = NA) +
  geom_sf(data = aoi, fill = NA, color = "white", linewidth = 0.4) +
  labs(title = "Cropped + masked to an AOI") +
  theme_minimal()

# ---- 5. Raster math ----------------------------------------------------
# Cell-wise algebra is just arithmetic on the SpatRaster.
dem_ft <- dem * 3.28084                   # metres -> feet
above_400 <- dem > 400                    # logical raster (TRUE/FALSE)

plot(above_400, main = "Cells above 400 m")

# ---- 6. Reprojection ---------------------------------------------------
# Project to Web Mercator (EPSG:3857). For continuous data use bilinear;
# for categorical (land cover, classes) use "near".
dem_3857 <- project(dem, "EPSG:3857", method = "bilinear")

ggplot() +
  geom_spatraster(data = dem_3857) +
  scale_fill_viridis_c(name = "Elevation (m)", na.value = NA) +
  labs(title = "Reprojected to EPSG:3857") +
  theme_minimal()

# ---- 7. Where to go next -----------------------------------------------
# - Geocomputation with R       https://r.geocompx.org/
# - rspatial.org (terra book)   https://rspatial.org/
# - tidyterra docs              https://dieghernan.github.io/tidyterra/
# - {stars} for multi-dim cubes (time, bands)  https://r-spatial.github.io/stars/
