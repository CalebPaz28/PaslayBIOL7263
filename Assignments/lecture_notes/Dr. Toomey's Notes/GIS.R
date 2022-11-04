GIS in R - Rasters and Points
M. Toomey
2022-10-18
A wide range of tools are available in R to work geographic information system (GIS) data. In this lesson we will

learn how to import, plot, and modify:
  Raster files - pixelated or gridded data where each cell is a value at some point on the earths surface.
Shapefiles - vectors of features, points, lines, polygons with specific attributes.
We will use publicly available data to model our own personal climate envelope.Essentially, we will pretend we are each a species and create our own personal “species” distribution model.
This will involve:
  
  Loading climate rasters.
Selecting points from places you’ve lived and/or traveled to.
Extracting climate data from these points.
Stacking the relevant climate rasters
Training a “species” distribution model.
Plotting your climate envelope.
Comparing your envelope to global climates.
Preliminaries
For this exercise we will need to install and load the following packages:
  
  # install.packages(c("sp","rgdal","raster","rgeos","geosphere","dismo"))
  library(sp) # classes for vector data (polygons, points, lines)
library(rgdal) # basic operations for spatial data
## Please note that rgdal will be retired by the end of 2023,
## plan transition to sf/stars/terra functions using GDAL and PROJ
## at your earliest convenience.
## 
## rgdal: version: 1.5-32, (SVN revision 1176)
## Geospatial Data Abstraction Library extensions to R successfully loaded
## Loaded GDAL runtime: GDAL 3.4.3, released 2022/04/22
## Path to GDAL shared files: C:/Users/mbtoo/AppData/Local/R/win-library/4.2/rgdal/gdal
## GDAL binary built with GEOS: TRUE 
## Loaded PROJ runtime: Rel. 7.2.1, January 1st, 2021, [PJ_VERSION: 721]
## Path to PROJ shared files: C:/Users/mbtoo/AppData/Local/R/win-library/4.2/rgdal/proj
## PROJ CDN enabled: FALSE
## Linking to sp version:1.5-0
## To mute warnings of possible GDAL/OSR exportToProj4() degradation,
## use options("rgdal_show_exportToProj4_warnings"="none") before loading sp or rgdal.
library(raster) # handles rasters
library(rgeos) # methods for vector files
## rgeos version: 0.5-9, (SVN revision 684)
##  GEOS runtime version: 3.9.1-CAPI-1.14.2 
##  Please note that rgeos will be retired by the end of 2023,
## plan transition to sf functions using GEOS at your earliest convenience.
##  GEOS using OverlayNG
##  Linking to sp version: 1.5-0 
##  Polygon checking: TRUE
library(geosphere) # more methods for vector files
library(dismo) # species distribution modeling tools
Prepare your project folder
GIS projects often involve several different classes of data and multiple files in a single analysis. To avoid confusion, let’s create a working folder GIS_lesson with four subfolders:
  
  My_Climate_Sapce
My_loacations
WORLDCLIM_Rasters
Country_Shapefiles
You can simply do this in the file browser on your computer.

Load Climate Data Rasters
We will use data available from worldclim.org to model the climate envelope and specifically 19 standard climatic variables recorded 1970-2000:
  
  https://geodata.ucdavis.edu/climate/worldclim/2_1/base/wc2.1_10m_bio.zip

Download this folder, unzip it, and move the files into your WORLDCLIM_Rasters folder. You should have a set of 19 .tif files. Each raster corresponds to a different climatic variable and you can learn more about each here:
  
  https://www.worldclim.org/data/bioclim.html

Let’s take a look at one of these rasters:
  
  #load a raster
  bio1<- raster("WORLDCLIM_Rasters/wc2.1_10m_bio_1.tif")
plot(bio1) 


bio1 is the mean temperature of the earth from 1970-2000. The units are degrees Celsius. Let’s look at the metadata:
  
  bio1
## class      : RasterLayer 
## dimensions : 1080, 2160, 2332800  (nrow, ncol, ncell)
## resolution : 0.1666667, 0.1666667  (x, y)
## extent     : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
## crs        : +proj=longlat +datum=WGS84 +no_defs 
## source     : wc2.1_10m_bio_1.tif 
## names      : wc2.1_10m_bio_1 
## values     : -54.72435, 30.98764  (min, max)
Here’s what you will see:
  
  Line 1, class: bio1 is a raster.

Line 2, dimensions: Raster dimensions.

Line 3, resolution: Size of a cell. The size is in the units used in the coordinate system. In this case the rasters is in the unprojected (WGS84) coordinate system, so the units are in degrees. 0.17 degrees is about 17 km at the equator.

Line 4, extent: This is the “bounding box” of the raster.

Line 5, crs: This string represents the WGS84 coordinate reference system. It tells R how to draw the raster and what units for cell size.

Line 6, data source: If the raster is in memory or a file.

Line 7, names: The name of the raster… you can change this with names(bio01) <- 'meanTemp'.

Line 8, values: The min and max values of the raster

You can do math on a raster just like any variable in R. Let’s convert to Celsius to Fahrenheit.

bio1_f <- bio1 * (9/5)+32
plot(bio1_f)


If we want to work with multiple rasters that have the same extent and resolution we can create a stack

clim_stack <- stack(list.files("WORLDCLIM_Rasters", full.names = TRUE, pattern = ".tif"))
Let’s look at the stack

plot(clim_stack, nc = 5) # nc plots five columns of the 19 rasters


clim_stack
## class      : RasterStack 
## dimensions : 1080, 2160, 2332800, 19  (nrow, ncol, ncell, nlayers)
## resolution : 0.1666667, 0.1666667  (x, y)
## extent     : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
## crs        : +proj=longlat +datum=WGS84 +no_defs 
## names      : wc2.1_10m_bio_1, wc2.1_10m_bio_10, wc2.1_10m_bio_11, wc2.1_10m_bio_12, wc2.1_10m_bio_13, wc2.1_10m_bio_14, wc2.1_10m_bio_15, wc2.1_10m_bio_16, wc2.1_10m_bio_17, wc2.1_10m_bio_18, wc2.1_10m_bio_19, wc2.1_10m_bio_2, wc2.1_10m_bio_3, wc2.1_10m_bio_4, wc2.1_10m_bio_5, ... 
## min values :      -54.724354,       -37.781418,       -66.311249,         0.000000,         0.000000,         0.000000,         0.000000,         0.000000,         0.000000,         0.000000,         0.000000,        1.000000,        9.131122,        0.000000,      -29.686001, ... 
## max values :        30.98764,         38.21617,         29.15299,      11191.00000,       2381.00000,        484.00000,        229.00169,       5284.00000,       1507.00000,       5282.00000,       4467.00000,        21.14754,       100.00000,      2363.84595,        48.08275, ...
For the remainder of the exercise, select a subset (3-5) of the climate variables that are particularly interesting or important to you and make your own raster stack.

