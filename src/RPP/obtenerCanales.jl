#funcion para obtener canales
using Gtk
using COMTRADE
pathCOMTRADE = open_dialog_native("Elegir COMTRADE .CFG", GtkNullContainer(), String[])
#sacar el ".cfg" o el ".DAT" del path obtenido para pasarle al read_comtrade
z1 = read_comtrade()
