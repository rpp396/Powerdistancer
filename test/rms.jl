# pruebas de la funcion de calculo de RMS
include("generarSeno.jl")

@testset verbose = true "Calculo de RMS" begin

	casos = [1000, 1005, 1015, 1020, 1035, 1045, 1050]
	@testset "Frecuencia muestreo $i" for i in casos
		# señal sinusoidal sin continua
		s = generarSeno(duracion = 1, f = 50, fs = i, valorPico = 32700)
		c = Powerdistancer.Canal(s, "va", i)
		zero = Powerdistancer.Canal(zeros(length(s)), "nn", i)
		sis_i = Powerdistancer.Sistema_trifasico_instanteneos([0:1/i:1], c, zero, zero, zero, zero, zero, 50, i)
		sis_rms = rms_calculation(sis_i)
		@test sis_rms.va.valores[10] ≈ (32700 / sqrt(2)) rtol = 0.005

		#sumo continua
		sdc = 2000 .+ s
		c = Powerdistancer.Canal(sdc, "vb", i)
		zero = Powerdistancer.Canal(zeros(length(s)), "nn", i)
		sis_i = Powerdistancer.Sistema_trifasico_instanteneos([0:1/i:1], zero, c, zero, zero, zero, zero, 50, i)
		sis_rms = rms_calculation(sis_i)
		@test sis_rms.vb.valores[100] ≈ (2000 + 32700 / sqrt(2)) rtol = 0.005

		#otra fase
		c = Powerdistancer.Canal(s, "va", i)
		zero = Powerdistancer.Canal(zeros(length(s)), "nn", i)
		sis_i = Powerdistancer.Sistema_trifasico_instanteneos([0:1/i:1], zero, zero, zero, c, zero, zero, 50, i)
		sis_rms = rms_calculation(sis_i)
		@test sis_rms.ia.valores[10] ≈ (32700 / sqrt(2)) rtol = 0.005
	end
end
