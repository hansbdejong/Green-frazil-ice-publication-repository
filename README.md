# Green-frazil-ice-publication-repository
Code for "Late Summer Frazil Ice‐Associated Algal Blooms around Antarctica" 
(https://agupubs.onlinelibrary.wiley.com/doi/full/10.1002/2017GL075472)

## Extracting MODIS satellite data

**MOD_MODIS_unpack.py** and **MYD_MODIS_unpack.py**

We used the MODIS Surface Reflectance Daily L2G Global product from both the Terra (**MOD**) and Aqua (**MYD**) satellites (MOD09GA/MYD09GA Version 006). We downloaded all MODIS Surface Reflectance tiles for February and March (2003–2017) that include the Antarctic coast (h14‐24, v15‐16). These tiles cover the majority of the Antarctic continental shelf.

The scripts above:
1. extract the 500 m visible spectral bands, Band 1 (red = 620–670 nm), Band 3 (blue = 459–479 nm), and Band 4 (green = 545–565 nm), as well as the state field (cloud cover mask)
2. mosaick the tiles for each day using a Polar Stereographic Projection.

## Pixel Classification Algorithm

**GB_MOD_RATIO_algorithm.pro** and **GB_MYD_RATIO_algorithm.pro**

For each day, we determined if a given pixel was green, taken as indicative of algal accumulation in frazil ice. We masked land and ice shelves with the global, self‐consistent, hierarchical, high‐resolution shoreline database and clouds with the internal 1 km cloud algorithm flag. In addition, pixels were masked if Band 3 or 4 surface reflectance was greater than 100%. Finally, we masked pixels if Band 4 was less than 10% to prevent classifying open water pixels as green and because of the lower signal‐to‐noise ratio for pixels with low reflectance values.

We created a Green Index that ranges from -1 to 1:(Band 4 - Band 3) / (Band 4 + Band 3)







