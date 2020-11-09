pro Adder_MCD_green
    ;adds the number of days/month a pixel is green
    ;change the directory depending on the threshold
    dir_green='F:\BOTH_diff_thresholds\BOTH_green_binary_10\green_binary'
  
    all_years=['2003', '2004', '2005', '2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017']
    all_months=['_02_', '_03_']
    CD, dir_green
    
    ;loop through all years
    for k = 0, 14 DO begin
        current_year=all_years(k)
    
    ;loop through all months
        for j = 0, 1 Do begin
            current_month=all_months(j)
        
            ;only count files for specified month
            green_string='*'+current_year + current_month+'*'
            green_dir=file_search(green_string)
            length=size(green_dir)
            length=length(1)
    
            ;filename
            year_month=current_year+current_month
            filename='1.green.MCD.10_' + year_month + '.tif'             ;change here if using different threshold

            output=read_tiff(green_dir(0), GEOTIFF=geotiff_meta)

            ;loop through all the daily files for specified month/year, add # of green pixel days
            for i = 1, length-1 DO begin
                next=read_tiff(green_dir(i))
                output=output+next
                print, green_dir(i)
            endfor
            WRITE_TIFF, filename, output, bits_per_sample=8, geotiff=geotiff_meta
        endfor
    endfor
end
