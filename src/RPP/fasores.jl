function calcularFasoresSeñal(señal, frecuencia, frecuencia_muestreo, debug=false) #Calcula fasores de un Canal
    anchoVentana = trunc(Int, round(frecuencia_muestreo / frecuencia))

    listaFrecuencias = fftfreq(anchoVentana, frecuencia_muestreo)

    listaFrecuenciasFloat = collect(listaFrecuencias)#para que sea un vector de Float64

    for i in eachindex(listaFrecuenciasFloat) #para redondear a 50Hz o 60Hz y encontrar el indice de la frecuencia correspondiente
        listaFrecuenciasFloat[i] = round(listaFrecuenciasFloat[i])
    end

    indiceFundamental = findfirst(x -> x == 50.0 || x == 60.0, listaFrecuenciasFloat) #Encuentro el indice de la frecuencia fundamental

    fasores = Vector{Complex}()
    i = 1
    while (i + anchoVentana - 1) <= length(señal) #ventana movil de ancho anchoVentana
        #=         println("i inicial: $i")
                println("i final: $(i+anchoVentana-1)") =#
        push!(fasores, fft(señal[i:i+anchoVentana-1])[indiceFundamental] / (anchoVentana / 2))
        i += 1
    end
    return fasores .* 1im #roto los fasores 90 grados para que coincidan con los visores de COMTRADE
end

function calcularFasoresSistema(sistema::Sistema_trifasico_instanteneos)
    tiempo_de_muestra = sistema.tiempo_de_muestra
    frecuencia = sistema.frecuencia
    frecuencia_muestreo = sistema.frecuencia_muestreo
    va = Canal_complejo(calcularFasoresSeñal(sistema.va.valores, frecuencia, frecuencia_muestreo), sistema.va.unidad, sistema.va.frecuencia_muestreo)
    vb = Canal_complejo(calcularFasoresSeñal(sistema.vb.valores, frecuencia, frecuencia_muestreo), sistema.vb.unidad, sistema.vb.frecuencia_muestreo)
    vc = Canal_complejo(calcularFasoresSeñal(sistema.vc.valores, frecuencia, frecuencia_muestreo), sistema.vc.unidad, sistema.vc.frecuencia_muestreo)
    ia = Canal_complejo(calcularFasoresSeñal(sistema.ia.valores, frecuencia, frecuencia_muestreo), sistema.ia.unidad, sistema.ia.frecuencia_muestreo)
    ib = Canal_complejo(calcularFasoresSeñal(sistema.ib.valores, frecuencia, frecuencia_muestreo), sistema.ib.unidad, sistema.ib.frecuencia_muestreo)
    ic = Canal_complejo(calcularFasoresSeñal(sistema.ic.valores, frecuencia, frecuencia_muestreo), sistema.ic.unidad, sistema.ic.frecuencia_muestreo)

    return Sistema_trifasico_fasores(tiempo_de_muestra, va, vb, vc, ia, ib, ic, frecuencia, frecuencia_muestreo)
end
