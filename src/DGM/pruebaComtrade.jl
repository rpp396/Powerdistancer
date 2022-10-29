module pruebaComtrade
"""
DocString de pruebaDocString
"""
function pruebaDocString()
    1 + 1
end
pruebaDocString()
using COMTRADE
using DataFrames
z1 = read_comtrade("./Oscilos/NOR-T2_osc1")
#= VSCodeServer.vscodedisplay(z1.cfg.A) #Para ver los DataFrames
VSCodeServer.vscodedisplay(z1.cfg.D) #Para ver los DataFrames
VSCodeServer.vscodedisplay(z1.dat) #Para ver los DataFramesst =#
end