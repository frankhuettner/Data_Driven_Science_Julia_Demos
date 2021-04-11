### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# ╔═╡ ae60e7d7-306b-4c19-837c-9bcaf70af754
using Plots, LinearAlgebra, FFTW, Convex, ECOS, Distributions

# ╔═╡ 1cc173bc-987b-11eb-1fdd-2fe456ed1c9f
html"""
<iframe width="100%" height="300" src="https://www.youtube.com/embed/KF5LaUVTBOY" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ b16c767b-38bb-48dd-a586-3b8e1cc07ac4
begin
	x = sort( rand(Uniform(-2,2), 25) ) # Random data from [-2,2]
	b = [0.9 * xᵢ + 0.1*randn()  for xᵢ in x] # Line y=.9x with noise 
	a_true = x\b          # Least-squares slope (no outliers)
	
	b[end] = -5.5                 # Introduce outlier                 
	a_corrupt = x\b               # New slope		
end

# ╔═╡ 0b1ba2c6-89c8-4d31-83a3-226d414124a6
begin
	# L1 optimization to reject outlier
	a_L1 = Variable(1)
	
	problem = minimize(  norm(a_L1 * x - b, 1)  )
	
	# Solve the problem by calling solve!
	solve!(problem, () -> ECOS.Optimizer(verbose=false))	
	
	# Get the optimum variables
	a_L1 = evaluate(a_L1)
end

# ╔═╡ 1ed5496c-f9f6-4ae4-9d50-5e5cdc4569e0
begin
	scatter(x[1:end-1], b[1:end-1], c=:blue, legend=false) # Data
	scatter!([x[end]], [b[end]], c=:red)         # Outlier
	x_grid = range(-2.0, stop=2, step=0.01)
	plot!(x_grid, x_grid * a_true, c=:black, ls=:dash)       # L2 fit (no outlier)
	plot!(x_grid, x_grid * a_corrupt, c=:red, ls=:dash)    # L2 fit (outlier)
	plot!(x_grid, x_grid * a_L1, c=:blue, ls=:dash)         # L1 fit
end

# ╔═╡ 88a367b5-686c-45bb-b9e1-2517e734fd3b
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
# ╟─1cc173bc-987b-11eb-1fdd-2fe456ed1c9f
# ╠═ae60e7d7-306b-4c19-837c-9bcaf70af754
# ╠═b16c767b-38bb-48dd-a586-3b8e1cc07ac4
# ╠═0b1ba2c6-89c8-4d31-83a3-226d414124a6
# ╠═1ed5496c-f9f6-4ae4-9d50-5e5cdc4569e0
# ╟─88a367b5-686c-45bb-b9e1-2517e734fd3b
