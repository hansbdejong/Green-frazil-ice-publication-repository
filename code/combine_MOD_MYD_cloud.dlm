;There are two satellites that pass over all points of earth each day (MOD and MYD). 
;if MOD or MYD cloud = 1  (clear, no land, with data), then MCD (combined) = 1 (there is data for the pixel for that day)

pro combine_MOD_MYD_cloud

CD, 'E:\BOTH\BOTH_cloud'
all_years=[2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017]

for j=0, 14 DO begin
    current_year=StrTrim(string(all_years(j)),2)
    
    ;go to the correct directory
    dir='E:\BOTH\BOTH_cloud\BOTH_' + current_year + '_cloud'
    CD, dir

    MOD_dir=file_search('*MOD*')
    MYD_dir=file_search('*MYD*')
    length=size(MOD_dir)
    length=length(1)
    print, systime()
  
    ;LOOP STARTS HERE
    for i = 0, length - 1 DO begin
        print, MOD_dir(i)
        yd=strmid(MOD_dir(i),10,10)  ;year date
        MCD_filename='cloud.MCD.' + yd +'.tif'
    
        ;open files
        image_MOD=read_tiff(MOD_dir(i), GEOTIFF=geotiff_meta)
        image_MYD=read_tiff(MYD_dir(i))

        ;create combined product
        dim=size(image_MOD)

        ;no data mask on either MOD or MYD
        cloud_MCD = make_array(dim(1),dim(2), /INTEGER, value=0)
        cloud_MCD[where(image_MOD EQ 1)] = 1
        cloud_MCD[where(image_MYD EQ 1)] = 1

        WRITE_TIFF, MCD_filename, cloud_MCD, bits_per_sample=1, geotiff=geotiff_meta
        endfor
    print, systime()
    endfor
end
