### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# ╔═╡ a0f79b2d-b209-4476-a5cc-f45a28f42d39
using Plots, JuMP, ECOS 

# ╔═╡ 5d2b8ffd-9778-47cb-8296-88551406f86d
import LinearAlgebra

# ╔═╡ c1e12537-41c1-4ed6-9e5a-2bacb4f81c0c
begin
	# Solve y = Θs for "s"
	n = 1000  # dimension of s
	p =  200   # number of measurements, dim(y)
	Θ = randn(p,n)  
	y = randn(p,1)
end

# ╔═╡ 35030bc6-e138-4c5c-85ce-7761757f4d10
begin
	# L1 Minimum norm solution s_L1
	
	# Initialize model
	model = Model(with_optimizer(ECOS.Optimizer))
	
	# Create a (column vector) variable of size n x 1.
	@variable(model, s[n:1])
	
	
	# The problem is to minimize ‖y‖₁ subject to Θs = y
	# This can be done by: minimize(objective, constraints)
	@objective(model, Min, LinearAlgebra.norm(s, 1) )
	@constraint(model, con, Θ * s == y)
	
	# Solve the problem by calling optimize!
	optimize!(model)
	
	# Check the status of the problem
	# termination_status(model)

	# Get the optimum value
	s_L1 = value(s)	
end

# ╔═╡ 52f7b506-9748-11eb-32be-c576b3612dc8
s_L2 = LinearAlgebra.pinv(Θ) * y  # L2 minimum norm solution s_L2

# ╔═╡ c00e241b-1f4d-4e8c-9e91-32f2cf08758a
plt_L2 = plot(s_L2, c=:"red", lw=1.5)

# ╔═╡ Cell order:
# ╠═a0f79b2d-b209-4476-a5cc-f45a28f42d39
# ╠═5d2b8ffd-9778-47cb-8296-88551406f86d
# ╠═c1e12537-41c1-4ed6-9e5a-2bacb4f81c0c
# ╠═35030bc6-e138-4c5c-85ce-7761757f4d10
# ╠═52f7b506-9748-11eb-32be-c576b3612dc8
# ╠═c00e241b-1f4d-4e8c-9e91-32f2cf08758a
