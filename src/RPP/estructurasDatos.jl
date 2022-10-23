struct Canal
    nombre::Any #nombre del canal: vr,vs,vt,ir,is,it
    valor_instantaneos::Any #vector de reales (valores instantáneos)
    valor_fasor::Any #vector de complejos (valores RMS)
    frecuencia_muestreo::Any #en Hz cantidad de muestras por segundos

end
