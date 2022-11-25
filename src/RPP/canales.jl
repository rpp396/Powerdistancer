"""
	Canal

	Contiene la informacion sampleada representada como muestras a una determinada frecuncia de muestreo. 
	El valor está expresado en magnitudes físicas primarias.
"""
struct Canal
    valores::Vector{Float64} #vector de reales (valores instantáneos)
    unidad::String #Volt, Amper, Hz, etc...
    frecuencia_muestreo::Float64 #en Hz cantidad de muestras por segundos

end
struct Canal_complejo
    valores::Vector{Complex} #vector de reales (valores instantáneos)
    unidad::String #Volt, Amper, Hz, etc...
    frecuencia_muestreo::Float64 #en Hz cantidad de muestras por segundos

end

abstract type Sistema_trifasico end

struct Sistema_trifasico_fasores <: Sistema_trifasico
    tiempo_de_muestra::Vector{Float64}
    va::Canal_complejo
    vb::Canal_complejo
    vc::Canal_complejo
    ia::Canal_complejo
    ib::Canal_complejo
    ic::Canal_complejo
    frecuencia::Float64
    frecuencia_muestreo::Float64 #en Hz cantidad de muestras por segundos
end

struct Sistema_trifasico_RMS <: Sistema_trifasico
    tiempo_de_muestra::Vector{Float64}
    va::Canal
    vb::Canal
    vc::Canal
    ia::Canal
    ib::Canal
    ic::Canal
    frecuencia::Float64
    frecuencia_muestreo::Float64 #en Hz cantidad de muestras por segundos
end

struct Sistema_trifasico_instanteneos <: Sistema_trifasico
    tiempo_de_muestra::Vector{Float64}
    va::Canal
    vb::Canal
    vc::Canal
    ia::Canal
    ib::Canal
    ic::Canal
    frecuencia::Float64
    frecuencia_muestreo::Float64 #en Hz cantidad de muestras por segundos
end

abstract type TimeFaultEstimator end # << tipo abstracto

Base.@kwdef struct TF_DUMMY <: TimeFaultEstimator
    # algoritmo dummy
    tf = 1 # tiempo de ocurrencia de la falta
end

# algoritmo que analiza componentes de Park de tensiones y corrientes
Base.@kwdef struct TF_ALG1 <: TimeFaultEstimator
end

abstract type LoopFaultEstimator end # << tipo abstracto

Base.@kwdef struct LF_ALG1 <: LoopFaultEstimator
    # algoritmo que utiliza la distancia euclidiana entre fasores consecutivos (en el tiempo) de las señales a monitorear
    level = 0.1 # valor de nivel para discrimiar si ocurrió un evento en una señal.
end

Base.@kwdef struct LF_ALG2 <: LoopFaultEstimator
    # algoritmo que define una suma acumulativa en el tiempo de las señales a monitorear
    v = 500 # corriente de vnetana para la detección
    h = 0.1 # porcentaje de valor pico de la señal para la detección, excepto para corrientes de tierra
end

abstract type CalcDistanceMetod end # << tipo abstracto

Base.@kwdef struct CD_TAKAGI <: CalcDistanceMetod
    # si implementa el método Takagi
end


#defino los tipos de falta posibles
@enum TiposFalta begin
    F_sin_falta = 0
    F_AN = 9
    F_BN = 5
    F_CN = 3
    F_AB = 12
    F_BC = 6
    F_AC = 10
    F_ABN = 13
    F_BCN = 7
    F_ACN = 11
    F_ABC = 14
    F_ABCN = 15
end

struct Linea_Transmision
    Long::Float64
    Z1::ComplexF64
    Z0::ComplexF64
end
