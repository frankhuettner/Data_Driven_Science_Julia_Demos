### A Pluto.jl notebook ###
# v0.14.7

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

# ╔═╡ ec291004-f61f-4dba-b084-4e4e79281c25
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add(["Plots", "Images", "LinearAlgebra", "Statistics", "PlutoUI"]) 
    using Plots, Images, LinearAlgebra, Statistics, PlutoUI
	
	Pkg.add("MAT") # used for reading *.mat files
	using MAT 	
end

# ╔═╡ d949c318-8f02-11eb-22eb-a1442d4594d8
md"Left the average, right the first factor"

# ╔═╡ 7f96e630-8ac9-11eb-3a04-a921c2307522
begin
	mat_contents = matread("allFaces.mat")	
	faces = mat_contents["faces"]
	m = convert(Int, mat_contents["m"])
	n = convert(Int, mat_contents["n"])
	nfaces = convert.(Int, mat_contents["nfaces"])
	
	# We use the first 36 people for training data
	trainingFaces = faces[ :, 1:sum(nfaces[1:36]) ]
	avgFace = mean(trainingFaces, dims=2) # size n*m by 1
	
	# Compute eigenfaces on mean-subtracted training data
	X = trainingFaces .- avgFace
	U, Σ, V = svd(X)	
	
	# A little helper function that converts a vector to an image
	# Alternatively, I could use heatmap, though this has poor performance
	vec2img(u) = reshape(normalize(u.-findmin(u)[1])*n*m/255,n,m) .|> Gray
	
	
	[vec2img(avgFace) vec2img(U[:,1])]
end

# ╔═╡ 6b8ef6b3-2a01-4043-83c0-3f4cb069ebe8
## Now show eigenface reconstruction of other images

begin
	using FileIO
	function get_img(url, x1, y1, scaler)
		pic = url |> download |> load
		img_cropped = pic[ floor(Int, x1*n) : floor(Int, x1*n+scaler*n), 
							floor(Int, y1*m) : floor(Int, y1*m+scaler*m)]
		img_resized = imresize(img_cropped, n,m)
		img2 = Gray.(img_resized)
		img2 = vec(img2)
		img2 = Float64.(img2)
	end
end

# ╔═╡ 903bb8ce-8ac9-11eb-00ea-e3cf0b177729
begin
	## Now show eigenface reconstruction of image that was omitted from test set
	testFace = faces[:,1+sum(nfaces[1:36])] # First face of person 37
	vec2img(testFace)
	
	testFaceMS = testFace - avgFace
	
	images = []
	for r in [25, 50, 100, 200, 400, 800, 1600, 2000, 2282]
		
		reconFace = avgFace + U[:,1:r] * U[:,1:r]' * testFaceMS
		push!(images,vec2img(reconFace))
	end				
end 


# ╔═╡ fd159e2c-8ad7-11eb-09ce-513b9574a1c4
@bind r_select Slider(1:length(images))

# ╔═╡ 721068d8-8f01-11eb-3d98-b98d14c11986
"Using the first $([25, 50, 100, 200, 400, 800, 1600, 2000, 2282][r_select]) of the $(length(Σ)) column vectors of U"

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

# ╔═╡ 0260ded6-cfbf-4b1e-8268-029c45ec321e
md"## Let's try some other pictures"

# ╔═╡ 9a976058-e3b9-4438-9dc1-2aefda8a4816
begin
	## Now show eigenface reconstruction of other images

	img2 = get_img("https://upload.wikimedia.org/wikipedia/commons/b/b4/Kafka.jpg", 
					3.9, 3.7, 4.0)
	img3 = get_img("https://upload.wikimedia.org/wikipedia/commons/0/05/Portrait_of_Beelte_from_Scarabaeidae_family.jpg", 1.3, 4.5, 14.5)
	img4 = get_img("https://upload.wikimedia.org/wikipedia/commons/9/94/Maggiolino_Type_1.jpg", .01, 1.3, 4.99)
	
	
	img2MS = img2 - avgFace
	img3MS = img3 - avgFace
	img4MS = img4 - avgFace
	
	images2 = []
	images3 = []
	images4 = []
	for r2 in [25, 50, 100, 200, 400, 800, 1600, 2000, 2282]
		UUr = U[:,1:r2] * U[:,1:r2]'
		reconFace2 = avgFace + UUr * img2MS
		reconFace3 = avgFace + UUr * img3MS
		reconFace4 = avgFace + UUr * img4MS
		
		push!(images2,vec2img(reconFace2))
		push!(images3,vec2img(reconFace3))
		push!(images4,vec2img(reconFace4))
	end		
	
end

# ╔═╡ a095cb21-3e67-41f4-b9c2-3d6f7a10c304
md"Move the slider for a transformation"

# ╔═╡ 3b3fb939-c5d8-44a0-8777-8ef722819b1c
@bind r_select2 Slider(1:length(images2))

# ╔═╡ 62e7b1fa-1b94-49d1-b5df-cadc83214edd
"Using the first $([25, 50, 100, 200, 400, 800, 1600, 2000, 2282][r_select2]) of the $(length(Σ)) column vectors of U"

# ╔═╡ 292c5dce-55c7-474b-aca4-5cd9f58038f7
[images2[r_select2]   images3[r_select2]  images4[r_select2] ]

# ╔═╡ 3532614c-3eb7-48f5-9481-f300f41a7269
# [vec2img(img2)   vec2img(img3)  vec2img(img4) ]  # Uncomment to see original

# ╔═╡ 5ef7e064-fbb5-4041-bfab-bbd39f35f5b7
md"Sources:
* https://upload.wikimedia.org/wikipedia/commons/b/b4/Kafka.jpg
* https://upload.wikimedia.org/wikipedia/commons/0/05/Portrait_of_Beelte_from_Scarabaeidae_family.jpg
* https://upload.wikimedia.org/wikipedia/commons/9/94/Maggiolino_Type_1.jpg
"

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
# ╠═ec291004-f61f-4dba-b084-4e4e79281c25
# ╟─d949c318-8f02-11eb-22eb-a1442d4594d8
# ╠═7f96e630-8ac9-11eb-3a04-a921c2307522
# ╠═903bb8ce-8ac9-11eb-00ea-e3cf0b177729
# ╟─fd159e2c-8ad7-11eb-09ce-513b9574a1c4
# ╟─721068d8-8f01-11eb-3d98-b98d14c11986
# ╠═86bd0206-8ad2-11eb-26c5-8f6f29275528
# ╠═2ef25f94-8ad7-11eb-368e-ad8a674b6ff8
# ╟─0260ded6-cfbf-4b1e-8268-029c45ec321e
# ╟─6b8ef6b3-2a01-4043-83c0-3f4cb069ebe8
# ╠═9a976058-e3b9-4438-9dc1-2aefda8a4816
# ╟─a095cb21-3e67-41f4-b9c2-3d6f7a10c304
# ╟─3b3fb939-c5d8-44a0-8777-8ef722819b1c
# ╟─62e7b1fa-1b94-49d1-b5df-cadc83214edd
# ╠═292c5dce-55c7-474b-aca4-5cd9f58038f7
# ╠═3532614c-3eb7-48f5-9481-f300f41a7269
# ╟─5ef7e064-fbb5-4041-bfab-bbd39f35f5b7
# ╟─37e93b54-8f05-11eb-348b-79c9875ff384
