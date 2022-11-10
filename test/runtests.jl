using Test, Powerdistancer

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
