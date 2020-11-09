pro adder_MCD_cloud_green
    ;adds the number of days/month (Feb/Mar) a pixel is clear (has no cloud cover)
  
    dir_cloud='E:\BOTH\BOTH_cloud\cloud'
    all_years=['2003', '2004', '2005', '2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017']
    all_months=['_02_', '_03_']

    ;loop through all years
    CD, dir_cloud 
    for k=0, 14 DO begin
        current_year=all_years(k)
        
        ;loop through all months
        for j = 0, 1 Do begin
            current_month=all_months(j)
            
            ;only keep files for specified month
            cloud_string='*'+current_year + current_month+'*'
            cloud_dir=file_search(cloud_string)
            length=size(cloud_dir)
            length=length(1)
            
            ;filename
            year_month=current_year+current_month
            filename='1.cloud.MCD_' + year_month + '.tif'

            output=read_tiff(cloud_dir(0), GEOTIFF=geotiff_meta)

            ;loop through all the daily files for specified month/year, add # of clear days
            for i = 1, length-1 DO begin
                next=read_tiff(cloud_dir(i))
                output=output+next
                print, cloud_dir(i)
            endfor
            WRITE_TIFF, filename, output, bits_per_sample=8, geotiff=geotiff_meta
        endfor
    endfor
end
