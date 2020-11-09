;there are three outputs
; 1: month_cloud_mask
;     OUTPUT:
;     1 = clear for 5 days or greater
;     0 = clear less than 5 days, land, or out of region
;
;  2: Percentage of clear days/pixel that are green - a pixel is masked if the pixel is clear for less than 5 days
;  3: percent_green_binary - pixels that are green 20% or more of the cloud free days.

;INPUT files:
;   the number of cloud free days / month / year 
;   cloud.MCD_year_month.tif
;
;   the number of days a pixel was green / month / year
;   green.MCD_year_month.tif

pro month_perc_green_MCD
  
    CD, 'E:\BOTH\monthly'
    cloud_dir=file_search('1.cloud*')
    green_dir=file_search('1.green*')
    
    length=size(cloud_dir)
    length=length(1)

    ;loop through all the month-years
    for i =0, length-1 DO begin
        print, cloud_dir(i)
        
        ;output filename
        year_month=strmid(cloud_dir(i),12,7)
        filename_cloud = 'month_cloud_mask_MCD_' + year_month +'.tif'
        filename_green = 'month_perc_green_MCD_' + year_month +'.tif'
        filename_green_binary = 'month_perc_green_bin_MCD_' + year_month +'.tif'

        cloud = read_tiff(cloud_dir(i), GEOTIFF=geotiff_meta)  ; the number of clear days/pixel
        green = read_tiff(green_dir(i))                        ;the number of green days/pixel

        dim = size(cloud)
        
        ;cloud mask --fewer than 5 clear days, land, and out of bounds = 0
        cloud_mask = make_array(dim(1),dim(2), /byte, value=1)
        cloud_mask[where(cloud lt 5)] = 0

        ;month_percentage_green
        green = float(green)
        cloud = float(cloud)
        
        ;cannot divide by 0. If clear is 0, then green will be 0
        cloud[where(cloud eq 0)] = 1          

        ;percent of days / month / year that a pixel has green frazil ice (for pixels with 5 or more clear days / month-year)
        perc_green = green/cloud
        perc_green = byte(perc_green*100)
        perc_green = perc_green * cloud_mask

        ;if > 20% of days (per month-year) a pixel was green, that pixel for that month-year had green frazil ice
        perc_green_binary = make_array(dim(1),dim(2), /byte, value=0)
        perc_green_binary[where(perc_green ge 20)] = 1

        WRITE_TIFF, filename_cloud, cloud_mask,  bits_per_sample=1, geotiff=geotiff_meta
        WRITE_TIFF, filename_green, perc_green,  bits_per_sample=8, geotiff=geotiff_meta
        WRITE_TIFF, filename_green_binary, perc_green_binary,  bits_per_sample=1, geotiff=geotiff_meta
    endfor
end
