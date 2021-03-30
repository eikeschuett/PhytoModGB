func_PPmean = function(I_0, atten, depth, params){
  
  # This function derives the mean primary production across the whole water 
  # column
  
  # calculate saturation depth of phytoplankton
  #Z1 = (log(I_0)-log(2*params$K_I))/atten
  Z1 = -(1/atten) * log((2*params$K_I)/I_0)
  # make sure that Z1 is always positive. In winter this may otherwise become
  # negative (if very little light and higher K_I). And a saturation depth in
  # the air makes no sense ;)
  Z1[Z1<0.1] = 0.1
  
  # calculate light at bottom I_H
  I_H = I_0 * exp(-atten*depth)
  # calculate light at saturation depth
  I_Z1 = I_0 * exp(-atten*Z1)
  
  # Calculate integral primary production of the whole water column
  PPmean = params$pmax / atten * (atten * Z1+1 - (I_H/I_Z1))
  
  # integral has to be divided by the depth of the water column to get the 
  # average primary production
  PPmean = PPmean/depth
  return(PPmean)
}