

"""
	Estimación de instante de tiempo de comienzo de la falta
 
	Se implementan algoritmos para determinar el tiempo en que inicia la falta, en función 
	de la información de los canales analógicos.

 $(TYPEDSIGNATURES)
 
"""
estimate_time_fault(sis_i::Sistema_trifasico_instanteneos, sis_f::Sistema_trifasico_fasores, sis_rms::Sistema_trifasico_RMS) = estimate_time_fault(TF_ALG1(), sis_i, sis_f, sis_rms)

#	Algoritmo "Dummy"
# metodo para continuar con el desarrollo de otras partes del módulo
function estimate_time_fault(alg::TF_DUMMY, sis_i::Sistema_trifasico_instanteneos, sis_f::Sistema_trifasico_fasores, sis_rms::Sistema_trifasico_RMS)
	# devuelvo el tiempo de falta indicado en el tipo
	return alg.tf
end

"""
	Estimación de instante de tiempo de comienzo de la falta - Algoritmo 1
 
	Este algoritmo utiliza la transformación de Park del sitema de tensiones y del sitema 
	de corrientes, analiza los cambios y evalua que sea el comienzo de una falta.

 $(TYPEDSIGNATURES)
 
"""
function estimate_time_fault(alg::TF_ALG1, sis_i::Sistema_trifasico_instanteneos, sis_f::Sistema_trifasico_fasores, sis_rms::Sistema_trifasico_RMS)
	#	Algoritmo tipo 1
	# utiliza descomoposición de Park
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

"""
	Estimación de loop de falta o fases que intervienen en el defecto
 
	Se implementan algoritmos para determinar  que fases intervienen en el defecto
	tomando como referencia el tiempo de falta calculado.

 $(TYPEDSIGNATURES)
 
"""
fault_loop(sis_i::Sistema_trifasico_instanteneos, sis_f::Sistema_trifasico_fasores, sis_rms::Sistema_trifasico_RMS, tf::Number) = fault_loop(LF_ALG2(), sis_i, sis_f, sis_rms,tf)

"""
	Estimación de loop de falta - Algoritmo 2
 
	Este algoritmo define una suma acumulada de las señales en el tiempo para determinar 
	que ocurrió un evento, luego se clasifica en función de las señales intervinientes. 
Se basa en el trabajo [4391032](@cite)

 $(TYPEDSIGNATURES)
 
"""
function fault_loop(alg::LF_ALG2, sis_i::Sistema_trifasico_instanteneos, sis_f::Sistema_trifasico_fasores, sis_rms::Sistema_trifasico_RMS, tf::Number) 

	# dado un tiempo de falta, voy a analizar 2,5 ciclos hacia atras para tomar valores prefalta
	ktf=ceil(Int64,tf*sis_i.frecuencia_muestreo) # determino posición en vector de datos
	N=ceil(Int64, sis_i.frecuencia_muestreo/sis_i.frecuencia) # determino ancho en muestras de un ciclo
	h=alg.h
	v=alg.v
	
	# comienzo a analizar el loop de falta 1/2 cilcos desde el tiempo de falta detectado
	(iagk_1,iagk_2)=(0,0);(ibgk_1,ibgk_2)=(0,0);(icgk_1,icgk_2)=(0,0);(ingk_1,ingk_2)=(0,0);

	falta=0b0000  # binario donde voy a ir marcando la corriente detectada, orden de los bits (ia,ib,ic,in)
	k=ceil(Int64,ktf-0.5*N) # arrnaco medio ciclo antes del tiempo de falta dado
	kexit=length(sis_i.ia.valores)
	resumir=false  # indica que va a salir en un ciclo
	while (k<kexit)
		
		#calculo señales de CUSUM
		iagk_1 = maximum([iagk_1+sis_i.ia.valores[k]-v,0])
		iagk_2 = maximum([iagk_2-sis_i.ia.valores[k]-v,0])
		ibgk_1 = maximum([ibgk_1+sis_i.ib.valores[k]-v,0])
		ibgk_2 = maximum([ibgk_2-sis_i.ib.valores[k]-v,0])
		icgk_1 = maximum([icgk_1+sis_i.ic.valores[k]-v,0])
		icgk_2 = maximum([icgk_2-sis_i.ic.valores[k]-v,0])
		in=sis_i.ia.valores[k]+sis_i.ib.valores[k]+sis_i.ic.valores[k]
		ingk_1 = maximum([ingk_1+in-v*0.5,0])
		ingk_2 = maximum([ingk_2-in-v*0.5,0])
		
		((iagk_1 > h*v) | (iagk_2 > h*v)) &&  (falta |= 0b1000)
		((ibgk_1 > h*v) | (ibgk_2 > h*v)) &&  (falta |= 0b0100)
		((icgk_1 > h*v) | (icgk_2 > h*v)) &&  (falta |= 0b0010)
		((ingk_1 > h*v*0.5) | (ingk_2 > h*v*0.5)) &&  (falta |= 0b0001)
		#println("k : $k, kexit = $kexit,  falta : ",bitstring(Int8(falta)))
		#println("ia-> g1= $iagk_1  y g2= $iagk_2")
		((falta != 0) & !resumir) && (kexit=k+N+1; resumir=true)   # si ya detecté una corriente, espero 1 ciclo mas y salgo
		k+=1
	end
	@assert !((falta == 0b0001) | (falta==0b0010) | (falta==0b0100) | (falta==0b1000) ) "Error, no se pudo determinal el lazo de falta"
	return TiposFalta(falta)
end


#dummy fasores
function sis_fasor()
	canales=Canal([],"",0)
	return Sistema_trifasico_fasores([2],canales,canales,canales,canales,canales,canales,0,0)
end

