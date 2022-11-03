"""
    Canal

    Contiene la informacion sampleada representada como muestras a una determinada frecuncia de muestreo. 
    El valor está expresado en magnitudes físicas primarias.
"""
struct Canal
    nombre::String #nombre del canal: vr,vs,vt,ir,is,it
    valores_instantaneos::Any #vector de reales (valores instantáneos)
    #valores_fasor::Any #vector de complejos (valores RMS)
    #frecuencia_muestreo::Any #en Hz cantidad de muestras por segundos
    #a multiplicador del canal
    #b ofset del canal
    #uu unidades del canal

    # The channel conversion factor is ax+b. The stored data value of x, in the data (.DAT) file, correspond to a sampled value of (ax+b) in units (uu) specified above. The rules of mathematical parsing are followed such that the data sample “x” is multiplied by the gain factor “a” and then the offset factor “b” is added. Manipulation of the data value by the 
    # conversion factor restores the original sampled values. See Annex E for an example.
 # al leerlos del archivo ya deberían quedar en primarios y con la cte correspondiente aplicada para llevarlo a magnitudes reales

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
