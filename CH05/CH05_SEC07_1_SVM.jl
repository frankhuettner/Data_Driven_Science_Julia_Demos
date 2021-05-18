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
        Pkg.PackageSpec(name="StatsBase"),        
		Pkg.PackageSpec(name="ScikitLearn"),
        Pkg.PackageSpec(name="StatsPlots"),
        Pkg.PackageSpec(name="MAT"),
        Pkg.PackageSpec(name="LinearAlgebra"),
    ])
    using Plots
	using MAT
	using StatsBase
	using LinearAlgebra
	using ScikitLearn
end

# ╔═╡ 4679654b-2f08-49fa-a93c-68d93ffaa240
begin 	
	n1 = 300 # training set size
	
	r = 7 .+ randn(n1)
	th = 2 * π * randn(n1)
	xr = r .* cos.(th)
	yr = r .* sin.(th)

	x5 = randn(n1)
	y5 = randn(n1)
	
	subplot_2 = scatter(xr, yr, c=:lime, 
		ms=5, leg=false, xlim=(-10,10), ylim=(-10,10))
	scatter!(x5, y5, c=:magenta, ms=5)	
end

# ╔═╡ 38c9ccdf-5fa2-43f4-979a-29116f82784a
begin
	X = -10:0.5:10
	Y = -10:0.5:10	
	F3 = [54 + 0 * x + 0 * y for x in X, y in Y]
	surface(X, Y, F3', c=:gray, alpha=.2, leg=false, xlim=(-10,10), ylim=(-10,10))
	
	zr = (xr.^2 + yr.^2) 
	scatter!(xr, yr, zr .+ 40, ms=5, c=:lime)
	z5 = (x5.^2 + y5.^2)	
	scatter!(x5, y5, z5 .+ 40, ms=5, c=:magenta)
	
	z5 = (x5.^2+y5.^2)	
	scatter!(xr, yr, zeros(n1), ms=5, c=:lime, alpha=.3, 
		leg=false, xlim=(-10,10), ylim=(-10,10))
	scatter!(x5, y5, zeros(n1), ms=5, c=:magenta, alpha=.3)
	scatter!(x5, y5, zeros(n1), ms=5, c=:magenta, alpha=.3)
	
	θ = range(0, stop=2*π, length=100)
	xrr = √14 * cos.(θ)
	yrr = √14 * sin.(θ)
	plot!(xrr, yrr, zeros(100), c=:black, lw=2)	
end

# ╔═╡ 1b6b0bb1-08f7-4d5f-afda-f015f47fc0e6
# Classify dogs vs. cats
begin	
	dogdata_w_mat = matread("dogData_w.mat")
	catdata_w_mat = matread("catData_w.mat")
	
	dog_wave = dogdata_w_mat["dog_wave"]
	cat_wave = catdata_w_mat["cat_wave"]
	
	CD_wave = [dog_wave cat_wave]
	u_wave,s_wave,v_wave = svd(CD_wave .- mean(CD_wave))	
	
	features = 1:20

	xtrain_wave = [v_wave[1:60,features]; v_wave[81:140,features]]
	label = convert.(Int,[ones(60); -1*ones(60)])
	test_wave =  [v_wave[61:80,features]; v_wave[141:160,features]]	
	truth = convert.(Int,[ones(20); -1*ones(20)])
end

# ╔═╡ 96c2d0d4-2be4-496c-b0a8-de980811c817
# Loading the LogisticRegression model from scikit-learn's library
@sk_import svm: SVC

# ╔═╡ 58c27295-5e2e-47b8-93c3-7109701d7dac
# Construct model
Mdl = SVC(kernel=:rbf, gamma=:auto)

# ╔═╡ fcd64c7d-4028-4a57-84b1-4089061f8ef4
begin
	# Train the model
	using ScikitLearn: fit!, predict  # avoiding conflict with fit! from Statsbase
	fit!(Mdl, xtrain_wave, label)
	
	# Cross-validate the model
	using ScikitLearn.CrossValidation: cross_val_score
	CMdl = cross_val_score(SVC(kernel=:rbf, gamma=:auto), xtrain_wave, label, cv=10)
end

# ╔═╡ 317dd3d5-e7cc-41b1-9519-237a2360107d
# Making predictions
test_labels = predict(Mdl, test_wave)

# ╔═╡ ec006012-2d97-49b6-ac3f-38ce856ae569
# Average error over all cross-validation iterations
classLoss = 1 - mean(CMdl)

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
# ╠═4679654b-2f08-49fa-a93c-68d93ffaa240
# ╠═38c9ccdf-5fa2-43f4-979a-29116f82784a
# ╠═1b6b0bb1-08f7-4d5f-afda-f015f47fc0e6
# ╠═96c2d0d4-2be4-496c-b0a8-de980811c817
# ╠═58c27295-5e2e-47b8-93c3-7109701d7dac
# ╠═fcd64c7d-4028-4a57-84b1-4089061f8ef4
# ╠═317dd3d5-e7cc-41b1-9519-237a2360107d
# ╠═ec006012-2d97-49b6-ac3f-38ce856ae569
# ╟─3d560fb8-8f05-11eb-1603-87841aa9858a
