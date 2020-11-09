;This script calculates a green index for daily satellite imagery that is over the 
;Southern Ocean for pixels without cloud cover. This script works with the MYD satellite.

pro GB_MYD_RATIO_algorithm
;START HERE

;Directory with the satellite image tif files
CD, 'E:\MYD'

;land mask
land=read_tiff('land_mask.tif')
region_mask=read_tiff('region_mask.tif')

;modify for years
all_years=[2003, 2002, 2001, 2000]

;loop though all years, daily images for each year have a different directory
for j=0, 4 DO begin
    current_year=StrTrim(string(all_years(j)),2)
    dir='D:\MYD\MYD_'+ current_year
    CD, dir
  
    ;get a directory of the files for the bands (colors) and the states (cloud cover) 
    band_dir=file_search('*bands.proj.tif')
    state_dir=file_search('*state.proj.tif')
    length_bands=size(band_dir)
    length_bands=length_bands(1)
    print, systime()

    ;loop through each daily satellite image file for each year
    for i = 0, length_bands - 1   DO begin 
        print, band_dir(i)
    
        ;date format for output files
        year = fix(strmid(band_dir(i),0,4)) ;get year from string
        day = fix(strmid(band_dir(i),4,3))  ;get doy from string
        CalDat, Julday(1, day, year), month, day
        theMonth = string(month, format='(I2.2)')
        theDay = string(day, format='(I2.2)')
        theYear = StrTrim(year, 2)
        yd=theYear+ '_' + theMonth + '_' + theDay
    
        ;output filenames
        green_binary_filename = 'green.binary.MYD.' + yd +'.tif'
        cloud_filename = 'cloud.MYD.' + yd +'.tif'
        green_index_filename = 'green_index.MYD.' + yd +'.tif'

        ;open files
        image = read_tiff(band_dir(i), GEOTIFF=geotiff_meta) 
        image_state=read_tiff(state_dir(i))

        ; band3 is the blue band, band4 is the green band
        band3 = reform(image(1,*,*))
        band4 = reform(image(2,*,*))
        state = image_state(1:14681,1:13377)

        ;dimensions
        dim=size(state)

        ;no data mask
        no_data_mask=make_array(dim(1),dim(2), /INTEGER, value=1)
        no_data_mask[where(band4 EQ 32767)] = 0

        ;high filter
        high_filter = make_array(dim(1),dim(2), /INTEGER, value=1)
        high_filter[where(band3 GT 10000)] = 0
        high_filter[where(band4 GT 10000)] = 0

        ;cloud filter
        ;1 means cloud inner term: shift everything to left, outer term: shift everything to right  15 14 13 ... 3 2 1 0
        cloud_unpack = ishft((ishft(state,5)),-15)         
        cloud = make_array(dim(1),dim(2), /INTEGER, value=1)
    
        ;1 is clear
        cloud[where(cloud_unpack EQ 1)] = 0   

        ;mask of 0s and 1s blocks any data that includes cloud cover or land
        mask = high_filter * cloud * land
    
        ;each band is turned to ZERO if there is cloud 
        ;OR if either band3/4 has a value greater than 10,000 
        ;OR if a value is less than 0 OR if it is on land  

        band3 = band3 * mask
        band4 = band4 * mask
        band3[where(band3 LE 0)] = 0
        band4[where(band4 LE 0)] = 0

        ;convert integer to floats
        band3 = float(band3)
        band4 = float(band4)

        ;If value in band4 is less than 10% = ocean, therefore convert to 0
        band3[where(band4 LT 1000)] = 0
        band4[where(band4 LT 1000)] = 0

        ;green algorithm
        band_diff = band4 - band3  ;green - blue
        band_sum=band4+band3

        ;cannot divide by 0
        band_sum[where(band_sum eq 0)]=1  

        green_index = band_diff / band_sum
        green_index[where(green_index le 0)] = 0
        green_index = green_index * 255
        green_index = byte(green_index)

        ;threshold approach, call the pixel green if green index > 15
        green_binary = make_array(dim(1),dim(2), /INTEGER, value = 0)
        green_binary[where(green_index GE 15)] = 1

        cloud = cloud*land*no_data_mask*region_mask

        ;output files
        WRITE_TIFF, cloud_filename, cloud, bits_per_sample=1, geotiff=geotiff_meta
        WRITE_TIFF, green_binary_filename, green_binary,  bits_per_sample=1, geotiff=geotiff_meta
        WRITE_TIFF, green_index_filename, green_index, bits_per_sample=8, geotiff=geotiff_meta
    endfor
    print, systime()
endfor

end
