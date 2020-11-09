;adds the number of years (15 years total) that a pixel is green for that month-year
;this is calculated separately for Feb and March

pro percent_years_green
    CD, 'F:\BOTH_diff_thresholds\threshold_10\monthly\month_green_binary'       ;change depending on the threshold
  
    ;Percent years green for February
    
    dir_feb=file_search('*_02*')
    length=size(dir_feb)
    length=length(1)
    filename_feb='1.Feb_green_all_years_10.tif'                                 ;change depending on the threshold 
  
    output=read_tiff(dir_feb(0), GEOTIFF=geotiff_meta)

    ;loops through all the years, counts number of years each pixel is green
    ;(1 if that pixel has green frazil ice, 0 if not)
    for i = 1, length - 1 DO begin
        next = read_tiff(dir_feb(i))
        output = output+next
        print, dir_feb(i)
    endfor
    WRITE_TIFF, filename_feb, output, bits_per_sample=8, geotiff=geotiff_meta

    ;Percent years green for February
    
    dir_march = file_search('*_03*')
    length = size(dir_march)
    length = length(1)
    filename_march = '1.March_green_all_years_10.tif'                                 ;change depending on the threshold

    output = read_tiff(dir_march(0), GEOTIFF=geotiff_meta)

    ;loops through all the years, counts number of years each pixel is green
    for i = 1, length-1 DO begin
        next = read_tiff(dir_march(i))
        output = output+next
        print, dir_march(i)
    endfor

    WRITE_TIFF, filename_march, output, bits_per_sample=8, geotiff=geotiff_meta
    
end
