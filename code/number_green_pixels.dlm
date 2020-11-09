;outputs number of pixels/month/year that are green for all of Antarctica as well as for 5 regions of Antarctica
;pixels only considered if they are clear for 5 days or greater for that month

pro number_green_pixels
    
    ;output filename, change for different thresholds
    filename = 'number_of_green_pixels_15.csv'                                         
    
    CD, 'C:\Users\hdejong\Desktop\region_shapefiles'
    
    ;masks for each region, 1 if part of the region, 0 if not part of that region
    Ross_Sea = read_tiff('RS_mask.tif')
    Ross_Sea = Ross_Sea(1:14681,1:13377)

    S_Indian = read_tiff('S_Indian_mask.tif')
    S_Indian = S_Indian(1:14681,1:13377)

    SW_Pac = read_tiff('SW_Pac_mask.tif')
    SW_Pac = SW_Pac(1:14681,1:13377)

    Weddell = read_tiff('Weddell_mask.tif')
    Weddell = Weddell(1:14681,1:13377)

    Amundsen = read_tiff('Amundsen_mask.tif')
    Amundsen = Amundsen(1:14681,1:13377)

    CD, 'E:\BOTH\monthly'                            

    dir = file_search('*perc_green_bin*')
    length = size(dir)
    length = length(1)
    output = make_array(8,30, /long, value=1)

    ;loop through all month-year green binary tiff files (1 if green >20% of the time, else 0)
    for i = 0, length-1 DO begin
        print, dir(i)
        
        ;year and month for output file
        year=fix(strmid(dir(i),25,4))                ;change here   30 if threshold is 15, 28 if 10, 27 if 5, 3, 1
        month=fix(strmid(dir(i),30,2))               ;change here   30 if threshold is 15, 33 if 10, 32 if 5, 3, 1

        ;open the geotiff file, apply all the region masks
        green_total = read_tiff(dir(i), GEOTIFF=geotiff_meta)
        green_Weddell = green_total*Weddell
        green_Amundsen = green_total*Amundsen
        green_Ross_Sea = green_total*Ross_Sea
        green_SW_Pac = green_total*SW_Pac
        green_Indian_S = green_total*S_Indian
      
        ;adds up the total number of green pixels / month / year 
        output(0,i) = long(year)
        output(1,i) = long(month)
        output(2,i) = long(total(green_total))
        output(3,i) = long(total(green_Weddell))
        output(4,i) = long(total(green_Amundsen))
        output(5,i) = long(total(green_Ross_Sea))
        output(6,i) = long(total(green_SW_Pac))
        output(7,i) = long(total(green_Indian_S))
    endfor
    write_csv, filename, output
end
