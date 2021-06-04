### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ bd4a5471-f7b3-483f-ade5-c99a42e4f593
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add(["Plots", "Images", "LinearAlgebra"]) 
    using Plots, Images, LinearAlgebra
end

# ╔═╡ c0a7d1c0-8b28-11eb-2b94-13c3dd6c172f
begin
	t = -3:.01:3
	
	Utrue = [cos.(17*t).*exp.(-t.^2)	 sin.(11*t)]
	Strue = [2  0
			 0 .5]
	Vtrue = [sin.(5*t).*exp.(-t.^2)		 cos.(13*t)]
	
	X = Utrue * Strue * Vtrue'
	colorview(Gray,X)
end

# ╔═╡ b02120a8-8b29-11eb-3506-db5e61fa2413
begin
	σ = 1
	Xnoisy = X + σ * randn(size(X))
	colorview(Gray,Xnoisy)
end

# ╔═╡ c940bbe6-8b29-11eb-1832-1fc02120f2c6
begin
	U, Σ, V = svd(Xnoisy)
	
	N = size(Xnoisy,1)
	cutoff = (4/sqrt(3)) * sqrt(N) * σ # Hard threshold
	r = length(Σ[Σ .> cutoff]) # Keep modes with sig > cutoff
	Xclean = U[:,1:r] * Diagonal(Σ[1:r]) * V[:,1:r]'
	colorview(Gray, Xclean)
end

# ╔═╡ 07da1d14-8b29-11eb-25c9-49d1939b3f16
begin
	cdS = cumsum(Σ)./sum(Σ)  # Cumulative energy
	r90 = length(cdS[cdS.<=0.90]) # Find r to capture 90% energy
	X90 = U[:,1:r90] * Diagonal(Σ[1:r90]) * V[:,1:r90]'
	colorview(Gray,X90)
end

# ╔═╡ 6b6bb674-8b2d-11eb-37e2-c10c4130aba4
begin
	## Plot Singular Values
	plot(Σ, yaxis=:log, c=:black, markershape=:o, lw=1.5,
		title="Singular Values", legend=false)
	plot!(Σ[1:r], c=:red, marker=:o, lw=1.5)
	hline!([cutoff], line=(:dash,:red), lw=1.5)
	plot!(Shape([(-5,20), (100,20), (100,200), (-5,200)]), 	
				lw=2, c=:black, line=:dash, fillcolor = false)
end

# ╔═╡ 42bc5d28-8b35-11eb-0610-0df44a1b4935
begin
	plot(Σ, yaxis=:log, xlim=(-5,100), ylim=(20,200),
		c=:black,marker=:o, lw=1.5, legend=false )
	hline!([cutoff], line =  (:dash, :red), lw=1.5)
	scatter!(Σ[1:r],color=:red,markershape=:o, lw=1.5)

end

# ╔═╡ d6d4ef66-8b32-11eb-110b-7d0e70cdebba
begin
	plt = plot(cdS,  color=:black, lw=7.5, 
		leg=false, xlim=[-10,610], xticks=[0,300,r90,600], yticks=[0,0.5,0.9,1])
	plot!(plt, cdS[1:r90],color=:blue, lw=7.5)
	plot!(plt, cdS[1:r],color=:red, markershape=:o, lw=1.5)
	plot!(plt, [r90, r90, -10],[0, 0.9, 0.9], color=:blue, line=:dash, lw=1.5)
end

# ╔═╡ 3b2b78f4-8f05-11eb-35e0-47bc10fdafd1
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
# ╠═bd4a5471-f7b3-483f-ade5-c99a42e4f593
# ╠═c0a7d1c0-8b28-11eb-2b94-13c3dd6c172f
# ╠═b02120a8-8b29-11eb-3506-db5e61fa2413
# ╠═c940bbe6-8b29-11eb-1832-1fc02120f2c6
# ╠═07da1d14-8b29-11eb-25c9-49d1939b3f16
# ╠═6b6bb674-8b2d-11eb-37e2-c10c4130aba4
# ╠═42bc5d28-8b35-11eb-0610-0df44a1b4935
# ╠═d6d4ef66-8b32-11eb-110b-7d0e70cdebba
# ╟─3b2b78f4-8f05-11eb-35e0-47bc10fdafd1
