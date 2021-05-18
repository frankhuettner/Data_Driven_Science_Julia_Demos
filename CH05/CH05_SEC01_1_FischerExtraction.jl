### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# ╔═╡ e31be176-376f-43f6-97a2-be53c555e6ff
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="Plots"),
        Pkg.PackageSpec(name="LinearAlgebra"),
        Pkg.PackageSpec(name="DataFrames"),
        Pkg.PackageSpec(name="RDatasets"),
        Pkg.PackageSpec(name="MAT"),
        Pkg.PackageSpec(name="StatsBase"),
        Pkg.PackageSpec(name="StatsPlots"),    
    ])
    using Plots, LinearAlgebra, DataFrames, RDatasets, MAT, StatsBase, StatsPlots
end

# ╔═╡ d3aae195-3e34-4eab-aab4-499c95df7444
begin
	iris = dataset("datasets", "iris")
	x1 = iris[1:50,1:4] |> Matrix # setosa
	x2 = iris[51:100,1:4] |> Matrix # versicolor
	x3 = iris[101:end,1:4] |> Matrix # virginica	
end

# ╔═╡ df472fac-0e6b-4488-8314-6326efa86b2c
let
	plotly()
	scatter(x1[:,1], x1[:,2], x1[:,4], c=:green, marker=:o, leg=false)
	scatter!(x2[:,1], x2[:,2], x2[:,4], c=:magenta, marker=:o)
	scatter!(x3[:,1], x3[:,2], x3[:,4], c=:red, marker=:o)
end

# ╔═╡ 5a755da2-3a84-4fd2-bac1-a750201c3b54
begin
	dogdata_mat = matread("dogData.mat")
	catdata_mat = matread("catData.mat")
	
	dogdata_w_mat = matread("dogData_w.mat")
	catdata_w_mat = matread("catData_w.mat")
	
	dog = dogdata_mat["dog"]
	cat = catdata_mat["cat"]

	dog_wave = dogdata_w_mat["dog_wave"]
	cat_wave = catdata_w_mat["cat_wave"]
	

	CD = [dog cat]
	CD2 = [dog_wave cat_wave]
	u,s,v = svd(CD .- mean(CD))
	u2,s2,v2 = svd(CD2 .- mean(CD2))
	vT = v'
	vT2 = v2'
	
end

# ╔═╡ 4eaf4c0a-c9c8-44fa-a4fa-bd0b3a19b5dc
let
	gr()
	heatplots = []
	for j = 1:4
		U = reshape(u[:,j],64,64)
		U2 = U[1:2:64,1:2:64] 
		U2 = reverse(U2, dims=1)
		push!(heatplots, heatmap(U2, c=:hot, leg=false, axis=nothing, ratio=:equal) )
	end
	plot(heatplots...)
end

# ╔═╡ 2a7e72f7-3614-4a93-93c0-5564b8d932aa
let
	gr()
	barplots = []
	for j = 1:4			
		push!(barplots, bar(v[:,j], leg=false) )
	end
	plot(barplots..., layout=(4,1))		
end

# ╔═╡ 35e5ab97-67c4-4866-a10c-9eac9e9d341b
let
	gr()
	heatplots = []
	for j = 1:4
		X = reverse( reshape(dog_wave[:,j],32,32), dims=1)
		push!(heatplots, heatmap(X, c=:hot, leg=false, axis=nothing, ratio=:equal) )
	end
	plot(heatplots...)
end

# ╔═╡ db00d1d9-eb00-4caf-9022-07812bda10be
let
	gr()
	heatplots = []
	for j = 1:4
		U3 = reverse( reshape(u2[:,j],32,32), dims=1)
		push!(heatplots, heatmap(U3, c=:hot, leg=false, axis=nothing, ratio=:equal) )
	end
	plot(heatplots...)
end

# ╔═╡ c9de555e-d713-4331-893b-86079fb0c801
let
	gr()
	barplots = []
	for j = 1:4			
		push!(barplots, bar(v2[:,j], leg=false) )
	end
	plot(barplots..., layout=(4,1))		
end