my_clim_stack <- stack(
  raster('WORLDCLIM_Rasters/wc2.1_10m_bio_2.tif'),
  raster('WORLDCLIM_Rasters/wc2.1_10m_bio_4.tif'),
  raster('WORLDCLIM_Rasters/wc2.1_10m_bio_17.tif')
)
#Look up the variable on https://www.worldclim.org/data/bioclim.html and rename the variable with a more descriptive name.  
names(my_clim_stack) <- c("mean_diurnal_range", "temperature_seasonality", "precip_driest_quarter")

plot(my_clim_stack)


Are my variables climate correlated with one another?
  
  pairs(my_clim_stack) #pairs is a base R function that plots univariate distribution and bivariate relationships


Mapping your personal points
Make a list of 10 locations you would like to model your climate envelope on. This could be places you have lived, places you have traveled, places you would like to travel, or places you want to avoid.

Now let’s determine the coordinates of these places on our map. We will use these locations to train our model. To do this we will plot a map of the earth and then use the mouse to select points.

Go to MaturalEarth and under the “Admin 0 – Countries” section download countries. This will download a shapefile. Unzip this files and place it in your Country_Shapefiles folder within this project.

Now load the shapefile into R.

countries <- shapefile("Country_Shapefiles/ne_10m_admin_0_countries.shp")
countries
## class       : SpatialPolygonsDataFrame 
## features    : 258 
## extent      : -180, 180, -90, 83.6341  (xmin, xmax, ymin, ymax)
## crs         : +proj=longlat +datum=WGS84 +no_defs 
## variables   : 168
## names       :      featurecla, scalerank, LABELRANK,  SOVEREIGNT, SOV_A3, ADM0_DIF, LEVEL,        TYPE, TLC,       ADMIN, ADM0_A3, GEOU_DIF,     GEOUNIT, GU_A3, SU_DIF, ... 
## min values  : Admin-0 country,         0,         2, Afghanistan,    AFG,        0,     1,     Country,   1, Afghanistan,     ABW,        0, Afghanistan,   ABW,      0, ... 
## max values  : Admin-0 country,         6,        10,    Zimbabwe,    ZWE,        1,     2, Sovereignty,   1,    Zimbabwe,     ZWE,        0,    Zimbabwe,   ZWE,      1, ...
This data object consists of two things: 1) vector data describing the borders of the shapes and a data frame with country names and a vairety of other data.

