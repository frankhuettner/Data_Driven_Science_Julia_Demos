### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ acdef028-8f0c-11eb-3e0d-252c235cf4c1
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ d2d793aa-86fd-11eb-1860-595b76b3d613
begin
	Pkg.add("LinearAlgebra")
	Pkg.add("Plots")
	Pkg.add("Statistics")
	using LinearAlgebra
	using Plots
	gr()
	using Statistics
end

# ╔═╡ 82538414-86fd-11eb-1602-b99a301400ac
begin
	xC = [2; 1];                           # Center of data (mean)
	sig = [2; .5];                         # Principal axes
	
	θ = π/3;                           	# Rotate cloud by pi/3
	R = [cos(θ) -sin(θ);            	# Rotation matrix
	    sin(θ) cos(θ)];
	
	nPoints = 10_000;                        # Create 10,000 points
	X = R * Diagonal(sig)*randn(2,nPoints) + Diagonal(xC)*ones(2,nPoints)
	R 
end

# ╔═╡ 83256cc8-86fe-11eb-1286-ef27b25d7c2e
scatter(X[1,:],X[2,:], legend=false, xlim=(-6, 8), ylim=(-6, 8), ratio=:equal)

# ╔═╡ e57a1e82-86fe-11eb-347b-d969c7045ffb
begin
	X_avg = mean(X,dims=2)      # Compute row mean
	B = X .- X_avg       		# Mean-subtracted data
	
	# Find principal components (SVD)
	U, σs, V = svd(B/ √(nPoints))		
	# U will be correlation matrix of Bᵀ/√(nPoints-1) * B/√(nPoints-1)
	# For Gaussian, we can use of covariance devides by √n instead of √(nPoints-1)
end

# ╔═╡ 8908be9a-8700-11eb-307d-a563ebbe81a1
begin
	# Plot data to overlay PCA
	scatter(X[1,:],X[2,:], 
		legend=false, xlim=(-6, 8), ylim=(-6, 8), markeralpha = 0.3, ratio=:equal)
	
	θs = 2 * π * collect(0:0.01:1)
	
	# 1-std confidence interval
	X_std = U * Diagonal(σs) * [cos.(θs) sin.(θs)]'
	
	
	plot!(X_avg[1] .+ X_std[1,:], X_avg[2] .+ X_std[2,:],lw=3)
	plot!(X_avg[1] .+ 2. * X_std[1,:], X_avg[2] .+ 2 .* X_std[2,:],lw=3)
	plot!(X_avg[1] .+ 3. * X_std[1,:], X_avg[2] .+ 3 .* X_std[2,:],lw=3)
	
	# Plot principal components U[:,0]S[0] and U[:,1]S[1]
	plot!([X_avg[1], X_avg[1]+U[1,1]*σs[1]],[X_avg[2], X_avg[2]+U[2,1]*σs[1]], 
		lw=5)	
	plot!([X_avg[1], X_avg[1]+U[1,2]*σs[2]],[X_avg[2], X_avg[2]+U[2,2]*σs[2]], 
		lw=5)
end

# ╔═╡ bbcce3b0-8f0c-11eb-24c6-951e96a10fe4
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
# ╠═acdef028-8f0c-11eb-3e0d-252c235cf4c1
# ╠═d2d793aa-86fd-11eb-1860-595b76b3d613
# ╠═82538414-86fd-11eb-1602-b99a301400ac
# ╠═83256cc8-86fe-11eb-1286-ef27b25d7c2e
# ╠═e57a1e82-86fe-11eb-347b-d969c7045ffb
# ╠═8908be9a-8700-11eb-307d-a563ebbe81a1
# ╟─bbcce3b0-8f0c-11eb-24c6-951e96a10fe4
