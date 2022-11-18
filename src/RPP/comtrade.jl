"""
Funcion para obtener canales, la salida debe ser en unidades primarias (por ejemplo amperios, voltios, etc...).
"""
function leer_canales(; path, conf = [1, 2, 3, 4, 5, 6], R1, X1, R0,X0 ,debug=true)
    comtrade = read_comtrade(path)
    #Nota: el comando read_comtrade ya toma en cuenta el factor de escalamiento "a" y de offset "b"

    #= 
    comandos utiles
    VSCodeServer.vscodedisplay(comtrade.cfg.A) #Para ver los DataFrames
    VSCodeServer.vscodedisplay(comtrade.cfg.D) #Para ver los DataFrames
    VSCodeServer.vscodedisplay(comtrade.dat) #Para ver los DataFramesst 
    =#
    frecuencia_muestreo = comtrade.cfg.samp[1]
    va = Canal(comtrade.dat[!, 1+2], comtrade.cfg.A[conf[1], 5],frecuencia_muestreo)
    vb = Canal(comtrade.dat[!, 2+2], comtrade.cfg.A[conf[2], 5],frecuencia_muestreo)
    vc = Canal(comtrade.dat[!, 3+2], comtrade.cfg.A[conf[3], 5],frecuencia_muestreo)
    ia = Canal(comtrade.dat[!, 4+2], comtrade.cfg.A[conf[4], 5],frecuencia_muestreo)
    ib = Canal(comtrade.dat[!, 5+2], comtrade.cfg.A[conf[5], 5],frecuencia_muestreo)
    ic = Canal(comtrade.dat[!, 6+2], comtrade.cfg.A[conf[6], 5],frecuencia_muestreo)
    tiempo_de_muestra = comtrade.dat[!, 2]
    #el tiempo en que se tomó cada muestra, empezando la muesta n = 1 en tiempo = 0 
    #la frecuencia se calcula usando el algoritmo que hizo DGM "alg_hfe.jl"


    if debug
        println("nrates: $(comtrade.cfg.nrates)")
        println("samp: $(comtrade.cfg.samp)")
        println("endsamp: $(comtrade.cfg.endsamp)")
        println("frecuencia de muestreo $(frecuencia_muestreo)")
        println("triggertime: $(comtrade.cfg.triggertime)")
        println("time: $(comtrade.cfg.time)")
        #println("triggertime-time: $(comtrade.cfg.triggertime - comtrade.cfg.time)")
    end
    #return Sistema_trifasico_instanteneos(tiempo_de_muestra,va, vb, vc, ia, ib, ic, frecuencia, frecuencia_muestreo,R1,X1,R0,X0)
    return [tiempo_de_muestra, va, vb, vc, ia, ib, ic, frecuencia_muestreo,R1,X1,R0,X0]
end
leer_canales(path=ruta,R1=10,X1=3,R0=20,X0=3)


