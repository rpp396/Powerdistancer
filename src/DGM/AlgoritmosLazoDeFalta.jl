# 
# 
# tiempo de falta y loop de falta
# Realtime_fault_detection_and_classification_in_power_systems_using_microprocessors
# este trabaja con los fasores así que voy a esperar a que termine Rodrigo
# voy a implementar otro método mas simple para seguir avanzando

abstract type TimeFaultEstimator end # << tipo abstracto

Base.@kwdef struct TF_DUMMY <: TimeFaultEstimator
	# algoritmo dummy
	tf = 1 # tiempo de ocurrencia de la falta
end

"""
	Estimación de instante de tiempo de comienzo de la falta
 
	Se implementan algoritmos para determinar el tiempo en que inicia la falta, en función de la información de los canales analógicos.

 $(TYPEDSIGNATURES)
 
"""
estimate_time_fault(sis_i::Sistema_trifasico_instanteneos, sis_f::Sistema_trifasico_fasores, sis_rms::Sistema_trifasico_RMS) = estimate_time_fault(HFE(), sis_i, sis_f, sis_rms)



#	Algoritmo "Dummy"
# petodo para continuar con el desarrollo de otras partes del módulo
function estimate_time_fault(alg::TF_DUMMY, sis_i::Sistema_trifasico_instanteneos, sis_f::Sistema_trifasico_fasores, sis_rms::Sistema_trifasico_RMS)
	# devuelvo el tiempo de falta indicado en el tipo
	return alg.tf
end




