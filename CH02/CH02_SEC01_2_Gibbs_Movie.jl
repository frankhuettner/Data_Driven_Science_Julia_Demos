### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 6a060e4e-8fbb-11eb-138a-ad0ea6aeb996
using Plots, LinearAlgebra, PlutoUI, OffsetArrays

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

# ╔═╡ de7a690a-8fbb-11eb-183b-19f5355ceb7b
begin
	# Compute Fourier series
	K = 100
	A0 = sum(f.*ones(n)) * dx
	fFS = A0/2 * ones(K,n)
	OsA_fFS = OffsetArray(fFS,0:K-1,1:n)  # Create Array with indices 0:99
	A = zeros(K)
	B = zeros(K)

	
@gif for k=1:K-1
	A[k] = dot(f, cos.(π * k .* x ./ L) ) .* dx  # Inner product
	B[k] = dot(f, sin.(π * k .* x ./ L)) .* dx
	OsA_fFS[k,:] = OsA_fFS[k-1,:] .+ 
				A[k] .* cos.(k * π .* x ./ L) .+ B[k] .* sin.(k * π .* x ./ L)
	plt = plot(x, OsA_fFS[k,:], c=:red, lw=1.2, label = "k = $k")
	plot!(plt, x ,f , c=:black,lw=1.5, label = "f")
	end	
end

# ╔═╡ a76083e1-55fa-44e6-952d-3256eac16fde
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
# ╠═de7a690a-8fbb-11eb-183b-19f5355ceb7b
# ╟─a76083e1-55fa-44e6-952d-3256eac16fde
