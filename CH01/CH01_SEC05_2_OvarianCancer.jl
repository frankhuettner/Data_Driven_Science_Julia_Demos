### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ f5e70aaf-bfc8-41ac-97cc-801ae3e04f9a
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add(["Plots", "LinearAlgebra", "CSV", "DataFrames"])
    using Plots, LinearAlgebra, CSV, DataFrames
	# gr()  	gives quicker plots
	plotly()  # this gives JS plots that allow for zooming etc
end

# ╔═╡ 0df8311e-89f7-11eb-2637-579c47ae9fd6
obs = CSV.File("ovariancancer_obs.csv", header=false) |> DataFrame |> Matrix

# ╔═╡ 75bdfb24-89fe-11eb-1f2a-290bab9607be
grp = CSV.File("ovariancancer_grp.csv", header=false) |> DataFrame |> Matrix

# ╔═╡ f36bd73b-515e-4bff-9d74-69c5c172b266
F = svd(obs); # Compute the svd and store the object in F

# ╔═╡ d513b793-c43e-4e1d-b635-d7e54b8c0f34
Vᵀ = F.Vt; 	# type \^T  and hit Tab-key to generate the unicode superscript ᵀ

# ╔═╡ 3160d659-0023-4df7-b2aa-01bce1a9d945
Σ = F.S;  # Get the sigma from the object F

# ╔═╡ de03021c-8a03-11eb-1ffe-4735b2a58d54
begin
	p1 = scatter(Σ, yaxis=:log, title="Singular Values")
	p2 = plot(cumsum(Σ)./sum(Σ), title="Cumulative Sum")
	plot(p1, p2, layout = (1, 2), leg=:false)
end

# ╔═╡ 071ac034-8a04-11eb-04da-0f6992550321
begin
	plt = plot3d(leg=false, camera=(85,20))
	for j in 1:size(obs, 1)
		# dot(x,y) works better than x*y' with vectors
		x = dot(Vᵀ[1,:], obs[j,:]) 
		# \cdot and tab-complete give ⋅ which is equivalent to dot() 
		y = Vᵀ[2,:] ⋅ obs[j,:]   
		# lastly, we could also use vector notation (vector is like column) 
		z = Vᵀ[3,:]' * obs[j,:]  
		
		if grp[j] == "Cancer"
        	scatter!(plt, [x],[y],[z],markershape=:x, color=:red)
			# Note we add vectors of data
    	else
        	scatter!(plt, [x],[y],[z], color=:blue)
		end
	end
	plt # call the plot to show
end

# ╔═╡ 3d560fb8-8f05-11eb-1603-87841aa9858a
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
# ╠═f5e70aaf-bfc8-41ac-97cc-801ae3e04f9a
# ╠═0df8311e-89f7-11eb-2637-579c47ae9fd6
# ╠═75bdfb24-89fe-11eb-1f2a-290bab9607be
# ╠═f36bd73b-515e-4bff-9d74-69c5c172b266
# ╠═d513b793-c43e-4e1d-b635-d7e54b8c0f34
# ╠═3160d659-0023-4df7-b2aa-01bce1a9d945
# ╠═de03021c-8a03-11eb-1ffe-4735b2a58d54
# ╠═071ac034-8a04-11eb-04da-0f6992550321
# ╟─3d560fb8-8f05-11eb-1603-87841aa9858a
