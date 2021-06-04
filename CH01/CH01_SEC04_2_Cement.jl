### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ 62f05a52-86aa-11eb-2388-2b88bd30ab0d
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add(["Plots", "LinearAlgebra", "CSV", "DataFrames", "GLM"])
    using Plots, LinearAlgebra, CSV, DataFrames, GLM
end

# ╔═╡ ac394098-86b4-11eb-3f32-69f383cec55e
df_A = CSV.File("hald_ingredients.csv", header=false) |> DataFrame
# the pipe operator   |>    concatenates into functions, i.e., it read like 
# df_A = DataFrame(CSV.File("hald_ingredients.csv"))

# ╔═╡ 9c52da8a-86ab-11eb-0640-a19b00a53896
df_b = DataFrame( CSV.File("hald_heat.csv", header=false) ); 

# ╔═╡ e5199959-334e-4027-a88f-a8b0f96bc11b
# Convert DataFrames to Matrices
A = Matrix(df_A);         b = df_b |> Matrix

# ╔═╡ d6944823-55ca-4818-a77c-09dc5c775d1a
# Solve Ax=b using SVD
U, Σ, V = svd(A); 

# ╔═╡ a71086f4-86ae-11eb-07c2-e9da298a3522
x = V * inv(Diagonal(Σ)) * U' * b

# ╔═╡ 9282c61a-86af-11eb-2fa0-37a159615351
begin
	pyplot() # using pyplot backend for a change
	# Plotting true relationship
	plot(b, lw=2, label="Heat Data", 
		leg=:topleft, markershape=:auto, xticks=1:length(b) ) 
	# Plotting regression
	plot!(A*x, lw=1.5,  label="Regression",  markershape=:auto)
end

# ╔═╡ 22b57b0a-86b1-11eb-2983-b5029aa15c81
# Alternative Method
x2 = pinv(A) * b

# ╔═╡ d1d7cde0-86b1-11eb-2d21-5d49d0be0572
# Alternative Method 2 would be a more practical approach

# ╔═╡ 1df8e80a-86b5-11eb-18a6-6d889fd7bcfd
df = DataFrame(hcat(A, b), :auto)

# ╔═╡ 6dfc9374-86b5-11eb-12d3-1b16b00c9d37
ols = lm(@formula(x5 ~ x1 + x2 + x3 + x4 + 0), df)

# ╔═╡ 162fd140-86b7-11eb-05c1-a51619bbaad7
begin
	# Plotting true relationship
	plot(b, lw=2, label="Heat Data", markershape=:auto,
		leg=:topleft, xticks = 1:length(b)) 
	# Plotting predition
	plot!(predict(ols), label="Prediction",  markershape=:auto)
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
# ╠═e5199959-334e-4027-a88f-a8b0f96bc11b
# ╠═d6944823-55ca-4818-a77c-09dc5c775d1a
# ╠═a71086f4-86ae-11eb-07c2-e9da298a3522
# ╠═9282c61a-86af-11eb-2fa0-37a159615351
# ╠═22b57b0a-86b1-11eb-2983-b5029aa15c81
# ╠═d1d7cde0-86b1-11eb-2d21-5d49d0be0572
# ╠═1df8e80a-86b5-11eb-18a6-6d889fd7bcfd
# ╠═6dfc9374-86b5-11eb-12d3-1b16b00c9d37
# ╠═162fd140-86b7-11eb-05c1-a51619bbaad7
# ╟─a292e9e6-8f05-11eb-3bc1-a7bf6b8efcaf
