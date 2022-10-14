using Test

#Agregar por ruta los archivos con las funciones a probar
include("../src/Powerdistancer.jl")
include("../src/RPP/generarSeno.jl")


@test Powerdistancer.f() == 1
