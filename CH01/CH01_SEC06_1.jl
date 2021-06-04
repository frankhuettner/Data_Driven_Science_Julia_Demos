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

# ╔═╡ 004d70db-c9a2-4302-8b92-41b2b80272f3
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add(["Plots", "Images", "LinearAlgebra",  "PlutoUI"]) 
    using Plots, Images, LinearAlgebra, MAT, PlutoUI
	
	Pkg.add("MAT") # used for reading *.mat files
	using MAT 	
	
end

# ╔═╡ 67e80ec4-8a18-11eb-3c07-699266a9e1b3
mat_contents = matread("allFaces.mat")	# import function from MAT.jl

# ╔═╡ 81b0dec0-8a18-11eb-32aa-53231cb2bce8
begin
	faces = mat_contents["faces"]
	m = convert(Int, mat_contents["m"])
	n = convert(Int, mat_contents["n"])
	nfaces = convert.(Int, mat_contents["nfaces"])
	
	allPersons = zeros(n*6, m*6)
end

# ╔═╡ 8412e938-8a1b-11eb-3c33-393e90ef1434
let    # "let" keeps the variables local
	count = 1	
	for i=1:6 	# i is not the imaginary number im but can be used as index 
		for j=1:6
			allPersons[1+(i-1)*n:i*n, 1+(j-1)*m:j*m] = 	
				reshape(faces[:,1+sum(nfaces[1:count-1])],n,m);
			count = count + 1;
		end
	end
	colorview(Gray, allPersons./255)
end

# ╔═╡ 846d2ff8-8a28-11eb-3512-5fe4d132f90e
@bind person Slider(1:length(nfaces); default=1, show_value=true)

# ╔═╡ 4c3a49ca-8a20-11eb-3208-55c7ed39a41c
begin 
	subset_start = 1+sum(nfaces[1:person-1])
	subset_end = sum(nfaces[1:person])
	subset = faces[:,subset_start:subset_end  ]
	allFaces = zeros(n*8,m*8)

	count = 1

	for i=1:8
		for j=1:8
			if count <= nfaces[person] 
				allFaces[1+(i-1)*n:i*n,1+(j-1)*m:j*m] = 
						reshape(subset[:,count],n,m)
				count = count + 1
			end
		end
	end
	colorview(Gray, allFaces./255)
end

# ╔═╡ 331a33a8-8f05-11eb-2c79-757b13b2426d
let # Loading the disclaimer
	url = "https://github.com/frankhuettner/Data_Driven_Science_Julia_Demos/raw/main/disclaimer.md"
	datafile = url |> download 
    datafile = open(datafile,"r")
    lines = readlines(datafile)
    close(datafile)
    lines[1]
	Markdown.parse(lines[1]) 
end

# ╔═╡ f28304aa-b172-47b7-a548-82daa29f80b9
typeof(im)

# ╔═╡ Cell order:
# ╠═004d70db-c9a2-4302-8b92-41b2b80272f3
# ╠═67e80ec4-8a18-11eb-3c07-699266a9e1b3
# ╠═81b0dec0-8a18-11eb-32aa-53231cb2bce8
# ╠═8412e938-8a1b-11eb-3c33-393e90ef1434
# ╠═846d2ff8-8a28-11eb-3512-5fe4d132f90e
# ╠═4c3a49ca-8a20-11eb-3208-55c7ed39a41c
# ╟─331a33a8-8f05-11eb-2c79-757b13b2426d
# ╠═f28304aa-b172-47b7-a548-82daa29f80b9
