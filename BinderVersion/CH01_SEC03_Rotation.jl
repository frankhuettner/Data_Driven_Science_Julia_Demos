### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 2d509054-8e95-11eb-0394-ad6ee2ed6fca
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 07cb68e0-8594-11eb-094b-3f8dcc6045a7
begin
	Pkg.add("LinearAlgebra")
	Pkg.add("Plots")
	using LinearAlgebra
	using Plots
	plotly()
end

# ╔═╡ 4f4db364-8594-11eb-1ff7-55f5196879e9
begin
	θ = [π/15, -π/9, -π/20]
	Σ = Diagonal([3, 1, 0.5]) # scale x, then y, then z
	
	# Rotation about x axis
	Rx = [[1 	0 			0 			]; 
	      [0 	cos(θ[1]) 	-sin(θ[1]) 	];
	      [0 	sin(θ[1]) 	cos(θ[1]) 	] ]
	
	# Rotation about y axis
	Ry = [[cos(θ[2]) 	0 	sin(θ[2])	];
		  [0 			1 	0 			];
	      [-sin(θ[2]) 	0 	cos(θ[2])	] ]
	
	# Rotation about z axis
	Rz = [[cos(θ[3]) 	-sin(θ[3]) 	0];
	      [sin(θ[3]) 	cos(θ[3]) 	0];
		  [0 			0 			1] ]
	
	# Rotate and scale
	X = Rz * Ry * Rx * Σ
end

# ╔═╡ fc0a12d6-85f2-11eb-1c70-6151fb235cad
begin 
	n = 100
	u = range(0,stop=2*π,length=n);
	v = range(0,stop=π,length=n);
	
	x = cos.(u) * sin.(v)';
	y = sin.(u) * sin.(v)';
	z = ones(n) * cos.(v)';
	
	# Plotting the sphere
	lims = (-2, 2)
	plt1 = surface(x,y,z, 
		alpha=0.6, c =:jet1, xlim=lims, ylim=lims, zlim=lims, legend=false) 
	wireframe!(plt1, x,y,z)
end

# ╔═╡ 1189dc9a-8602-11eb-27f7-c129afee0a29
begin
	# Data of the transformed sphere
	xR = similar(x)
	yR = similar(y)
	zR = similar(z)
	
	for i in 1:n
	    for j in 1:n
	        vec = [x[i,j], y[i,j], z[i,j]]
	        vecR = X * vec
	        xR[i,j] = vecR[1]
	        yR[i,j] = vecR[2]
	        zR[i,j] = vecR[3]
	    end
	end
	# Plotting transformed sphere
	plt2 = surface(xR,yR,zR, 
		alpha=0.6, c =:jet1, xlim=lims, ylim=lims, zlim=lims,legend=false) 
	wireframe!(plt2, xR,yR,zR) 
	plot(plt1,plt2, layout=(1,2))
end

# ╔═╡ d0a7384a-8f65-11eb-2b8a-d319ec6b8d76
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
# ╠═2d509054-8e95-11eb-0394-ad6ee2ed6fca
# ╠═07cb68e0-8594-11eb-094b-3f8dcc6045a7
# ╠═4f4db364-8594-11eb-1ff7-55f5196879e9
# ╠═fc0a12d6-85f2-11eb-1c70-6151fb235cad
# ╠═1189dc9a-8602-11eb-27f7-c129afee0a29
# ╟─d0a7384a-8f65-11eb-2b8a-d319ec6b8d76
