### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# ╔═╡ 49da2c55-f142-4ed6-9e43-bce350acfcab
using Plots, LinearAlgebra, FFTW, Images, PerceptualColourMaps, MAT, Convex, ECOS

# ╔═╡ a216e475-f92a-43d9-b11e-7814f3c95e10
# This little helper function shows a vec as an image
function vec_to_img(vec; dims=(192, 168), colormap="gray") 
	# convert vector into 3-dimensional array
	arr = applycolormap(reshape(vec, dims...), cmap(colormap)) 
	# converts to image
	return colorview(RGB, permuteddimsview(arr, (3,1,2)) ) 
end

# ╔═╡ d3fd4bb4-0cbc-475c-a4b8-d77003404903
begin
	file_contents = matread("../../DATA/allFaces.mat")	
	
	X = file_contents["faces"]
	nfaces = convert.(Int, file_contents["nfaces"])
	m = convert(Int, file_contents["m"])
	n = convert(Int, file_contents["n"])
	
	# Build Training and Test sets
	nTrain = 30;  nTest = 20;  nPeople = 20
	
	Train = zeros(size(X,1), nTrain * nPeople)
	Test = zeros(size(X,1), nTest * nPeople)
	
	for k=1:nPeople
    	baseind = 0
    	if k>1 	 baseind = sum(nfaces[1:k-1]) end
		inds = baseind .+ range(1, length=nfaces[k])
		
		Train[:, (k-1)*nTrain+1:k*nTrain ] = X[:, inds[1:nTrain] ]
		Test[:,(k-1)*nTest+1:k*nTest] = X[:,inds[nTrain+1:nTrain+nTest]] 
	end
end

# ╔═╡ 5842f6a4-4d2a-45fe-912d-2fc408c1f746
begin
	# Downsample training images (build Θ)
	M = size(Train, 2) 
	
	Θ = zeros(120, M)
	for k in range(1, stop=M)
	    temp = reshape(Train[:,k], n, m)
	    tempSmall = imresize(temp, 12, 10)
	    Θ[:, k] = vec(tempSmall)
	end
	# Renormalize columns of Θ
	norm_Θ = zeros(M)
	for k in 1:M
		norm_Θ[k] = norm(Θ[:,k])
		Θ[:, k] = Θ[:, k] ./ norm_Θ[k]
	end
end

# ╔═╡ cf35a7e8-3361-4e50-b7bd-a85b7d0e120d
Θ

# ╔═╡ 71bb3f98-78b4-4fda-ad34-6336e3d15cd3
begin
	# Occlude test image (Test[:, 126] = test image 6 person 7)
	x1 = Test[:, 126]   # clean image
	mustache = "mustache.jpg" |> load .|> Gray |> channelview
	mustache = 255 * mustache
	x2 = Test[:, 126] .* vec(mustache) ./ 255 # mustache
	x3 = copy(x1)
	for idx in rand(1:n*m, floor(Int, 0.3*n*m))
		x3[idx] = 255/2
	end 					#  x3 30% occluded
	x4 = x1 + 50*randn(n*m)  # x4 random noise	
	
	[vec_to_img(x1)    vec_to_img(x2)  vec_to_img(x3)  vec_to_img(x4)]
end

# ╔═╡ d67b2b67-a14d-4cee-a222-fe68dc587817
begin
	## Downsample Test Images
	test_pics = hcat(x1, x2, x3, x4)	
	Y = zeros(120, 4)
	for k in range(1, stop=4)
	    temp = reshape(test_pics[:, k], n, m)
	    tempSmall = imresize(temp, 12, 10)
	    Y[:, k] = vec(tempSmall)
	end
	[vec_to_img(Y[:,k], dims=(12,10)) for k in 1:4]
end

# ╔═╡ 8a66de1d-b002-4af8-9960-0a7830b202b1
md"# L1 Search, Testclean"

