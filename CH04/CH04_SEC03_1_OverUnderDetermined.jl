### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# ╔═╡ 47a5ec18-a8ff-11eb-320e-150284faee49
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="Convex"),
        Pkg.PackageSpec(name="Plots"),
		Pkg.PackageSpec(name="ECOS"),
        Pkg.PackageSpec(name="LaTeXStrings"),
    ])
    using Convex, Plots, LaTeXStrings, ECOS
end

# ╔═╡ 085a1359-93a8-4002-99de-ba0ed1e89ed1
let
	# underdetermined
	n = 20;  m = 100
	A = rand(n, m);  b = rand(n)	
	
	# L2 optimization 
	x2 = Variable(m)
	constraints2 = [A * x2 == b] # Define a list of constraints
	obj2 = norm(x2, 2)   # Define objective
	problem2 = minimize(obj2 , constraints2)  # Define problems
	solve!(problem2, () -> ECOS.Optimizer(verbose=false))	# Solve the problem 
	x2 = evaluate(x2)   # Get the optimum variables
	
	# L1 optimization 
	x1 = Variable(m)
	constraints1 = [A * x1 == b] # Define a list of constraints
	obj1 = norm(x1, 1)   # Define objective
	problem1 = minimize(obj1 , constraints1)  # Define problems
	solve!(problem1, () -> ECOS.Optimizer(verbose=false))	# Solve the problem 
	x1 = evaluate(x1)   # Get the optimum variables	
	
	plt2_val = bar(x2, legend=false, title=L"x_2")
	plt1_val = bar(x1, legend=false, title=L"x_1")
	plt2_dis = histogram(x2, bins=40, legend=false)
	plt1_dis = histogram(x1, bins=40, legend=false)
	
	plot(plt2_val, plt1_val, plt2_dis, plt1_dis)	
end

# ╔═╡ 1cfac885-49fc-417a-9811-2c0c836074d7
let
	# overdetermined
	n = 500;  m = 100
	A = rand(n, m);  b = rand(n)	
	
	λ = [0, 0.1, 0.5] # penalty weigth
	
	val_plots = []
	his_plots = []
	for j in 1:3
		x = Variable(m)
		obj = norm(A * x - b, 2) + λ[j] * norm(x, 1)   # Define objective
		problem = minimize(obj)  # Define problems
		solve!(problem, () -> ECOS.Optimizer(verbose=false))	# Solve the problem 
		x = evaluate(x)   # Get the optimum variables
		push!( val_plots, 
				bar(x, legend=false, title = L"\lambda_1 = %$(λ[j])", yticks = [-.1,0,.1]) )
		push!( his_plots, 
				histogram(x, bins = 20, title = L"\lambda_1 = %$(λ[j])",
					legend = false,  xticks=[-0.1,0,0.1], yticks=[0,40,80])
			)
	end
	l = @layout([a; b; c; [d e f]])
	plot(val_plots..., his_plots...,  layout = l)
	
end

# ╔═╡ c83cd2c9-9385-4cd7-9885-da361a216afa
let
	# overdetermined
	n = 300; m = 60; p = 20
	A = rand(n, m);  b = rand(n, p)

	plots = []
	λ = [0, 0.1]
	for j = 1:2
		x = Variable(m, p)
		problem = minimize(  norm(vec(A * x - b), 2) + λ[j] * norm(vec(x), 1)  )
		solve!(problem, () -> ECOS.Optimizer(verbose=false))	# Solve the problem 
		x = evaluate(x)   # Get the optimum variables
		push!(  plots, heatmap(x', title = L"\lambda_1 = %$(λ[j])", c=:hot)  )
	end
	plot(plots..., layout=(2,1))
end

# ╔═╡ d9d2aea4-3380-4bc9-b33b-978424014799
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
# ╠═47a5ec18-a8ff-11eb-320e-150284faee49
# ╠═085a1359-93a8-4002-99de-ba0ed1e89ed1
# ╠═1cfac885-49fc-417a-9811-2c0c836074d7
# ╠═c83cd2c9-9385-4cd7-9885-da361a216afa
# ╟─d9d2aea4-3380-4bc9-b33b-978424014799
