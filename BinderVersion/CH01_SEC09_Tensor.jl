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

# ╔═╡ ef1c86fa-8f5f-11eb-146b-01f73d6868a1
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 8a2b5804-8de1-11eb-34d5-71b3f46885c3
begin
	Pkg.add("LinearAlgebra")
	Pkg.add("Plots")
	Pkg.add("PlutoUI")
	Pkg.add("TensorToolbox")
	Pkg.add("LaTeXStrings")
	using LinearAlgebra
	using Plots
	using PlutoUI
	using TensorToolbox
	using LaTeXStrings 
end

# ╔═╡ 9b69950e-8de1-11eb-32f5-2749cfc88e6e
begin
	x = -5:0.1:5; y =-6:0.1:6; t = 0:0.1:10*π
	f1(x, y, t) = exp(-(x^2+0.5*y^2)) * cos(2*t)
	f2(x, y, t) = sech(x) * tanh(x) * exp(-0.2*y^2) * sin(t)
    f(x, y, t) = f1(x, y, t) + f2(x, y, t)
end

# ╔═╡ 198cee96-8de6-11eb-34b1-efa575881f3f
@bind t_plotted Slider(t, show_value=true)

# ╔═╡ 1aaba872-8de5-11eb-18e1-eb3285bddb6d
begin
	f(x, y) = f(x,y,t_plotted)
	#f1(x, y) = f1(x,y,t_plotted)
	#f2(x, y) = f2(x,y,t_plotted)
	surface(x, y, f, aspect_ratio=:equal)	
	#surface(x, y, f1, aspect_ratio=:equal)	
	#surface(x, y, f2, aspect_ratio=:equal)	
end

# ╔═╡ dd7a0d14-8de8-11eb-2dcc-c16fc1710e10
# create tensor ℳ
begin
	ℳ = [f(i,j,k) for i=x, j=y, k=t]    # type \scrM followed by TAB-key to create ℳ
	size(ℳ)
end

# ╔═╡ 275eaf6a-8def-11eb-393d-8750f6ebd9fe
# factorization of rank 2. Like parafac(ℳ,2) in Matlab
model = cp_als(ℳ,2,maxit=2500,init="nvecs" ) 

# ╔═╡ 153550f8-8e41-11eb-018c-37c19a9f9ded
# access the factors via model.fmat
A,B,C = model.fmat # Like fac2let(model)

# ╔═╡ 62fb9c7e-8deb-11eb-2dd0-ef74620d90df
begin
	plt_a = plot(y, B[:,1], ylim=(-.50,.50),label="1st",xlabel=L"y")
	plot!(plt_a, y, B[:,2], ylim=(-.50,.50),label="2nd")
	plt_b = plot(x, A[:,1], ylim=(-.5,.5),label="1st",xlabel=L"x")
	plot!(plt_b, x, A[:,2], ylim=(-.5,.5),label="2nd")
	# And to show how to plot and label both factors at once
	plt_c = plot(t, C, ylim=(-.1,.1),label=["1st" "2nd"],xlabel=L"t")
	plot(plt_a, plt_b, plt_c, layout=(3,1))
end

# ╔═╡ f863de2e-8f60-11eb-2d3f-9fa8e8b6820f
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
# ╠═ef1c86fa-8f5f-11eb-146b-01f73d6868a1
# ╠═8a2b5804-8de1-11eb-34d5-71b3f46885c3
# ╠═9b69950e-8de1-11eb-32f5-2749cfc88e6e
# ╠═198cee96-8de6-11eb-34b1-efa575881f3f
# ╠═1aaba872-8de5-11eb-18e1-eb3285bddb6d
# ╠═dd7a0d14-8de8-11eb-2dcc-c16fc1710e10
# ╠═275eaf6a-8def-11eb-393d-8750f6ebd9fe
# ╠═153550f8-8e41-11eb-018c-37c19a9f9ded
# ╠═62fb9c7e-8deb-11eb-2dd0-ef74620d90df
# ╟─f863de2e-8f60-11eb-2d3f-9fa8e8b6820f
