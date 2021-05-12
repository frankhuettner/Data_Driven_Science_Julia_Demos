### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# ╔═╡ 47a5ec18-a8ff-11eb-320e-150284faee49
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="Plots"),
    ])
    using  Plots
end

# ╔═╡ bb8a87f1-8ff3-4974-b8eb-4c805e19e3ee
md"The points that are not dominated are called Pareto-optimal. The Pareto-optimal points in the shaded area appear to offer a good trade-off."

# ╔═╡ 69186d55-6680-4cbe-91e0-c5af99db2930
begin
	x = 0.2:0.1:5
	y = [ 1/xi for xi in x ]
	
	x2 = range(0.2, step = 0.1, stop = 5)
	n = length(x2) 
	y2 =  [ 1/xi + 0.5 * randn()  for xi in x2  ]
	
	
	plt = plot(x, y, c=:black, lw=2, leg=false, xlim = (0.2, 4), ylim = (0, 5.5))
	rect(w, h, x, y) = Shape(x .+ [0, w, w, 0, 0], y .+ [0, 0, h, h, 0])
	plot!(plt, rect(0.9, 1.6, 0.5, 0.4), opacity=.6, c=:gray)
	scatter!(plt, x2, y2, c=:magenta)
	for i in 1:5
		scatter!(plt, x2, y2 + 2 * rand(n) + ones(n), c=:lime)
	end
	plt
end

# ╔═╡ d9d2aea4-3380-4bc9-b33b-978424014799
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
# ╠═47a5ec18-a8ff-11eb-320e-150284faee49
# ╟─bb8a87f1-8ff3-4974-b8eb-4c805e19e3ee
# ╠═69186d55-6680-4cbe-91e0-c5af99db2930
# ╟─d9d2aea4-3380-4bc9-b33b-978424014799
