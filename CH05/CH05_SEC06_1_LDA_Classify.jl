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
        Pkg.PackageSpec(name="StatsBase"),        Pkg.PackageSpec(url="https://github.com/trthatcher/DiscriminantAnalysis.jl.git"),
        Pkg.PackageSpec(name="StatsPlots"),
        Pkg.PackageSpec(name="MAT"),
        Pkg.PackageSpec(name="Distributions"),
        Pkg.PackageSpec(name="StatsFuns"),
    ])
    using Plots, LinearAlgebra, StatsBase, DiscriminantAnalysis, StatsPlots, MAT
	using DiscriminantAnalysis: lda, posteriors, classify
	using StatsFuns
end

# ╔═╡ ba70c476-e89f-4e9a-a751-28ac2e679032
begin
	# For QDA, we'll use ScikitLearn
	Pkg.add(Pkg.PackageSpec(name="ScikitLearn"))
	using ScikitLearn
	using ScikitLearn: fit!, predict  # avoiding conflict with fit! from Statsbase
end

# ╔═╡ 2ee9eee7-8570-4b3e-b4e2-47a70b91c145
begin	
	dogdata_w_mat = matread("dogData_w.mat")
	catdata_w_mat = matread("catData_w.mat")
	
	dog_wave = dogdata_w_mat["dog_wave"]
	cat_wave = catdata_w_mat["cat_wave"]
	
	CD_wave = [dog_wave cat_wave]
	u_wave,s_wave,v_wave = svd(CD_wave .- mean(CD_wave))	

	xtrain_wave = [v_wave[1:60,2:2:4]; v_wave[81:140,2:2:4]]
	#   NOTE: classes must be indexed by integers from 1 to the number of 
	#         classes (2 in this case)	
	label = convert.(Int,[ones(60); 2*ones(60)])
	test_wave =  [v_wave[61:80,2:2:4]; v_wave[141:160,2:2:4]]	
end

# ╔═╡ a2533c1d-2c2d-44cd-b0bd-d9f992e2dbe2
begin	
	# Construct the LDA model
	model_wave = lda(xtrain_wave, label)
	
	# Get the posterior probabilities for new data
	# test_prob = posteriors(model, test)
	
	# Get the class predictions
	test_class_wave = classify(model_wave, test_wave)	
	
	truth = [ones(Int, 20);  2 * ones(Int, 20)] 
	E_wave = count(test_class_wave .== truth) / 40
	
	bar(2*test_class_wave .- 3.0, leg=false)
end

# ╔═╡ 4679654b-2f08-49fa-a93c-68d93ffaa240
E_wave

# ╔═╡ 69311ff3-f401-4547-8491-86f5103e6f36
begin
	scatter(v_wave[1:80,2],v_wave[1:80,4], c=:lime, ms=8, leg=false)
	scatter!(v_wave[81:end,2],v_wave[81:end,4], c=:magenta, ms=8)
end

# ╔═╡ cfc34074-c32a-469e-9ab8-796bb3b33985
let
	plots = []
	for j in 1:2
	    U3 = reverse(reshape(u_wave[:,2*j],(32,32)))
		push!(plots, heatmap(U3, ratio=:equal, color=:hot, leg=false, axis=nothing))
	end
	plot(plots...)
end

# ╔═╡ 0d00c667-c29d-4bca-b7ad-ca00e93c6aba
begin	
	dogdata_mat = matread("dogData.mat")
	catdata_mat = matread("catData.mat")
	
	dog = dogdata_mat["dog"]
	cat = catdata_mat["cat"]
	
	CD = [dog cat]
	u,s,v = svd(CD .- mean(CD))
	
	xtrain = [v[1:60,2:2:4]; v[81:140,2:2:4]]
	#   NOTE: classes must be indexed by integers from 1 to the number of 
	#         classes (2 in this case)	
	test =  [v[61:80,2:2:4]; v[141:160,2:2:4]]	
end

# ╔═╡ d883cdd5-93cf-4e88-84d3-cddb98970261
begin	
	# Construct the LDA model
	model = lda(xtrain, label)
	
	# Get the posterior probabilities for new data
	# test_prob = posteriors(model, test)
	
	# Get the class predictions
	test_class = classify(model, test)	
	
	E = count(test_class .== truth) / 40
	
	bar(2 * test_class .- 3.0, leg=false)
end

# ╔═╡ 9dceb5de-797b-46d6-be8e-62b1c636ae9c
E

# ╔═╡ 9da09a6f-6c9f-4f43-b8c0-98ff200f0dd0
begin
	scatter(v[1:80,2],v[1:80,4], c=:lime, ms=8, leg=false)
	scatter!(v[81:end,2],v[81:end,4], c=:magenta, ms=8)
end

# ╔═╡ e60b7829-f159-4fb2-a1f9-65b26f674383
begin
	## Cross-validate
	Es = zeros(100)
	
	for i=1:100  
		# There might be a mistake in the book: 
		#     ind2=r2(1:60)+60 should be ind2=r2(1:60)+80
		r1 = sample(1:80, 80, replace=false)
		r2 = sample(81:160, 80, replace=false)
		
		xtrain = [v[r1[1:60],2:2:4]; v[r2[1:60],2:2:4]]
		test = [v[r1[61:80],2:2:4]; v[r2[61:80],2:2:4]]
		
		model = lda(xtrain, label)
	    class = classify(model, test)	
		
	    Es[i] = count(class .== truth) / 40
	end
	bar(Es, leg=false, ylim=(0,1), title="Average = $(mean(Es))")
	plot!(1:100, mean(Es)*ones(100), lw=3, c=:red, ls=:dot)
