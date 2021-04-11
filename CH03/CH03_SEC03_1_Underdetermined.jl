### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# ╔═╡ a0f79b2d-b209-4476-a5cc-f45a28f42d39
using Plots, LinearAlgebra, Convex, ECOS

# ╔═╡ 4ec7b380-6c95-4f47-aeee-d6bc24d247a6
html"""
<iframe width="100%" height="300" src="https://www.youtube.com/embed/otr1YwNBWfc" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ c1e12537-41c1-4ed6-9e5a-2bacb4f81c0c
begin
	# Solve y = Θs for "s"
	n = 1000  # dimension of s
	p =  200   # number of measurements, dim(y)
	Θ = randn(p,n)  
	y = randn(p,1)
end

# ╔═╡ e506d4f9-4ab7-4575-8adf-7d75ad6e8bde
begin
	# L1 Minimum norm solution s_L1
	# Create a (column vector) variable of size n x 1.
	s = Variable(n)
	
	# The problem is to minimize ‖y‖₁ subject to Θs = y
	# This can be done by: minimize(objective, constraints)
	problem = minimize(norm(s, 1), [Θ * s == y])
end

# ╔═╡ 296d7f9a-3fbe-4f64-b979-b091226be3ea
# Solve the problem by calling solve!
solve!(problem, () -> ECOS.Optimizer(verbose=false))

# ╔═╡ 90e507ac-767c-487d-a12f-711fafe722a3
# Get the optimum variables
s_L1 = evaluate(s)

# ╔═╡ 52f7b506-9748-11eb-32be-c576b3612dc8
s_L2 = pinv(Θ) * y  # L2 minimum norm solution s_L2

# ╔═╡ c00e241b-1f4d-4e8c-9e91-32f2cf08758a
begin
	plt_L1 = plot(s_L1, c=:"blue", lw=1.5, label=false, title="L1")
	plt_L2 = plot(s_L2, c=:"red", lw=1.5, label=false, title="L2")
	his_L1 = histogram(s_L1, bins = :scott, c=:"blue", lw=1.5, label=false)
	his_L2 = histogram(s_L2, bins = :scott, c=:"red", lw=1.5, label=false)
	plot(plt_L1, plt_L2, his_L1, his_L2,  layout=(2,2))
end

# ╔═╡ 2fc1e7c9-af08-42e8-9066-40825964c5d6
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
# ╟─4ec7b380-6c95-4f47-aeee-d6bc24d247a6
# ╠═a0f79b2d-b209-4476-a5cc-f45a28f42d39
# ╠═c1e12537-41c1-4ed6-9e5a-2bacb4f81c0c
# ╠═e506d4f9-4ab7-4575-8adf-7d75ad6e8bde
# ╠═296d7f9a-3fbe-4f64-b979-b091226be3ea
# ╠═90e507ac-767c-487d-a12f-711fafe722a3
# ╠═52f7b506-9748-11eb-32be-c576b3612dc8
# ╠═c00e241b-1f4d-4e8c-9e91-32f2cf08758a
# ╟─2fc1e7c9-af08-42e8-9066-40825964c5d6
