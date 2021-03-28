### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 49d91148-8b74-11eb-38f3-fba664506192
begin
	using Images
	using LinearAlgebra
	using Plots
	using Rotations
end

# ╔═╡ c1c9ce1a-8b77-11eb-2140-9d8dcb15c785
begin
	n = 1000  # 1000 x 1000 square
	q = n÷4
	
	X = zeros(n,n)
	X[q:3*q, q-1:3*q] .= 1
	heatmap(X, seriescolor=:grays, yaxis = :flip, title="Unrotated Matrix",
			axis=(false,nothing), legend=false, ratio=:equal)
end

# ╔═╡ 87b80550-8b79-11eb-2567-13f3db82f0fc
begin
	X_rot = imrotate(X, π/18, axes(X))
	X_rot = (X_rot.>0)
	heatmap(X_rot, seriescolor=:grays, yaxis = :flip, title="Rotated Matrix",
			axis=(false,nothing), legend=false, ratio=:equal)
end

# ╔═╡ eb78e862-8b7d-11eb-1f97-ef0b8fc9dccf
begin
	U,Σ,V = svd(X)
	
	plot(Σ, yaxis=:log, title="Unrotated Matrix: Spectrum",
				color=:black,markershape=:o, lw=1.5, legend=false)
end

# ╔═╡ 22d997fc-8b7e-11eb-2edc-5bbef33cfc05
begin
	U_rot,Σ_rot,V_rot = svd(X_rot)
	
	plot(Σ_rot, yaxis=:log, title="Rotated Matrix: Spectrum",
				color=:black,markershape=:o, lw=1.5, legend=false)
end

# ╔═╡ 30791038-8f05-11eb-023f-213363533a51
md"[Frank Huettner](https://frankhuettner.de) has created this Pluto notebook with Julia code and all errors are on him. It mimics the [Matlab code here](https://github.com/dylewsky/Data_Driven_Science_Python_Demos), and it is intended as a companion to chapter 1 of the book:  
[Data Driven Science & Engineering: Machine Learning, Dynamical Systems, and Control  
by S. L. Brunton and J. N. Kutz, Cambridge Textbook, 2019, Copyright 2019, All Rights Reserved]
(http://databookuw.com/). 
Please cite this book when using this code/data. 
No guarantee can be given for the functionality of this code."

# ╔═╡ Cell order:
# ╠═49d91148-8b74-11eb-38f3-fba664506192
# ╠═c1c9ce1a-8b77-11eb-2140-9d8dcb15c785
# ╠═87b80550-8b79-11eb-2567-13f3db82f0fc
# ╠═eb78e862-8b7d-11eb-1f97-ef0b8fc9dccf
# ╠═22d997fc-8b7e-11eb-2edc-5bbef33cfc05
# ╟─30791038-8f05-11eb-023f-213363533a51
