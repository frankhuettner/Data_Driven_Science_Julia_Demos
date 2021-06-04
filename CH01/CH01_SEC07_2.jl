### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ 677d292c-2b4c-48db-a767-885af35fe294
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add(["Plots", "Images", "LinearAlgebra", "Rotations"]) 
    using Plots, Images, LinearAlgebra, Rotations
end

# ╔═╡ c1c9ce1a-8b77-11eb-2140-9d8dcb15c785
begin
	n = 1000  # 1000 x 1000 square
	q = n÷4  # Integer division tab-complete \div to get ÷, which is like div()
	
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
# ╠═677d292c-2b4c-48db-a767-885af35fe294
# ╠═c1c9ce1a-8b77-11eb-2140-9d8dcb15c785
# ╠═87b80550-8b79-11eb-2567-13f3db82f0fc
# ╠═eb78e862-8b7d-11eb-1f97-ef0b8fc9dccf
# ╠═22d997fc-8b7e-11eb-2edc-5bbef33cfc05
# ╟─30791038-8f05-11eb-023f-213363533a51
