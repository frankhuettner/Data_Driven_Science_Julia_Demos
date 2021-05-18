### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# ╔═╡ e31be176-376f-43f6-97a2-be53c555e6ff
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="Plots"),
        Pkg.PackageSpec(name="LinearAlgebra"),
        Pkg.PackageSpec(name="StatsBase"),
        Pkg.PackageSpec(name="Images"),
    ])
    using Plots, LinearAlgebra, StatsBase,  Images
end

# ╔═╡ 2ee9eee7-8570-4b3e-b4e2-47a70b91c145
let 	
	# Training and test set sizes
	n1 = 100 # Training set size
	n2 = 50  # Test set size

	# Random ellipse 1 centered at (-2,0)
	x = randn(n1 + n2) .- 2
	y = 0.5 .* randn(n1 + n2)

	# Random ellipse 5 centered at (1,0)
	x5 = 2 .* randn(n1 + n2) .+ 1
	y5 = 0.5 .* randn(n1 + n2)

	# Random ellipse 2 centered at (2,-2)
	x2 = randn(n1 + n2) .+ 2
	y2 = 0.2 .* randn(n1 + n2) .- 2

	# Rotate ellipse 2 by theta
	θ = π/4
	A = zeros(2, 2)
	A=[cos(θ) -sin(θ); sin(θ) cos(θ)]

	x3 = A[1,1] * x2 + A[1,2] * y2
	y3 = A[2,1] * x2 + A[2,2] * y2	
	
	subplot_11 = scatter(x[1:n1], y[1:n1], ms=5, c=:lightgray, leg=false)
	scatter!(x3[1:n1], y3[1:n1], ms=5, c=:lightgray)
	
	subplot_12 = scatter(x[1:70], y[1:70], ms=5, c=:lightgray, leg=false)
	scatter!(x3[1:70], y3[1:70], ms=5, c=:lightgray)
	scatter!(x[71:n1], y[71:n1], ms=5, c=:lime)
	scatter!(x3[71:n1], y3[71:n1], ms=5, c=:magenta)
	
	
	subplot_21 = scatter(x5[1:n1], y5[1:n1], ms=5, c=:lightgray, leg=false)
	scatter!(x3[1:n1], y3[1:n1], ms=5, c=:lightgray)
	
	subplot_22 = scatter(x5[1:70], y5[1:70], ms=5, c=:lightgray, leg=false)
	scatter!(x3[1:70], y3[1:70], ms=5, c=:lightgray)
	scatter!(x5[71:n1], y5[71:n1], ms=5, c=:lime)
	scatter!(x3[71:n1], y3[71:n1], ms=5, c=:magenta)
	
	plot(subplot_11, subplot_12, subplot_21, subplot_22)
end

# ╔═╡ 193df697-334f-4b71-b6b5-73e4107b29d2
let 	
	n1 = 300 # training set size
	x1 = 1.5 * randn(n1) .- 1.5
	y1 = 1.2 * randn(n1) + (x1 .+ 1.5).^2 .- 7
	x2 = 1.5 * randn(n1) .+ 1.5
	y2 = 1.2 * randn(n1) - (x2 .- 1.5).^2 .+ 7

	subplot_1 = scatter(x1, y1, ms=5, c=:magenta, 
		leg=false, xlim=(-6,6), ylim=(-10,10))
	scatter!(x2, y2, ms=5, c=:lime)
	
	r = 7 .+ randn(n1)
	th = 2 * π * randn(n1)
	xr = r .* cos.(th)
	yr = r .* sin.(th)

	x5 = randn(n1)
	y5 = randn(n1)
	
	subplot_2 = scatter(xr, yr, ms=5, c=:lime, 
		leg=false, xlim=(-10,10), ylim=(-10,10))
	scatter!(x5, y5, ms=5, c=:magenta)
	
	plot(subplot_1, subplot_2, layout=(2,1))
	
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
# ╠═e31be176-376f-43f6-97a2-be53c555e6ff
# ╠═2ee9eee7-8570-4b3e-b4e2-47a70b91c145
# ╠═193df697-334f-4b71-b6b5-73e4107b29d2
# ╟─3d560fb8-8f05-11eb-1603-87841aa9858a
