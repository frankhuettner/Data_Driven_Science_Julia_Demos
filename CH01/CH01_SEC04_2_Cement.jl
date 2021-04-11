### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 62f05a52-86aa-11eb-2388-2b88bd30ab0d
begin
	using CSV
	using DataFrames
	using LinearAlgebra
	using Plots
end

# ╔═╡ d1d7cde0-86b1-11eb-2d21-5d49d0be0572
# Alternative Method 2 would be a more practical approach
begin		
	using GLM
end

# ╔═╡ ac394098-86b4-11eb-3f32-69f383cec55e
begin
	df_A = CSV.File("../DATA/hald_ingredients.csv", header=false) |> DataFrame
	# the pipe operator |> concatenates function, i.e., it read like 
	# df = DataFrame(CSV.File("../DATA/hald_ingredients.csv"))
end

# ╔═╡ 9c52da8a-86ab-11eb-0640-a19b00a53896
begin
	df_b = CSV.File("../DATA/hald_heat.csv", header=false) |> DataFrame
end

# ╔═╡ a71086f4-86ae-11eb-07c2-e9da298a3522
begin
	# Convert DataFrame to Matrix
	A = Matrix(df_A)  
	b = Matrix(df_b)
	
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

# ╔═╡ 1df8e80a-86b5-11eb-18a6-6d889fd7bcfd
df = DataFrame(hcat(A, b) )

# ╔═╡ 6dfc9374-86b5-11eb-12d3-1b16b00c9d37
ols = lm(@formula(x5 ~ x1 + x2 + x3 + x4 + 0), df)

# ╔═╡ 162fd140-86b7-11eb-05c1-a51619bbaad7
begin
	# Plotting true relationship
	plot(b, linewidth=2, label="Heat Data", legend=:topleft, markershape = :auto, 
	xticks = 1:length(b)) 
	# Plotting predition
	plot!(predict(ols), label="Prediction",  markershape = :auto)
end

# ╔═╡ a292e9e6-8f05-11eb-3bc1-a7bf6b8efcaf
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
# ╠═62f05a52-86aa-11eb-2388-2b88bd30ab0d
# ╠═ac394098-86b4-11eb-3f32-69f383cec55e
# ╠═9c52da8a-86ab-11eb-0640-a19b00a53896
# ╠═a71086f4-86ae-11eb-07c2-e9da298a3522
# ╠═9282c61a-86af-11eb-2fa0-37a159615351
# ╠═22b57b0a-86b1-11eb-2983-b5029aa15c81
# ╠═d1d7cde0-86b1-11eb-2d21-5d49d0be0572
# ╠═1df8e80a-86b5-11eb-18a6-6d889fd7bcfd
# ╠═6dfc9374-86b5-11eb-12d3-1b16b00c9d37
# ╠═162fd140-86b7-11eb-05c1-a51619bbaad7
# ╟─a292e9e6-8f05-11eb-3bc1-a7bf6b8efcaf
