;calculates whether a pixel contains green frazil ice or not based on varying thresholds of the green index
;for the final publication, we used the thresholds 5, 10, and 15.

pro green_binary_from_green_index_MOD

    ;START HERE
    dir_output = 'C:\Users\hdejong\Desktop\Output'
    all_years = ['17', '16', '15', '14', '13', '12', '11', '10', '09', '08', '07', '06', '05', '04', '03']

    ;loop through all years
    for j = 0, 14 DO begin
        current_year = all_years(j)
        dir = 'E:\MOD\MOD_green_index\MOD'+ current_year +'_green_index'
        CD, dir

        green_index_dir = file_search('*index*')
        length = size(green_index_dir)
        length = length(1)
        print, systime()
  
        ;loop through each daily green index file
        for i = 0, length-1   DO begin
            print, green_index_dir(i) 
            CD, dir 
            
            ;output file names
            yd=strmid(green_index_dir(i),16,10) ;get year from string
            green_binary_filename_1 = 'green.binary.MOD.1.' + yd +'.tif'
            green_binary_filename_3 = 'green.binary.MOD.3.' + yd +'.tif'
            green_binary_filename_5 = 'green.binary.MOD.5.' + yd +'.tif'
            green_binary_filename_10 = 'green.binary.MOD.10.' + yd +'.tif'
  
            ;open files
            green_index = read_tiff(green_index_dir(i), GEOTIFF=geotiff_meta)
            dim = size(green_index)

            ;calculates whether or not a pixel contains green frazil ice or not based on 
            ;the thresholds 1, 3, 5, and 10
            
            green_binary_1 = make_array(dim(1),dim(2), /INTEGER, value=0)
            green_binary_1[where(green_index GE 1)]=1

            green_binary_3 = make_array(dim(1),dim(2), /INTEGER, value=0)
            green_binary_3[where(green_index GE 3)]=1
    
            green_binary_5 = make_array(dim(1),dim(2), /INTEGER, value=0)
            green_binary_5[where(green_index GE 5)]=1
    
            green_binary_10 = make_array(dim(1),dim(2), /INTEGER, value=0)
            green_binary_10[where(green_index GE 10)]=1

            CD, dir_output
            WRITE_TIFF, green_binary_filename_1, green_binary_1,  bits_per_sample=1, geotiff=geotiff_meta
            WRITE_TIFF, green_binary_filename_3, green_binary_3,  bits_per_sample=1, geotiff=geotiff_meta
            WRITE_TIFF, green_binary_filename_5, green_binary_5,  bits_per_sample=1, geotiff=geotiff_meta
            WRITE_TIFF, green_binary_filename_10, green_binary_10,  bits_per_sample=1, geotiff=geotiff_meta
        endfor
        print, systime()
    endfor
end
