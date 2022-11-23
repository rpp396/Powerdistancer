"""
	Canal

	Contiene la informacion sampleada representada como muestras a una determinada frecuncia de muestreo. 
	El valor está expresado en magnitudes físicas primarias.
"""
struct Canal
    valores::Vector #vector de reales (valores instantáneos)
    unidad::String #Volt, Amper, Hz, etc...
    frecuencia_muestreo::Any #en Hz cantidad de muestras por segundos

end

abstract type Sistema_trifasico end

struct Sistema_trifasico_fasores <: Sistema_trifasico
    tiempo_de_muestra::Vector
    va::Canal
    vb::Canal
    vc::Canal
    ia::Canal
    ib::Canal
    ic::Canal
    frecuencia::Number
    frecuencia_muestreo::Number #en Hz cantidad de muestras por segundos
end

struct Sistema_trifasico_RMS <: Sistema_trifasico
    tiempo_de_muestra::Vector
    va::Canal
    vb::Canal
    vc::Canal
    ia::Canal
    ib::Canal
    ic::Canal
    frecuencia::Number
    frecuencia_muestreo::Number #en Hz cantidad de muestras por segundos
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
end