head(countries)
##        featurecla scalerank LABELRANK SOVEREIGNT SOV_A3 ADM0_DIF LEVEL
## 1 Admin-0 country         0         2  Indonesia    IDN        0     2
## 2 Admin-0 country         0         3   Malaysia    MYS        0     2
## 3 Admin-0 country         0         2      Chile    CHL        0     2
## 4 Admin-0 country         0         3    Bolivia    BOL        0     2
## 5 Admin-0 country         0         2       Peru    PER        0     2
## 6 Admin-0 country         0         2  Argentina    ARG        0     2
##                TYPE TLC     ADMIN ADM0_A3 GEOU_DIF   GEOUNIT GU_A3 SU_DIF
## 1 Sovereign country   1 Indonesia     IDN        0 Indonesia   IDN      0
## 2 Sovereign country   1  Malaysia     MYS        0  Malaysia   MYS      0
## 3 Sovereign country   1     Chile     CHL        0     Chile   CHL      0
## 4 Sovereign country   1   Bolivia     BOL        0   Bolivia   BOL      0
## 5 Sovereign country   1      Peru     PER        0      Peru   PER      0
## 6 Sovereign country   1 Argentina     ARG        0 Argentina   ARG      0
##     SUBUNIT SU_A3 BRK_DIFF      NAME NAME_LONG BRK_A3  BRK_NAME BRK_GROUP
## 1 Indonesia   IDN        0 Indonesia Indonesia    IDN Indonesia      <NA>
## 2  Malaysia   MYS        0  Malaysia  Malaysia    MYS  Malaysia      <NA>
## 3     Chile   CHL        0     Chile     Chile    CHL     Chile      <NA>
## 4   Bolivia   BOL        0   Bolivia   Bolivia    BOL   Bolivia      <NA>
## 5      Peru   PER        0      Peru      Peru    PER      Peru      <NA>
## 6 Argentina   ARG        0 Argentina Argentina    ARG Argentina      <NA>
##    ABBREV POSTAL                      FORMAL_EN FORMAL_FR NAME_CIAWF NOTE_ADM0
## 1   Indo.   INDO          Republic of Indonesia      <NA>  Indonesia      <NA>
## 2  Malay.     MY                       Malaysia      <NA>   Malaysia      <NA>
## 3   Chile     CL              Republic of Chile      <NA>      Chile      <NA>
## 4 Bolivia     BO Plurinational State of Bolivia      <NA>    Bolivia      <NA>
## 5    Peru     PE               Republic of Peru      <NA>       Peru      <NA>
## 6    Arg.     AR             Argentine Republic      <NA>  Argentina      <NA>
##   NOTE_BRK NAME_SORT NAME_ALT MAPCOLOR7 MAPCOLOR8 MAPCOLOR9 MAPCOLOR13
## 1     <NA> Indonesia     <NA>         6         6         6         11
## 2     <NA>  Malaysia     <NA>         2         4         3          6
## 3     <NA>     Chile     <NA>         5         1         5          9
## 4     <NA>   Bolivia     <NA>         1         5         2          3
## 5     <NA>      Peru     <NA>         4         4         4         11
## 6     <NA> Argentina     <NA>         3         1         3         13
##     POP_EST POP_RANK POP_YEAR  GDP_MD GDP_YEAR                  ECONOMY
## 1 270625568       17     2019 1119190     2019 4. Emerging region: MIKT
## 2  31949777       15     2019  364681     2019     6. Developing region
## 3  18952038       14     2019  282318     2019  5. Emerging region: G20
## 4  11513100       14     2019   40895     2019  5. Emerging region: G20
## 5  32510453       15     2019  226848     2019  5. Emerging region: G20
## 6  44938712       15     2019  445445     2019  5. Emerging region: G20
##               INCOME_GRP FIPS_10 ISO_A2 ISO_A2_EH ISO_A3 ISO_A3_EH ISO_N3
## 1 4. Lower middle income      ID     ID        ID    IDN       IDN    360
## 2 3. Upper middle income      MY     MY        MY    MYS       MYS    458
## 3 3. Upper middle income      CI     CL        CL    CHL       CHL    152
## 4 4. Lower middle income      BL     BO        BO    BOL       BOL    068
## 5 3. Upper middle income      PE     PE        PE    PER       PER    604
## 6 3. Upper middle income      AR     AR        AR    ARG       ARG    032
##   ISO_N3_EH UN_A3 WB_A2 WB_A3   WOE_ID WOE_ID_EH                   WOE_NOTE
## 1       360   360    ID   IDN 23424846  23424846 Exact WOE match as country
## 2       458   458    MY   MYS 23424901  23424901 Exact WOE match as country
## 3       152   152    CL   CHL 23424782  23424782 Exact WOE match as country
## 4       068   068    BO   BOL 23424762  23424762 Exact WOE match as country
## 5       604   604    PE   PER 23424919  23424919 Exact WOE match as country
## 6       032   032    AR   ARG 23424747  23424747 Exact WOE match as country
##   ADM0_ISO ADM0_DIFF ADM0_TLC ADM0_A3_US ADM0_A3_FR ADM0_A3_RU ADM0_A3_ES
## 1      IDN      <NA>      IDN        IDN        IDN        IDN        IDN
## 2      MYS      <NA>      MYS        MYS        MYS        MYS        MYS
## 3      CHL      <NA>      CHL        CHL        CHL        CHL        CHL
## 4      BOL      <NA>      BOL        BOL        BOL        BOL        BOL
## 5      PER      <NA>      PER        PER        PER        PER        PER
## 6      ARG      <NA>      ARG        ARG        ARG        ARG        ARG
##   ADM0_A3_CN ADM0_A3_TW ADM0_A3_IN ADM0_A3_NP ADM0_A3_PK ADM0_A3_DE ADM0_A3_GB
## 1        IDN        IDN        IDN        IDN        IDN        IDN        IDN
## 2        MYS        MYS        MYS        MYS        MYS        MYS        MYS
## 3        CHL        CHL        CHL        CHL        CHL        CHL        CHL
## 4        BOL        BOL        BOL        BOL        BOL        BOL        BOL
## 5        PER        PER        PER        PER        PER        PER        PER
## 6        ARG        ARG        ARG        ARG        ARG        ARG        ARG
##   ADM0_A3_BR ADM0_A3_IL ADM0_A3_PS ADM0_A3_SA ADM0_A3_EG ADM0_A3_MA ADM0_A3_PT
## 1        IDN        IDN        IDN        IDN        IDN        IDN        IDN
## 2        MYS        MYS        MYS        MYS        MYS        MYS        MYS
## 3        CHL        CHL        CHL        CHL        CHL        CHL        CHL
## 4        BOL        BOL        BOL        BOL        BOL        BOL        BOL
## 5        PER        PER        PER        PER        PER        PER        PER
## 6        ARG        ARG        ARG        ARG        ARG        ARG        ARG
##   ADM0_A3_AR ADM0_A3_JP ADM0_A3_KO ADM0_A3_VN ADM0_A3_TR ADM0_A3_ID ADM0_A3_PL
## 1        IDN        IDN        IDN        IDN        IDN        IDN        IDN
## 2        MYS        MYS        MYS        MYS        MYS        MYS        MYS
## 3        CHL        CHL        CHL        CHL        CHL        CHL        CHL
## 4        BOL        BOL        BOL        BOL        BOL        BOL        BOL
## 5        PER        PER        PER        PER        PER        PER        PER
## 6        ARG        ARG        ARG        ARG        ARG        ARG        ARG
##   ADM0_A3_GR ADM0_A3_IT ADM0_A3_NL ADM0_A3_SE ADM0_A3_BD ADM0_A3_UA ADM0_A3_UN
## 1        IDN        IDN        IDN        IDN        IDN        IDN        -99
## 2        MYS        MYS        MYS        MYS        MYS        MYS        -99
## 3        CHL        CHL        CHL        CHL        CHL        CHL        -99
## 4        BOL        BOL        BOL        BOL        BOL        BOL        -99
## 5        PER        PER        PER        PER        PER        PER        -99
## 6        ARG        ARG        ARG        ARG        ARG        ARG        -99
##   ADM0_A3_WB     CONTINENT REGION_UN          SUBREGION
## 1        -99          Asia      Asia South-Eastern Asia
## 2        -99          Asia      Asia South-Eastern Asia
## 3        -99 South America  Americas      South America
## 4        -99 South America  Americas      South America
## 5        -99 South America  Americas      South America
## 6        -99 South America  Americas      South America
##                   REGION_WB NAME_LEN LONG_LEN ABBREV_LEN TINY HOMEPART MIN_ZOOM
## 1       East Asia & Pacific        9        9          5  -99        1        0
## 2       East Asia & Pacific        8        8          6  -99        1        0
## 3 Latin America & Caribbean        5        5          5  -99        1        0
## 4 Latin America & Caribbean        7        7          7  -99        1        0
## 5 Latin America & Caribbean        4        4          4  -99        1        0
## 6 Latin America & Caribbean        9        9          4  -99        1        0
##   MIN_LABEL MAX_LABEL   LABEL_X    LABEL_Y      NE_ID WIKIDATAID   NAME_AR
## 1       1.7       6.7 101.89295  -0.954404 1159320845       Q252 إندونيسيا
## 2       3.0       8.0 113.83708   2.528667 1159321083       Q833   ماليزيا
## 3       1.7       6.7 -72.31887 -38.151771 1159320493       Q298     تشيلي
## 4       3.0       7.5 -64.59343 -16.666015 1159320439       Q750   بوليفيا
## 5       2.0       7.0 -72.90016 -12.976679 1159321163       Q419      بيرو
## 6       2.0       7.0 -64.17333 -33.501159 1159320331       Q414 الأرجنتين
##      NAME_BN     NAME_DE   NAME_EN   NAME_ES  NAME_FA   NAME_FR   NAME_EL
## 1 ইন্দোনেশিয়া  Indonesien Indonesia Indonesia  اندونزی Indonésie Ινδονησία
## 2  মালয়েশিয়া    Malaysia  Malaysia   Malasia    مالزی  Malaisie  Μαλαισία
## 3       চিলি       Chile     Chile     Chile     شیلی     Chili      Χιλή
## 4    বলিভিয়া    Bolivien   Bolivia   Bolivia   بولیوی   Bolivie   Βολιβία
## 5        পেরু        Peru      Peru      Perú      پرو     Pérou     Περού
## 6  আর্জেন্টিনা Argentinien Argentina Argentina آرژانتین Argentine Αργεντινή
##     NAME_HE  NAME_HI   NAME_HU   NAME_ID   NAME_IT      NAME_JA    NAME_KO
## 1 אינדונזיה इंडोनेशिया Indonézia Indonesia Indonesia インドネシア 인도네시아
## 2     מלזיה   मलेशिया  Malajzia  Malaysia  Malaysia   マレーシア 말레이시아
## 3     צ'ילה     चिली     Chile     Chili      Cile         チリ       칠레
## 4   בוליביה बोलिविया   Bolívia   Bolivia   Bolivia     ボリビア   볼리비아
## 5       פרו       पेरू      Peru      Peru      Perù       ペルー       페루
## 6  ארגנטינה अर्जेण्टीना Argentína Argentina Argentina アルゼンチン 아르헨티나
##      NAME_NL   NAME_PL   NAME_PT   NAME_RU    NAME_SV   NAME_TR   NAME_UK
## 1  Indonesië Indonezja Indonésia Индонезия Indonesien Endonezya Індонезія
## 2   Maleisië   Malezja   Malásia  Малайзия   Malaysia   Malezya  Малайзія
## 3      Chili     Chile     Chile      Чили      Chile      Şili      Чилі
## 4    Bolivia   Boliwia   Bolívia   Боливия    Bolivia   Bolivya   Болівія
## 5       Peru      Peru      Peru      Перу       Peru      Peru      Перу
## 6 Argentinië Argentyna Argentina Аргентина  Argentina  Arjantin Аргентина
##     NAME_UR   NAME_VI    NAME_ZH   NAME_ZHT      FCLASS_ISO TLC_DIFF
## 1 انڈونیشیا Indonesia 印度尼西亚 印度尼西亞 Admin-0 country     <NA>
## 2  ملائیشیا  Malaysia   马来西亚   馬來西亞 Admin-0 country     <NA>
## 3       چلی     Chile       智利       智利 Admin-0 country     <NA>
## 4   بولیویا   Bolivia   玻利维亚   玻利維亞 Admin-0 country     <NA>
## 5      پیرو      Peru       秘鲁       秘魯 Admin-0 country     <NA>
## 6  ارجنٹائن Argentina     阿根廷     阿根廷 Admin-0 country     <NA>
##        FCLASS_TLC FCLASS_US FCLASS_FR FCLASS_RU FCLASS_ES FCLASS_CN FCLASS_TW
## 1 Admin-0 country      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 2 Admin-0 country      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 3 Admin-0 country      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 4 Admin-0 country      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 5 Admin-0 country      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 6 Admin-0 country      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
##   FCLASS_IN FCLASS_NP FCLASS_PK FCLASS_DE FCLASS_GB FCLASS_BR FCLASS_IL
## 1      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 2      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 3      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 4      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 5      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 6      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
##   FCLASS_PS FCLASS_SA FCLASS_EG FCLASS_MA FCLASS_PT FCLASS_AR FCLASS_JP
## 1      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 2      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 3      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 4      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 5      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 6      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
##   FCLASS_KO FCLASS_VN FCLASS_TR FCLASS_ID FCLASS_PL FCLASS_GR FCLASS_IT
## 1      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 2      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 3      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 4      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 5      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 6      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
##   FCLASS_NL FCLASS_SE FCLASS_BD FCLASS_UA
## 1      <NA>      <NA>      <NA>      <NA>
## 2      <NA>      <NA>      <NA>      <NA>
## 3      <NA>      <NA>      <NA>      <NA>
## 4      <NA>      <NA>      <NA>      <NA>
## 5      <NA>      <NA>      <NA>      <NA>
## 6      <NA>      <NA>      <NA>      <NA>
This looks just like a data frame and you can manipulate it like a data frame:
  
  nrow(countries) # how many rows?
