
# analizo las funciones de tiempo de falta y tipo de falta con sistemas creados manualmente

include("generarSeno.jl")

@testset "Deteccion de tiempo de ocurrencia de falta" begin
	f = 50
	fs = 1000
	# Tensiones sanas
	va_ok = generarSeno(duracion = 5 / f, f = f, fs = fs, fase = 0, valorPico = 87000)
	vb_ok = generarSeno(duracion = 5 / f, f = f, fs = fs, fase = -120, valorPico = 87000)
	vc_ok = generarSeno(duracion = 5 / f, f = f, fs = fs, fase = 120, valorPico = 87000)

	#Tension baja
	va_uv = generarSeno(duracion = 5 / f, f = f, fs = fs, fase = 0, valorPico = 87000 * 0.95)
	vb_uv = generarSeno(duracion = 5 / f, f = f, fs = fs, fase = -120, valorPico = 87000 * 0.95)
	vc_uv = generarSeno(duracion = 5 / f, f = f, fs = fs, fase = 120, valorPico = 87000 * 0.95)

	#tensiones con faltas
	va_tf = generarSeno(duracion = 1 / f, f = f, fs = fs, fase = 0, valorPico = 87000, valorPico_fin = 10000)
	va_f  = generarSeno(duracion = 4 / f, f = f, fs = fs, fase = 0, valorPico = 10000)

	#corrientes sanas
	ia_ok = generarSeno(duracion = 5 / f, f = f, fs = fs, fase = 10, valorPico = 300)
	ib_ok = generarSeno(duracion = 5 / f, f = f, fs = fs, fase = 10 - 120, valorPico = 300)
	ic_ok = generarSeno(duracion = 5 / f, f = f, fs = fs, fase = 10 + 120, valorPico = 300)

	#corrientes altas
	ia_toc = generarSeno(duracion = 1 / f, f = f, fs = fs, fase = 10, valorPico = 300, valorPico_fin = 500)
	ib_toc = generarSeno(duracion = 1 / f, f = f, fs = fs, fase = 10 - 120, valorPico = 300, valorPico_fin = 500)
	ic_toc = generarSeno(duracion = 1 / f, f = f, fs = fs, fase = 10 + 120, valorPico = 300, valorPico_fin = 500)
	ia_oc = generarSeno(duracion = 4 / f, f = f, fs = fs, fase = 10, valorPico = 500)
	ib_oc = generarSeno(duracion = 4 / f, f = f, fs = fs, fase = 10 - 120, valorPico = 500)
	ic_oc = generarSeno(duracion = 4 / f, f = f, fs = fs, fase = 10 + 120, valorPico = 500)


	#corriente con falta
	ia_tf = generarSeno(duracion = 1 / f, f = f, fs = fs, fase = 10, valorPico = 300, valorPico_fin = 1500)
	ia_f  = generarSeno(duracion = 4 / f, f = f, fs = fs, fase = 10, valorPico = 1500)

	# sistema con una subtension, no tiene que detectar nada
	cva = Canal(vcat(va_ok, va_uv, va_ok), "va", fs)
	cvb = Canal(vcat(vb_ok, vb_uv, vb_ok), "vb", fs)
	cvc = Canal(vcat(vc_ok, vc_uv, vc_ok), "vc", fs)
	cia = Canal(vcat(ia_ok, ia_ok, ia_ok), "ia", fs)
	cib = Canal(vcat(ib_ok, ib_ok, ib_ok), "ib", fs)
	cic = Canal(vcat(ic_ok, ic_ok, ic_ok), "ic", fs)
	sis_i = Sistema_trifasico_instanteneos([], cva, cvb, cvc, cia, cib, cic, f, fs)
	sis_f = Sistema_trifasico_fasores([], cva, cvb, cvc, cia, cib, cic, f, fs)
	sis_r = Sistema_trifasico_RMS([], cva, cvb, cvc, cia, cib, cic, f, fs)

	@test estimate_time_fault(TF_ALG1(), sis_i, sis_f, sis_r) == 0

	#sistema con aumento de corriente, no debe detectar nada
	cva = Canal(vcat(va_ok, va_ok, va_ok), "va", fs)
	cvb = Canal(vcat(vb_ok, vb_ok, vb_ok), "vb", fs)
	cvc = Canal(vcat(vc_ok, vc_ok, vc_ok), "vc", fs)
	cia = Canal(vcat(ia_ok, ia_toc, ia_oc, ia_ok), "ia", fs)
	cib = Canal(vcat(ib_ok, ib_toc, ib_oc, ib_ok), "ib", fs)
	cic = Canal(vcat(ic_ok, ic_toc, ic_oc, ic_ok), "ic", fs)
	sis_i = Sistema_trifasico_instanteneos([], cva, cvb, cvc, cia, cib, cic, f, fs)
	sis_f = Sistema_trifasico_fasores([], cva, cvb, cvc, cia, cib, cic, f, fs)
	sis_r = Sistema_trifasico_RMS([], cva, cvb, cvc, cia, cib, cic, f, fs)

	@test estimate_time_fault(TF_ALG1(), sis_i, sis_f, sis_r) == 0

	# sistema con falta
	cva = Canal(vcat(va_ok, va_tf, va_f, va_ok), "va", fs)
	cvb = Canal(vcat(vb_ok, vb_ok, vb_ok), "vb", fs)
	cvc = Canal(vcat(vc_ok, vc_ok, vc_ok), "vc", fs)
	cia = Canal(vcat(ia_ok, ia_tf, ia_f, ia_ok), "ia", fs)
	cib = Canal(vcat(ib_ok, ib_ok, ib_ok), "ib", fs)
	cic = Canal(vcat(ic_ok, ic_ok, ic_ok), "ic", fs)
	sis_i = Sistema_trifasico_instanteneos([], cva, cvb, cvc, cia, cib, cic, f, fs)
	sis_f = Sistema_trifasico_fasores([], cva, cvb, cvc, cia, cib, cic, f, fs)
	sis_r = Sistema_trifasico_RMS([], cva, cvb, cvc, cia, cib, cic, f, fs)

	@test estimate_time_fault(TF_ALG1(), sis_i, sis_f, sis_r) ≈ (length(ia_ok) / fs) rtol = 0.01
end
