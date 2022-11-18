"""
Funcion para obtener canales, la salida debe ser en unidades primarias (por ejemplo amperios, voltios, etc...).
"""
function leer_canales(; path, conf=[1, 2, 3, 4, 5, 6], debug=true)
    comtrade = read_comtrade(path)
    #Nota: el comando read_comtrade ya toma en cuenta el factor de escalamiento "a" y de offset "b"

    #= 
    comandos utiles
    VSCodeServer.vscodedisplay(comtrade.cfg.A) #Para ver los DataFrames
    VSCodeServer.vscodedisplay(comtrade.cfg.D) #Para ver los DataFrames
    VSCodeServer.vscodedisplay(comtrade.dat) #Para ver los DataFramesst 
    =#

    va = Canal(comtrade.cfg.A[1, 2], comtrade.dat[!, 1+2], comtrade.cfg.A[1, 5])
    vb = Canal(comtrade.cfg.A[2, 2], comtrade.dat[!, 2+2], comtrade.cfg.A[2, 5])
    vc = Canal(comtrade.cfg.A[3, 2], comtrade.dat[!, 3+2], comtrade.cfg.A[3, 5])
    ia = Canal(comtrade.cfg.A[4, 2], comtrade.dat[!, 4+2], comtrade.cfg.A[4, 5])
    ib = Canal(comtrade.cfg.A[5, 2], comtrade.dat[!, 5+2], comtrade.cfg.A[5, 5])
    ic = Canal(comtrade.cfg.A[6, 2], comtrade.dat[!, 6+2], comtrade.cfg.A[6, 5])
    frecuencia = Canal(comtrade.cfg.A[9, 2], comtrade.dat[!, 9+2], comtrade.cfg.A[9, 5])
    tiempo_de_muestra = comtrade.dat[!, 2] #el tiempo en que se tomó cada muestra, empezando la muesta n = 1 en tiempo = 0 
    #frecuencia_muestreo? es necesario calcularla aca? 
    frecuencia_muestreo = comtrade.cfg.endsamp[1] / (comtrade.cfg.triggertime[1] - comtrade.cfg.time[1])
    #tiempo_de_muestra y frecuencia como canal o vectores?

    if debug
        println("nrates: $(comtrade.cfg.nrates)")
        println("samp: $(comtrade.cfg.samp)")
        println("endsamp: $(comtrade.cfg.endsamp)")
        println("frecuencia de muestreo $(frecuencia_muestreo)")
        println("triggertime: $(comtrade.cfg.triggertime)")
        println("time: $(comtrade.cfg.time)")
        #println("triggertime-time: $(comtrade.cfg.triggertime - comtrade.cfg.time)")
    end
    return Sistema_trifasico_instanteneos(va, vb, vc, ia, ib, ic, frecuencia, frecuencia_muestreo)
    #return [va, vb, vc, ia, ib, ic, frecuencia_sistema, frecuencia_muestreo]
end
