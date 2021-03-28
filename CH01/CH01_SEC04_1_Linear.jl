### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ ae69ef0c-860f-11eb-2c0d-2fd556ff7342
begin
	using Plots
	using Random
	using LinearAlgebra
end

# ╔═╡ bfbb3dec-860f-11eb-0bef-394ec038837c
begin
	x = 3 # True slope
	a = collect(-2:0.25:2)
	a = reshape(a,(length(a),1))
	b = x*a + randn(Float64,size(a)) # Add noise
end

# ╔═╡ 65f2c132-8616-11eb-31c6-85a9c43ca3a5
# A more applied approach uses DataFrames and GLM
begin
	using DataFrames
	using GLM
	df = DataFrame(hcat(b,a))  # Create dataframe from concatenated vectors
	rename!(df,[:b,:a])  		# Give names to the vectors
end

# ╔═╡ fe4d680a-860f-11eb-21e2-93e7aad88cee
begin
	fig = plot(a, x*a, Color='k', LineWidth=2, label="True line", legend=:topleft, xlabel="a", ylabel="b") # True relationship
	plot!(fig, a, b, seriestype = :scatter, label="Noisy data") # Noisy measurements
end

# ╔═╡ b1896d64-8611-11eb-32ae-633ad50d13b9
begin
	U, σs, V = svd(a);
	xtilde = V * inv(Diagonal(σs)) * U' * b # Least-square fit
end

# ╔═╡ c0c831b8-8614-11eb-006e-2f140a95152e
plot!(fig, a,xtilde .* a,linestyle=:dash,linewidth=4, label="Regression line")

# ╔═╡ eca5a666-8615-11eb-2fed-6fabc18c6b92
begin
	# Another methods of computing regression
	xtilde2 = pinv(a) * b
end

# ╔═╡ 655c7516-861a-11eb-35a7-a1f31ac7ab05
begin
	ols = lm(@formula(b ~ a + 0), df)    # regress b on a
end

# ╔═╡ f48a31b2-861a-11eb-2788-cf7ae0815622
coef(ols)[1]

# ╔═╡ a711bb34-8f05-11eb-3e2e-5f20104cf34c
md"[Frank Huettner](https://frankhuettner.de) has created this Pluto notebook with Julia code and all errors are on him. It mimics the [Matlab code here](https://github.com/dylewsky/Data_Driven_Science_Python_Demos), and it is intended as a companion to chapter 1 of the book:  
[Data Driven Science & Engineering: Machine Learning, Dynamical Systems, and Control  
by S. L. Brunton and J. N. Kutz, Cambridge Textbook, 2019, Copyright 2019, All Rights Reserved]
(http://databookuw.com/). 
Please cite this book when using this code/data. 
No guarantee can be given for the functionality of this code."

# ╔═╡ Cell order:
# ╠═ae69ef0c-860f-11eb-2c0d-2fd556ff7342
# ╠═bfbb3dec-860f-11eb-0bef-394ec038837c
# ╠═fe4d680a-860f-11eb-21e2-93e7aad88cee
# ╠═b1896d64-8611-11eb-32ae-633ad50d13b9
# ╠═c0c831b8-8614-11eb-006e-2f140a95152e
# ╠═eca5a666-8615-11eb-2fed-6fabc18c6b92
# ╠═65f2c132-8616-11eb-31c6-85a9c43ca3a5
# ╠═655c7516-861a-11eb-35a7-a1f31ac7ab05
# ╠═f48a31b2-861a-11eb-2788-cf7ae0815622
# ╟─a711bb34-8f05-11eb-3e2e-5f20104cf34c
