using Powerdistancer
ruta = joinpath("data", "Comtrade", "osc04p") #falta AN
sistema = leer_canales(path=ruta)
f = sistema.frecuencia
fs = sistema.frecuencia_muestreo
t0 = 0
tmax = ((length(sistema.ia.valores)) / fs) - 1 / fs
t = 0.02:1/fs:0.04
FFT = Powerdistancer.fft(señal[1:100])
F = Powerdistancer.fftshift(FFT)
freqs = Powerdistancer.fftshift(Powerdistancer.fftfreq(length(señal), fs))
#= for i in 1:100:1001
    println(FFT[i])
end =#

#calculo el ancho de ventana para un ciclo y lo paso a int para iterar
anchoVentana = trunc(Int, round(sistema.frecuencia_muestreo / sistema.frecuencia))
function generarSeno(; duracion=5, f=50, fs=10000, valorPico=1)
    # duración en segundos
    # f y fs en Hz.  
    # f frecuencia de la señal periódica
    # fs frecuencia de muestreo
    # valorPico es la máxima amplitud
    #

    v = Vector{Float64}()
    for i = 1:(duracion*fs)
        push!(v, valorPico * sin(f * 2 * pi * (i-1) / (fs)))
    end
    return v
end

seno = generarSeno(duracion=0.8, f=52, fs=5000, valorPico=1)
FFT = Powerdistancer.fft(seno[1:100])
Powerdistancer.fftfreq(1000, 10)
Powerdistancer.fftfreq(1000, 10)[anchoVentana]
F = Powerdistancer.fftshift(FFT)
anchoVentana=100
for i = 1:anchoVentana:3500
    #=    println(i)
       println(i+99)
     =#
    @show i
    @show i+anchoVentana-1
    println("tiempo: $(i/5000)")
    @show anchoVentana = 100
    @show FFT = Powerdistancer.fft(seno[i:(i+anchoVentana-1)])[2]/(anchoVentana/2)
    @show anchoVentana = 200
    @show FFT = Powerdistancer.fft(seno[i:(i+anchoVentana-1)])[3]/(anchoVentana/2)
end

anchoVentana = 10
fs = 5000.0
Powerdistancer.fftfreq(anchoVentana, fs)[trunc(Int,anchoVentana/2)-1:1:trunc(Int,anchoVentana/2)+1]