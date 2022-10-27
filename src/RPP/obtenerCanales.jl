#funcion para obtener canales
    using Gtk
    using COMTRADE
function obtenerCanales()

    pathCOMTRADE = open_dialog_native("Elegir COMTRADE .CFG", GtkNullContainer(), String[])
   
    #sacar el ".cfg" o el ".DAT" del path obtenido para pasarle al read_comtrade
    pathCOMTRADE = replace(pathCOMTRADE, ".DAT" =>"")
    pathCOMTRADE = replace(path, ".dat" =>"")
    pathCOMTRADE = replace(path, ".CFG" =>"")
    pathCOMTRADE = replace(path, ".cfg" =>"")
    return(read_comtrade(pathCOMTRADE))
    
end