# ╔═╡ 4e89bcee-d8cc-4fe9-8257-6038b2a9587d
begin
	## L1 Search, Testclean
	y₁ = Y[:, 1]
	ϵ = 0.01
	# L1 Minimum norm solution s₁
	s₁ = Variable(M)	# sparse vector of M coefficients
	objective = norm(s₁, 1)
	constraints  = [norm(Θ * s₁ - y₁, 2) < ϵ]
	problem = minimize(objective, constraints)
	solve!(problem, () -> ECOS.Optimizer(verbose=false))	
	# Get the optimum variables
	s₁ = Convex.evaluate(s₁)
end

# ╔═╡ 9a570a13-9791-415a-adaa-afb4ce5b1997
count([abs(i)≈0 for i in s₁])  # nothing went all the way down to zero

# ╔═╡ cf775e4a-d8fa-43e7-ab03-81f7c16b5cca
sparsify(x) = [abs(xᵢ)<0.00001 ? 0.0 : xᵢ     for xᵢ in x]

# ╔═╡ 5e03b993-d5ac-4704-9714-26ca7f230ddd
sparse_s₁ = sparsify(s₁)

# ╔═╡ d9d5f6fe-fbd9-43b5-b576-183c6dfd5510
count([abs(i)≈0 for i in sparse_s₁])  # there were plenty of super-small entries

# ╔═╡ 441dc1b2-7331-421b-b215-db1df0b03e71
scatter(sparse_s₁, label="sparse_s₁")

# ╔═╡ eb37ac2e-1697-4a1d-baba-3dbfe7b1518c
# Original vs. Reconstruction
[vec_to_img(x1)    vec_to_img(Train * (sparse_s₁ ./ norm_Θ) ) ]

# ╔═╡ b62df870-789a-4d54-bdf2-7a32ca9e328a
begin
	binErr = zeros(nPeople)
	for k in range(1, stop = nPeople)
	    L = range( (k-1) * nTrain + 1,   stop = k * nTrain )
	    binErr[k] = norm( x1 - (Train[:,L] * (sparse_s₁[L]./norm_Θ[L])) )  / norm(x1)
	end
	bar(binErr, label=false, title="Reconstruction errors", ylabel="ϵₖ", xlabel="Person #k")
end

# ╔═╡ f123641f-4e11-4b0c-bb82-356da5051df6
md"# L1 Search, Mustache"

# ╔═╡ 381e4272-3264-46b6-b72a-ff8acb830267
begin
	## L1 Search, Mustache
	y2 = copy(Y[:,2])
	ϵ2 = 500
	
	# L1 Minimum norm solution s2
	s2 = Variable(M)	# sparse vector of M coefficients
	objective2 = norm(s2, 1)
	constraints2  = [ norm(Θ * s2 - y2, 2) < ϵ2 ]
	problem2 = minimize(objective2, constraints2)
	solve!(problem2, () -> ECOS.Optimizer(verbose=false))	
	# Get the optimum variables
	sparse_s2 = sparsify(Convex.evaluate(s2))
	scatter(sparse_s2, label="sparse_s2")
end

# ╔═╡ dedd16e2-e4b9-450c-8812-2223ec42d46b
# Original vs. Reconstruction, Sparse errors
[vec_to_img(x1)    vec_to_img(Train * (sparse_s2 ./ norm_Θ) )    vec_to_img(x2 - Train * (sparse_s2 ./ norm_Θ) )  ]

# ╔═╡ e8691bcb-a735-48da-9681-6ea111c275a2
begin
	binErr2 = zeros(nPeople)
	for k in range(1, stop = nPeople)
	    L = range( (k-1) * nTrain + 1,   stop = k * nTrain )
	    binErr2[k] = norm( x2 - (Train[:,L] * (sparse_s2[L]./norm_Θ[L])) )  / norm(x2)
	end
	bar(binErr2, label=false, title="Reconstruction errors", ylabel="ϵₖ", xlabel="Person #k")
