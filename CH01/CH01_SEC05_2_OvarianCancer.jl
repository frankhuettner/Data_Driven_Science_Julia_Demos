### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 9572728c-89f5-11eb-36c7-cf20362ce0ee
begin
	using CSV
	using DataFrames
	using LinearAlgebra
	using Plots
	# gr()  	gives quicker plots
	plotly()  # this gives JS plots that allow for zooming etc
end

# ╔═╡ 0df8311e-89f7-11eb-2637-579c47ae9fd6
obs = CSV.File("../DATA/ovariancancer_obs.csv", header=false) |> DataFrame |> Matrix

# ╔═╡ 75bdfb24-89fe-11eb-1f2a-290bab9607be
grp = CSV.File("../DATA/ovariancancer_grp.csv", header=false) |> DataFrame |> Matrix

# ╔═╡ d819d58e-89f6-11eb-12af-e9b295eb3f9c
begin
	U, σs, V = svd(obs)	 
	Vᵀ = V' 	# type \^T  and hit Tab-key to generate the unicode superscript
end

# ╔═╡ de03021c-8a03-11eb-1ffe-4735b2a58d54
begin
	p1 = scatter(σs, yaxis=:log, label="Singular Values")
	p2 = plot(cumsum(σs)./sum(σs),label="Singular Values: Cumulative Sum", 
		legend=:right)
	plot(p1, p2, layout = (1, 2))
end

# ╔═╡ 071ac034-8a04-11eb-04da-0f6992550321
begin
	plt = plot3d(1, marker = 2, legend = false, camera = (85,20) )
	for j in 1:size(obs, 1)
		x = dot(Vᵀ[1,:], obs[j,:]) # dot(x,y) works better than x*y' with vectors
		y = dot(Vᵀ[2,:], obs[j,:]) 
		z = dot(Vᵀ[3,:], obs[j,:]) 
		
		if grp[j] == "Cancer"
        	scatter!(plt, [x],[y],[z],markershape=:x, color=:red)
    	else
        	scatter!(plt, [x],[y],[z],color=:blue)
		end
	end
	plt # call the plot to show
end

# ╔═╡ 3d560fb8-8f05-11eb-1603-87841aa9858a
md"[Frank Huettner](https://frankhuettner.de) has created this Pluto notebook with Julia code and all errors are on him. It mimics the [Matlab code here](https://github.com/dylewsky/Data_Driven_Science_Python_Demos), and it is intended as a companion to chapter 1 of the book:  
[Data Driven Science & Engineering: Machine Learning, Dynamical Systems, and Control  
by S. L. Brunton and J. N. Kutz, Cambridge Textbook, 2019, Copyright 2019, All Rights Reserved]
(http://databookuw.com/). 
Please cite this book when using this code/data. 
No guarantee can be given for the functionality of this code."

# ╔═╡ Cell order:
# ╠═9572728c-89f5-11eb-36c7-cf20362ce0ee
# ╠═0df8311e-89f7-11eb-2637-579c47ae9fd6
# ╠═75bdfb24-89fe-11eb-1f2a-290bab9607be
# ╠═d819d58e-89f6-11eb-12af-e9b295eb3f9c
# ╠═de03021c-8a03-11eb-1ffe-4735b2a58d54
# ╠═071ac034-8a04-11eb-04da-0f6992550321
# ╟─3d560fb8-8f05-11eb-1603-87841aa9858a
