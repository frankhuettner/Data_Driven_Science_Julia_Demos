### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ ae60e7d7-306b-4c19-837c-9bcaf70af754
using LinearAlgebra, MAT, LowRankApprox, PlutoUI, Images, PerceptualColourMaps

# ╔═╡ b7a7a10c-770e-4472-bdc6-05ff16eca9c2
html"""
<iframe width="100%" height="300" src="https://www.youtube.com/embed/yDpz0PqULXQ" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ 601c21ba-1844-4b52-956e-bd82c3223a5a
𝒮(X, τ) = [sign(x) * max(abs(x) - τ, 0.0) for x in X]

# ╔═╡ def21e95-217a-417b-986d-4617a2cdebf6
function SVT(X, τ) 
	F = psvdfact(X) # Store the Factorization Object
	return F.U * Diagonal(𝒮(F.S, τ)) * F.Vt
end

# ╔═╡ 7fcdefdb-a80f-4646-8c3c-d171884b1564
"""	
	RPCA(X)

Robust Principal Component Analysis using the alternating directions method (ADM)
Returns L and S, such that L has low rank, S is sparse, and L + S = X

# Example
```julia-repl
julia> X = [1 2; 3 4]; L, S = RPCA(X)
2×2 Matrix{Float64}:
 1.0  2.0
 2.0  4.0
2×2 Matrix{Float64}:
 -0.0       0.0
  0.999999  0.0
```

"""
function RPCA(X) 
	n, m = size(X)
	μ = n * m /  (4 * sum(abs, X) )
	λ = 1/sqrt(maximum([n, m]))
	thresh = 1.0e-7 * norm(X)
	
    L = zeros(n, m)	
    S = zeros(n, m)
    Y = zeros(n, m)
	count = 0
	
    while (count < 1000) && (norm(X-L-S) > thresh)  
		
        L = SVT(X - S + (1/μ) * Y,  1/μ)
		
        S = 𝒮(X - L + (1/μ) * Y, λ/μ)
		
        Y = Y + μ * (X-L-S)
		
        count += 1	
	end
	return L, S
end

# ╔═╡ 65f8156e-1932-4d32-87b9-552dbe2d423e
begin
	file_contents = matread("../../DATA/allFaces.mat")	
	faces = file_contents["faces"]
	nfaces = convert.(Int, file_contents["nfaces"])
	X = faces[:, 1:nfaces[1]]
	size(X)
end

# ╔═╡ ad9c05ce-9a51-47a4-b0b6-826ecf3cf939
# Takes 1 to 2 minutes
L, S = RPCA(X) 

# ╔═╡ 0210fc00-1cd0-4ae5-b99b-1e5ee6d456ee
# This little helper function shows a vec as an image
function vec_to_img(vec; dims=(192, 168), colormap="gray") 
	# convert vector into 3-dimensional array
	arr = applycolormap(reshape(vec, dims...), cmap(colormap)) 
	# converts to image
	return colorview(RGB, permuteddimsview(arr, (3,1,2)) ) 
end

# ╔═╡ f24b60d4-5d84-4154-87c4-efbecf874ed5
begin
	inds = (3,4,14,15,17,18,19,20,21,32,43) .+1
	@bind i Slider(1:length(inds))
end

# ╔═╡ 0df226cb-a105-4244-8afb-7fb8aaedffe4
begin
	k = inds[i]
	md"Image $k"
end

# ╔═╡ ac417354-55a7-42f6-b111-349a60a70f79
md" ## Original X  		=	Low-Rank L 			+	Sparse S
where rank(L)=$(rank(reshape( L[:,k-1], 192, 168))), and $(count([s==0 for s in S[:,k-1]])) of the 32256 pixels are zero in S."

# ╔═╡ 3c31bf65-4cd5-49a3-9846-91655f3eecc4
begin
	[vec_to_img(X[:,k-1])  vec_to_img(L[:,k-1])  vec_to_img(S[:,k-1]) ]
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
# ╟─b7a7a10c-770e-4472-bdc6-05ff16eca9c2
# ╠═ae60e7d7-306b-4c19-837c-9bcaf70af754
# ╠═601c21ba-1844-4b52-956e-bd82c3223a5a
# ╠═def21e95-217a-417b-986d-4617a2cdebf6
# ╠═7fcdefdb-a80f-4646-8c3c-d171884b1564
# ╠═65f8156e-1932-4d32-87b9-552dbe2d423e
# ╠═ad9c05ce-9a51-47a4-b0b6-826ecf3cf939
# ╠═0210fc00-1cd0-4ae5-b99b-1e5ee6d456ee
# ╟─f24b60d4-5d84-4154-87c4-efbecf874ed5
# ╟─0df226cb-a105-4244-8afb-7fb8aaedffe4
# ╟─ac417354-55a7-42f6-b111-349a60a70f79
# ╠═3c31bf65-4cd5-49a3-9846-91655f3eecc4
# ╟─88a367b5-686c-45bb-b9e1-2517e734fd3b
