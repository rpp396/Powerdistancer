"""
    HFE(datos, n::Integer; fn=50, fs=1000)
 
    Hybrid Frequency Estimator
 basado en [8887270](@cite)

 ahora trabajo con vectores pero la idea es usar la estructura que definamos para manejar los datos de las señales

"""
function HFE(datos, n::Integer; fn=50, fs=1000)
    # datos un array con las muestras
    # n en que indice del vector tengo que calcular la frecuencia
    # fn frecuencia nominal del sistema
    # fs frecuencia de muestreo

    ciclo=datos[n:Integer(n+ceil(fs/fn))]
    display(plot(ciclo))
    cruces=NZC(ciclo)
    
    f_est= length(cruces)>=2 ? fs/((cruces[2]-cruces[1])*2) : fn
    f_i=f_est
    grado=1
    error=1 #valor inicial para comenzar bucle
    while  (error > 0.0005) & (grado < 9)
        ciclo=DMF(datos[n:Integer(n+ceil(fs/fn)+grado+1)],grado)
        display(plot!(ciclo))
        cruces=NZC(ciclo)
        # println(cruces)
        f_i= length(cruces)>=2 ? fs/((cruces[2]-cruces[1])*2) : f_i
        error=abs(f_est-f_i)
        println("grado ",grado,"   F_est ",f_est, "  f_i ",f_i)
        f_est=f_i
        grado+=1
    end
    return f_est
end

using BasicInterpolators: CubicInterpolator
function NZC(ciclo)
    # devulve vector con los cruces por cero, tiempo donde ocurre (usando interpolacion polinomial )
    
    # elimino componente de continua
    DC=(maximum(ciclo)+minimum(ciclo))/2
    ciclo = ciclo .- DC # elimino continua
    # busco untervalo de indices de cruce por cero
    ZC=[]
    for i=1:length(ciclo)-1
        if sign(sign(ciclo[i])*sign(ciclo[i+1]))==-1 
            #hay cambio de signo, por tanto cruce por cero
            i_a= i<3 ? 1 : i-2
            i_b= i_a+3
            p_interp = CubicInterpolator([i_a:i_b...],ciclo[i_a:i_b])
            ϵ=abs(DC)*1E-5+1E-6
            #println("tolerancia ",ϵ)
            pto_a=p_interp(i_a)
            pto_b=p_interp(i_b)
            while abs(abs(pto_b)-abs(pto_a))>ϵ
                #mientras que tengo error grande, itero
                i_interm=(i_a+i_b)/2
                pto_interm=p_interp(i_interm)
                if sign(pto_a)==sign(pto_interm)
                    i_a=i_interm
                    pto_a=pto_interm
                else
                    i_b=i_interm
                    pto_b=pto_interm
                end
                 # println("i_a ",i_a,"  i_b ",i_b, " error ", abs(abs(pto_b)-abs(pto_a)))
            end
            push!(ZC,(i_a+i_b)/2)
                
            end

    end
    return ZC
end

function DMF(datos,grado)
    # implementa filtro de promedio de "grado" puntos consecutivos.
    # devuelve nuevo vector con los datos filtrados.
    # tener en cuenta que se devuelve un vector con "grado"-1 elementos menos
    new_datos=[]
    for i=1:length(datos)-grado
        punto=sum(datos[i:(i+grado)]/(grado+1))
        push!(new_datos,punto)
    end
    return new_datos
end