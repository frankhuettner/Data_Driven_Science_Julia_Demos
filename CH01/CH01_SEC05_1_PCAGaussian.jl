### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ 183ea6ac-94f7-419f-8c29-882331762f06
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add(["Plots", "LinearAlgebra", "CSV", "DataFrames", "Statistics"])
    using Plots, LinearAlgebra, CSV, DataFrames, Statistics
end

# ╔═╡ 82538414-86fd-11eb-1602-b99a301400ac
begin
	xC = [2, 1]            # Center of data (mean)
	sig = [2, .5]          # Principal axes
	
	θ = π/3                # Rotate cloud by π/3
	
	R = [cos(θ) -sin(θ)    # Rotation matrix
	     sin(θ)  cos(θ)]
	
	nPoints = 10_000;                       
end

# ╔═╡ 514d58ee-b2c2-4a69-9235-5fa26ad546d9
# Create 10,000 points
X = R * Diagonal(sig) * randn(2,nPoints) + Diagonal(xC) * ones(2,nPoints)

# ╔═╡ 83256cc8-86fe-11eb-1286-ef27b25d7c2e
scatter(X[1,:],X[2,:], legend=false, xlim=(-6, 8), ylim=(-6, 8), ratio=:equal)
# Note that we have scatter(vec with x values, vec with y values)

# ╔═╡ 0eda0069-2436-4196-a23a-d66297ebf4e5
# Compute row means
X_avg = mean(X, dims=2)

# ╔═╡ e5733095-5155-4e7b-9ac3-8b3d3498f9e1
# Mean-subtracted data
B = X .- X_avg

# ╔═╡ e57a1e82-86fe-11eb-347b-d969c7045ffb
# Find principal components (SVD)
U, Σ, V = svd(B/ √(nPoints))		
# U will be correlation matrix of Bᵀ/√(nPoints-1) * B/√(nPoints-1)
# For Gaussian, we can use of covariance devides by √n instead of √(nPoints-1)

# ╔═╡ 8908be9a-8700-11eb-307d-a563ebbe81a1
begin
	# Plot data to overlay PCA
	scatter(X[1,:],X[2,:], 
		legend=false, xlim=(-6, 8), ylim=(-6, 8), markeralpha = 0.3, ratio=:equal)
	
	θs = 2 * π * (0:0.01:1)
	
	# 1-std confidence interval
	X_std = U * Diagonal(Σ) * [cos.(θs) sin.(θs)]'
	
	plot!(X_avg[1] .+ X_std[1,:], X_avg[2] .+ X_std[2,:],lw=3)
	plot!(X_avg[1] .+ 2. * X_std[1,:], X_avg[2] .+ 2 .* X_std[2,:],lw=3)
	plot!(X_avg[1] .+ 3. * X_std[1,:], X_avg[2] .+ 3 .* X_std[2,:],lw=3)
	
	# Plot principal components U[:,0]S[0] and U[:,1]S[1]
	plot!([X_avg[1], X_avg[1]+U[1,1]*Σ[1]],[X_avg[2], X_avg[2]+U[2,1]*Σ[1]], 
		lw=5)	
	plot!([X_avg[1], X_avg[1]+U[1,2]*Σ[2]],[X_avg[2], X_avg[2]+U[2,2]*Σ[2]], 
		lw=5)
end

# ╔═╡ 401ee5c8-8f05-11eb-38ad-37fe86f6a05f
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
# ╠═183ea6ac-94f7-419f-8c29-882331762f06
# ╠═82538414-86fd-11eb-1602-b99a301400ac
# ╠═514d58ee-b2c2-4a69-9235-5fa26ad546d9
# ╠═83256cc8-86fe-11eb-1286-ef27b25d7c2e
# ╠═0eda0069-2436-4196-a23a-d66297ebf4e5
# ╠═e5733095-5155-4e7b-9ac3-8b3d3498f9e1
# ╠═e57a1e82-86fe-11eb-347b-d969c7045ffb
# ╠═8908be9a-8700-11eb-307d-a563ebbe81a1
# ╟─401ee5c8-8f05-11eb-38ad-37fe86f6a05f
