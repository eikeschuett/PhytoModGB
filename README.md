# Effects of Climate-driven Variability in Atlantic Nutrient Supply on Primary Production in the German Bight

Climate change is predicted to alter the nutrient content of the North Sea. Using a simple numerical model approach implemented in R (version 4.0.3), primary production for spring algal blooms in the German Bight was calculated. The model is based on remote sensing data from 2018 and simulates nutrient concentrations under climate change scenarios (RCP8.5 mean, RCP8.5 maximum variability) as well as a baseline scenario, based on the current status, for the year 2100.

Contacts:  
Josephine Eismann (stu223324@mail.uni-kiel.de), Eike Schütt (stu200750@mail.uni-kiel.de), Ariane Tepaß (stu224042@mail.uni-kiel.de) 

## Model
The <a href=https://github.com/eikeschuett/PhytoModGB/blob/main/model_predict_2100_scenarios.R>script</a> models a potential primary production with consideration of the different climate change scenarios, under specification of different parameters. By changing the parameter Noffset (nutrient concentration in infinite deep waters) the three different predictions can be made.
Calculation, modeling, saving and plotting take place collectively in this script. By sourcing separate scripts, changes can be arranged clearly. These can be found under <a href=https://github.com/eikeschuett/PhytoModGB/tree/main/functions>functions</a>. 

![Plot_Übersicht](https://user-images.githubusercontent.com/66785690/115141777-67833280-a03e-11eb-972f-74eaae447b2a.JPG)

## Required R packages
- cmocean
- ncdf4
- plot3D
- dplyr
- rasterVis
- maptools
- rgdal
- sp
- ggplot2

## NetCDF and shapefiles
Note: The code runs with data already implemented into the repository (see <a href=https://github.com/eikeschuett/PhytoModGB/tree/main/data>data</a>)

The code works with netCDF files. Initial values for Chl and attenuation coefficient at a time t were taken from monthly averages of the 5th reprocessing of the Ocean-Colour Climate Change Initiative (OC-CCI, <a href=https://www.oceancolour.org/thredds/ncss/grid/CCI_ALL-v5.0-MONTHLY/dataset.html>Link to data source</a>).

A bathymetry NetCDF-file (ESA CCI data) for the southern North Sea was provided by Kai Wirtz (pers. common).

Shapefiles with basic geodata of our study area used when plotting model results are available at https://www.naturalearthdata.com

## Results
Outputs are saved in a <a href=https://github.com/eikeschuett/PhytoModGB/tree/main/Results>Results</a> folder. The folder contains 4 NetCDF-files with model results.

## Report
The derivation, application, results of the model and the interpretation can be read in detail: <a href=https://github.com/eikeschuett/PhytoModGB/tree/main/Report>Report</a>


