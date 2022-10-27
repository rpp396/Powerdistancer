#funcion para obtener canales
    using Gtk
    using COMTRADE
function obtenerCanales()

    pathCOMTRADE = open_dialog_native("Elegir COMTRADE .CFG", GtkNullContainer(), String["*.cfg"])
    #sacar el ".cfg" del path obtenido para pasarle al read_comtrade
    pathCOMTRADE = replace(pathCOMTRADE, ".CFG" =>"")
    pathCOMTRADE = replace(pathCOMTRADE, ".cfg" =>"")

    #ToDo
    #Filtrar canales
    return(read_comtrade(pathCOMTRADE))
    
end