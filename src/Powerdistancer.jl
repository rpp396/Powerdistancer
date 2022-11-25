module Powerdistancer

# Cargar dependencias.
include("init.jl")

# Estructuras de datos.
include(joinpath("RPP", "canales.jl"))

# Lectura de archivos COMTRADE.
include(joinpath("RPP", "comtrade.jl"))

# Aplicar FFT a los canales del sistema trifásico.
include(joinpath("RPP", "FFT.jl"))

# Plotear sistema Sistema_trifasico.
include(joinpath("RPP", "plotear.jl"))

# Calcular fasores de canal y sistema.
include(joinpath("RPP", "fasores.jl"))

# Algoritmos.
include(joinpath("DGM", "AlgoritmosFrecuencia.jl"))
include(joinpath("DGM", "AlgoritmosLazoDeFalta.jl"))
include(joinpath("DGM", "CalculoRMS.jl"))

# Metodos y tipos exportados.
include("exports.jl")

# Interfaces
include("interface.jl")

end # module
