#Buscar archivos comtrade en carpeta

#= 
Por cada oscilografìa a analizar deberá haber tres arvhivos:
*.cfg
*.dat
*.csv

El archivo csv contiene los parámetros de la línea de la sieguiente forma:
R1,X1,R0,X0
por ejemlo:
10,5,20,5

R1 = parte real de impedancia de secuencia directa
X1 = parte imaginaria de la impedancia de secuencia directa
R0 = parte real de impedancia de secuencia cero
X0 = parte imaginaria de la impedancia de secuencia cero

=#


function buscarArchivos(ruta)
walkdir(ruta)
end

#= Area de pruebas =#
home = pwd()
ruta = joinpath("data","comtrade")
walkdir(ruta)
readdir(ruta)

cd(readdir,ruta)
readdir(ruta)

for (files) in walkdir(ruta)
    for file in files
        println(file) # path to files
    end
end

for file in walkdir(ruta)
    println(file)
end

files = walkdir(ruta)
print(files)

for file in files
    println(file)
end