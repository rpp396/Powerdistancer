# funciones de interce del módulo con el usuario

"""
	Calculo de distancia de la falta, para 1 terminal
 
	Dado el registro de la falta (COMTRADE), se realiza el cálculo de distancia a la falta
	utilizando un algoritmo por defecto o el indicado por el usuario.
	Se realiza el cálculo tomando información de un solo extremo.

 $(TYPEDSIGNATURES)
 
"""
function calc_distance_1end(archivo::String)
	#calcula distancia de falta segun comtrade dado

	sis_i = leer_canales(path = archivo)
	#sis_f= xxxx
	sis_rms = rms_calculation(sis_i)
	#tf = fault_time(sis_i, sis_f, sis_rms)
	#lf = fault_loop(sis_i, sis_f, sis_rms, tf)
	#distancia = distance_1end(sis_i, sis_f, sis_rms, tf)
end
