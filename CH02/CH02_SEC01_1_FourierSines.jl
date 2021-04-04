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
using Plots, LinearAlgebra, PlutoUI, Statistics

# ╔═╡ b677a612-8fba-11eb-3ccb-31c2f5c08e03
begin
	# Define domain
	dx = 0.001
	L = π
	x = (-1+dx:dx:1)*L
	n = length(x);   nquart = floor(Int, n/4)
end

# ╔═╡ 0c1549e6-8fbb-11eb-2214-bd4ff882725c
begin
	# Define hat function
	f = zeros(n)
	f[nquart:2*nquart] = 4 .* (1:nquart+1) ./ n
	f[2*nquart+1:3*nquart] = 1 .- 4 .* (0:nquart-1) ./ n
end

# ╔═╡ 225b6b08-8fbf-11eb-15d7-a11e81251945
@bind K Slider(0:20, default=20)

# ╔═╡ de7a690a-8fbb-11eb-183b-19f5355ceb7b
begin
	# Compute Fourier series
	A0 = sum(f.*ones(n)) * dx
	fFS = A0/2 * ones(n)
	plt = plot(x,f,lw=1.5, label = "f")
	plot!(plt, x, fFS, lw=1.2, label = "k = 0")
	A = zeros(K)
	B = zeros(K)
	for k=1:K
		A[k] = dot(f, cos.(π * k .* x ./ L) ) .* dx  # Inner product
		B[k] = dot(f, sin.(π * k .* x ./ L)) .* dx
		fFS = fFS .+ A[k] .* cos.(k * π .* x ./ L) .+ B[k] .* sin.(k * π .* x ./ L)
		plot!(plt, x, fFS, lw=1.2, label = "k = $k")
	end	
	plt
end

# ╔═╡ eff65884-8fbf-11eb-165e-73124512489f
let # use let for local variables to avoid conflict with global variables like fFS
	
	# Plot amplitudes
	A0 = sum(f.*ones(n)) * dx
	fFS = A0/2 * ones(n)
	kmax = 100
	A = zeros(kmax)
	B = zeros(kmax)
	ERR = zeros(kmax)
	A[1] = A0/2
	ERR[1] = norm(f-fFS)/norm(f)
	for k=1:kmax
		A[k] = dot(f, cos.(π * k .* x ./ L) ) .* dx  # Inner product
		B[k] = dot(f, sin.(π * k .* x ./ L)) .* dx
		fFS = fFS .+ A[k] .* cos.(k * π .* x ./ L) .+ B[k] .* sin.(k * π .* x ./ L)
		ERR[k] = norm(f-fFS)/norm(f)
	end	
	thresh = median(ERR) * sqrt(kmax) * (4/sqrt(3))
	r = maximum(findall(ERR .> thresh))
	
	plt1 = scatter(1:kmax, A, yaxis=:log, ms=3)
	plot!(plt1, A, yaxis=:log, legend=false, title = "Fourier Coefficients")
	
	plt2 = scatter(1:kmax, ERR, yaxis=:log, ms=3)
	plot!(plt2, ERR, yaxis=:log, legend=false, title = "Error")
	
	plot(plt1, plt2, layout=(2,1))
end

# ╔═╡ 60149d34-f61e-4536-873c-df42e63f5adc
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
# ╟─225b6b08-8fbf-11eb-15d7-a11e81251945
# ╠═de7a690a-8fbb-11eb-183b-19f5355ceb7b
# ╠═eff65884-8fbf-11eb-165e-73124512489f
# ╟─60149d34-f61e-4536-873c-df42e63f5adc