countries$wantToBeHere <- FALSE # add a column
mexico <- subset(countries, NAME=='Mexico') # subset using subset command
uzbek <- countries[countries$NAME=='Uzbekistan', ] # subset by row
sovereign <- countries[ , 4] # 4th column... but still has all shapes associated with it
countries[ , 'SOVEREIGNT']  # 4th column again... still has all shapes associated with it
countriesDf <- as.data.frame(countries) # remove shape data but keep data frame
Let’s plot the countries shapefile.

plot(countries, col='goldenrod', border='darkblue') 


If the extent and coordinate systems are the same, we can plot both raster and shapefiles. We will start by opening up a new plot device:
  
  dev.new()
Resize this plot widow to full screen. Now plot the raster and shapefile.

plot(my_clim_stack[[2]]) # plot mean annual temperature
plot(countries, add=TRUE) # add countries shapefile


Now let’s locate your points on this map. We will start by issuing the command below and then using the mouse to click on points on the map. This will populate my_sites with the lat. and lon. of each point.

my_sites <- as.data.frame(click(n=10))
Now let’s look at your points

names(my_sites) <- c('longitude', 'latitude')
my_sites
##       longitude latitude
## 1    70.3161401 43.81823
## 2   101.5794610 50.67422
## 3    45.9088107 25.99265
## 4    10.8061346 44.64095
## 5    13.8227708 58.90141
## 6    -0.9861706 51.49694
## 7   -81.0641504 27.08961
## 8   -72.8369607 43.81823
## 9   -98.6154885 35.59104
## 10 -113.9729092 34.21984
Note that longitude is first and latitude is second. Often we say “latitude and longitude”, by which we mean “y and x coordinates.” However, we usually also say “x and y” (not “y and x”). Many spatial commands in R assume longitude (x) is first and latitude is second (y), so we’ll adopt that convention here as a good practice.

Now we can extract values from the climate rasters at each of our points.

env <- as.data.frame(extract(my_clim_stack, my_sites))
env
##    mean_diurnal_range temperature_seasonality precip_driest_quarter
## 1           13.174375               1223.1614                    12
## 2           14.276125               1373.3907                     8
## 3           13.974229                868.3943                     1
## 4           10.608021                778.4135                   163
## 5            6.639521                654.0322                    98
## 6            7.916042                474.6800                   149
## 7           12.700188                410.7738                   132
## 8           11.460604               1003.9276                   245
## 9           13.480500                938.7786                    79
## 10          16.226896                858.1950                    11
# join environmental data and your site data
my_sites <- cbind(my_sites, env)
my_sites
##       longitude latitude mean_diurnal_range temperature_seasonality
## 1    70.3161401 43.81823          13.174375               1223.1614
## 2   101.5794610 50.67422          14.276125               1373.3907
## 3    45.9088107 25.99265          13.974229                868.3943
## 4    10.8061346 44.64095          10.608021                778.4135
## 5    13.8227708 58.90141           6.639521                654.0322
## 6    -0.9861706 51.49694           7.916042                474.6800
## 7   -81.0641504 27.08961          12.700188                410.7738
## 8   -72.8369607 43.81823          11.460604               1003.9276
## 9   -98.6154885 35.59104          13.480500                938.7786
## 10 -113.9729092 34.21984          16.226896                858.1950
##    precip_driest_quarter
## 1                     12
## 2                      8
## 3                      1
## 4                    163
## 5                     98
## 6                    149
## 7                    132
## 8                    245
## 9                     79
## 10                    11
Creating shapefiles and intersecting shapes and rasters
We can turn our points into a shapefile by specifying a cooordinate system. We will get the coordinate system from our raster

myCrs <- projection(my_clim_stack) # get projection info

