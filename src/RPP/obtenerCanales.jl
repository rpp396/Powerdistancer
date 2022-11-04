#funcion para obtener canales, la salida debe ser en unidades primarias (por ejemplo amperios, voltios, etc...)
    using Gtk
    using COMTRADE
    include("../estructurasDatos.jl")
function obtenerCanales()

    pathCOMTRADE = open_dialog_native("Elegir COMTRADE .CFG", GtkNullContainer(), String["*.cfg"])
    #sacar el ".cfg" del path obtenido para pasarle al read_comtrade
    pathCOMTRADE = replace(pathCOMTRADE, ".CFG" =>"")
    pathCOMTRADE = replace(pathCOMTRADE, ".cfg" =>"")
    comtrade = read_comtrade(pathCOMTRADE)
    #comandos utiles
#= 
VSCodeServer.vscodedisplay(comtrade.cfg.A) #Para ver los DataFrames
VSCodeServer.vscodedisplay(comtrade.cfg.D) #Para ver los DataFrames
VSCodeServer.vscodedisplay(comtrade.dat) #Para ver los DataFramesst 
=#
    #ToDo
    #Filtrar canales
    #Multiplicar el canal por "a" y sumarle b? o ya lo hace el modulo?
    #Va = Canal()
    return()
    
end


#= pathCOMTRADE = open_dialog_native("Elegir COMTRADE .CFG", GtkNullContainer(), String["*.cfg"])
#sacar el ".cfg" del path obtenido para pasarle al read_comtrade
pathCOMTRADE = replace(pathCOMTRADE, ".CFG" =>"")
pathCOMTRADE = replace(pathCOMTRADE, ".cfg" =>"")
comtrade=read_comtrade(pathCOMTRADE)
comtrade.cfg.A[!,1:13] #nombre de los canalescomtrade.cfg.A[!,5] #unidades de los canales
comtrade.cfg.A[!,6] #escalamiento de canales "parametro a"
VSCodeServer.vscodedisplay(comtrade.cfg)
@show va = comtrade.dat[!,3]
VSCodeServer.vscodedisplay(comtrade.dat[!,1:12])
VSCodeServer.vscodedisplay(comtrade.dat[!,3])
typeof(va)

 =#