end

# ╔═╡ c0f5fe62-01dd-4692-bc4f-d5fbe6ef0cec
md"# L1 Search, Occlusion"

# ╔═╡ 1e585617-9f18-4eec-9f79-f142d7007090
begin
	## L1 Search, Occlusion
	y3 = copy(Y[:,3])
	ϵ3 = 1000
	
	# L1 Minimum norm solution s3
	s3 = Variable(M)	# sparse vector of M coefficients
	objective3 = norm(s3, 1)
	constraints3  = [ norm(Θ * s3 - y3, 2) < ϵ3 ]
	problem3 = minimize(objective3, constraints3)
	solve!(problem3, () -> ECOS.Optimizer(verbose=false))	
	# Get the optimum variables
	sparse_s3 = sparsify(Convex.evaluate(s3))
	
	scatter(sparse_s3, label="sparse_s3")
end

# ╔═╡ 076dbbbd-ba81-4e64-b879-0524035a8561
begin
	binErr3 = zeros(nPeople)
	for k in range(1, stop = nPeople)
	    L = range( (k-1) * nTrain + 1,   stop = k * nTrain )
	    binErr3[k] = norm( x3 - (Train[:,L] * (sparse_s3[L]./norm_Θ[L])) )  / norm(x3)
	end
	bar(binErr3, label=false, title="Reconstruction errors", ylabel="ϵₖ", xlabel="Person #k")
end

# ╔═╡ 6885aa8a-28fe-417e-94a4-f4291489ea97
# Original vs. Reconstruction, Sparse errors
[vec_to_img(x3)    vec_to_img(Train * (sparse_s3 ./ norm_Θ) )    vec_to_img(x3 - Train * (sparse_s3 ./ norm_Θ) )  ]

# ╔═╡ ad210433-0348-4751-9f7a-f50c95e4e02b
md"# L1 Search, noise"

# ╔═╡ 5d1ecc01-0143-4a77-8b69-6c3bd0f89e90
begin
	## L1 Search, noise
	y4 = copy(Y[:,4])
	ϵ4 = 400
	
	# L1 Minimum norm solution s4
	s4 = Variable(M)	# sparse vector of M coefficients
	objective4 = norm(s4, 1)
	constraints4  = [ norm(Θ * s4 - y4, 2) < ϵ4 ]
	problem4 = minimize(objective4, constraints4)
	solve!(problem4, () -> ECOS.Optimizer(verbose=false))	
	# Get the optimum variables
	sparse_s4 = Convex.evaluate(s4) |> sparsify
	scatter(sparse_s4, label="sparse_s4")
end

# ╔═╡ 9af4d9e9-9ab0-4a0c-ad4e-4318646baeb8
# Original vs. Reconstruction, Sparse errors
[vec_to_img(x4)    vec_to_img(Train * (sparse_s4 ./ norm_Θ) )    vec_to_img(x4 - Train * (sparse_s4 ./ norm_Θ) )  ]

# ╔═╡ 0982b3de-c95a-4048-9bf7-d108e6023f48
begin
	binErr4 = zeros(nPeople)
	for k in range(1, stop = nPeople)
	    L = range( (k-1) * nTrain + 1,   stop = k * nTrain )
	    binErr4[k] = norm( x4 - (Train[:,L] * (sparse_s4[L]./norm_Θ[L])) )  / norm(x4)
	end
	bar(binErr4, label=false, title="Reconstruction errors", ylabel="ϵₖ", xlabel="Person #k")
end

# ╔═╡ 47ca5124-5518-48bd-b20f-0844fc8b648f
md"# Least square is no good"

# ╔═╡ 216930e6-a53f-49ee-aada-40a4d0c8b61d
begin
	# Least square is no good
	s4L2 = pinv(Train)*x4
	sparse_s4L2 = s4L2 |> sparsify
	scatter(sparse_s4L2, label="sparse_s4L2")
