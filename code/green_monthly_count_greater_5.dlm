;In order to determine the location of green frazil ice hotspots
;The scripts outputs a geotiff for all pixels that had green frazil ice
;in 6 or more years (of the 15 years analyzed)

pro green_monthly_count_greater_5
    dir='E:\1.frazil_ice_paper_updated\Cluster_analysis'
    CD, dir

    ;loop through all thresholds (5, 10, 15) and months (feb/march)
    for i=0, 5 DO begin
        files=file_search('1.*')
        length=size(files)
        length=length(1)
        print, files(i)
     
        ;filename
        string = strmid(files(i),2,22) ;get year from string
        filename = string + '_6_and_above.tif'
  
        ;open files
        file = read_tiff(files(i), GEOTIFF=geotiff_meta)
        dim = size(file)

        greater_than_5 = make_array(dim(1),dim(2), /INTEGER, value=0)
        greater_than_5[where(file GE 6)]=1

        WRITE_TIFF, filename, greater_than_5,  bits_per_sample=1, geotiff=geotiff_meta
    endfor
end
