struct Canal
    id::Int #El lugar donde se ubica en el comtrade
    nombre::String #nombre del canal: vr,vs,vt,ir,is,it
    valores_instantaneos::Any #vector de reales (valores instantáneos)
    #valores_fasor::Any #vector de complejos (valores RMS)
    #frecuencia_muestreo::Any #en Hz cantidad de muestras por segundos
end
function obtenerCanales(pathCOMTRADE, [id])#pathDataFrame: la ruta del comtrade; id el un vector de
    #retorna los  6 u 9 canales de corrientes y tensiones
    #retorna la frecuenca de frecuencia_muestreo
    #la cantidad de puntos la sabemos de los largos de los vectores.   
end

abstract type Sistema_trifasico end

struct Sistema_trifasico_fasores <: Sistema_trifasico
    v1::Canal
    v2::Canal
    v3::Canal
    c1::Canal
    c2::Canal
    c3::Canal
    frecuencia_muestreo::Any #en Hz cantidad de muestras por segundos
end
struct Sistema_trifasico_RMS <: Sistema_trifasico
    v1::Canal
    v2::Canal
    v3::Canal
    c1::Canal
    c2::Canal
    c3::Canal
    frecuencia_muestreo::Any #en Hz cantidad de muestras por segundos
end
