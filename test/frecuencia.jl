# pruebas de los algoritmos de cálculo de frecuencia
@testset verbose = true "Pruebas de algoritmos de determinacion de frecuencia" begin

	casos = [(50, 1000, 9), (63, 1000, 9), (77, 5000, 9), (45, 10000, 16)]
	@testset "HFE para Triangular con $i" for i in casos
		# onda triangular
		(f, fs, g) = i # frecuencia de la onda
		t = [0:1/fs:1] # tiempo, 1s
		s = 0.25 .+ map(x -> rem(x, 1 / f) * f < 0.5 ? rem(x, 1 / f) * f - 0.5 : 0.5 - rem(x, 1 / f) * f, t...)
		@test estimate_frequency(HFE(fn = f, gr = g), s, Int64(round(1 + rand() * length(t))), fs) ≈ f rtol = 0.005

		#pruebo corrmiento de frecuencia con respecto a la nominal
		fc = f + 0.02 * f
		sd = 0.25 .+ map(x -> rem(x, 1 / fc) * fc < 0.5 ? rem(x, 1 / fc) * fc - 0.5 : 0.5 - rem(x, 1 / fc) * fc, t...)
		@test estimate_frequency(HFE(fn = f, gr = g), sd, Int64(round(1 + rand() * length(t))), fs) ≈ fc rtol = 0.005

		fc = f - 0.04 * f
		sd = 0.25 .+ map(x -> rem(x, 1 / fc) * fc < 0.5 ? rem(x, 1 / fc) * fc - 0.5 : 0.5 - rem(x, 1 / fc) * fc, t...)
		@test estimate_frequency(HFE(fn = f, gr = g), sd, Int64(round(1 + rand() * length(t))), fs) ≈ fc rtol = 0.005

		# agrego componente de continua
		sc = s .+ 20
		@test estimate_frequency(HFE(fn = f, gr = g), sc, Int64(round(1 + rand() * length(t))), fs) ≈ f rtol = 0.005
		# agrego ruido
		sr = s + abs(maximum(s) - minimum(s)) / 30 * rand(length(s))
		@test estimate_frequency(HFE(fn = f, gr = g), sr, Int64(round(1 + rand() * length(t))), fs) ≈ f rtol = 0.05

	end

	casos = [(50, 1000, 9), (63, 1000, 9), (77, 5000, 9), (45, 10000, 16)]
	@testset "HFE para Sinusoidal con $i" for i in casos
		# onda triangular
		(f, fs, g) = i # frecuencia de la onda
		t = [0:1/fs:1] # tiempo, 1s

		s = map(x -> sin(2π * x * f), t...)
		@test estimate_frequency(HFE(fn = f, gr = g), s, Int64(round(1 + rand() * length(t))), fs) ≈ f rtol = 0.005

		#pruebo corrmiento de frecuencia con respecto a la nominal
		fc = f + 0.02 * f
		sd = map(x -> sin(2π * x * fc), t...)
		@test estimate_frequency(HFE(fn = f, gr = g), sd, Int64(round(1 + rand() * length(t))), fs) ≈ fc rtol = 0.005

		fc = f - 0.04 * f
		sd = map(x -> sin(2π * x * fc), t...)
		@test estimate_frequency(HFE(fn = f, gr = g), sd, Int64(round(1 + rand() * length(t))), fs) ≈ fc rtol = 0.005


		# agrego componente de continua
		sc = s .+ 20
		@test estimate_frequency(HFE(fn = f, gr = g), sc, Int64(round(1 + rand() * length(t))), fs) ≈ f rtol = 0.005
		# agrego ruido
		sr = s + abs(maximum(s) - minimum(s)) / 30 * rand(length(s))
		@test estimate_frequency(HFE(fn = f, gr = g), sr, Int64(round(1 + rand() * length(t))), fs) ≈ f rtol = 0.05
		# agrego armónicos
		f = f * 2
		s1 = 0.15 .* map(x -> sin(2π * x * f), t...)
		f = f * 3 / 2
		s2 = 0.13 .* map(x -> sin(2π * x * f), t...)
		sh = s .+ s1 .+ s2
		@test estimate_frequency(HFE(fn = f / 3, gr = g), sh, Int64(round(1 + rand() * length(t))), fs) ≈ (f / 3) rtol = 0.05

	end
end
