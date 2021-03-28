### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 07cb68e0-8594-11eb-094b-3f8dcc6045a7
begin
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

# ╔═╡ ab766448-8f05-11eb-3158-2dcf363c5f21
md"[Frank Huettner](https://frankhuettner.de) has created this Pluto notebook with Julia code and all errors are on him. It mimics the [Matlab code here](https://github.com/dylewsky/Data_Driven_Science_Python_Demos), and it is intended as a companion to chapter 1 of the book:  
[Data Driven Science & Engineering: Machine Learning, Dynamical Systems, and Control  
by S. L. Brunton and J. N. Kutz, Cambridge Textbook, 2019, Copyright 2019, All Rights Reserved]
(http://databookuw.com/). 
Please cite this book when using this code/data. 
No guarantee can be given for the functionality of this code."

# ╔═╡ Cell order:
# ╠═07cb68e0-8594-11eb-094b-3f8dcc6045a7
# ╠═4f4db364-8594-11eb-1ff7-55f5196879e9
# ╠═fc0a12d6-85f2-11eb-1c70-6151fb235cad
# ╠═1189dc9a-8602-11eb-27f7-c129afee0a29
# ╟─ab766448-8f05-11eb-3158-2dcf363c5f21
