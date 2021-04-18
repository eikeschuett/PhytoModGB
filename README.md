# Effects of Climate-driven Variability in Atlantic Nutrient Supply on Primary Production in the German Bight

Climate change is predicted to alter the nutrient content of the North Sea. Using a simple numerical model approach implemented in R (version 4.0.3), primary production for spring algal blooms in the German Bight was calculated. The model is based on remote sensing data from 2018 and simulates nutrient concentrations under different climate change scenarios (RCP4.5, RCP8.5) as well as a baseline scenario, based on the current status, for the year 2100.

## Model
The <a href=https://github.com/eikeschuett/PhytoModGB/blob/main/model_predict_2100_scenarios.R>script</a> models, under specification of different parameters, a potential primary production with consideration of the different climate change scenarios. By changing the parameter Noffset (nutrient concentration in infinite deep waters) the three different predictions can be made.
Calculation, modeling, saving and plotting take place collectively in this script. By sourcing separate scripts, changes can be arranged clearly. These can be found under <a href=https://github.com/eikeschuett/PhytoModGB/tree/main/functions>functions</a>. 

![Plot_Übersicht](https://user-images.githubusercontent.com/66785690/115141777-67833280-a03e-11eb-972f-74eaae447b2a.JPG)