# make into points file
my_sites_shape <- SpatialPointsDataFrame(coords=my_sites, data=my_sites, proj4string=CRS(myCrs))
my_sites_shape
## class       : SpatialPointsDataFrame 
## features    : 10 
## extent      : -113.9729, 101.5795, 25.99265, 58.90141  (xmin, xmax, ymin, ymax)
## crs         : +proj=longlat +datum=WGS84 +no_defs 
## variables   : 5
## names       :    longitude,    latitude, mean_diurnal_range, temperature_seasonality, precip_driest_quarter 
## min values  : -113.9729092,  25.9926519,    6.6395206451416,        410.773773193359,                     1 
## max values  :   101.579461, 58.90141071,   16.2268962860107,        1373.39074707031,                   245
Now let’s plot this shapefile along with the other elements.

plot(my_clim_stack[[2]])
plot(countries, add=TRUE)
points(my_sites_shape, pch=16) # show sites on the map


If you want to save these points for later we can do that with writeORG function from the rgdal package

writeOGR(mySitesShape, 'My_locations', 'my_sites_shape', driver='ESRI Shapefile')
What if we want to create a shape file of only the countries we have visited? We can intersect our points with the country shape file. But first we will need to ensure they are in the same map projection.

projection(my_sites_shape)
## [1] "+proj=longlat +datum=WGS84 +no_defs"
projection(countries)
## [1] "+proj=longlat +datum=WGS84 +no_defs"
Looks good!
  
  Now we can identify the countries that contain our points

# add a column to countries data frame with a unique number
countries$id <- 1:nrow(countries)

