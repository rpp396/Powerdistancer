using Test, Powerdistancer

#include("lectura.jl")

@testset verbose = true "Funciones Rodrigo" begin
    include("leerCanalesTest.jl")
    # include("arithmetic.jl")
    # include("utils.jl")
end

@testset verbose = true "Funciones Daniel" begin
    include("frecuencia.jl")
    include("rms.jl")
    # include("utils.jl")
end

@testset "Funciones generales" begin
    # include("arithmetic.jl")
    # include("utils.jl")
end

#@test Powerdistancer.f() == 1
