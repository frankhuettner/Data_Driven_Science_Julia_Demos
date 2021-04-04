### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 6a060e4e-8fbb-11eb-138a-ad0ea6aeb996
using Plots, LinearAlgebra, PlutoUI

# ╔═╡ b677a612-8fba-11eb-3ccb-31c2f5c08e03
begin
	# Define domain
	dx = 0.001
	L = 2* π
	x = (-1+dx:dx:1)*L
	n = length(x);   nquart = floor(Int, n/4)
end

# ╔═╡ 0c1549e6-8fbb-11eb-2214-bd4ff882725c
begin
	# Define hat function
	f = zeros(n)
	f[nquart:3*nquart] .= 1
end

# ╔═╡ 225b6b08-8fbf-11eb-15d7-a11e81251945
@bind K Slider(0:100, default=100)

# ╔═╡ de7a690a-8fbb-11eb-183b-19f5355ceb7b
begin
	# Compute Fourier series
	A0 = sum(f.*ones(n)) * dx
	fFS = A0/2 * ones(n)
	A = zeros(K)
	B = zeros(K)
	plt = plot(x,f,lw=1.5, label = "f")
	for k=1:K
		A[k] = dot(f, cos.(π * k .* x ./ L) ) .* dx  # Inner product
		B[k] = dot(f, sin.(π * k .* x ./ L)) .* dx
		fFS = fFS .+ A[k] .* cos.(k * π .* x ./ L) .+ B[k] .* sin.(k * π .* x ./ L)
		plt = plot(x, fFS, c=:red, lw=1.2, label = "k = $k")
	end	
	plot!(plt, x ,f , c=:black,lw=1.5, label = "f")
end

# ╔═╡ 7007d16a-902e-11eb-1c16-67fe2a63d9f4
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
# ╠═6a060e4e-8fbb-11eb-138a-ad0ea6aeb996
# ╠═b677a612-8fba-11eb-3ccb-31c2f5c08e03
# ╠═0c1549e6-8fbb-11eb-2214-bd4ff882725c
# ╠═225b6b08-8fbf-11eb-15d7-a11e81251945
# ╠═de7a690a-8fbb-11eb-183b-19f5355ceb7b
# ╟─7007d16a-902e-11eb-1c16-67fe2a63d9f4
