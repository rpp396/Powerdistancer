
# template de documentación para funciones exportadas

"""
	mysearch(array::MyArray{T}, val::T; verbose=true) where {T} -> Int

Searches the `array` for the `val`. For some reason we don't want to use Julia's
builtin search :)

# Arguments
- `array::MyArray{T}`: the array to search
- `val::T`: the value to search for

# Keywords
- `verbose::Bool=true`: print out progress details

# Returns
- `Int`: the index where `val` is located in the `array`

# Throws
- `NotFoundError`: I guess we could throw an error if `val` isn't found.
"""
# o

"""
	Manager(args...; kwargs...) -> Manager

A cluster manager which spawns workers.

# Arguments

- `min_workers::Integer`: The minimum number of workers to spawn or an exception is thrown
- `max_workers::Integer`: The requested number of workers to spawn

# Keywords

- `definition::AbstractString`: Name of the job definition to use. Defaults to the
	definition used within the current instance.
- `name::AbstractString`: ...
- `queue::AbstractString`: ...
"""
# o
"""
	Manager(max_workers; kwargs...)
	Manager(min_workers:max_workers; kwargs...)
	Manager(min_workers, max_workers; kwargs...)

A cluster manager which spawns workers.

# Arguments

- `min_workers::Int`: The minimum number of workers to spawn or an exception is thrown
- `max_workers::Int`: The requested number of workers to spawn

# Keywords

- `definition::AbstractString`: Name of the job definition to use. Defaults to the
	definition used within the current instance.
- `name::AbstractString`: ...
- `queue::AbstractString`: ...
"""


"""
	Hybrid Frequency Estimator
 basado en [8887270](@cite)

 ahora trabajo con vectores pero la idea es usar la estructura que definamos para manejar los datos de las señales
 $(TYPEDSIGNATURES)
 
"""
function hybrid_freq_est(datos, n::Integer; fn = 50, fs = 1000)
	# datos un array con las muestras
	# n en que indice del vector tengo que calcular la frecuencia
	# fn frecuencia nominal del sistema
	# fs frecuencia de muestreo

	ciclo = datos[n:Integer(n + ceil(fs / fn))]
	display(plot(ciclo))
	cruces = _NZC(ciclo)

	f_est = length(cruces) >= 2 ? fs / ((cruces[2] - cruces[1]) * 2) : fn
	f_i = f_est
	grado = 1
	error = 1 #valor inicial para comenzar bucle
	while (error > 0.0005) & (grado < 9)
		ciclo = DMF(datos[n:Integer(n + ceil(fs / fn) + grado + 1)], grado)
		display(plot!(ciclo))
		cruces = _NZC(ciclo)
		# println(cruces)
		f_i = length(cruces) >= 2 ? fs / ((cruces[2] - cruces[1]) * 2) : f_i
		error = abs(f_est - f_i)
		println("grado ", grado, "   F_est ", f_est, "  f_i ", f_i)
		f_est = f_i
		grado += 1
	end
	return f_est
end

using BasicInterpolators: CubicInterpolator

"""
	_NZC(ciclo)

	Dado un vector de muestras, devuelve un vector de los cruces por cero.
	El algoritmo hace una eliminación de la componente continua (valida para tamaño de muestra de pocos ciclos).
	Los índices devueltos como resultado son fraccionarios pues la función realiza una estimación polinomial del cruce por cero.

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

	Dado un vector con muestras de una señal, se devulve la señal filtrada con un filtro de promedio de grado "grado".
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
