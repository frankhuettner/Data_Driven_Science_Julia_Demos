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
        Pkg.PackageSpec(name="StatsPlots"),
        Pkg.PackageSpec(name="LinearAlgebra"),
        Pkg.PackageSpec(name="Statistics"),
        Pkg.PackageSpec(name="StatsBase"),
        Pkg.PackageSpec(name="Trapz"),
    ])
    using Plots, StatsPlots, LinearAlgebra, Statistics, StatsBase, Trapz
end

# ╔═╡ 28423674-615c-46a4-8d0e-9b47edb3e287
begin
	n = 10000
	x1 = randn(n) # "truth" model (data)
	x2 = 0.8 .* randn(n) .+ 1 # model 1
	x3 = 0.5 .* randn(n) .- 1 # model 3 components
	x4 = 0.7 .* randn(n) .- 3
	x5 = 5.0 .* rand(n) .- 0.5 
	
	x = -6:0.01:6.0 # range for data
	x_closed = -6:0.01:6.01
end

# ╔═╡ 8fe7bde0-9a89-4cdb-92d2-66d1cb95f573
begin
	f = fit(Histogram, x1, x_closed)
	f = f.weights .+ 0.01  # generate PDFs
	f = f ./ trapz(x, f)  # normalize data
	
	g1 = fit(Histogram, x2, x_closed).weights .+ 0.01
	g1 = g1 ./ trapz(x, g1)
	
	g2a = fit(Histogram, x3, x_closed).weights
	g2b = fit(Histogram, x4, x_closed).weights
	g2 = g2a .+ 0.3 .* g2b .+ 0.01 
	g2 = g2 ./ trapz(x, g2)
	
	g3 = fit(Histogram, x5, x_closed).weights .+ 0.01
	g3 = g3 ./ trapz(x, g3)
	
	plot([f, g1, g2, g3], label = ["f" "g1" "g2" "g3"], lw = 2)
end

# ╔═╡ 3afd6b4a-2462-48a1-b004-d9bc4ed1f58d
# compute integrand
Int1 = f .* log.(f ./ g1);   Int2=f.*log.(f./g2); Int3=f.*log.(f./g3)

# ╔═╡ 1840761a-e2de-465e-ab4b-7892ad4ed789
# KL divergence
Dict(["I1"=>trapz(x, Int1), "I2"=>trapz(x, Int2), "I3"=>trapz(x, Int3)])

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
# ╠═28423674-615c-46a4-8d0e-9b47edb3e287
# ╠═8fe7bde0-9a89-4cdb-92d2-66d1cb95f573
# ╠═3afd6b4a-2462-48a1-b004-d9bc4ed1f58d
# ╠═1840761a-e2de-465e-ab4b-7892ad4ed789
# ╟─d9d2aea4-3380-4bc9-b33b-978424014799
