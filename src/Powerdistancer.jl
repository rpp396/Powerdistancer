module Powerdistancer

# Cargar dependencias.
include("init.jl")

# Estructuras de datos.
include(joinpath("RPP", "canales.jl"))

# Lectura de archivos COMTRADE.
include(joinpath("RPP", "comtrade.jl"))

# Algoritmos.
include(joinpath("DGM", "alg_hfe.jl"))

# Metodos y tipos exportados.
include("exports.jl")

end # module
