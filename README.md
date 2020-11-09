# Green-frazil-ice-publication-repository
Code for "Late Summer Frazil Ice‐Associated Algal Blooms around Antarctica" 
(https://agupubs.onlinelibrary.wiley.com/doi/full/10.1002/2017GL075472)

## Extracting MODIS satellite data
### MOD_MODIS_unpack.py / MYD_MODIS_unpack.py

We used the MODIS Surface Reflectance Daily L2G Global product from both the Terra (**MOD**) and Aqua (**MYD**) satellites (MOD09GA/MYD09GA Version 006). We downloaded all MODIS Surface Reflectance tiles for February and March (2003–2017) that include the Antarctic coast (h14‐24, v15‐16). These tiles cover the majority of the Antarctic continental shelf.

The scripts above:
1. extract the 500 m visible spectral bands, Band 1 (red = 620–670 nm), Band 3 (blue = 459–479 nm), and Band 4 (green = 545–565 nm), as well as the state field (cloud cover mask)
2. mosaick the tiles for each day using a Polar Stereographic Projection.

## Pixel Classification Algorithm

### GB_MOD_RATIO_algorithm.pro / GB_MYD_RATIO_algorithm.pro 

For each day, we determined if a given pixel was green, taken as indicative of algal accumulation in frazil ice. We masked land and ice shelves with the global, self‐consistent, hierarchical, high‐resolution shoreline database and clouds with the internal 1 km cloud algorithm flag. In addition, pixels were masked if Band 3 or 4 surface reflectance was greater than 100%. Finally, we masked pixels if Band 4 was less than 10% to prevent classifying open water pixels as green and because of the lower signal‐to‐noise ratio for pixels with low reflectance values.

We created a Green Index that ranges from -1 to 1: (Band 4 - Band 3) / (Band 4 + Band 3)

### green_binary_from_green_index_MOD.pro / green_binary_from_green_index_MYD.pro

We applied the Green Index function to nonmasked pixels for each day. Finally, we classified a pixel as green from algal accumulation within frazil ice if the Green Index was greater or equal to a threshold. We present the results from three thresholds (5/255, 10/255, and 15/255, hereafter called the lower, medium, and higher thresholds). 


###  combine_MOD_MYD_cloud.pro / combine_MOD_MYD_green.pro
We combined Terra and Aqua satellite images for each day (hearafter called **MCD**) to maximize the number of cloud free pixels. A pixel was classified as green if that pixel in either Terra or Aqua was green. Similarly, a pixel was classified as cloud‐free if that pixel in either Terra or Aqua was cloud‐free.

## Green Frazil Ice Hot Spot Detection

### adder_MCD_cloud.pro / adder_MCD_green.pro

For each threshold for February and then March of each year, we counted the number of days that each pixel was classified as green. Similarly, we counted the number of days that each pixel was cloud‐free.

### month_percent_green_MCD.pro
Using these monthly counts, we calculated Green Frequency: (number of green days / number of cloud free days) * 100%.

Next, we classified pixels as Monthly Green if Green Frequency was 20% or greater for a particular month. Pixels were masked out if there were fewer than five cloud‐free days in a given month. 

### percent_years_green.pro
We then calculated Monthly Green Count, the number of times a specific pixel was classified as Monthly Green between 2003 and 2017 (calculated separately for February and March). We used Monthly Green Count to calculate Percent Years Green (also calculated separately for February and March).

Percent Years Green = (monthly green count / 15) * 100%

where 15 is the number of years of data that we analyzed (2003–2017).

### green_monthly_count_greater_5.pro
To examine the location of green colored frazil ice hot spots, we classified a pixel as a hot spot pixel if Percent Years Green was equal or greater than 40%. Finally, we classified a region as a hot spot if it was composed of more than 500 km2 of connected hot spot pixels (using 8‐connected pixel neighborhood criteria).

## Interannual Variability

### number_green_pixels.pro
To examine interannual variability, we calculated Green Frazil Ice Extent (area of the Monthly Green pixels) for February and March of each year. We also calculated Green Frazil Ice Extent separately for five geographical sectors (following Arrigo, van Dijken, & Long, 2008; Figure 2).







