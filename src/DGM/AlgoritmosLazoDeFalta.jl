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

# algoritmo que analiza componentes de Park de tensiones y corrientes
Base.@kwdef struct TF_ALG1 <: TimeFaultEstimator
end

"""
	Estimación de instante de tiempo de comienzo de la falta
 
	Se implementan algoritmos para determinar el tiempo en que inicia la falta, en función 
	de la información de los canales analógicos.

 $(TYPEDSIGNATURES)
 
"""
estimate_time_fault(sis_i::Sistema_trifasico_instanteneos, sis_f::Sistema_trifasico_fasores, sis_rms::Sistema_trifasico_RMS) = estimate_time_fault(HFE(), sis_i, sis_f, sis_rms)



#	Algoritmo "Dummy"
# metodo para continuar con el desarrollo de otras partes del módulo
function estimate_time_fault(alg::TF_DUMMY, sis_i::Sistema_trifasico_instanteneos, sis_f::Sistema_trifasico_fasores, sis_rms::Sistema_trifasico_RMS)
	# devuelvo el tiempo de falta indicado en el tipo
	return alg.tf
end



#	Algoritmo tipo 1
# utiliza descomoposición de Park
function estimate_time_fault(alg::TF_ALG1, sis_i::Sistema_trifasico_instanteneos, sis_f::Sistema_trifasico_fasores, sis_rms::Sistema_trifasico_RMS)
	f=sis_i.frecuencia; fs=sis_i.frecuencia_muestreo
	# matriz para el calculo de transformada de Clarke
	TC=sqrt(2/3).*[sqrt(2)/2 sqrt(2)/2 sqrt(2)/2; 1 -1/2 -1/2; 0 sqrt(3)/2 -sqrt(3)/2]
	# matriz para trasnformada de Park, variante en kθ
	P(k)=[cos(2π*f*k/fs) sin(2π*f*k/fs); -sin(2π*f*k/fs) cos(2π*f*k/fs)]
	#vector de estado tensiones
	vk(k)=[sis_i.va.valores[k], sis_i.vb.valores[k], sis_i.vc.valores[k]]
	#vector de estado corrientes
	ik(k)=[sis_i.ia.valores[k], sis_i.ib.valores[k], sis_i.ic.valores[k]]
	# calculo la transformada de las señales del Sistema
	park(k)=(P(k)*(TC*vk(k))[2:3],P(k)*(TC*ik(k))[2:3])
	
	tf=0 # tiempo de falta detectado, 0 es NO detectado
	# cola de datos estadisticos de 3 ciclos
	cΔvd=CircularBuffer(ceil(Int64,3*fs/f)) 
	cΔvq=CircularBuffer(ceil(Int64,3*fs/f)) 
	cΔid=CircularBuffer(ceil(Int64,3*fs/f))
	cΔiq=CircularBuffer(ceil(Int64,3*fs/f))

	# primer dato
	(vkp_ant,ikp_ant)=park(1)
	
	# variacion relativa admitida
	Δvq=0.01 # 1%
	Δvd=0.01 # 1%
	Δiq=0.01 # 1%
	Δid=0.01 # 1%
	#recorro buscando variaciones bruscas
	etapa=0 # etapa de analisis de las variaciones tipicas en los primeros 3 ciclos
	criterios=0 # acumula la cantidad de criterios que detectaron "algo raro"
	criterios_ant=0 # utilizado para analizar el acumulado de criterios en muestras consecutivas
	for k in 1:length(sis_i.va.valores) 
		
		(vkp,ikp)=park(k)

		# variacion para el paso K
		Δvdk=abs(vkp_ant[1]-vkp[1])/abs(vkp[1]); push!(cΔvd,Δvdk)
		Δvqk=abs(vkp_ant[2]-vkp[2])/abs(vkp[2]); push!(cΔvq,Δvqk)
		Δidk=abs(ikp_ant[1]-ikp[1])/abs(ikp[1]); push!(cΔid,Δidk)
		Δiqk=abs(ikp_ant[2]-ikp[2])/abs(ikp[2]); push!(cΔiq,Δiqk)

		#println("Media : ",mean(cvkd),"  Std : ",std(cvkd))
		if etapa==0
			#etapa de estudio de los "movimientos" tipicos de los vectores en la proyección de Park
			Δvd = Δvdk > Δvd ? Δvd+(Δvdk-Δvd)/Δvdk : Δvd
			Δvq = Δvqk > Δvq ? Δvq+(Δvqk-Δvq)/Δvqk : Δvq
			Δid = Δidk > Δid ? Δid+(Δidk-Δid)/Δidk : Δid
			Δiq = Δiqk > Δiq ? Δiq+(Δiqk-Δiq)/Δiqk : Δiq
			#println("K: ",k, " Δvd-> $Δvd, Δvq-> $Δvq, Δid-> $Δid, Δiq-> $Δiq")
		else
			#println("K: ",k, " vkd-> ",vkp[1]," vkq-> ",vkp[2])

			(Δvdk > (mean(cΔvd)+3*std(cΔvd))) && (criterios += 1)
			(Δvqk>(mean(cΔvq)+3*std(cΔvq))) && (criterios += 1)
			(Δidk>(mean(cΔid)+3*std(cΔid))) && (criterios += 1)
			(Δiqk>(mean(cΔiq)+3*std(cΔiq))) && (criterios += 1)
			((Δvdk > Δvd) & ( Δvqk > Δvq)) && (criterios += 1)
			((Δidk > Δid) & (Δiqk > Δiq)) && (criterios += 1)

			# if Δvdk>(mean(cΔvd)+3*std(cΔvd))
			# 	println("Detectado por fuera de distribucion ΔVd ")
			# 	criterios += 1
			# end
			# if Δvqk>(mean(cΔvq)+3*std(cΔvq))
			# 	println("Detectado por fuera de distribucion ΔVq")
			# 	criterios += 1
			# end
			# if Δidk>(mean(cΔid)+3*std(cΔid))
			# 	println("Detectado por fuera de distribucion Δid")
			# 	criterios += 1
			# end
			# if Δiqk>(mean(cΔiq)+3*std(cΔiq))
			# 	println("Detectado por fuera de distribucion Δiq")
			# 	criterios += 1
			# end
			# if (Δvdk > Δvd) & ( Δvqk > Δvq) 	
			# 	println("Deteccion en tension, k= $k, variaciones ",Δvdk," y ",Δvqk)
			# 	criterios += 1
			# end
			# if (Δidk > Δid) & (Δiqk > Δiq) 	
			# 	println("Deteccion en corrientes, k= $k, variaciones ",Δidk," y ",Δiqk)
			# 	criterios += 1
			# end
			if (criterios >=3) | ((criterios_ant+criterios)>=3)
				# si los criteros en el paso k o su acumulado con paso k-1 son mas de 3 (de los 6 totales)
				#println("Falta detectada en k=$k")
				tf=k/fs
				break
			end
			
		end
		((k > ceil(3*fs/f)) & (etapa == 0)) && (etapa +=1)  # me mantengo en el analisis por 3 ciclos
		vkp_ant=vkp
		ikp_ant=ikp
		criterios_ant=criterios
		criterios=0
	end
	
	return tf
end

#dummy fasores
function sis_fasor()
	canales=Canal([],"",0)
	return Sistema_trifasico_fasores([2],canales,canales,canales,canales,canales,canales,0,0)
end