# see which countries points fall into
my_countries <- over(my_sites_shape, countries)
head(as.data.frame(my_countries)) # let's look at data frame portion
##        featurecla scalerank LABELRANK     SOVEREIGNT SOV_A3 ADM0_DIF LEVEL
## 1 Admin-0 country         0         3     Kazakhstan    KA1        1     1
## 2 Admin-0 country         0         3       Mongolia    MNG        0     2
## 3 Admin-0 country         0         2   Saudi Arabia    SAU        0     2
## 4 Admin-0 country         0         2          Italy    ITA        0     2
## 5 Admin-0 country         0         3         Sweden    SWE        0     2
## 6 Admin-0 country         0         2 United Kingdom    GB1        1     2
##                TYPE TLC          ADMIN ADM0_A3 GEOU_DIF        GEOUNIT GU_A3
## 1       Sovereignty   1     Kazakhstan     KAZ        0     Kazakhstan   KAZ
## 2 Sovereign country   1       Mongolia     MNG        0       Mongolia   MNG
## 3 Sovereign country   1   Saudi Arabia     SAU        0   Saudi Arabia   SAU
## 4 Sovereign country   1          Italy     ITA        0          Italy   ITA
## 5 Sovereign country   1         Sweden     SWE        0         Sweden   SWE
## 6           Country   1 United Kingdom     GBR        0 United Kingdom   GBR
##   SU_DIF        SUBUNIT SU_A3 BRK_DIFF           NAME      NAME_LONG BRK_A3
## 1      0     Kazakhstan   KAZ        0     Kazakhstan     Kazakhstan    KAZ
## 2      0       Mongolia   MNG        0       Mongolia       Mongolia    MNG
## 3      0   Saudi Arabia   SAU        0   Saudi Arabia   Saudi Arabia    SAU
## 4      0          Italy   ITA        0          Italy          Italy    ITA
## 5      0         Sweden   SWE        0         Sweden         Sweden    SWE
## 6      0 United Kingdom   GBR        0 United Kingdom United Kingdom    GBR
##         BRK_NAME BRK_GROUP ABBREV POSTAL
## 1     Kazakhstan      <NA>   Kaz.     KZ
## 2       Mongolia      <NA>  Mong.     MN
## 3   Saudi Arabia      <NA>  Saud.     SA
## 4          Italy      <NA>  Italy      I
## 5         Sweden      <NA>   Swe.      S
## 6 United Kingdom      <NA>   U.K.     GB
##                                              FORMAL_EN FORMAL_FR     NAME_CIAWF
## 1                               Republic of Kazakhstan      <NA>     Kazakhstan
## 2                                             Mongolia      <NA>       Mongolia
## 3                              Kingdom of Saudi Arabia      <NA>   Saudi Arabia
## 4                                     Italian Republic      <NA>          Italy
## 5                                    Kingdom of Sweden      <NA>         Sweden
## 6 United Kingdom of Great Britain and Northern Ireland      <NA> United Kingdom
##   NOTE_ADM0 NOTE_BRK      NAME_SORT NAME_ALT MAPCOLOR7 MAPCOLOR8 MAPCOLOR9
## 1      <NA>     <NA>     Kazakhstan     <NA>         6         1         6
## 2      <NA>     <NA>       Mongolia     <NA>         3         5         5
## 3      <NA>     <NA>   Saudi Arabia     <NA>         6         1         6
## 4      <NA>     <NA>          Italy     <NA>         6         7         8
## 5      <NA>     <NA>         Sweden     <NA>         1         4         2
## 6      <NA>     <NA> United Kingdom     <NA>         6         6         6
##   MAPCOLOR13  POP_EST POP_RANK POP_YEAR  GDP_MD GDP_YEAR
## 1          1 18513930       14     2019  181665     2019
## 2          6  3225167       12     2019   13996     2019
## 3          7 34268528       15     2019  792966     2019
## 4          7 60297396       16     2019 2003576     2019
## 5          4 10285453       14     2019  530883     2019
## 6          3 66834405       16     2019 2829108     2019
##                      ECONOMY              INCOME_GRP FIPS_10 ISO_A2 ISO_A2_EH
## 1       6. Developing region  3. Upper middle income      KZ     KZ        KZ
## 2       6. Developing region  4. Lower middle income      MG     MN        MN
## 3 2. Developed region: nonG7 2. High income: nonOECD      SA     SA        SA
## 4    1. Developed region: G7    1. High income: OECD      IT     IT        IT
## 5 2. Developed region: nonG7    1. High income: OECD      SW     SE        SE
## 6    1. Developed region: G7    1. High income: OECD      UK     GB        GB
##   ISO_A3 ISO_A3_EH ISO_N3 ISO_N3_EH UN_A3 WB_A2 WB_A3   WOE_ID WOE_ID_EH
## 1    KAZ       KAZ    398       398   398    KZ   KAZ      -90  23424871
## 2    MNG       MNG    496       496   496    MN   MNG 23424887  23424887
## 3    SAU       SAU    682       682   682    SA   SAU 23424938  23424938
## 4    ITA       ITA    380       380   380    IT   ITA 23424853  23424853
## 5    SWE       SWE    752       752   752    SE   SWE 23424954  23424954
## 6    GBR       GBR    826       826   826    GB   GBR      -90  23424975
##                                                                                                                                                                  WOE_NOTE
## 1                                                                                                             Includes Baykonur Cosmodrome as an Admin-1 states provinces
## 2                                                                                                                                              Exact WOE match as country
## 3                                                                                                                                              Exact WOE match as country
## 4                                                                                                                                              Exact WOE match as country
## 5                                                                                                                                              Exact WOE match as country
## 6 Eh ID includes Channel Islands and Isle of Man. UK constituent countries of England (24554868), Wales (12578049), Scotland (12578048), and Northern Ireland (20070563).
##   ADM0_ISO ADM0_DIFF ADM0_TLC ADM0_A3_US ADM0_A3_FR ADM0_A3_RU ADM0_A3_ES
## 1      KAZ      <NA>      KAZ        KAZ        KAZ        KAZ        KAZ
## 2      MNG      <NA>      MNG        MNG        MNG        MNG        MNG
## 3      SAU      <NA>      SAU        SAU        SAU        SAU        SAU
## 4      ITA      <NA>      ITA        ITA        ITA        ITA        ITA
## 5      SWE      <NA>      SWE        SWE        SWE        SWE        SWE
## 6      GBR      <NA>      GBR        GBR        GBR        GBR        GBR
##   ADM0_A3_CN ADM0_A3_TW ADM0_A3_IN ADM0_A3_NP ADM0_A3_PK ADM0_A3_DE ADM0_A3_GB
## 1        KAZ        KAZ        KAZ        KAZ        KAZ        KAZ        KAZ
## 2        MNG        MNG        MNG        MNG        MNG        MNG        MNG
## 3        SAU        SAU        SAU        SAU        SAU        SAU        SAU
## 4        ITA        ITA        ITA        ITA        ITA        ITA        ITA
## 5        SWE        SWE        SWE        SWE        SWE        SWE        SWE
## 6        GBR        GBR        GBR        GBR        GBR        GBR        GBR
##   ADM0_A3_BR ADM0_A3_IL ADM0_A3_PS ADM0_A3_SA ADM0_A3_EG ADM0_A3_MA ADM0_A3_PT
## 1        KAZ        KAZ        KAZ        KAZ        KAZ        KAZ        KAZ
## 2        MNG        MNG        MNG        MNG        MNG        MNG        MNG
## 3        SAU        SAU        SAU        SAU        SAU        SAU        SAU
## 4        ITA        ITA        ITA        ITA        ITA        ITA        ITA
## 5        SWE        SWE        SWE        SWE        SWE        SWE        SWE
## 6        GBR        GBR        GBR        GBR        GBR        GBR        GBR
##   ADM0_A3_AR ADM0_A3_JP ADM0_A3_KO ADM0_A3_VN ADM0_A3_TR ADM0_A3_ID ADM0_A3_PL
## 1        KAZ        KAZ        KAZ        KAZ        KAZ        KAZ        KAZ
## 2        MNG        MNG        MNG        MNG        MNG        MNG        MNG
## 3        SAU        SAU        SAU        SAU        SAU        SAU        SAU
## 4        ITA        ITA        ITA        ITA        ITA        ITA        ITA
## 5        SWE        SWE        SWE        SWE        SWE        SWE        SWE
## 6        GBR        GBR        GBR        GBR        GBR        GBR        GBR
##   ADM0_A3_GR ADM0_A3_IT ADM0_A3_NL ADM0_A3_SE ADM0_A3_BD ADM0_A3_UA ADM0_A3_UN
## 1        KAZ        KAZ        KAZ        KAZ        KAZ        KAZ        -99
## 2        MNG        MNG        MNG        MNG        MNG        MNG        -99
## 3        SAU        SAU        SAU        SAU        SAU        SAU        -99
## 4        ITA        ITA        ITA        ITA        ITA        ITA        -99
## 5        SWE        SWE        SWE        SWE        SWE        SWE        -99
## 6        GBR        GBR        GBR        GBR        GBR        GBR        -99
##   ADM0_A3_WB CONTINENT REGION_UN       SUBREGION                  REGION_WB
## 1        -99      Asia      Asia    Central Asia      Europe & Central Asia
## 2        -99      Asia      Asia    Eastern Asia        East Asia & Pacific
## 3        -99      Asia      Asia    Western Asia Middle East & North Africa
## 4        -99    Europe    Europe Southern Europe      Europe & Central Asia
## 5        -99    Europe    Europe Northern Europe      Europe & Central Asia
## 6        -99    Europe    Europe Northern Europe      Europe & Central Asia
##   NAME_LEN LONG_LEN ABBREV_LEN TINY HOMEPART MIN_ZOOM MIN_LABEL MAX_LABEL
## 1       10       10          4  -99        1        0       2.7       7.0
## 2        8        8          5  -99        1        0       3.0       7.0
## 3       12       12          5  -99        1        0       1.7       7.0
## 4        5        5          5  -99        1        0       2.0       7.0
## 5        6        6          4  -99        1        0       2.0       7.0
## 6       14       14          4  -99        1        0       1.7       6.7
##      LABEL_X  LABEL_Y      NE_ID WIKIDATAID         NAME_AR   NAME_BN
## 1  68.685548 49.05415 1159320967       Q232       كازاخستان কাজাখস্তান
## 2 104.150405 45.99749 1159321071       Q711         منغوليا  মঙ্গোলিয়া
## 3  44.699600 23.80691 1159321225       Q851        السعودية  সৌদি আরব
## 4  11.076907 44.73248 1159320919        Q38         إيطاليا     ইতালি
## 5  19.017050 65.85918 1159321287        Q34          السويد     সুইডেন
## 6  -2.116346 54.40274 1159320713       Q145 المملكة المتحدة   যুক্তরাজ্য
##                  NAME_DE        NAME_EN        NAME_ES       NAME_FA
## 1             Kasachstan     Kazakhstan     Kazajistán      قزاقستان
## 2               Mongolei       Mongolia       Mongolia      مغولستان
## 3          Saudi-Arabien   Saudi Arabia Arabia Saudita عربستان سعودی
## 4                Italien          Italy         Italia       ایتالیا
## 5               Schweden         Sweden         Suecia          سوئد
## 6 Vereinigtes Königreich United Kingdom    Reino Unido      بریتانیا
##           NAME_FR          NAME_EL        NAME_HE      NAME_HI
## 1      Kazakhstan        Καζακστάν         קזחסטן    कज़ाख़िस्तान
## 2        Mongolie         Μογγολία       מונגוליה      मंगोलिया
## 3 Arabie saoudite  Σαουδική Αραβία    ערב הסעודית     सउदी अरब
## 4          Italie           Ιταλία         איטליה         इटली
## 5           Suède          Σουηδία         שוודיה        स्वीडन
## 6     Royaume-Uni Ηνωμένο Βασίλειο הממלכה המאוחדת यूनाइटेड किंगडम
##              NAME_HU       NAME_ID        NAME_IT        NAME_JA        NAME_KO
## 1         Kazahsztán    Kazakhstan     Kazakistan   カザフスタン     카자흐스탄
## 2           Mongólia      Mongolia       Mongolia     モンゴル国           몽골
## 3       Szaúd-Arábia    Arab Saudi Arabia Saudita サウジアラビア 사우디아라비아
## 4        Olaszország        Italia         Italia       イタリア       이탈리아
## 5         Svédország        Swedia         Svezia   スウェーデン         스웨덴
## 6 Egyesült Királyság Britania Raya    Regno Unito       イギリス           영국
##               NAME_NL          NAME_PL        NAME_PT           NAME_RU
## 1          Kazachstan       Kazachstan    Cazaquistão         Казахстан
## 2            Mongolië         Mongolia       Mongólia          Монголия
## 3       Saoedi-Arabië Arabia Saudyjska Arábia Saudita Саудовская Аравия
## 4              Italië           Włochy         Itália            Италия
## 5              Zweden          Szwecja         Suécia            Швеция
## 6 Verenigd Koninkrijk  Wielka Brytania    Reino Unido    Великобритания
##          NAME_SV          NAME_TR           NAME_UK     NAME_UR
## 1      Kazakstan       Kazakistan         Казахстан    قازقستان
## 2      Mongoliet       Moğolistan          Монголія     منگولیا
## 3   Saudiarabien  Suudi Arabistan Саудівська Аравія   سعودی عرب
## 4        Italien           İtalya            Італія      اطالیہ
## 5        Sverige            İsveç            Швеція       سویڈن
## 6 Storbritannien Birleşik Krallık   Велика Британія مملکت متحدہ
##                                   NAME_VI    NAME_ZH     NAME_ZHT
## 1                              Kazakhstan 哈萨克斯坦       哈薩克
## 2                                 Mông Cổ     蒙古国       蒙古國
## 3                             Ả Rập Saudi 沙特阿拉伯 沙烏地阿拉伯
## 4                                       Ý     意大利       義大利
## 5                               Thụy Điển       瑞典         瑞典
## 6 Vương quốc Liên hiệp Anh và Bắc Ireland       英国         英國
##        FCLASS_ISO TLC_DIFF      FCLASS_TLC FCLASS_US FCLASS_FR FCLASS_RU
## 1 Admin-0 country     <NA> Admin-0 country      <NA>      <NA>      <NA>
## 2 Admin-0 country     <NA> Admin-0 country      <NA>      <NA>      <NA>
## 3 Admin-0 country     <NA> Admin-0 country      <NA>      <NA>      <NA>
## 4 Admin-0 country     <NA> Admin-0 country      <NA>      <NA>      <NA>
## 5 Admin-0 country     <NA> Admin-0 country      <NA>      <NA>      <NA>
## 6 Admin-0 country     <NA> Admin-0 country      <NA>      <NA>      <NA>
##   FCLASS_ES FCLASS_CN FCLASS_TW FCLASS_IN FCLASS_NP FCLASS_PK FCLASS_DE
## 1      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 2      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 3      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 4      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 5      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 6      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
##   FCLASS_GB FCLASS_BR FCLASS_IL FCLASS_PS FCLASS_SA FCLASS_EG FCLASS_MA
## 1      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 2      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 3      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 4      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 5      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 6      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
##   FCLASS_PT FCLASS_AR FCLASS_JP FCLASS_KO FCLASS_VN FCLASS_TR FCLASS_ID
## 1      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 2      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 3      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 4      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 5      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
## 6      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>
##   FCLASS_PL FCLASS_GR FCLASS_IT FCLASS_NL FCLASS_SE FCLASS_BD FCLASS_UA  id
## 1      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>  42
## 2      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>  47
## 3      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA> 106
## 4      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>  91
## 5      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>  54
## 6      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>      <NA>  79
This is only the data from the country polygons to get the actual country polygons to plot we have to do one more step.

