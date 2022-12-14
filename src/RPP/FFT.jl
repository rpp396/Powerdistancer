
function transformadaFourier(sistema)
    señal = sistema.ia.valores
    f = sistema.frecuencia
    fs = sistema.frecuencia_muestreo
    t0 = 0
    tmax = ((length(señal)) / fs) - 1 / fs
    t = t0:1/fs:tmax
    fft(señal)
    F = fftshift(fft(señal))
    freqs = fftshift(fftfreq(length(t), fs))
    time_domain = plot(t, señal, title="Señal", label='f', legend=:top)
    freq_domain = plot(freqs, abs.(F), title="Espectro", xlim=(0, +300), xticks=0:50:251, label="abs.(F)", legend=:top)
    p = plot(time_domain, freq_domain, layout=(2, 1))
end
