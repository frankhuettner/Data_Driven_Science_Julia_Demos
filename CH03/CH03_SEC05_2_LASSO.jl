### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# ╔═╡ 49da2c55-f142-4ed6-9e43-bce350acfcab
using Plots, LinearAlgebra, GLMNet, LaTeXStrings

# ╔═╡ 1cc173bc-987b-11eb-1fdd-2fe456ed1c9f
html"""
<iframe width="100%" height="300" src="https://www.youtube.com/embed/GaXfqoLR_yI" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ 159ccebd-393a-4f53-b308-61fd32898a6c
begin
		A = randn(100,10)                    # Matrix of possible predictors
		x = [0, 0, 1, 0, 0, 0, -1, 0, 0, 0]   # Two nonzero predictors
		b = A * x  +  2 * randn(100)       # Observations (with noise)
	
		x_L2 = pinv(A) * b
		minimum(abs.(x_L2))	# all coefficients non-zero
end

# ╔═╡ d38ad62a-88fc-41bf-882f-49588dcc6441
cv_models = glmnetcv(A, b) 

# ╔═╡ 0b8a4a30-8cd1-4317-9b4c-9047281ac4e8
λ_best_idx = argmin(cv_models.meanloss)

# ╔═╡ 82e13340-30de-4fc0-98f6-f0b3e30f0567
begin
	plot(cv_models.lambda, cv_models.meanloss, yerror=cv_models.stdloss, legend=false,				xlabel=L"\lambda",ylabel="mean loss  +/- std error")
	scatter!([cv_models.lambda[λ_best_idx]], [cv_models.meanloss[λ_best_idx]], c=:green)
end

# ╔═╡ 25530da8-85a5-4d87-9e61-78a4be9a464d
cv_models.lambda[λ_best_idx], cv_models.meanloss[λ_best_idx]

# ╔═╡ f75ac207-c1d9-421c-b101-b0d62bf15ffc
β_lasso = coef(cv_models) 
# equivalent to cv_models.path.betas[:, λ_best_idx]

# ╔═╡ b16c767b-38bb-48dd-a586-3b8e1cc07ac4
begin
	x_L1_debiased = pinv(A[:,abs.(β_lasso).>0]) * b	
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
# ╠═49da2c55-f142-4ed6-9e43-bce350acfcab
# ╠═159ccebd-393a-4f53-b308-61fd32898a6c
# ╠═d38ad62a-88fc-41bf-882f-49588dcc6441
# ╠═82e13340-30de-4fc0-98f6-f0b3e30f0567
# ╠═25530da8-85a5-4d87-9e61-78a4be9a464d
# ╠═0b8a4a30-8cd1-4317-9b4c-9047281ac4e8
# ╠═f75ac207-c1d9-421c-b101-b0d62bf15ffc
# ╠═b16c767b-38bb-48dd-a586-3b8e1cc07ac4
# ╟─88a367b5-686c-45bb-b9e1-2517e734fd3b
