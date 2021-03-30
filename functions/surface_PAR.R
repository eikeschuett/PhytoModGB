###################################################################
# surface_PAR estimates the photosynthetic active radiation (PAR) #
# for a time point, given as the day of the year (DOY)            #
# for a clear sky, very simplified for a given wave length        #
#                                                                 #
# for detailed modeling of PAR a starting point would be:         #
# Campbell & Aarup 1989: Photosynthatically available radiation   #
# at high latitudes. Limnol. Oceanogr. 34(8), 1490-1499           #
#                                                                 # 
# from where this simple, really rough model is derived           #
# see also: http://5e.plantphys.net/article.php?ch=t&id=131       #
###################################################################

surface_PAR=function(t,units='d',lambda=465){
# t:      time (required), zero equals new year  
# units:  units of the time (s,d (default))    
# lambda: wave length of used light in units of [nm]
#         Chl a absorbs at ~465 nm and 665 nm
#         so set the default value to 465 here
if(grepl(units,'s'))
   {# factor to convert days to seconds
    t_fac = 86400.
   }
else
   {# default value 'd'
    t_fac = 1.
   }

# 21st of June: day of summer solstice on northern hemisphere   
solstice = 172*t_fac

######## for units of: mole photons m^-2 d^-1
# fixed values for rough calculations of average light
# values (gu-)estimated from above mentioned publication 
# for approx. 50-60°N
A_PAR = 25 # Amplitude
B_PAR = 35 # offset of year mean PAR

mean_day_PAR = A_PAR * cos(t * 2.*pi/(365.*t_fac) - solstice * 2.*pi/(365.*t_fac)) + B_PAR
                       
########  conversion from: mole photons m^-2 d^-1 to W m^-2 as 
# a mean value for one day
#day      = 86400.    # day in seconds
#avogadro = 6.02e23   # Avogadro number (1mol = avogadro # molecules)
#hc       = 1.988e-16 # speed of light times Planck constant

#mean_day_PAR = mean_day_PAR / day * avogadro * hc / lambda

return(mean_day_PAR)
}

# for short check:
# source('surface_PAR.R')
# doy=1:365
# par=surface_PAR(doy)
# plot(doy,par)
