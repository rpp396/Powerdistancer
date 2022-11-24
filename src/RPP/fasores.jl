using Powerdistancer
ruta = joinpath("data", "Comtrade", "osc04p") #falta AN
sistema = leer_canales(path=ruta)
señal = sistema.ia.valores
f = sistema.frecuencia
fs = sistema.frecuencia_muestreo
t0 = 0
tmax = ((length(señal)) / fs) - 1 / fs
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
        push!(v, valorPico * sin(f * 2 * pi * i / (fs)))
    end
    return v
end

seno = generarSeno(duracion=0.8, f=50, fs=5000, valorPico=1000)
FFT = Powerdistancer.fft(seno[101:200])
F = Powerdistancer.fftshift(FFT)
Powerdistancer.fftfreq(length(1:100), 5000)
FFT[2]
FFT = Powerdistancer.fft(señal[1:100])[2]
FFT = Powerdistancer.fft(señal[101:200])[2]
FFT = Powerdistancer.fft(señal[201:300])[2]
FFT = Powerdistancer.fft(señal[301:400])[2]
FFT = Powerdistancer.fft(señal[401:500])[2]
FFT = Powerdistancer.fft(señal[501:600])[2]
FFT = Powerdistancer.fft(señal[600:701])[2]
for i = 1:100:3500
    #=    println(i)
       println(i+99)
     =#
    @show i
    println("tiempo: $(i/5000)")
    @show FFT = Powerdistancer.fft(seno[i:(i+200)])[2]
end