end

# ╔═╡ f62a5d5f-d398-4025-8a50-9259c5779223
begin
	# Computing contour levels of labels to draw separation line
	X = range(minimum(v_wave[:,2]), stop = maximum(v_wave[:,2]), length = 1000)
	Y = range(minimum(v_wave[:,4]), stop = maximum(v_wave[:,4]), length = 1000)
	Z = [classify(model_wave, Matrix([x y]))[1] for x in X, y in Y]
end

# ╔═╡ bf5ed436-9323-4082-b57a-2fe63363e376
begin 
	lda_plt = scatter(v_wave[1:80,2],v_wave[1:80,4], c=:lime, ms=8, leg=false)
	scatter!(v_wave[81:end,2],v_wave[81:end,4], c=:magenta, ms=8)
	scatter!((model_wave.Θ.M[1,1], model_wave.Θ.M[1,2]), markershape=:star5, ms=10)
	scatter!((model_wave.Θ.M[2,1], model_wave.Θ.M[2,2]), markershape=:star5, ms=10)
	contour!(X, Y, Z', leg=false, title="Data and LDA separator")
end

# ╔═╡ b25814a6-741b-4e26-95ee-753639521135
begin
	scatter(v_wave[1:60,2],v_wave[1:60,4], 
		c=classify(model_wave, v_wave[1:60,2:2:4]), ms=8, leg=false)
	scatter!(v_wave[81:140,2],v_wave[81:140,4], 
		c=classify(model_wave, v_wave[81:140,2:2:4]), ms=8, leg=false)
	scatter!((model_wave.Θ.M[2,1], model_wave.Θ.M[2,2]), markershape=:star5, ms=10)
	scatter!((model_wave.Θ.M[1,1], model_wave.Θ.M[1,2]), markershape=:star5, ms=10)
	contour!(X, Y, Z', leg=false, title="Classification")
	
end

# ╔═╡ 2027e73a-31a3-47cf-bda9-6f4dd2d060f4
plot(1:160, posteriors(model_wave, v_wave[:,2:2:4])[:,1], markershape=:o, leg=false, title="Posterior Probability")

# ╔═╡ f38e5484-f2e9-46f3-b459-1b62ffcdb212
# Loading the QuadraticDiscriminantAnalysis from scikit-learn's library
@sk_import discriminant_analysis: QuadraticDiscriminantAnalysis

# ╔═╡ 620bfec8-b493-4249-9099-ab3cb8789e71
# Construct model
Mdl_qda = QuadraticDiscriminantAnalysis()

# ╔═╡ 289265ac-9715-497e-9471-5bce3168fcf1
# Train the model
fit!(Mdl_qda, xtrain_wave, label)

# ╔═╡ 9add6bf3-f779-489d-8dbf-6935e8dcb825
# Making predictions
Z_qda = [predict(Mdl_qda, Matrix([x y]))[1] for x in X, y in Y]

# ╔═╡ 8699a7df-5459-4886-b3eb-a04a9d84f35d
begin 
	qda_plt = scatter(v_wave[1:80,2],v_wave[1:80,4], c=:lime, ms=8, leg=false)
	scatter!(v_wave[81:end,2],v_wave[81:end,4], c=:magenta, ms=8)
	contour!(X, Y, Z_qda', leg=false, title="Data QDA separator")
		plot(lda_plt, qda_plt)
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
# ╠═2ee9eee7-8570-4b3e-b4e2-47a70b91c145
# ╠═a2533c1d-2c2d-44cd-b0bd-d9f992e2dbe2
# ╠═4679654b-2f08-49fa-a93c-68d93ffaa240
# ╠═69311ff3-f401-4547-8491-86f5103e6f36
# ╠═cfc34074-c32a-469e-9ab8-796bb3b33985
# ╠═0d00c667-c29d-4bca-b7ad-ca00e93c6aba
# ╠═d883cdd5-93cf-4e88-84d3-cddb98970261
# ╠═9dceb5de-797b-46d6-be8e-62b1c636ae9c
# ╠═9da09a6f-6c9f-4f43-b8c0-98ff200f0dd0
# ╠═e60b7829-f159-4fb2-a1f9-65b26f674383
# ╠═f62a5d5f-d398-4025-8a50-9259c5779223
# ╠═bf5ed436-9323-4082-b57a-2fe63363e376
# ╠═b25814a6-741b-4e26-95ee-753639521135
# ╠═2027e73a-31a3-47cf-bda9-6f4dd2d060f4
# ╠═ba70c476-e89f-4e9a-a751-28ac2e679032
# ╠═f38e5484-f2e9-46f3-b459-1b62ffcdb212
# ╠═620bfec8-b493-4249-9099-ab3cb8789e71
# ╠═289265ac-9715-497e-9471-5bce3168fcf1
# ╠═9add6bf3-f779-489d-8dbf-6935e8dcb825
# ╠═8699a7df-5459-4886-b3eb-a04a9d84f35d
# ╟─3d560fb8-8f05-11eb-1603-87841aa9858a
