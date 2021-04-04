### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 497b6c8c-9047-11eb-020b-5db168d6814f
begin
	using Images
	using Plots
end

# ╔═╡ 5e50f920-9046-11eb-09d9-47f055183d13
begin
	n = 256
	w = exp(- im * 2 * π/n)
	
	DFT = [w^((i-1)*(j-1)) for i=1:n, j=1:n]	# fast
	heatmap(real.(DFT), legend=false, ratio=:equal, axis=(nothing,false))
end

# ╔═╡ 60d43108-5d60-46dd-b77d-251e68088677
let # Loading the disclaimer
	url = "https://github.com/frankhuettner/Data_Driven_Science_Julia_Demos/raw/main/disclaimer.md"
	datafile = url |> download 
    datafile = open(datafile,"r")
    lines = readlines(datafile)
    close(datafile)
    lines[1]
	Markdown.parse(lines[1]) 
end

# ╔═╡ Cell order:
# ╠═497b6c8c-9047-11eb-020b-5db168d6814f
# ╠═5e50f920-9046-11eb-09d9-47f055183d13
# ╟─60d43108-5d60-46dd-b77d-251e68088677
