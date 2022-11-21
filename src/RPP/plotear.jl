function plotear(sistema)
    va = plot(sistema.va.valores)
    vb = plot(sistema.vb.valores)
    vc = plot(sistema.vc.valores)
    ia = plot(sistema.ia.valores)
    ib = plot(sistema.ib.valores)
    ic = plot(sistema.ic.valores)
    plot(va, vb, vb, ia, ib, ic, layout=(6, 1),
        label=["va" "vb" "vc" "ia" "ib" "ic"])
end