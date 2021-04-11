### A Pluto.jl notebook ###
# v0.12.21

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

# ╔═╡ 9e4f5c7a-8b86-11eb-0b16-4124437c66f4
begin
	using Images
	using LinearAlgebra
	using Plots
	using Rotations
	using PlutoUI
end

# ╔═╡ b809a77e-8b86-11eb-2d75-9b298610bdd6
begin
	n = 1000  # 1000 x 1000 square
	q = n÷4
	nAngles = 12
	X = zeros(n,n)
	X[q:3*q, q-1:3*q] .= 1	
end

# ╔═╡ a7b68aea-8b8b-11eb-15c6-3f8f5eb9a68b
md"Move the slider to rotate the Matrix"

# ╔═╡ 235118f8-8b89-11eb-1664-fb3a4d0aaaee
@bind angle Slider(0:nAngles)  #sweep through 12 different angles

# ╔═╡ fa538e08-8b89-11eb-2951-7757db87f3a2
begin
	X_rot = imrotate(X, angle * π/4/nAngles, axes(X))
	X_rot = (X_rot.>0)
	F_rot = svd(X_rot) # We will just need F_rot.S 
	plt_Mat = plot(Gray.( X_rot)) # colorview(Gray, X_rot)
	plt_Σs = plot(F_rot.S, yaxis=:log, markershape=:o, lw=1.5, legend=false)
	plot(plt_Mat, plt_Σs, layout=(1,2))
end

# ╔═╡ 2d369bfe-8f05-11eb-1a23-b91c5b9c32ba
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
# ╠═9e4f5c7a-8b86-11eb-0b16-4124437c66f4
# ╠═b809a77e-8b86-11eb-2d75-9b298610bdd6
# ╟─a7b68aea-8b8b-11eb-15c6-3f8f5eb9a68b
# ╟─235118f8-8b89-11eb-1664-fb3a4d0aaaee
# ╠═fa538e08-8b89-11eb-2951-7757db87f3a2
# ╟─2d369bfe-8f05-11eb-1a23-b91c5b9c32ba
