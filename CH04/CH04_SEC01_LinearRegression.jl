### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# ╔═╡ ae60e7d7-306b-4c19-837c-9bcaf70af754
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="Polynomials"),
        Pkg.PackageSpec(name="Plots", version="1"),
        Pkg.PackageSpec(name="Optim", version="1"),
        Pkg.PackageSpec(name="LaTeXStrings"),
    ])
    using Polynomials, Plots, Optim, LaTeXStrings
end

# ╔═╡ 24a0fd54-f279-44b5-9e7b-ddaf263d141f
begin
	# The data
	x = 1:10
	y = [0.2,0.5,0.3,3.5,1.0,1.5,1.8,2.0,2.3,2.2]
end

# ╔═╡ 87d818fa-a2c9-4d83-9038-90c103318dea
begin
	# Function definitions
	fit1( (β₁, β₂), x, y ) = maximum( abs(β₁ + β₂*x[i] - y[i])  for i=1:length(x) )
	fit2( (β₁, β₂), x, y ) = sum( abs(β₁ + β₂*x[i] - y[i])  for i=1:length(x) )
	fit3( (β₁, β₂), x, y ) = sum( (β₁ + β₂*x[i] - y[i])^2  for i=1:length(x) )
end

# ╔═╡ 647073a6-68ba-48f7-b90d-0e895033c612
# optimize f with starting guess
result1 =  optimize(β -> fit1(β, x, y), [1.0, 1.0] ) 

# ╔═╡ 8c9d80ca-b7b7-48fd-bb15-1f5b032e4d2d
# define polynomial function based on the optimal parameters
p1 = Polynomial(result1.minimizer) 

# ╔═╡ 293abe92-16f8-400b-8c84-0846110cb413
begin
	result2 =  optimize(β -> fit2(β, x, y), [1.0, 1.0] )  
	p2 = Polynomial(result2.minimizer)
	
	result3 =  optimize(β -> fit3(β, x, y), [1.0, 1.0] )  
	p3 = Polynomial(result3.minimizer)
end

# ╔═╡ 70f51365-8232-4d88-883c-6e0171e0f196
begin
	xf = 0:0.1:11
	plot(xf,p1.(xf),color=:black,label=L"E_\infty", legend=:topleft)
	plot!(xf,p2.(xf),color=:black,ls=:dash, label=L"E_1")
	plot!(xf,p3.(xf),color=:black,lw=2,label=L"E_2")
	scatter!(x, y, color=:red, label = "Data", xlabel=L"x", ylabel=L"y")
end

# ╔═╡ b006c447-25dd-4f38-a167-606f873b99ec
let
	# The data without outlier
	x = 1:10
	y = [0.2,0.5,0.3,0.7,1.0,1.5,1.8,2.0,2.3,2.2]
	
	result1 =  optimize(β -> fit1(β, x, y), [1.0, 1.0] )  
	p1 = Polynomial(result1.minimizer)
	
	result2 =  optimize(β -> fit2(β, x, y), [1.0, 1.0] )  
	p2 = Polynomial(result2.minimizer)
	
	result3 =  optimize(β -> fit3(β, x, y), [1.0, 1.0] )  
	p3 = Polynomial(result3.minimizer)

	xf = 0:0.1:11
	plot(xf,p1.(xf),color=:black,label=L"E_\infty", legend=:topleft)
	plot!(xf,p2.(xf),color=:black,ls=:dash, label=L"E_1")
	plot!(xf,p3.(xf),color=:black,lw=2,label=L"E_2")
	scatter!(x, y, color=:red, label = "Data", xlabel=L"x", ylabel=L"y")
end

# ╔═╡ 88a367b5-686c-45bb-b9e1-2517e734fd3b
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
# ╠═ae60e7d7-306b-4c19-837c-9bcaf70af754
# ╠═24a0fd54-f279-44b5-9e7b-ddaf263d141f
# ╠═87d818fa-a2c9-4d83-9038-90c103318dea
# ╠═647073a6-68ba-48f7-b90d-0e895033c612
# ╠═8c9d80ca-b7b7-48fd-bb15-1f5b032e4d2d
# ╠═293abe92-16f8-400b-8c84-0846110cb413
# ╠═70f51365-8232-4d88-883c-6e0171e0f196
# ╠═b006c447-25dd-4f38-a167-606f873b99ec
# ╟─88a367b5-686c-45bb-b9e1-2517e734fd3b
