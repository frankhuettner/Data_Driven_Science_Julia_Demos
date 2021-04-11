### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ d81477b2-8e9a-11eb-1085-852d483e4a4a
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ ae69ef0c-860f-11eb-2c0d-2fd556ff7342
begin
	Pkg.add("Plots")
	Pkg.add("Random")
	Pkg.add("LinearAlgebra")
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

# ╔═╡ 5ad20770-8f0c-11eb-0e08-2bce4238c90b
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
# ╠═d81477b2-8e9a-11eb-1085-852d483e4a4a
# ╠═ae69ef0c-860f-11eb-2c0d-2fd556ff7342
# ╠═bfbb3dec-860f-11eb-0bef-394ec038837c
# ╠═fe4d680a-860f-11eb-21e2-93e7aad88cee
# ╠═b1896d64-8611-11eb-32ae-633ad50d13b9
# ╠═c0c831b8-8614-11eb-006e-2f140a95152e
# ╠═eca5a666-8615-11eb-2fed-6fabc18c6b92
# ╟─5ad20770-8f0c-11eb-0e08-2bce4238c90b
