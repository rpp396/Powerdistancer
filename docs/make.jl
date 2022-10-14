using Documenter, Template

DocMeta.setdocmeta!(Template, :DocTestSetup,
    :(using Template); recursive=true)

makedocs(
    sitename="Template",
    modules=[Template],
    format=Documenter.HTML(
        prettyurls=get(ENV, "CI", nothing) == "true",
        assets=["assets/aligned.css"]),
    pages=[
        "Home" => "index.md"
    ],
    strict=true
)

deploydocs(
    repo="github.com/mforets/Template.jl.git",
    push_preview=true
)
