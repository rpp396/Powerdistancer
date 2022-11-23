

# pruebas de los algoritmos de cálculo de frecuencia
@testset verbose = true "Prueba de lectura de COMTRADE y pasaje a Sistema_trifasico_instanteneos" begin
    ruta = joinpath("data", "Comtrade", "osc01p")
    prueba = leer_canales(path=ruta)
    @test length(prueba.va.valores) == 4000

end