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
        Pkg.PackageSpec(name="PlutoUI"),
        Pkg.PackageSpec(name="DecisionTree"),
        Pkg.PackageSpec(name="StatsBase"),    
        Pkg.PackageSpec(name="StatsPlots"),        
		Pkg.PackageSpec(name="ScikitLearn"),
        Pkg.PackageSpec(name="RDatasets"),
        Pkg.PackageSpec(name="MAT"),
        Pkg.PackageSpec(name="CSV"),
    ])
    using Plots
	using MAT
	using LinearAlgebra
	using PlutoUI
	using StatsBase
	using DecisionTree
	using RDatasets 
	using StatsPlots
	using CSV
end

# ╔═╡ b9170c2e-2ccc-4021-9b2f-db68ac7f2235
begin
	# Let's use the interface of ScikitLearn
	using ScikitLearn
	using ScikitLearn: fit!
end

# ╔═╡ e2ecc4cd-e217-4485-9d69-c67a0e24da0f
# Load iris data set from RDatasets
iris = dataset("datasets", "iris")

# ╔═╡ d1343d01-ece4-40e5-aa36-8b23fc9017dc
scatter(iris[:,1], iris[:,2], iris[:,3],  marker=:o, leg=:right, group=iris[:,5])

# macro available when using StatsPlots
# @df iris scatter(:SepalLength, :SepalWidth, :PetalLength, marker=:o,  group=:Species, leg=:right)

# ╔═╡ c844962a-d04e-4424-852a-7c4905e37f9d
begin
	# train depth-truncated classifier
	features_iris = Matrix(iris[:,1:4])
	labels_iris = iris[:,5] .|>string
	model_iris = build_tree(labels_iris, features_iris, 0, 3) # 3 is max_depth
end

# ╔═╡ d95ce577-fdd8-4a4d-b99e-2de60134f581
# pretty print of the tree, using with_terminal() to have it print in Pluto
with_terminal() do 
	print_tree(model_iris)
end

# ╔═╡ 52c3cc7d-4e3b-4762-838d-9724a33d1030
# Nothe the features 3 and 4 are...
names(iris)[3:4]

# ╔═╡ c9dff6ee-a90c-4352-b820-7754e1ee2cf6
let
	plt1 = @df iris scatter(:PetalLength, :PetalWidth, group=:Species, leg=:topleft)
	vline!([2.45], label="Split 1", ls=:dot, lw=3)
	plot!([2.45,7], [1.75, 1.75], label="Split 2", ls=:dot, lw=3)
	plot!([4.85, 4.85],[0, 1.75], label="Split 3", ls=:dot, lw=3)
	
	plt2 = @df iris scatter(:SepalLength, :SepalWidth, group=:Species, leg=:topleft)
	
	plot(plt1, plt2)
end

# ╔═╡ e12ec1e9-4575-4e1b-b185-5577269096da
begin
	# train 3 depth-truncated classifier with 10 cv folds (1.0 is pruning_purity)
	accuracy = nfoldCV_tree(labels_iris, features_iris, 10, 1.0, 3)
	error_iris = 1 - mean(accuracy)
end

# ╔═╡ cfb798d3-7f1e-4535-ac08-a0e81700b93d
begin	
	dogdata_w_mat = matread("dogData_w.mat")
	catdata_w_mat = matread("catData_w.mat")
	
	dog_wave = dogdata_w_mat["dog_wave"]
	cat_wave = catdata_w_mat["cat_wave"]
	
	CD_wave = [dog_wave cat_wave]
	u_wave,s_wave,v_wave = svd(CD_wave .- mean(CD_wave))	
	
	features = 1:20
	features_wave = [v_wave[1:60,features]; v_wave[81:140,features]]
	labels_wave = [ones(60); -ones(60)]
	
	test_wave = [v_wave[61:80,features]; v_wave[141:160,features]]
	truth_wave = [ones(20); -ones(20)]
end

# ╔═╡ fbb03b75-19a3-42db-ac74-8763c9a41155
# Load the model
@sk_import tree: (DecisionTreeClassifier, export_graphviz, plot_tree)

# ╔═╡ 87abd068-1ccf-45de-bdc1-60cc1d3d1de5
begin
	# Construct the model
	model_wave = DecisionTreeClassifier(max_depth=2)
	# Train the model
	fit!(model_wave, features_wave, labels_wave)
end

# ╔═╡ 599b94fe-5b69-4820-b622-227bb6177c46
begin
	#cross-validate the model
	using ScikitLearn.CrossValidation: cross_val_score
	cv = cross_val_score(model_wave, features_wave, labels_wave, cv=10) 
	
	# average error over all cross-validation iterations
	classError = 1 - mean(cv) 
end

# ╔═╡ d84d9d22-db64-4fa3-b865-69396f47e6c2
begin
	Pkg.add([Pkg.PackageSpec(name="PyPlot")])
	using PyPlot
	
	plot_tree(model_wave) 
	gcf()	# get current figure	
