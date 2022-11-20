"""
Funcion para obtener canales, la salida debe ser en unidades primarias (por ejemplo amperios, voltios, etc...)
La funcion toma como parametros:
path: ruta del archivo a comtrade a utilizar, por ejemlo joinpath("data","comtrade","osc08p"), no hay que incluir la extensión.
conf: vector que contiene en que orden estan los canales: [va, vb, vc, ia, ib, ic, ia2, ib2, ic2], los canales terminados en 2 son para el caso que se sumen corrientes (interruptor y medio)
R1: parte real de la impedancia de secuencia directa de la línea en valores primarios
X1: parte imaginaria de la impedancia de secuencia directa de la línea en valores primarios
R0: parte real de la impedancia de secuencia cero de la línea en valores primarios
X0: parte imaginaria de la impedancia de secuencia cero de la línea en valores primarios
"""
function leer_canales(; path, conf=[1, 2, 3, 4, 5, 6], R1, X1, R0, X0, i2=false, i2conf=[7, 8, 9], debug=false)
    comtrade = read_comtrade(path)
    #Nota: el comando read_comtrade ya toma en cuenta el factor de escalamiento "a" y de offset "b"

    #= 
    comandos utiles
    VSCodeServer.vscodedisplay(comtrade.cfg.A) #Para ver los DataFrames
    VSCodeServer.vscodedisplay(comtrade.cfg.D) #Para ver los DataFrames
    VSCodeServer.vscodedisplay(comtrade.dat) #Para ver los DataFramesst 
    =#
    frecuencia_muestreo = comtrade.cfg.samp[1]
    va = Canal(comtrade.dat[!, conf[1]+2], comtrade.cfg.A[conf[1], 5], frecuencia_muestreo)
    vb = Canal(comtrade.dat[!, conf[2]+2], comtrade.cfg.A[conf[2], 5], frecuencia_muestreo)
    vc = Canal(comtrade.dat[!, conf[3]+2], comtrade.cfg.A[conf[3], 5], frecuencia_muestreo)
    ia = Canal(comtrade.dat[!, conf[4]+2], comtrade.cfg.A[conf[4], 5], frecuencia_muestreo)
    ib = Canal(comtrade.dat[!, conf[5]+2], comtrade.cfg.A[conf[5], 5], frecuencia_muestreo)
    ic = Canal(comtrade.dat[!, conf[6]+2], comtrade.cfg.A[conf[6], 5], frecuencia_muestreo)
    tiempo_de_muestra = comtrade.dat[!, 2]

    if i2
        i2a = Canal(comtrade.dat[!, i2conf[1]+2], comtrade.cfg.A[i2conf[1], 5], frecuencia_muestreo)
        i2b = Canal(comtrade.dat[!, i2conf[2]+2], comtrade.cfg.A[i2conf[2], 5], frecuencia_muestreo)
        i2c = Canal(comtrade.dat[!, i2conf[3]+2], comtrade.cfg.A[i2conf[3], 5], frecuencia_muestreo)
    end

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
    if i2
        if debug
            println("6 corrientes")
        end
        return [frecuencia_muestreo, va, vb, vc, ia, ib, ic, i2a, i2b, i2c]
    end
    return [frecuencia_muestreo, va, vb, vc, ia, ib, ic]
    #return Sistema_trifasico_instanteneos(tiempo_de_muestra,va, vb, vc, ia, ib, ic, frecuencia, frecuencia_muestreo,R1,X1,R0,X0)
    #return [tiempo_de_muestra, va, vb, vc, ia, ib, ic, frecuencia_muestreo,R1,X1,R0,X0]
end

ruta = joinpath("data", "comtrade", "osc08p")
a = Powerdistancer.leer_canales(path=ruta, conf=[1, 2, 3, 4, 5, 6], R1=10, X1=3, R0=20, X0=3)
b = Powerdistancer.leer_canales(path=ruta, conf=[1, 2, 3, 4, 5, 6], R1=10, X1=3, R0=20, X0=3, i2=true, i2conf=[4, 5, 6], debug=true)
z1 = read_comtrade(ruta)
datos = z1.dat[!, 3]
