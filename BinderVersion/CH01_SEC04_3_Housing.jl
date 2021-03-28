### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 41673f5c-8f62-11eb-1223-cba421eb4ff5
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 70e1a9c8-86cc-11eb-290e-0b52ba155bc2
begin
	Pkg.add("LinearAlgebra")
	Pkg.add("Plots")
	Pkg.add("FileIO")
	Pkg.add("JLD")
	Pkg.add("Statistics")
	using LinearAlgebra
	using Plots
	using FileIO
	using JLD
	using Statistics
end

# ╔═╡ 6662d53a-8f64-11eb-032d-cf9d49d51586
url="https://github.com/frankhuettner/Data_Driven_Science_Julia_Demos_Ch1/blob/main/DATA/housing.jld?raw=true"

# ╔═╡ 706c9d0e-8f64-11eb-333a-dbe333394e30
data = url  |> download |> load

# ╔═╡ ef933520-86cf-11eb-219a-a329c08311ae
b = data["b"] # housing values in $1000s

# ╔═╡ b8d5bc16-86d0-11eb-1bd1-cbdd07fc5af2
A = data["A"] # other factors

# ╔═╡ d6608b6a-86d2-11eb-0e00-496c54396cab
o = ones(size(A,1), 1); # a column vector of ones

# ╔═╡ faadf232-86d2-11eb-2df1-9f609410810d
A_padded = hcat(A, o); # Pad with ones for nonzero offset

# ╔═╡ e198a8ae-86d3-11eb-3f1c-abf6014c9cbd
begin
	# Solve Ax=b using SVD
	# Note that the book uses the Matlab-specific "regress" command
	U, σs, V = svd(A_padded)
	x = V * inv(Diagonal(σs)) * U' * b
end

# ╔═╡ 609e5180-86d4-11eb-3cf9-cb02216cc259
begin
	plotly()
	plot(b, label="Housing Value") # True relationship
	plot!(A_padded * x, label="Regression")
	plot!(xlabel="Neighborhood")
	plot!(ylabel="Median Home Value [\$1k]")
end

# ╔═╡ eb8c6b5e-86d6-11eb-33df-2136c66478f3
begin
	sort_ind = sortperm(b) # get the sorted indices of b
	b_sorted = b[sort_ind]
	A_padded_sorted = A_padded[sort_ind,:]
	plot(b_sorted, label="Housing Value", lw = 3) # True relationship
	plot!(A_padded_sorted * x, label="Regression",  
			markershape = :hexagon,
			markersize = 2,
			markeralpha = 0.6,)
	plot!(xlabel="Neighborhood")
	plot!(ylabel="Median Home Value [\$1k]")	
	plot!(legend=:topleft)	
end

# ╔═╡ 6303f634-86e1-11eb-0c07-13f10471bad1
begin
	# first we z-transform each column
	A_trans = copy(A_padded)
	for j in 1:size(A_trans,2)-1
		c_j = A_trans[:,j]
		col_mean = mean(c_j)
		col_std = std(c_j,corrected=false)    
		for i in 1:size(A_trans,1)
			A_trans[i,j] = (A_trans[i,j] - col_mean) / col_std
		end
	end
	U_trans, σs_trans, V_trans = svd(A_trans)
	x_trans = pinv(A_trans)*b # Direct usage of pseudo-inverse via pinv
	# It seesm that the book wrongly uses b_sorted instead of b
	
	gr() # The plotly() backend has trouble with the bar charts 
	bar(x_trans[1:end-1], xticks = 1:length(x)-1, xlabel="Attribute", 
		ylabel="Estimated impact of coefficinet \n using z-transformed data", 
		legend = false)
end

# ╔═╡ 370796c2-8f69-11eb-2263-23fa72c85a22


# ╔═╡ 43a9fd5e-8f62-11eb-0573-6fff94d61696
md"[Frank Huettner](https://frankhuettner.de) has created this Pluto notebook with Julia code and all errors are on him. It mimics the [Matlab code here](https://github.com/dylewsky/Data_Driven_Science_Python_Demos), and it is intended as a companion to chapter 1 of the book:  
[Data Driven Science & Engineering: Machine Learning, Dynamical Systems, and Control  
by S. L. Brunton and J. N. Kutz, Cambridge Textbook, 2019, Copyright 2019, All Rights Reserved]
(http://databookuw.com/). 
Please cite this book when using this code/data. 
No guarantee can be given for the functionality of this code."

# ╔═╡ Cell order:
# ╠═41673f5c-8f62-11eb-1223-cba421eb4ff5
# ╠═70e1a9c8-86cc-11eb-290e-0b52ba155bc2
# ╠═6662d53a-8f64-11eb-032d-cf9d49d51586
# ╠═706c9d0e-8f64-11eb-333a-dbe333394e30
# ╠═ef933520-86cf-11eb-219a-a329c08311ae
# ╠═b8d5bc16-86d0-11eb-1bd1-cbdd07fc5af2
# ╠═d6608b6a-86d2-11eb-0e00-496c54396cab
# ╠═faadf232-86d2-11eb-2df1-9f609410810d
# ╠═e198a8ae-86d3-11eb-3f1c-abf6014c9cbd
# ╠═609e5180-86d4-11eb-3cf9-cb02216cc259
# ╠═eb8c6b5e-86d6-11eb-33df-2136c66478f3
# ╠═6303f634-86e1-11eb-0c07-13f10471bad1
# ╠═370796c2-8f69-11eb-2263-23fa72c85a22
# ╟─43a9fd5e-8f62-11eb-0573-6fff94d61696