end

# ╔═╡ 69049ed3-3ff1-4f19-8130-ec963f8bbdf2
# export_graphviz(model_wave, out_file="tree.dot")
# Julia's GraphViz.jl is broken so we use python

# ╔═╡ 58ff950b-e1ed-490e-a570-18d3d1b40257
begin
	df_adultdata = CSV.File("census1994.csv") |> DataFrame
	select!(df_adultdata, [:age, :workClass, :education_num, :marital_status, :race, :sex, :capital_gain, :capital_loss, :hours_per_week, :salary])
end

# ╔═╡ 31c3767f-78f4-462d-956f-5d6ece89c221
# helper function to convert categorical variables to one-hot representation
# df  is the dataframe
# cat_cols  is an array of symbolys
begin

	function get_dummies!(df, cat_cols::Array{Symbol})
		for col in cat_cols
			for entry in unique(df[:, col])
				df[:, Symbol(string(col)*"_"*entry)] = 
									ifelse.(df[:, col] .== entry, 1, 0)
			end
		end
		return select!(df, Not(cat_cols))
	end
	
	function get_dummies!(df, cat_col::Symbol)
		for entry in unique(df[:, cat_col])
			df[:, Symbol(string(cat_col)*"_"*entry)] =
						ifelse.(df[:, cat_col] .== entry, 1, 0)
		end
		return select!(df, Not(cat_col))
	end
end

# ╔═╡ c30287a8-3ca0-4776-9f4e-dcb43e2d68d2
begin
	# train depth-truncated classifier
	df_features = df_adultdata[:,1:end-1]
	df_labels = df_adultdata[:,end:end]
	
	#DummyCoding and Conversion to Array
	cat_cols = [:workClass, :marital_status, :race, :sex, :salary]
	features_adultdata = get_dummies!(df_features, cat_cols[1:end-1]) |> Matrix
	
	labels_adultdata = get_dummies!(df_labels, cat_cols[end])[:,end]
	
	# Construct the model
	model_adultdata = DecisionTreeClassifier(max_features=10)
	# Train the model
	fit!(model_adultdata, features_adultdata, labels_adultdata)
end

# ╔═╡ fe68a02a-dbd5-4e1a-83ee-2820dd4625f8
names(df_features)

# ╔═╡ 9b90e6ef-f5c3-4801-8070-825d4423139d
begin
	imp = model_adultdata.feature_importances_
	imp_combine = imp[1:5]
	push!( imp_combine,  mean(imp[6:14]) )
	push!( imp_combine,  mean(imp[15:21]) )
	push!( imp_combine,  mean(imp[22:26]) )
	push!( imp_combine,  mean(imp[27:28]) )
end

# ╔═╡ 149deb14-a63d-4d42-a085-2f392ac6a3c7
predictors = ["age","workClass","education_num", "marital_status", "race", "sex", "capital_gain","capital_loss","hours_per_week"]

# ╔═╡ c7eaf68d-cd32-4995-87b0-3657e564dba0
Plots.bar(imp_combine, leg=false, 
	xticks=(1:length(predictors), predictors), xrotation=45) 

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
# ╠═e2ecc4cd-e217-4485-9d69-c67a0e24da0f
# ╠═d1343d01-ece4-40e5-aa36-8b23fc9017dc
# ╠═c844962a-d04e-4424-852a-7c4905e37f9d
# ╠═d95ce577-fdd8-4a4d-b99e-2de60134f581
# ╠═52c3cc7d-4e3b-4762-838d-9724a33d1030
# ╠═c9dff6ee-a90c-4352-b820-7754e1ee2cf6
# ╠═e12ec1e9-4575-4e1b-b185-5577269096da
# ╠═cfb798d3-7f1e-4535-ac08-a0e81700b93d
# ╠═b9170c2e-2ccc-4021-9b2f-db68ac7f2235
# ╠═fbb03b75-19a3-42db-ac74-8763c9a41155
# ╠═87abd068-1ccf-45de-bdc1-60cc1d3d1de5
# ╠═599b94fe-5b69-4820-b622-227bb6177c46
# ╠═69049ed3-3ff1-4f19-8130-ec963f8bbdf2
# ╠═d84d9d22-db64-4fa3-b865-69396f47e6c2
# ╠═58ff950b-e1ed-490e-a570-18d3d1b40257
# ╠═31c3767f-78f4-462d-956f-5d6ece89c221
# ╠═c30287a8-3ca0-4776-9f4e-dcb43e2d68d2
# ╠═fe68a02a-dbd5-4e1a-83ee-2820dd4625f8
# ╠═9b90e6ef-f5c3-4801-8070-825d4423139d
# ╠═149deb14-a63d-4d42-a085-2f392ac6a3c7
# ╠═c7eaf68d-cd32-4995-87b0-3657e564dba0
# ╟─3d560fb8-8f05-11eb-1603-87841aa9858a
