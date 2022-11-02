using Test

#Agregar por ruta los archivos con las funciones a probar
include("../src/Powerdistancer.jl")
include("../src/RPP/generarSeno.jl")

@testset "Funciones Rodrigo" begin
    # include("arithmetic.jl")
    # include("utils.jl")
end

@testset "Funciones Daniel" begin
    # include("arithmetic.jl")
    # include("utils.jl")
end

@testset "Funciones generales" begin
    # include("arithmetic.jl")
    # include("utils.jl")
end

@test Powerdistancer.f() == 1
