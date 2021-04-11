### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# ╔═╡ 49da2c55-f142-4ed6-9e43-bce350acfcab
using Plots, LinearAlgebra, FFTW, Images, PerceptualColourMaps, Convex, ECOS

# ╔═╡ 1cc173bc-987b-11eb-1fdd-2fe456ed1c9f
html"""
<iframe width="100%" height="300" src="https://www.youtube.com/embed/hmBTACBGWJs" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ d3fd4bb4-0cbc-475c-a4b8-d77003404903
begin
	p = 14
	n = 32
end

# ╔═╡ a216e475-f92a-43d9-b11e-7814f3c95e10
# This little helper function shows a matrix as a colorful image
function mat_to_img(mat; colormap="L3") 
	if typeof(mat) <: Vector{Float64}  # convert vectors to matrix
		mat = Matrix(mat')
	end
	arr = applycolormap(1 .- mat, cmap(colormap)) # convert matrix into 3-dimensional array
	return colorview(RGB, permuteddimsview(arr, (3,1,2)) ) # converts to image
end

# ╔═╡ 6eb34136-a41a-49ee-b283-eec1be354067
md"# Ψ"

# ╔═╡ ee357874-3b63-4f58-beaa-9f137939b673
begin
	## Plot Psi
	Ψ = dct(I(n), 2)
	mat_to_img(Ψ)
end

# ╔═╡ ba52bc21-c4c7-447b-b597-22e80aead34f
md"# C"

# ╔═╡ 427610ef-3e63-4668-9632-d040f9959d13
begin
	## Plot C
	perm = rand(range(1,length=n), p)
	C = collect(I(n)[perm,:])
	mat_to_img(C, colormap="grey")
end

# ╔═╡ 3cbcf473-9968-4b7f-a2a6-ccf547f14275
md"# Θ"

# ╔═╡ dc9886b4-5521-47f7-8e06-ca62b20624b1
begin
	## Plot Θ
	Θ = C * Ψ
	mat_to_img(Θ)
end

# ╔═╡ 283235be-3cc3-4ab7-8ccd-193af5ced94b
md"# s"

# ╔═╡ 7f24a6e8-e44f-489c-8314-81d0cb3649ff
begin
	## Plot s, y
	s = zeros(n)
	s[2] = 1.4
	s[13] = 0.7
	s[27] = 2.2
	y = C * Ψ * s	
	mat_to_img(s)
end

# ╔═╡ 216e7e71-b815-4ad9-9e98-f3642a366047
md"# s_L2"

# ╔═╡ bf47ddb1-dade-4469-ac81-86fcb4eb28aa
begin
	s_L2 = pinv(Θ) * y
	mat_to_img(s_L2)
end

# ╔═╡ d62da560-264d-4213-86ce-0c82061186f7
md"# s_backslash"

# ╔═╡ aa24d533-3831-45dd-94d7-32dc81d77875
begin
	s_backslash = Θ \ y    |> mat_to_img
end

# ╔═╡ b58612c8-4a34-4eda-8b5e-e312fb901897
md"# y"

# ╔═╡ 77d6084a-4c61-47e2-87f6-d5554cd45fb5
mat_to_img(y)

# ╔═╡ acb4a9d0-5f6c-4756-b9d4-9422e5f89598
md"# s_L1"

# ╔═╡ cf15f7d4-1c4e-471f-ac23-e88cd811e993
begin
	# L1 optimization 
	s_2 = Variable(n)
	problem = minimize(  norm(s_2, 1), [Θ * s_2 == y] )
	# Solve the problem by calling solve!
	solve!(problem, () -> ECOS.Optimizer(verbose=false))	
	# Get the optimum variables
	s_2 = Convex.evaluate(s_2)
	mat_to_img(s_2)
end

# ╔═╡ ea4a0859-0cb5-4f87-9346-b62d4c43da54
md"# Gaussian random C and Θ"

# ╔═╡ 0802016a-9d2d-4cfd-b6c8-ec59d12e392b
begin
	## Plot C and Theta (2) - Gaussian Random
	C_Gauß = randn(p,n) 
	Θ_Gauß = C_Gauß * Ψ
	[  mat_to_img(C_Gauß)  Gray.(ones(p,n))    mat_to_img(Θ_Gauß) ]
end

# ╔═╡ b795507e-a18f-49fa-a12c-fd2d45a15b6c
md"# Bernoulli random C and Θ"

# ╔═╡ 6c077175-5b27-40fe-b6e1-c13ece730a41
begin
	## Plot C and Theta (2) - Gaussian Random
	C_Bernoulli = randn(p,n) 
	C_Bernoulli = C_Bernoulli .> 0
	Θ_Bernoulli = C_Bernoulli * Ψ
	[  mat_to_img(C_Bernoulli)  Gray.(ones(p,n))    mat_to_img(Θ_Bernoulli) ]
end

# ╔═╡ 949bcda7-90e1-46f7-b8d6-d5914cf73a7a
md"# Sparse Bernoulli random C and Θ"

# ╔═╡ 86a35b09-f9ea-4840-88fe-e7588ba125d1
begin
	## Plot C and Theta (2) - Gaussian Random
	C_Sparse_Bernoulli = randn(p,n) 
	C_Sparse_Bernoulli = C_Sparse_Bernoulli .> 1
	Θ_Sparse_Bernoulli = C_Sparse_Bernoulli * Ψ
	[mat_to_img(C_Sparse_Bernoulli)  Gray.(ones(p,n)) mat_to_img(Θ_Sparse_Bernoulli) ]
end

# ╔═╡ dd25ab51-aae3-49c3-9d11-b8bbd9b42190
md"# Bad C and Θ: DCT MEAS"

# ╔═╡ ffa12a99-511d-4ab1-beed-f123566ac53f
begin
	## Plot C and Theta (2) - Gaussian Random
	#C_idct = idct(I(n), 2)[n-p:n, :]
	C_idct = idct(I(n), 2)[n-p+1:n, :]
	Θ_idct = C_idct * Ψ
	[  mat_to_img(C_idct)  Gray.(ones(p,n))    mat_to_img(Θ_idct) ]
end

# ╔═╡ 29ac8d7e-aa88-4d52-b692-36bf54907ecc
begin
	y_idct = Θ_idct * s
	mat_to_img(y_idct )
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
# ╠═d3fd4bb4-0cbc-475c-a4b8-d77003404903
# ╠═a216e475-f92a-43d9-b11e-7814f3c95e10
# ╟─6eb34136-a41a-49ee-b283-eec1be354067
# ╠═ee357874-3b63-4f58-beaa-9f137939b673
# ╟─ba52bc21-c4c7-447b-b597-22e80aead34f
# ╠═427610ef-3e63-4668-9632-d040f9959d13
# ╟─3cbcf473-9968-4b7f-a2a6-ccf547f14275
# ╠═dc9886b4-5521-47f7-8e06-ca62b20624b1
# ╟─283235be-3cc3-4ab7-8ccd-193af5ced94b
# ╠═7f24a6e8-e44f-489c-8314-81d0cb3649ff
# ╟─216e7e71-b815-4ad9-9e98-f3642a366047
# ╠═bf47ddb1-dade-4469-ac81-86fcb4eb28aa
# ╠═d62da560-264d-4213-86ce-0c82061186f7
# ╠═aa24d533-3831-45dd-94d7-32dc81d77875
# ╟─b58612c8-4a34-4eda-8b5e-e312fb901897
# ╠═77d6084a-4c61-47e2-87f6-d5554cd45fb5
# ╠═acb4a9d0-5f6c-4756-b9d4-9422e5f89598
# ╠═cf15f7d4-1c4e-471f-ac23-e88cd811e993
# ╟─ea4a0859-0cb5-4f87-9346-b62d4c43da54
# ╠═0802016a-9d2d-4cfd-b6c8-ec59d12e392b
# ╟─b795507e-a18f-49fa-a12c-fd2d45a15b6c
# ╠═6c077175-5b27-40fe-b6e1-c13ece730a41
# ╟─949bcda7-90e1-46f7-b8d6-d5914cf73a7a
# ╠═86a35b09-f9ea-4840-88fe-e7588ba125d1
# ╟─dd25ab51-aae3-49c3-9d11-b8bbd9b42190
# ╠═ffa12a99-511d-4ab1-beed-f123566ac53f
# ╠═29ac8d7e-aa88-4d52-b692-36bf54907ecc
# ╟─88a367b5-686c-45bb-b9e1-2517e734fd3b
