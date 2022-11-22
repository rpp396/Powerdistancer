push!(LOAD_PATH, "../src/")

using Documenter, Powerdistancer, DocumenterCitations

bib = CitationBibliography(joinpath(@__DIR__, "Referencias.bib"), sorting = :nyt)


DocMeta.setdocmeta!(
	Powerdistancer,
	:DocTestSetup,
	:(using Powerdistancer);
	recursive = true,
)

makedocs(bib,
	sitename = "Powerdistancer",
	modules = [Powerdistancer],
	format = Documenter.HTML(
		prettyurls = get(ENV, "CI", nothing) == "true",
		assets = ["assets/aligned.css"],
	),
	pages = ["Interface" => "index.md",
		"All functions" => "todas.md",
		"References" => "references.md",
		"Table of contents" => "toc.md"],
	strict = true,
)

deploydocs(repo = "github.com/rpp396/Powerdistancer.git", push_preview = true)
