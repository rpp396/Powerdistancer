"""
    Canal

    Contiene la informacion sampleada representada como muestras a una determinada frecuncia de muestreo. 
    El valor está expresado en magnitudes físicas primarias.
"""
struct Canal
    valores::Vector #vector de reales (valores instantáneos)
    unidad::String #Volt, Amper, Hz, etc...
    frecuencia_muestreo::Any #en Hz cantidad de muestras por segundos
    #a multiplicador del canal
    #b ofset del canal
    #uu unidades del canal

    # The channel conversion factor is ax+b. The stored data value of x, in the data (.DAT) file, correspond to a sampled value of (ax+b) in units (uu) specified above. The rules of mathematical parsing are followed such that the data sample “x” is multiplied by the gain factor “a” and then the offset factor “b” is added. Manipulation of the data value by the 
    # conversion factor restores the original sampled values. See Annex E for an example.
    # al leerlos del archivo ya deberían quedar en primarios y con la cte correspondiente aplicada para llevarlo a magnitudes reales

end

abstract type Sistema_trifasico end

struct Sistema_trifasico_fasores <: Sistema_trifasico
    tiempo_de_muestra::Vector
    vb::Canal
    vc::Canal
    ia::Canal
    ib::Canal
    ic::Canal
    frecuencia::Number
    frecuencia_muestreo::Number #en Hz cantidad de muestras por segundos
    R1::Number
    X1::Number
    R0::Number
    X0::Number
end

struct Sistema_trifasico_RMS <: Sistema_trifasico
    tiempo_de_muestra::Vector
    vb::Canal
    vc::Canal
    ia::Canal
    ib::Canal
    ic::Canal
    frecuencia::Number
    frecuencia_muestreo::Number #en Hz cantidad de muestras por segundos
    R1::Number
    X1::Number
    R0::Number
    X0::Number
end

struct Sistema_trifasico_instanteneos <: Sistema_trifasico
    tiempo_de_muestra::Vector
    va::Canal
    vb::Canal
    vc::Canal
    ia::Canal
    ib::Canal
    ic::Canal
    frecuencia::Number
    frecuencia_muestreo::Number #en Hz cantidad de muestras por segundos
    R1::Number
    X1::Number
    R0::Number
    X0::Number
end
