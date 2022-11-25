using Test, Powerdistancer

#include("lectura.jl")

CasoSimulado = Dict(
	#formato de los datos [frec, tiempo falta, loop de falta, %distancia]
	"osc01p" => [50, 0.310, TiposFalta(7), 0.05],
	"osc02p" => [50, 0.305, TiposFalta(14), 0.05],
	"osc03p" => [50, 0.305, TiposFalta(15), 0.05],
	"osc04p" => [50, 0.305, TiposFalta(9), 0.10],
	"osc05p" => [50, 0.3232, TiposFalta(12), 0.20],
	"osc06p" => [50, 0.3116, TiposFalta(5), 0.50])

@testset verbose = true "Funciones Rodrigo" begin
	include("leerCanalesTest.jl")
	# include("arithmetic.jl")
	# include("utils.jl")
end

@testset verbose = true "Funciones Daniel" begin
	include("frecuencia.jl")
	include("rms.jl")
	include("tipofalta.jl")
	# include("utils.jl")
end

@testset "Funciones generales" begin
	# include("arithmetic.jl")
	# include("utils.jl")
end

#@test Powerdistancer.f() == 1
