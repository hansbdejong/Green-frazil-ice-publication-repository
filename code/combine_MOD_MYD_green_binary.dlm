;Green Binary files indicate whether a pixel contains green frazil ice (1) or not (0). Due to cloud cover, we 
;combine daily data from 2 satellites.  

pro combine_MOD_MYD_green_binary

;there are 3 thresholds used for whether a pixel contains green frazil ice or not (5, 10, and 15)
;change below as required.
CD, 'F:\Green_Binary_diff_thresholds\BOTH_green_binary_10'                ;change here 

all_years=[2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017]

for j=0, 14 DO begin
    current_year=StrTrim(string(all_years(j)),2)
    dir='F:\Green_Binary_diff_thresholds\BOTH_green_binary_10\BOTH_' + current_year + '_green_binary_10'        ;change here 
    CD, dir

    MOD_dir = file_search('*MOD*')
    MYD_dir = file_search('*MYD*')
    length = size(MOD_dir)
    length = length(1)

    print, systime()
    ;LOOP through each daily satellite file
    for i = 0, length-1   DO begin
        print, MOD_dir(i)
        yd=strmid(MOD_dir(i),20,10)                                        
        MCD_filename = 'green.binary.MCD.10.' + yd +'.tif'                 ;change here 
            
        ;open files
        image_MOD = read_tiff(MOD_dir(i), GEOTIFF=geotiff_meta)
        image_MYD = read_tiff(MYD_dir(i))
         
        ;create combined product
        dim = size(image_MOD)

        ;no data mask
        green_binary_MCD = make_array(dim(1),dim(2), /INTEGER, value=0)
        green_binary_MCD[where(image_MOD EQ 1)] = 1
        green_binary_MCD[where(image_MYD EQ 1)] = 1 

        WRITE_TIFF, MCD_filename, green_binary_MCD, bits_per_sample=1, geotiff=geotiff_meta
        endfor
        print, systime()
    endfor
end