end

# ╔═╡ 8ddfc22f-077f-42ca-85ea-fdda80f76ae0
# Original vs. Reconstruction, Sparse errors
[vec_to_img(x4)    vec_to_img(Train * (sparse_s4L2 ./ norm_Θ) )    vec_to_img(x4 - Train * (sparse_s4L2 ./ norm_Θ) )  ]

# ╔═╡ 0ee4eb7f-8d0a-40bc-bd3e-2fc5e49f0377
begin
	binErr4L2 = zeros(nPeople)
	for k in range(1, stop = nPeople)
	    L = range( (k-1) * nTrain + 1,   stop = k * nTrain )
	    binErr4L2[k] = norm( x4 - (Train[:,L] * (sparse_s4L2[L]./norm_Θ[L])) )  / norm(x4)
	end
	bar(binErr4L2, label=false, title="Reconstruction errors", ylabel="ϵₖ", xlabel="Person #k")
end

# ╔═╡ 4fd0fd0b-8ce6-4158-b0e1-77dd5c667c9f
md"*The repetitive work screams for functions, which would be more Julian...*"

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
# ╠═49da2c55-f142-4ed6-9e43-bce350acfcab
# ╠═a216e475-f92a-43d9-b11e-7814f3c95e10
# ╠═d3fd4bb4-0cbc-475c-a4b8-d77003404903
# ╠═5842f6a4-4d2a-45fe-912d-2fc408c1f746
# ╠═cf35a7e8-3361-4e50-b7bd-a85b7d0e120d
# ╠═71bb3f98-78b4-4fda-ad34-6336e3d15cd3
# ╠═d67b2b67-a14d-4cee-a222-fe68dc587817
# ╟─8a66de1d-b002-4af8-9960-0a7830b202b1
# ╠═4e89bcee-d8cc-4fe9-8257-6038b2a9587d
# ╠═9a570a13-9791-415a-adaa-afb4ce5b1997
# ╠═cf775e4a-d8fa-43e7-ab03-81f7c16b5cca
# ╠═5e03b993-d5ac-4704-9714-26ca7f230ddd
# ╠═d9d5f6fe-fbd9-43b5-b576-183c6dfd5510
# ╠═441dc1b2-7331-421b-b215-db1df0b03e71
# ╠═eb37ac2e-1697-4a1d-baba-3dbfe7b1518c
# ╠═b62df870-789a-4d54-bdf2-7a32ca9e328a
# ╟─f123641f-4e11-4b0c-bb82-356da5051df6
# ╠═381e4272-3264-46b6-b72a-ff8acb830267
# ╠═dedd16e2-e4b9-450c-8812-2223ec42d46b
# ╠═e8691bcb-a735-48da-9681-6ea111c275a2
# ╟─c0f5fe62-01dd-4692-bc4f-d5fbe6ef0cec
# ╠═1e585617-9f18-4eec-9f79-f142d7007090
# ╠═076dbbbd-ba81-4e64-b879-0524035a8561
# ╠═6885aa8a-28fe-417e-94a4-f4291489ea97
# ╟─ad210433-0348-4751-9f7a-f50c95e4e02b
# ╠═5d1ecc01-0143-4a77-8b69-6c3bd0f89e90
# ╠═9af4d9e9-9ab0-4a0c-ad4e-4318646baeb8
# ╠═0982b3de-c95a-4048-9bf7-d108e6023f48
# ╟─47ca5124-5518-48bd-b20f-0844fc8b648f
# ╠═216930e6-a53f-49ee-aada-40a4d0c8b61d
# ╠═8ddfc22f-077f-42ca-85ea-fdda80f76ae0
# ╠═0ee4eb7f-8d0a-40bc-bd3e-2fc5e49f0377
# ╟─4fd0fd0b-8ce6-4158-b0e1-77dd5c667c9f
# ╟─88a367b5-686c-45bb-b9e1-2517e734fd3b
