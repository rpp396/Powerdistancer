"""
Funcion para obtener canales, la salida debe ser en unidades primarias (por ejemplo amperios, voltios, etc...)
La funcion toma como parametros:
path: ruta del archivo a comtrade a utilizar, por ejemlo joinpath("data","comtrade","osc08p"), no hay que incluir la extensión.
conf: vector que contiene en que orden estan los canales: [va, vb, vc, ia, ib, ic]
En el caso de contar con sumas de corrientes (interruptor y medio), se pasa el parametro i2=true y i2conf[posisción de i2a,posisción de i2b,posisción de i2c]
ejemplo_3_corrientes = Powerdistancer.leer_canales(path=ruta, conf=[1, 2, 3, 4, 5, 6])
ejemplo_3_corr aientes = Powerdistancer.leer_canales(path=ruta, conf=[1, 2, 3, 4, 5, 6],i2=true, i2conf=[4, 5, 6])
"""
function leer_canales(; path, conf=[1, 2, 3, 4, 5, 6], i2=false, i2conf=[7, 8, 9], debug=false)
    comtrade = read_comtrade(path)
    #Nota: el comando read_comtrade ya toma en cuenta el factor de escalamiento "a" y de offset "b"

    #= 
    comandos utiles
    VSCodeServer.vscodedisplay(comtrade.cfg.A) #Para ver los DataFrames
    VSCodeServer.vscodedisplay(comtrade.cfg.D) #Para ver los DataFrames
    VSCodeServer.vscodedisplay(comtrade.dat) #Para ver los DataFrames 
    =#
    frecuencia_muestreo = comtrade.cfg.samp[1]
    frecuencia = 50
    tiempo_de_muestra = comtrade.dat[!, 2]
    va = Canal(comtrade.dat[!, conf[1]+2], comtrade.cfg.A[conf[1], 5], frecuencia_muestreo)
    vb = Canal(comtrade.dat[!, conf[2]+2], comtrade.cfg.A[conf[2], 5], frecuencia_muestreo)
    vc = Canal(comtrade.dat[!, conf[3]+2], comtrade.cfg.A[conf[3], 5], frecuencia_muestreo)
    if i2
        ia = Canal(comtrade.dat[!, conf[4]+2] + comtrade.dat[!, i2conf[1]+2], comtrade.cfg.A[conf[4], 5], frecuencia_muestreo)
        ib = Canal(comtrade.dat[!, conf[5]+2] + comtrade.dat[!, i2conf[2]+2], comtrade.cfg.A[conf[5], 5], frecuencia_muestreo)
        ic = Canal(comtrade.dat[!, conf[6]+2] + comtrade.dat[!, i2conf[3]+2], comtrade.cfg.A[conf[6], 5], frecuencia_muestreo)
    else
        ia = Canal(comtrade.dat[!, conf[4]+2], comtrade.cfg.A[conf[4], 5], frecuencia_muestreo)
        ib = Canal(comtrade.dat[!, conf[5]+2], comtrade.cfg.A[conf[5], 5], frecuencia_muestreo)
        ic = Canal(comtrade.dat[!, conf[6]+2], comtrade.cfg.A[conf[6], 5], frecuencia_muestreo)
    end
    #usar algorirmo de frecuencia para calcular
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
    return Sistema_trifasico_instanteneos(tiempo_de_muestra, va, vb, vc, ia, ib, ic, frecuencia, frecuencia_muestreo)
end

#ruta = joinpath("data", "comtrade", "osc08p")
#a = Powerdistancer.leer_canales(path=ruta, conf=[1, 2, 3, 4, 5, 6])
#b = Powerdistancer.leer_canales(path=ruta, conf=[1, 2, 3, 4, 5, 6],i2=true, i2conf=[4, 5, 6], debug=true)

