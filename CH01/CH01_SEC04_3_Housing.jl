### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 70e1a9c8-86cc-11eb-290e-0b52ba155bc2
begin
	using CSV
	using DataFrames
	using LinearAlgebra
	using Plots
	using Statistics
end

# ╔═╡ 959c323a-86cf-11eb-2f14-f9f4343da3c0
# Helper function to convert data file to csv
# Cheers to Stefan Karpinski, see https://stackoverflow.com/a/61667075/15412096
function dat2csv(dat_path::AbstractString, csv_path::AbstractString)
    open(csv_path, write=true) do io
        for line in eachline(dat_path)
            join(io, split(line), ',')
            println(io)
        end
    end
    return csv_path
end

# ╔═╡ c3c2962c-86cf-11eb-3445-55f0413a46d6
# Creat csv file
dat2csv("../DATA/housing.data", "../DATA/housing.csv")

# ╔═╡ 2c9e135e-86cd-11eb-34b5-c54269f3cc05
# loading data
df = CSV.File("../DATA/housing.csv",  header=false) |> DataFrame

# ╔═╡ ef933520-86cf-11eb-219a-a329c08311ae
b = df[:,end] # housing values in $1000s

# ╔═╡ b8d5bc16-86d0-11eb-1bd1-cbdd07fc5af2
A = df[:,1:end-1] |> Matrix; # other factors

# ╔═╡ e36fa4f4-8eb5-11eb-12ee-15a338fb5fc0
# This is how we can save the data in a Julia Data format (JLD):
# using JLD
# save("../DATA/housing.jld", "b", b, "A", A)

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
	# The book uses b_sorted instead of b
	
	gr() # plotly() seems to have issues with bar charts
	bar(x_trans[1:end-1], xticks = 1:length(x)-1, xlabel="Attribute", 
		ylabel="Estimated impact of coefficinet \n using z-transformed data", 
		legend = false)
end

# ╔═╡ 9aadb168-8f05-11eb-0411-2f072447d6f4
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
# ╠═70e1a9c8-86cc-11eb-290e-0b52ba155bc2
# ╠═959c323a-86cf-11eb-2f14-f9f4343da3c0
# ╠═c3c2962c-86cf-11eb-3445-55f0413a46d6
# ╠═2c9e135e-86cd-11eb-34b5-c54269f3cc05
# ╠═ef933520-86cf-11eb-219a-a329c08311ae
# ╠═b8d5bc16-86d0-11eb-1bd1-cbdd07fc5af2
# ╠═e36fa4f4-8eb5-11eb-12ee-15a338fb5fc0
# ╠═d6608b6a-86d2-11eb-0e00-496c54396cab
# ╠═faadf232-86d2-11eb-2df1-9f609410810d
# ╠═e198a8ae-86d3-11eb-3f1c-abf6014c9cbd
# ╠═609e5180-86d4-11eb-3cf9-cb02216cc259
# ╠═eb8c6b5e-86d6-11eb-33df-2136c66478f3
# ╠═6303f634-86e1-11eb-0c07-13f10471bad1
# ╟─9aadb168-8f05-11eb-0411-2f072447d6f4
