### A Pluto.jl notebook ###
# v0.12.21

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

# ╔═╡ 7f96e630-8ac9-11eb-3a04-a921c2307522
begin
	using Images
	using LinearAlgebra
	using Statistics
	using Plots
	using MAT
	using PlutoUI
	
	mat_contents = matread("../DATA/allFaces.mat")	# import function from MAT.jl
	faces = mat_contents["faces"]
	m = convert(Int, mat_contents["m"])
	n = convert(Int, mat_contents["n"])
	nfaces = convert.(Int, mat_contents["nfaces"])
	
	# We use the first 36 people for training data
	trainingFaces = faces[ :, 1:sum(nfaces[1:36]) ]
	avgFace = mean(trainingFaces, dims=2) # size n*m by 1
	
	# Compute eigenfaces on mean-subtracted training data
	X = trainingFaces .- avgFace
	U, σs, V = svd(X)	
	
	# A little helper function that converts a vector to an image
	# Alternatively, I could use heatmap, though this has poor performance
	vec2img(u) = reshape(normalize(u.-findmin(u)[1])*n*m/255,n,m) .|> Gray
	
	
	[vec2img(avgFace) vec2img(U[:,1])]
end

# ╔═╡ d949c318-8f02-11eb-22eb-a1442d4594d8
md"Left the average, right the first factor"

# ╔═╡ 903bb8ce-8ac9-11eb-00ea-e3cf0b177729
begin
	## Now show eigenface reconstruction of image that was omitted from test set
	testFace = faces[:,1+sum(nfaces[1:36])] # First face of person 37
	vec2img(testFace)
	
	testFaceMS = testFace - avgFace
	
	images = []
	for r in [25, 50, 100, 200, 400, 800, 1600]
		
		reconFace = avgFace + U[:,1:r] * U[:,1:r]' * testFaceMS
		push!(images,vec2img(reconFace))
	end				
end 


# ╔═╡ fd159e2c-8ad7-11eb-09ce-513b9574a1c4
@bind r_select Slider(1:7)

# ╔═╡ 721068d8-8f01-11eb-3d98-b98d14c11986
"Rank is $([25, 50, 100, 200, 400, 800, 1600][r_select])"

# ╔═╡ 86bd0206-8ad2-11eb-26c5-8f6f29275528
[vec2img(testFace) images[r_select] ]

# ╔═╡ 2ef25f94-8ad7-11eb-368e-ad8a674b6ff8
begin
	## Project person 2 and 7 onto PC5 and PC6
	
	P1num = 2 # Person number 2
	P2num = 7 # Person number 7
	
	P1 = faces[:, 1+sum(nfaces[1:(P1num-1)]):sum(nfaces[1:P1num])]
	P2 = faces[:, 1+sum(nfaces[1:(P2num-1)]):sum(nfaces[1:P2num])]
	
	P1 = P1 - avgFace*ones(1,size(P1,2))
	P2 = P2 - avgFace*ones(1,size(P2,2))
	
	PCAmodes = [5, 6] # Project onto PCA modes 5 and 6
	PCACoordsP1 = U[:,PCAmodes]' * P1
	PCACoordsP2 = U[:,PCAmodes]' * P2
	
	scatter(PCACoordsP1[1,:],PCACoordsP1[2,:],label="Person 2")
	scatter!(PCACoordsP2[1,:],PCACoordsP2[2,:],label="Person 7", markershape=:^)	
end

# ╔═╡ 37e93b54-8f05-11eb-348b-79c9875ff384
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
# ╟─d949c318-8f02-11eb-22eb-a1442d4594d8
# ╠═7f96e630-8ac9-11eb-3a04-a921c2307522
# ╠═903bb8ce-8ac9-11eb-00ea-e3cf0b177729
# ╟─fd159e2c-8ad7-11eb-09ce-513b9574a1c4
# ╟─721068d8-8f01-11eb-3d98-b98d14c11986
# ╠═86bd0206-8ad2-11eb-26c5-8f6f29275528
# ╠═2ef25f94-8ad7-11eb-368e-ad8a674b6ff8
# ╟─37e93b54-8f05-11eb-348b-79c9875ff384
