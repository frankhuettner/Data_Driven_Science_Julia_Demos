### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 8b2513e8-8e9b-11eb-3eaf-1dbbb150f4ed
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 62f05a52-86aa-11eb-2388-2b88bd30ab0d
begin
	Pkg.add("CSV")
	Pkg.add("LinearAlgebra")
	Pkg.add("Plots")
	Pkg.add("FileIO")
	using CSV
	using LinearAlgebra
	using Plots
	using FileIO
end

# ╔═╡ 3656ea40-8eb3-11eb-149e-c39394e5913b
url_A = "https://github.com/dylewsky/Data_Driven_Science_Python_Demos/blob/master/DATA/hald_ingredients.csv?raw=true"

# ╔═╡ 5d04caec-8eb1-11eb-09f9-496e880e9d09
begin 
	A_filename = download(url_A)
	
	# The cumbersome way without DataFrame
	A = CSV.read(A_filename, header=false, Tuple)
	A = vcat([col' for col in A]...)'
	# easier A = CSV.File(A_filename, header=false) |> DataFrame |> Matrix
end

# ╔═╡ 6ea421fc-8eb2-11eb-0f06-1db4572c0794
url_b = "https://github.com/dylewsky/Data_Driven_Science_Python_Demos/blob/master/DATA/hald_heat.csv?raw=true"

# ╔═╡ 9c52da8a-86ab-11eb-0640-a19b00a53896
begin
	b_filename = download(url_b)
	b = CSV.read(b_filename, header=false, Tuple)
	b = b[1]
end

# ╔═╡ a71086f4-86ae-11eb-07c2-e9da298a3522
begin
	# Solve Ax=b using SVD
	U, σs, V = svd(A)
	x = V * inv(Diagonal(σs)) * U' * b
end

# ╔═╡ 9282c61a-86af-11eb-2fa0-37a159615351
begin
	# Plotting true relationship
	plot(b, linewidth=2, label="Heat Data", legend=:topleft, markershape = :auto, 
    xticks = 1:length(b)) 
	# Plotting regression
	plot!(A*x, LineWidth=1.5,  label="Regression",  markershape = :auto)
end

# ╔═╡ 22b57b0a-86b1-11eb-2983-b5029aa15c81
# Alternative Method
x2 = pinv(A)*b

# ╔═╡ 58023c00-8f62-11eb-3b50-af048224f997
md"[Frank Huettner](https://frankhuettner.de) has created this Pluto notebook with Julia code and all errors are on him. It mimics the [Matlab code here](https://github.com/dylewsky/Data_Driven_Science_Python_Demos), and it is intended as a companion to chapter 1 of the book:  
[Data Driven Science & Engineering: Machine Learning, Dynamical Systems, and Control  
by S. L. Brunton and J. N. Kutz, Cambridge Textbook, 2019, Copyright 2019, All Rights Reserved]
(http://databookuw.com/). 
Please cite this book when using this code/data. 
No guarantee can be given for the functionality of this code."

# ╔═╡ Cell order:
# ╠═8b2513e8-8e9b-11eb-3eaf-1dbbb150f4ed
# ╠═62f05a52-86aa-11eb-2388-2b88bd30ab0d
# ╠═3656ea40-8eb3-11eb-149e-c39394e5913b
# ╠═5d04caec-8eb1-11eb-09f9-496e880e9d09
# ╠═6ea421fc-8eb2-11eb-0f06-1db4572c0794
# ╠═9c52da8a-86ab-11eb-0640-a19b00a53896
# ╠═a71086f4-86ae-11eb-07c2-e9da298a3522
# ╠═9282c61a-86af-11eb-2fa0-37a159615351
# ╠═22b57b0a-86b1-11eb-2983-b5029aa15c81
# ╟─58023c00-8f62-11eb-3b50-af048224f997
