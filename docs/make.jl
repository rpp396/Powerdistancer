using Documenter, Powerdistancer

DocMeta.setdocmeta!(Powerdistancer, :DocTestSetup,
    :(using Powerdistancer); recursive=true)

makedocs(
    sitename="Powerdistancer",
    modules=[Powerdistancer],
    format=Documenter.HTML(
        prettyurls=get(ENV, "CI", nothing) == "true",
        assets=["assets/aligned.css"]),
    pages=[
        "Home" => "index.md"
    ],
    strict=true
)

deploydocs(
    repo="github.com/rpp396/Powerdistancer.jl.git",
    push_preview=true
)
