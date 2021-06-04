### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ adea421b-ccec-4ec5-ad92-d028e9545075
begin
    import Pkg; Pkg.activate(mktempdir())
    Pkg.add(["Plots", "Images", "LinearAlgebra", "Rotations", 
			 "PlutoUI", "Statistics", "MAT", "Random"]) 
    using Plots, Images, LinearAlgebra, Rotations, 
		  PlutoUI, Statistics, MAT, Random
end

# ╔═╡ 56c093c2-8ba3-11eb-3c0c-af74e33c406a
function sample_cols(X, r, p)
	# Sample r+p columns from X
	ny = size(X,2)
	P = sort!(rand(1:ny, r+p))
	return view(X, :, P)
end

# ╔═╡ 5d4b94ae-8baf-11eb-22b8-35e46fddc59f
function iterate_Z(Z,X,q)
	Z = Z
	for k in 1:q   
        Z = X * (X' * Z)
	end
	return Z
end

# ╔═╡ 5493d076-8ba8-11eb-3513-a74fb2a374ed
# Define randomized SVD function
# Checkout https://github.com/JuliaMatrices/LowRankApprox.jl for implementations
function rSVD(X,r,q,p)	
    # Step 1: Sample column space of X with P matrix
	Z = sample_cols(X,r,p)
	Z = iterate_Z(Z,X,q)
	
	Q, R = qr(Z)
	# Step 2: Compute SVD on projected Y = Q' * X
    Y = Q' * X
    UY, S, V = svd(Y)
    U = Q * UY
	
    return U, S, V
end

# ╔═╡ 6be0657a-8ba1-11eb-0b55-ad04c71a3ee3
begin
	A = load("jupiter.jpg")
	X = Gray.(A) |> Matrix{Float64} # Convert RGB -> grayscale -> Float Array
	
	U, S, V = svd(X) # Deterministic SVD	
	
	r = 400 # Target rank
	q = 1   # Power iterations
	p = 5   # Oversampling parameter
	
	rU, rS, rV = rSVD(X, r, q, p)
	
	## Reconstruction
	XSVD = U[:,1:r] * Diagonal(S[1:r]) * V'[1:r,:] # SVD approximation
	errSVD = norm(X-XSVD) / norm(X)
	
	rXSVD = rU[:,1:r] * Diagonal(rS[1:r]) * rV'[1:r,:] # SVD approximation
	errrSVD = norm(X-rXSVD) / norm(X)
	
	errrSVD - errSVD
end

# ╔═╡ c378f928-8ba6-11eb-232f-6bf7957c26ad
[ Gray.(X) Gray.(XSVD) Gray.(rXSVD) ]

# ╔═╡ c17a7d32-8baa-11eb-035d-fb3933f22376
let
	## Illustrate power iterations
	X = randn(1000,100)
	U, S, V = svd(X)	
	S = range(1, 0; length=100)
	X = U * Diagonal(S) * V'
	
	plt = plot(S, LineWidth=2, markershape=:o, label="SVD")
	Z = copy(X)
	for q in 1:5
		Z = iterate_Z(Z,X,1)
		F = svd(Z)
		plot!(plt, F.S,LineWidth=2, markershape=:o,label="rSVD, q = $q")
	end
	plt
end

# ╔═╡ dd868c90-8f61-11eb-1c08-0dfa9cb02fcb
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
# ╠═adea421b-ccec-4ec5-ad92-d028e9545075
# ╠═56c093c2-8ba3-11eb-3c0c-af74e33c406a
# ╠═5d4b94ae-8baf-11eb-22b8-35e46fddc59f
# ╠═5493d076-8ba8-11eb-3513-a74fb2a374ed
# ╠═6be0657a-8ba1-11eb-0b55-ad04c71a3ee3
# ╠═c378f928-8ba6-11eb-232f-6bf7957c26ad
# ╠═c17a7d32-8baa-11eb-035d-fb3933f22376
# ╟─dd868c90-8f61-11eb-1c08-0dfa9cb02fcb
