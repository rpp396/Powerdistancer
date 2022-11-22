
abstract type FrequencyEstimator end # << tipo abstracto

Base.@kwdef struct FE_HFE <: FrequencyEstimator
	fn = 50 # frecuencia nominal del sistema
	gr = 9 # grado máximo del fitlro de promedio O cantidad de puntos a considerar para el promedio
end


"""
	Estimación de frecuencia
 
	Se implementan algoritmos para determinar la frecuencia de la onda.

 $(TYPEDSIGNATURES)
 
"""
estimate_frequency(datos::Vector, start::Integer, fs::Integer) = estimate_frequency(FE_HFE(), datos, start, fs)

"""
	Algoritmo "Hybrid Frequency Estimator"
 basado en [8887270](@cite)

$(TYPEDSIGNATURES)
 
"""
function estimate_frequency(alg::FE_HFE, datos::Vector, start::Integer, fs::Integer)
	# datos un array con las muestras
	# start en que indice del vector tengo que calcular la frecuencia
	# fs frecuencia de muestreo
	fn = alg.fn
	n = start # por cuestiones de implementación
	ciclo = datos[n:Integer(n + ceil(1.5 * fs / fn))] #agrego medio cilco mas
	cruces = _NZC(ciclo)

	f_est = length(cruces) >= 2 ? fs / ((cruces[2] - cruces[1]) * 2) : fn
	f_i = f_est
	grado = 1
	error = 1 #valor inicial para comenzar bucle
	while (error > 0.0005) & (grado < alg.gr)
		ciclo = _DMF(datos[n:Integer(n + ceil(1.5 * fs / fn) + grado + 1)], grado)
		cruces = _NZC(ciclo)
		# println(cruces)
		f_i = length(cruces) >= 2 ? fs / ((cruces[2] - cruces[1]) * 2) : f_i
		error = abs(f_est - f_i)
		#println("grado ", grado, "   F_est ", f_est, "  f_i ", f_i)
		f_est = f_i
		grado += 1
	end
	if abs(fn - f_est) / fn > 0.1
		# no admito variaciones de mas de 10% en la frecuencia nominal
		# si eso sucede, devuelvo la nominal
		f_est = fn
	end
	return f_est
end

# using BasicInterpolators: CubicInterpolator

"""
	_NZC(ciclo)

	Dado un vector de muestras, devuelve un vector de los cruces por cero.
	El algoritmo hace una eliminación de la componente continua (valida para 
	tamaño de muestra de pocos ciclos).
	Los índices devueltos como resultado son fraccionarios pues la función realiza una 
	estimación polinomial del cruce por cero.

"""
function _NZC(ciclo)
	# devulve vector con los cruces por cero, tiempo donde ocurre (usando interpolacion polinomial )

	# elimino componente de continua
	DC = (maximum(ciclo) + minimum(ciclo)) / 2
	ciclo = ciclo .- DC # elimino continua
	# busco untervalo de indices de cruce por cero
	ZC = []
	for i in 1:length(ciclo)-1
		if sign(sign(ciclo[i]) * sign(ciclo[i+1])) == -1
			#hay cambio de signo, por tanto cruce por cero
			i_a = i < 3 ? 1 : i - 2
			i_b = i_a + 3
			p_interp = CubicInterpolator([i_a:i_b...], ciclo[i_a:i_b])
			ϵ = abs(DC) * 1E-5 + 1E-6
			#println("tolerancia ",ϵ)
			pto_a = p_interp(i_a)
			pto_b = p_interp(i_b)
			while abs(abs(pto_b) - abs(pto_a)) > ϵ
				#mientras que tengo error grande, itero
				i_interm = (i_a + i_b) / 2
				pto_interm = p_interp(i_interm)
				if sign(pto_a) == sign(pto_interm)
					i_a = i_interm
					pto_a = pto_interm
				else
					i_b = i_interm
					pto_b = pto_interm
				end
				# println("i_a ",i_a,"  i_b ",i_b, " error ", abs(abs(pto_b)-abs(pto_a)))
			end
			push!(ZC, (i_a + i_b) / 2)

		end

	end
	return ZC
end

"""
	_DMF(datos,grado)

	Dado un vector con muestras de una señal, se devuelve la señal filtrada 
	con un filtro de promedio de grado "grado".
	El vector de salida tiene largo menor al vector de entrada, en (grado-1) elementos.
"""
function _DMF(datos, grado)
	# implementa filtro de promedio de "grado" puntos consecutivos.
	# devuelve nuevo vector con los datos filtrados.
	# tener en cuenta que se devuelve un vector con "grado"-1 elementos menos
	new_datos = []
	for i in 1:length(datos)-grado
		punto = sum(datos[i:(i+grado)] / (grado + 1))
		push!(new_datos, punto)
	end
	return new_datos
end
