"""
    generarSeno(; duracion=1000, f=50, fs=1000, valorPico=1)

generarSeno es una funcion que devuelve un vector con los valores de la función seno, 
con una amplitud igual al parámetro valorPico (por defecto 1), 
una frecuencia igual al parámetro f.
La longitud del vector esta dada por la multiplicación de los parametros duracion y fs (frecuencia de muestreo)
por ejemplo: duracion=2, fs=200, la longitud del vector será duracion * fs = 2 * 200 = 400 puntos.


"""
function generarSeno(; duracion=5, f=50, fs=10000, valorPico=1)
    # duración en segundos
    # f y fs en Hz.  
    # f frecuencia de la señal periódica
    # fs frecuencia de muestreo
    # valorPico es la máxima amplitud
    #

    v = []
    for i in 1:(duracion*fs)
        push!(v, valorPico * sin(f * 2 * pi * i / (fs)))
    end
    return v
end

export generarSeno