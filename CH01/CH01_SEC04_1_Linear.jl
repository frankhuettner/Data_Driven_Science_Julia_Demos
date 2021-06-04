### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ 4b2b84cd-ef6d-47f1-88fa-139a4119f150
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add(["Plots", "LinearAlgebra"])
    using Plots, LinearAlgebra
end

# ╔═╡ d64b6d70-00b7-40b1-b390-babe7bd876aa
x = 3 # True slope

# ╔═╡ 249520a0-ebf4-4dc2-a6cd-536c79c385cd
a = -2:0.25:2   # Short for   a = range(-2.0, stop=2.0, step=0.25)

# ╔═╡ 29f2914e-8940-476b-aee5-bb89304b488f
b = x * a + randn(Float64,size(a)) # Add noise

# ╔═╡ 65f2c132-8616-11eb-31c6-85a9c43ca3a5
# A more applied approach uses DataFrames and GLM
begin
    Pkg.add(["DataFrames", "GLM"])
	using DataFrames, GLM
	df = DataFrame(hcat(b,a), :auto) # Create dataframe from concatenated vectors
	rename!(df,[:b,:a])  		# Give names to the vectors
end

# ╔═╡ fe4d680a-860f-11eb-21e2-93e7aad88cee
begin
	plotly() # using plotly() plotting backend
	# Create plot
	fig = plot(leg=:topleft, xlabel="a", ylabel="b")
	# Plot true relationship
	plot!(fig, a, x*a, c=:black, lw=2, label="True line")
	# Add noisy measurements to plot
	plot!(fig, a, b, seriestype = :scatter, label="Noisy data") 
end

# ╔═╡ 3931d235-ec61-4cc3-bab0-e1aba529cddc
A = collect(reshape(a, length(a), 1))   # collect materializes the matrix

# ╔═╡ a77c2b9e-e283-4a2a-8ed2-0f7cae450d30
U, σs, V = svd(A);

# ╔═╡ b1896d64-8611-11eb-32ae-633ad50d13b9
xtilde = V * inv(Diagonal(σs)) * U' * b # Least-square fit

# ╔═╡ c0c831b8-8614-11eb-006e-2f140a95152e
plot!(fig, a, xtilde .* a, c=:blue, ls=:dash, lw=4, label="Regression line")

# ╔═╡ eca5a666-8615-11eb-2fed-6fabc18c6b92
# Another methods of computing regression
xtilde2 = pinv(a) * b

# ╔═╡ 655c7516-861a-11eb-35a7-a1f31ac7ab05
ols = lm(@formula(b ~ a + 0), df)    # regress b on a

# ╔═╡ f48a31b2-861a-11eb-2788-cf7ae0815622
coef(ols)[1]

# ╔═╡ a711bb34-8f05-11eb-3e2e-5f20104cf34c
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
# ╠═4b2b84cd-ef6d-47f1-88fa-139a4119f150
# ╠═d64b6d70-00b7-40b1-b390-babe7bd876aa
# ╠═249520a0-ebf4-4dc2-a6cd-536c79c385cd
# ╠═29f2914e-8940-476b-aee5-bb89304b488f
# ╠═fe4d680a-860f-11eb-21e2-93e7aad88cee
# ╠═3931d235-ec61-4cc3-bab0-e1aba529cddc
# ╠═a77c2b9e-e283-4a2a-8ed2-0f7cae450d30
# ╠═b1896d64-8611-11eb-32ae-633ad50d13b9
# ╠═c0c831b8-8614-11eb-006e-2f140a95152e
# ╠═eca5a666-8615-11eb-2fed-6fabc18c6b92
# ╠═65f2c132-8616-11eb-31c6-85a9c43ca3a5
# ╠═655c7516-861a-11eb-35a7-a1f31ac7ab05
# ╠═f48a31b2-861a-11eb-2788-cf7ae0815622
# ╟─a711bb34-8f05-11eb-3e2e-5f20104cf34c
