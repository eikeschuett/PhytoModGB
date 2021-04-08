

nutrilim = function(params, h){
  N_H = (params$N_0 - params$offset) * params$H_0 / (params$H_0 + h) + params$offset
  fN_H = (params$K_N / params$KN_0) * N_H / (N_H + params$K_N)
  return(fN_H)
}
