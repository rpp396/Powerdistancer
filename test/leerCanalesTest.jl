ruta = joinpath("data", "Comtrade", "osc01p")

prueba = leer_canales(path=ruta)

# pruebas de los algoritmos de cálculo de frecuencia
@testset verbose = true "Prueba de lectura de COMTRADE y pasaje a Sistema_trifasico_instanteneos" begin
    @test length(prueba.va) = 4000

end