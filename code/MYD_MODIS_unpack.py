#AA_MODIS_unpack
#3/2/2017
#Evan Lyons and Hans Bjorn DeJong
import os
working_dir = r"D:\MYD"
output_dir = r"C:\Users\hdejong\Desktop\Antarctica_output"
import arcpy
arcpy.env.workspace = working_dir
arcpy.env.extent = r"C:\Users\hdejong\Desktop\2012275bands.proj.tif"
arcpy.env.snapRaster = r"C:\Users\elyons\Desktop\2012275bands.proj.tif"

#Loop through by day and identify granule IDs
#Start date: October 1st
#End date: April 30
startyear = 2015
endyear = 2016

#Test start and end years for leaps
import calendar
if calendar.isleap(startyear):
    startday = 275
else:
    startday = 274
if calendar.isleap(endyear):
    endday = 121
else:
    endday = 120

#Loop through years
for year in range(startyear,endyear):
    #test for leaps
    if calendar.isleap(year):
        maxd = 367
    else:
        maxd = 366

    #Loop through days
    for day in range(0, 212):

        #Generate YYYYDDD date for file selection
        if day + startday < maxd:
            yd = str(year) + str(day + startday).zfill(3)
        else:
            yd = str(year + 1) + str(startday + day - maxd + 1).zfill(3)

        arcpy.env.workspace = working_dir
        #Make list of hdf files for that day
        wildcard = "*A" + yd + "*"
        hdfList = arcpy.ListRasters(wildcard,'HDF')
        
        #Test if there are HDF files for that day
        if not(os.path.isfile(output_dir + "\\" + yd + 'MYD.bands.proj.tif')):
            print hdfList
            if len(hdfList) <> 0:
                

                #Loop through HDF files        
                for hdf in hdfList:
                    tifname=hdf[8:23] + ".tif"
                    print "Extracting bands from..."+str(hdf)
                    data1=arcpy.ExtractSubDataset_management(hdf, output_dir + r'\bands.' + tifname, [11, 13, 14])
                    data1=arcpy.ExtractSubDataset_management(hdf, output_dir + r'\state.' + tifname, [1])

                #Make a list of all the new tifs
                arcpy.env.workspace = output_dir
                tiflist = arcpy.ListRasters('bands.*','TIF')
                tiflist_state = arcpy.ListRasters('state.*','TIF')

                #Mosaic tifs together
                print "Combining MODIS tiles..."
                arcpy.MosaicToNewRaster_management(tiflist,output_dir, yd + 'bands.tif', \
                                                   "PROJCS['World_Sinusoidal',GEOGCS['GCS_WGS_1984',DATUM['D_WGS_1984',SPHEROID['WGS_1984',6378137.0,298.257223563]],PRIMEM['Greenwich',0.0],UNIT['Degree',0.0174532925199433]],PROJECTION['Sinusoidal'],PARAMETER['False_Easting',0.0],PARAMETER['False_Northing',0.0],PARAMETER['Central_Meridian',0.0],UNIT['Meter',1.0]]", '16_BIT_SIGNED', \
                                                   number_of_bands="3")
                arcpy.MosaicToNewRaster_management(tiflist_state,output_dir, yd + 'state.tif', \
                                                   "PROJCS['World_Sinusoidal',GEOGCS['GCS_WGS_1984',DATUM['D_WGS_1984',SPHEROID['WGS_1984',6378137.0,298.257223563]],PRIMEM['Greenwich',0.0],UNIT['Degree',0.0174532925199433]],PROJECTION['Sinusoidal'],PARAMETER['False_Easting',0.0],PARAMETER['False_Northing',0.0],PARAMETER['Central_Meridian',0.0],UNIT['Meter',1.0]]", '16_BIT_SIGNED', \
                                                   number_of_bands="1")

                #Project raster to Polar Stereographic
                print "Projecting to Polar Stereographic"
                arcpy.ProjectRaster_management(in_raster=yd + 'bands.tif', out_raster=yd + 'MYD.bands.proj.tif', out_coor_system="PROJCS['South_Pole_Stereographic',GEOGCS['GCS_WGS_1984',DATUM['D_WGS_1984',SPHEROID['WGS_1984',6378137.0,298.257223563]],PRIMEM['Greenwich',0.0],UNIT['Degree',0.0174532925199433]],PROJECTION['Stereographic'],PARAMETER['False_Easting',0.0],PARAMETER['False_Northing',0.0],PARAMETER['Central_Meridian',0.0],PARAMETER['Scale_Factor',1.0],PARAMETER['Latitude_Of_Origin',-90.0],UNIT['Meter',1.0]]", resampling_type="NEAREST", cell_size="463.3127165275 463.3127165275", geographic_transform="", Registration_Point="", in_coor_system="PROJCS['World_Sinusoidal',GEOGCS['GCS_WGS_1984',DATUM['D_WGS_1984',SPHEROID['WGS_1984',6378137.0,298.257223563]],PRIMEM['Greenwich',0.0],UNIT['Degree',0.0174532925199433]],PROJECTION['Sinusoidal'],PARAMETER['False_Easting',0.0],PARAMETER['False_Northing',0.0],PARAMETER['Central_Meridian',0.0],UNIT['Meter',1.0]]")

                arcpy.ProjectRaster_management(in_raster=yd + 'state.tif', out_raster=yd + 'MYD.state.proj.tif', out_coor_system="PROJCS['South_Pole_Stereographic',GEOGCS['GCS_WGS_1984',DATUM['D_WGS_1984',SPHEROID['WGS_1984',6378137.0,298.257223563]],PRIMEM['Greenwich',0.0],UNIT['Degree',0.0174532925199433]],PROJECTION['Stereographic'],PARAMETER['False_Easting',0.0],PARAMETER['False_Northing',0.0],PARAMETER['Central_Meridian',0.0],PARAMETER['Scale_Factor',1.0],PARAMETER['Latitude_Of_Origin',-90.0],UNIT['Meter',1.0]]", resampling_type="NEAREST", cell_size="463.3127165275 463.3127165275", geographic_transform="", Registration_Point="", in_coor_system="PROJCS['World_Sinusoidal',GEOGCS['GCS_WGS_1984',DATUM['D_WGS_1984',SPHEROID['WGS_1984',6378137.0,298.257223563]],PRIMEM['Greenwich',0.0],UNIT['Degree',0.0174532925199433]],PROJECTION['Sinusoidal'],PARAMETER['False_Easting',0.0],PARAMETER['False_Northing',0.0],PARAMETER['Central_Meridian',0.0],UNIT['Meter',1.0]]")


                #Delete temporary tif files
                print "Removing temporary tif files..."
                arcpy.Delete_management(yd + 'bands.tif')
                for tif in tiflist:
                    arcpy.Delete_management(tif)
                arcpy.Delete_management(yd + 'state.tif')
                for tif in tiflist_state:
                    arcpy.Delete_management(tif)
                print yd + " Completed"
            else:
                print "No data for " + yd
        else:
            print "Files already exist for " + yd
print "DONE"
