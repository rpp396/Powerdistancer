#funcion para obtener canales, la salida debe ser en unidades primarias (por ejemplo amperios, voltios, etc...)
    using Gtk
    using COMTRADE
    #using Unitful
    include("../estructurasDatos.jl")
function obtenerCanales()

    pathCOMTRADE = open_dialog_native("Elegir COMTRADE .CFG", GtkNullContainer(), String["*.cfg"])
    #sacar el ".cfg" del path obtenido para pasarle al read_comtrade
    pathCOMTRADE = replace(pathCOMTRADE, ".CFG" =>"")
    pathCOMTRADE = replace(pathCOMTRADE, ".cfg" =>"")
    comtrade = read_comtrade(pathCOMTRADE)
    #Nota: el comando read_comtrade ya toma en cuenta el factor de escalamiento "a" y de offset "b"
    
#= 
comandos utiles
VSCodeServer.vscodedisplay(comtrade.cfg.A) #Para ver los DataFrames
VSCodeServer.vscodedisplay(comtrade.cfg.D) #Para ver los DataFrames
VSCodeServer.vscodedisplay(comtrade.dat) #Para ver los DataFramesst 
=#

va = Canal(comtrade.cfg.A[1,2],comtrade.dat[!,1+2],comtrade.cfg.A[1,5])
vb = Canal(comtrade.cfg.A[2,2],comtrade.dat[!,2+2],comtrade.cfg.A[2,5])
vc = Canal(comtrade.cfg.A[3,2],comtrade.dat[!,3+2],comtrade.cfg.A[3,5])
ia = Canal(comtrade.cfg.A[4,2],comtrade.dat[!,4+2],comtrade.cfg.A[4,5])
ib = Canal(comtrade.cfg.A[5,2],comtrade.dat[!,5+2],comtrade.cfg.A[5,5])
ic = Canal(comtrade.cfg.A[6,2],comtrade.dat[!,6+2],comtrade.cfg.A[6,5])
frecuencia = Canal(comtrade.cfg.A[9,2],comtrade.dat[!,9+2],comtrade.cfg.A[9,5])
tiempo_de_muestra = comtrade.dat[!,2] #el tiempo en que se tomó cada muestra, empezando la muesta n = 1 en tiempo = 0 
#frecuencia_muestreo? es necesario calcularla aca? 
#tiempo_de_muestra y frecuencia como canal o vectores? 
return([va,vb,vc,ia,ib,ic,frecuencia,tiempo_de_muestra])
    
end 


#= 
pathCOMTRADE = open_dialog_native("Elegir COMTRADE .CFG", GtkNullContainer(), String["*.cfg"])
pathCOMTRADE = replace(pathCOMTRADE, ".CFG" =>"")
pathCOMTRADE = replace(pathCOMTRADE, ".cfg" =>"")
comtrade = read_comtrade(pathCOMTRADE)
VSCodeServer.vscodedisplay(comtrade.dat) #Para ver los DataFrames
=#