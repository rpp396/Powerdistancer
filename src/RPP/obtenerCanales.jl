"""
Funcion para obtener canales, la salida debe ser en unidades primarias (por ejemplo amperios, voltios, etc...).
"""
function obtenerCanales(pathCOMTRADE="src\\Comtrade\\NOR-T2_osc1")

    #pathCOMTRADE = open_dialog_native("Elegir COMTRADE .CFG", GtkNullContainer(), String["*.cfg"])
    #sacar el ".cfg" del path obtenido para pasarle al read_comtrade
    pathCOMTRADE = replace(pathCOMTRADE, ".CFG" => "")
    pathCOMTRADE = replace(pathCOMTRADE, ".cfg" => "")
    comtrade = read_comtrade(pathCOMTRADE)
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
    frecuencia_sistema = Canal(comtrade.cfg.A[9, 2], comtrade.dat[!, 9+2], comtrade.cfg.A[9, 5])
    tiempo_de_muestra = comtrade.dat[!, 2] #el tiempo en que se tomó cada muestra, empezando la muesta n = 1 en tiempo = 0 
    #frecuencia_muestreo? es necesario calcularla aca? 
    frecuencia_muestreo = (comtrade.cfg.triggertime[1] - comtrade.cfg.time[1]) / comtrade.cfg.endsamp[1]
    #tiempo_de_muestra y frecuencia como canal o vectores?
    println("nrates: $(comtrade.cfg.nrates)")
    println("samp: $(comtrade.cfg.samp)")
    println("endsamp: $(comtrade.cfg.endsamp)")
    println("frecuencia de muestreo $(frecuencia_muestreo)")
    return ()
    #return([va,vb,vc,ia,ib,ic,frecuencia_sistema,frecuencia_muestreo])

end
#walkdir() para iterar en carpeta 

#= 
comtrade = read_comtrade(pathCOMTRADE)
VSCodeServer.vscodedisplay(comtrade.dat) #Para ver los DataFrames
=#
#DOL_000_TRA_TR1_F2
#test
#MVAlineaPANHR_10233
#= Agregar el calculo de frecuencia de sampleo a la funcion o al paquete COMTRADE =#
prueba = obtenerCanales()
comtrades = read_comtrade("src\\Comtrade\\DOL_000_TRA_TR1_F2")
@show comtrades.cfg.samp
@show comtrades.cfg.endsamp
@show comtrades.cfg.nrates
@show comtrades.cfg.npts
@show comtrades.cfg.time
@show comtrades.cfg.lf
