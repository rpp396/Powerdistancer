"""
	Calculo de RMS

basado en [Mog2004MEANAR](@cite)

Debido a la forma de cálculo, a los valores del vector correspondientes al ultimo ciclo
no se les puede aplicar una ventana de ancho 1 ciclo por falta de datos, por lo tanto
se completa el vector con el ultimo valor calculado y así mantener el la longitud
$(TYPEDSIGNATURES)
"""
function rms_calculation(sis::Sistema_trifasico_instanteneos)::Sistema_trifasico_RMS
	fn = sis.frecuencia
	va = _RMS_signal(sis.va, fn)
	vb = _RMS_signal(sis.vb, fn)
	vc = _RMS_signal(sis.vc, fn)
	ia = _RMS_signal(sis.ia, fn)
	ib = _RMS_signal(sis.ib, fn)
	ic = _RMS_signal(sis.ic, fn)

	return Sistema_trifasico_RMS(sis.tiempo_de_muestra, va, vb, vc, ia, ib, ic, fn, sis.frecuencia_muestreo)
end

"""
	Interna

Realiza el cálculo del RMS a una señal, completa los datos correspondientes al 
último cilco con el último valor calculado.
$(TYPEDSIGNATURES)
"""
function _RMS_signal(x::Canal, fn::Number)::Canal
	# funcion interna para el calculo del RMS a una señal solamente
	# los valores de RMS del último ciclo no se pueden calcular, se completa con el ultimo valor conocido para mantener tamaño

	P = x.frecuencia_muestreo / fn
	N = trunc(Int64, P)
	δ = P - N
	salida = []
	x_rms = 0
	for i in (1:length(x.valores))
		if i <= length(x.valores) - N
			x_rms = sqrt((sum(x.valores[i:i+N-1] .^ 2) + δ * ((1 - δ) / 2 * x.valores[i+N-1] + (1 + δ) / 2 * x.valores[i+N])^2) / P)
		end
		push!(salida, x_rms)
	end
	return Canal(salida, x.unidad, x.frecuencia_muestreo)
end
