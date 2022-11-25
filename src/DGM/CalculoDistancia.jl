
#implemento un metodo de cálculo de distancia.


"""
	Calculo de distancia de ocurrencia de falta
 
	Se implementan varios algoritmos clásicos para la determinación de la distancia.

 $(TYPEDSIGNATURES)
 
"""
distance_1end(sis_i::Sistema_trifasico_instanteneos, sis_f::Sistema_trifasico_fasores, sis_rms::Sistema_trifasico_RMS, tf::Number, lf::TiposFalta) = distance_1end(CD_TAKAGI(), sis_i, sis_f, sis_rms, tf, lf)

"""
	Calculo de distancia de ocurrencia de falta. Método de Takagi
 
 $(TYPEDSIGNATURES)
 
"""
function distance_1end(alg::CD_TAKAGI, sis_i::Sistema_trifasico_instanteneos, sis_f::Sistema_trifasico_fasores, sis_rms::Sistema_trifasico_RMS, tf::Number, lf::TiposFalta)

    # valido poara faltas FT

    

end