my_countries <- countries[countries$id %in% my_countries$id, ] #select my countries from the country shape file by id #
# now let's plot just my countries
plot(my_countries)
points(my_sites_shape, col='red', pch=16)


We can then use my_countries to subset the climate rasters.

# convert shapefile to raster
my_countries_mask <- rasterize(my_countries, my_clim_stack[[2]])
my_countries_mask <- my_countries_mask * 0 + 1 # make all values 1

my_clim_sites <- my_clim_stack[[2]] * my_countries_mask
plot(my_clim_sites)


Selecting Random Points
To train our climate model we need a large set of random points to contrast agianst our selected locations. Ideally these would be locations where we were absent. However, if this is not practicable, a random selection of points can be sufficient.

bg <- as.data.frame(randomPoints(my_clim_stack, n=10000)) # 10,000 random sites
names(bg) <- c('longitude', 'latitude')
head(bg)
##    longitude  latitude
## 1  -83.91667  35.25000
## 2   21.25000 -12.41667
## 3 -149.75000 -82.25000
## 4   20.08333 -17.58333
## 5   22.75000  66.75000
## 6   44.58333  30.25000
Note `select random points takes into account the curvature of the earth and you will see a lower density of random points where the projection has enlarged a feature (e.g. Greenland)

Lest take a look at our random or background (bg) points

plot(my_clim_stack[[1]])
points(bg, pch='.') # plot on map


Now lets extract the climate values at these points and combine them with the bg data set of locations.

# extract enviro variables for the random points
bgEnv <- as.data.frame(extract(my_clim_stack, bg))
head(bgEnv)
##   mean_diurnal_range temperature_seasonality precip_driest_quarter
## 1          12.942896                721.4316                   356
## 2          14.958521                199.6431                     2
## 3           6.557916               1000.7164                     9
## 4          15.914250                340.9404                     1
## 5           8.738459                997.5553                    89
## 6          14.830105                929.9492                     0
bg <- cbind(bg, bgEnv)
head(bg)
##    longitude  latitude mean_diurnal_range temperature_seasonality
## 1  -83.91667  35.25000          12.942896                721.4316
## 2   21.25000 -12.41667          14.958521                199.6431
## 3 -149.75000 -82.25000           6.557916               1000.7164
## 4   20.08333 -17.58333          15.914250                340.9404
## 5   22.75000  66.75000           8.738459                997.5553
## 6   44.58333  30.25000          14.830105                929.9492
##   precip_driest_quarter
## 1                   356
## 2                     2
## 3                     9
## 4                     1
## 5                    89
## 6                     0
The Model
To start we will combine our site data with the background points and create a varaible pres_bg that indicates my point as a 1 and background as a 0.

pres_bg <- c(rep(1, nrow(my_sites)), rep(0, nrow(bg)))

train_data <- data.frame(
  pres_bg=pres_bg,
  rbind(my_sites, bg)
)

head(train_data)
##   pres_bg   longitude latitude mean_diurnal_range temperature_seasonality
## 1       1  70.3161401 43.81823          13.174375               1223.1614
## 2       1 101.5794610 50.67422          14.276125               1373.3907
## 3       1  45.9088107 25.99265          13.974229                868.3943
## 4       1  10.8061346 44.64095          10.608021                778.4135
## 5       1  13.8227708 58.90141           6.639521                654.0322
## 6       1  -0.9861706 51.49694           7.916042                474.6800
##   precip_driest_quarter
## 1                    12
## 2                     8
## 3                     1
## 4                   163
## 5                    98
## 6                   149
Now we are ready to train the model. We will use a generalized linear model (glm) with pres_bg as the dependent variable and our climate variables as independent variables. Since this is a binary outcome and quadratic model provides a good starting point.

my_model <- glm(
  pres_bg ~ mean_diurnal_range*temperature_seasonality*precip_driest_quarter + I(mean_diurnal_range^2) + I(temperature_seasonality^2) + I(precip_driest_quarter^2),
  data=train_data,
  family='binomial',
  weights=c(rep(1, nrow(my_sites)), rep(nrow(my_sites) / nrow(bg), nrow(bg)))
)
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
summary(my_model)
## 
## Call:
## glm(formula = pres_bg ~ mean_diurnal_range * temperature_seasonality * 
##     precip_driest_quarter + I(mean_diurnal_range^2) + I(temperature_seasonality^2) + 
##     I(precip_driest_quarter^2), family = "binomial", data = train_data, 
##     weights = c(rep(1, nrow(my_sites)), rep(nrow(my_sites)/nrow(bg), 
##         nrow(bg))))
## 
## Deviance Residuals: 
##      Min        1Q    Median        3Q       Max  
## -0.13318  -0.03052  -0.00782  -0.00078   0.96622  
## 
## Coefficients:
##                                                                    Estimate
## (Intercept)                                                       6.678e+00
## mean_diurnal_range                                               -9.630e-01
## temperature_seasonality                                          -1.484e-02
## precip_driest_quarter                                            -7.824e-02
## I(mean_diurnal_range^2)                                          -6.903e-02
## I(temperature_seasonality^2)                                     -1.639e-05
## I(precip_driest_quarter^2)                                       -1.383e-04
## mean_diurnal_range:temperature_seasonality                        3.799e-03
## mean_diurnal_range:precip_driest_quarter                          1.327e-02
## temperature_seasonality:precip_driest_quarter                     1.859e-04
## mean_diurnal_range:temperature_seasonality:precip_driest_quarter -1.894e-05
##                                                                  Std. Error
## (Intercept)                                                       2.159e+01
## mean_diurnal_range                                                2.758e+00
## temperature_seasonality                                           2.841e-02
## precip_driest_quarter                                             1.895e-01
## I(mean_diurnal_range^2)                                           1.196e-01
## I(temperature_seasonality^2)                                      1.146e-05
## I(precip_driest_quarter^2)                                        1.404e-04
## mean_diurnal_range:temperature_seasonality                        2.851e-03
## mean_diurnal_range:precip_driest_quarter                          1.692e-02
## temperature_seasonality:precip_driest_quarter                     2.777e-04
## mean_diurnal_range:temperature_seasonality:precip_driest_quarter  2.423e-05
##                                                                  z value
## (Intercept)                                                        0.309
## mean_diurnal_range                                                -0.349
## temperature_seasonality                                           -0.523
## precip_driest_quarter                                             -0.413
## I(mean_diurnal_range^2)                                           -0.577
## I(temperature_seasonality^2)                                      -1.429
## I(precip_driest_quarter^2)                                        -0.985
## mean_diurnal_range:temperature_seasonality                         1.333
## mean_diurnal_range:precip_driest_quarter                           0.785
## temperature_seasonality:precip_driest_quarter                      0.670
## mean_diurnal_range:temperature_seasonality:precip_driest_quarter  -0.782
##                                                                  Pr(>|z|)
## (Intercept)                                                         0.757
## mean_diurnal_range                                                  0.727
## temperature_seasonality                                             0.601
## precip_driest_quarter                                               0.680
## I(mean_diurnal_range^2)                                             0.564
## I(temperature_seasonality^2)                                        0.153
## I(precip_driest_quarter^2)                                          0.325
## mean_diurnal_range:temperature_seasonality                          0.183
## mean_diurnal_range:precip_driest_quarter                            0.433
## temperature_seasonality:precip_driest_quarter                       0.503
## mean_diurnal_range:temperature_seasonality:precip_driest_quarter    0.434
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 27.726  on 10009  degrees of freedom
## Residual deviance: 14.205  on  9999  degrees of freedom
## AIC: 27.154
## 
## Number of Fisher Scoring iterations: 8
We will ignore the warning and we are not going to put to much stock in the statistical significance of the variables in the model. Our glm does not account for spatial autocorrelation, so these are likely inflated. However, we can use the model to make useful predictions and characterize suitable habitat given our selected points.

my_world <- predict(
  my_clim_stack,
  my_model,
  type='response'
)

my_world
## class      : RasterLayer 
## dimensions : 1080, 2160, 2332800  (nrow, ncol, ncell)
## resolution : 0.1666667, 0.1666667  (x, y)
## extent     : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
## crs        : +proj=longlat +datum=WGS84 +no_defs 
## source     : memory
## names      : layer 
## values     : 2.220446e-16, 0.9999005  (min, max)
What does my world look like?
  
  plot(my_world)
plot(countries, add=TRUE)
points(my_sites_shape, col='red', pch=16)


The closer a point is to 1 the better match it is to the points I selected.

Let’s save this raster, we may need it later!
  
  writeRaster(my_world, 'My_Climate_Niche/my_world', format='GTiff', overwrite=TRUE, progress='text')
We have now defined our climate preference. We can further compare this to the global environment by setting a threshold to select the top 25% most preferred regions and comparing to the globe as a whole.

# threshold your "preferred" climate
my_world_thresh <- my_world >= quantile(my_world, 0.75)
plot(my_world_thresh)


# convert all values not equal to 1 to NA...
# using "calc" function to implement a custom function
my_world_thresh <- calc(my_world_thresh, fun=function(x) ifelse(x==0 | is.na(x), NA, 1))

# get random sites
my_best_sites <- randomPoints(my_world_thresh, 10000)
my_best_env <- as.data.frame(extract(my_clim_stack, my_best_sites))

# plot world's climate
smoothScatter(x=bgEnv$temperature_seasonality, y=bgEnv$precip_driest_quarter, col='lightblue')
points(my_best_env$temperature_seasonality, my_best_env$precip_driest_quarter, col='red', pch=16, cex=0.2)
points(my_sites$temperature_seasonality, my_sites$precip_driest_quarter, pch=16)
legend(
  'bottomright',
  inset=0.01,
  legend=c('world', 'my niche', 'my locations'),
  pch=16,
  col=c('lightblue', 'red', 'black'),
  pt.cex=c(1, 0.4, 1)
  
)


Looks like my climate niche is dry and temperate regions!
  
  This lesson was adapted with permission from Adam Smith: http://www.earthskysea.org/.