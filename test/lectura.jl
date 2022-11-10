using Test, Powerdistancer

path = joinpath("data", "Comtrade", "Test")

#= Agregar el calculo de frecuencia de sampleo a la funcion o al paquete COMTRADE =#
prueba = leer_canales(path=path, debug=true)

# Debug:
using COMTRADE
data = read_comtrade(path)

#= Notas:
  walkdir() para iterar en carpeta 

    comtrade = read_comtrade(pathCOMTRADE)
    VSCodeServer.vscodedisplay(comtrade.dat) #Para ver los DataFrames

    DOL_000_TRA_TR1_F2
    test
    MVAlineaPANHR_10233
=#