# ╔═╡ 0648ffd0-402d-4f32-a032-42dd74142926
let
	gr()
	pdfplots = []
	xbin = range(-0.25,stop=0.25,length=21)

	for j=1:4
		pdf1 = fit(Histogram, v[1:80,j], xbin)
		pdf2 = fit(Histogram, v[81:160,j], xbin)
		
		push!(pdfplots, plot(range(-0.25,stop=0.25,length=20), 
				[pdf1.weights, pdf2.weights], leg=false, lw=2) )
		
		pdf1 = fit(Histogram, v2[1:80,j], xbin)
		pdf2 = fit(Histogram, v2[81:160,j], xbin)
		
		push!(pdfplots, plot(range(-0.25,stop=0.25,length=20), 
				[pdf1.weights, pdf2.weights], leg=false, lw=2) )
		
	end
	plot(pdfplots..., layout=(4,2))
end

# ╔═╡ 11752f3a-cb4d-4742-9eff-ec315b281e0b
let
	gr()
	scatter(v[1:80,1],v[1:80,2],v[1:80,3], c=:red, marker=:o, leg=false)
	scatter!(v[81:end,1],v[81:end,2],v[81:end,3], c=:blue, marker=:o, leg=false)	
end

# ╔═╡ e0986a28-7091-4b2f-ba96-ac2b7845348a
let
	gr()
	scatter(v2[1:80,1],v2[1:80,2],v2[1:80,3], c=:red, marker=:o, leg=false)
	scatter!(v2[81:end,1],v2[81:end,2],v2[81:end,3], c=:blue, marker=:o, leg=false)	
end

# ╔═╡ 08fa6756-86aa-4dcf-844c-21a0507a6110
let
	begin
		master = zeros(32*5,32*4)
		count = 1
		
		for jj in 1:4
		    for j in 1:5
		        T2 = reverse( reshape(dog[:,count],64,64), dims=1)
		        T = T2[1:2:64,1:2:64]
		        master[1+32*(j-1):32+32*(j-1),1+32*(jj-1):32+32*(jj-1)] = T
		        count += 1
			end
		end
	end
	heatmap(master, color = :greys, leg=false, axis=nothing, ratio=:equal)
end

# ╔═╡ 92f03c4e-81d7-47e9-b07a-8b994c795410
let
	begin
		master = zeros(32*5,32*4)
		count = 1
		
		for jj in 1:4
		    for j in 1:5
		        T2 = reverse( reshape(cat[:,count],64,64), dims=1)
		        T = T2[1:2:64,1:2:64]
		        master[1+32*(j-1):32+32*(j-1),1+32*(jj-1):32+32*(jj-1)] = T
		        count += 1
			end
		end
	end
	heatmap(master, color = :greys, leg=false, axis=nothing, ratio=:equal)
end

# ╔═╡ 3d560fb8-8f05-11eb-1603-87841aa9858a
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
# ╠═e31be176-376f-43f6-97a2-be53c555e6ff
# ╠═d3aae195-3e34-4eab-aab4-499c95df7444
# ╠═df472fac-0e6b-4488-8314-6326efa86b2c
# ╠═5a755da2-3a84-4fd2-bac1-a750201c3b54
# ╠═4eaf4c0a-c9c8-44fa-a4fa-bd0b3a19b5dc
# ╠═2a7e72f7-3614-4a93-93c0-5564b8d932aa
# ╠═35e5ab97-67c4-4866-a10c-9eac9e9d341b
# ╠═db00d1d9-eb00-4caf-9022-07812bda10be
# ╠═c9de555e-d713-4331-893b-86079fb0c801
# ╠═0648ffd0-402d-4f32-a032-42dd74142926
# ╠═11752f3a-cb4d-4742-9eff-ec315b281e0b
# ╠═e0986a28-7091-4b2f-ba96-ac2b7845348a
# ╠═08fa6756-86aa-4dcf-844c-21a0507a6110
# ╠═92f03c4e-81d7-47e9-b07a-8b994c795410
# ╟─3d560fb8-8f05-11eb-1603-87841aa9858a
