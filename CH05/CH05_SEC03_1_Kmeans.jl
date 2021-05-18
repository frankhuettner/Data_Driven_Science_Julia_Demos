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
        Pkg.PackageSpec(name="Clustering"),
        Pkg.PackageSpec(name="StatsPlots"),
    ])
    using Plots, LinearAlgebra, StatsBase, Images, Clustering, StatsPlots
end

# ╔═╡ 2ee9eee7-8570-4b3e-b4e2-47a70b91c145
begin 	
	# Training and testing set sizes
	n1 = 100 # Train
	n2 = 50  # Test
	n = n1 + n2

	# Random ellipse 1 centered at (0,0)
	x = randn(n)
	y = 0.5 * randn(n)

	# Random ellipse 2 centered at (1,-2)
	x2 = randn(n) .+ 1
	y2 = 0.2 * randn(n) .- 2

	# Rotate ellipse 2 by theta
	θ = π/4
	A = zeros(2,2)
	A = [cos.(θ) -sin.(θ); sin.(θ)  cos.(θ)]

	x3 = A[1,1] * x2 + A[1,2] * y2
	y3 = A[2,1] * x2 + A[2,2] * y2
	
	scatter(x[1:n1], y[1:n1], ms=3, c=:red, leg=false)
	scatter!(x3[1:n1], y3[1:n1], ms=3, c=:blue)
end

# ╔═╡ 193df697-334f-4b71-b6b5-73e4107b29d2
begin 	
	# Training set: first 200 of 240 points
	X1 = [x3[1:n1] y3[1:n1]]
	X2 = [x[1:n1] y[1:n1]]
	
	Y=[X1; X2]
	Z=[ones(n1); 2*ones(n1)]

	# Test set: remaining 40 points
	x1test = [x3[n1+1:end] y3[n1+1:end]]
	x2test = [x[n1+1:end] y[n1+1:end]]
	
end

# ╔═╡ 9341861f-4ff3-4ceb-9197-dfa2c933ef8b
begin
	g1 = (-1.0,  0.0) # Initial guess
	g2 = (1.0,  0.0)
	
	class1 = []
	class2 = []
	plots = []
	
	for	j = 1:4
		class1_j = [g1]
		class2_j = [g2]
	    for jj = 1:size(Y,1)       
	        d1 = norm(g1 .- Y[jj,:])
	        d2 = norm(g2 .- Y[jj,:])
	        if d1 < d2
	        	push!(class1_j, (Y[jj,1], Y[jj,2]))
	        else
	        	push!(class2_j, (Y[jj,1], Y[jj,2]))
	        end        
	    end
		class1 = class1_j
		class2 = class2_j
		plot_j = scatter(class1, c=:red, leg=false)
		scatter!(class2, c=:blue) 
		scatter!(g1 ,ms=10, markershape=:star5, c=:black)
		scatter!(g2 ,ms=10, markershape=:star5, c=:black)
		push!(plots, plot_j)
		g1 = (mean(x[1] for x in class1), mean(x[2] for x in class1))
		g2 = (mean(x[1] for x in class2), mean(x[2] for x in class2))
	
	end 
	plot(plots...)
end

# ╔═╡ 4f5e9c55-7ec7-49cf-bc36-bba5a5e5789c
g1, g2

# ╔═╡ 2fd3952c-eb6e-4a9c-9aac-d1396ffcf810
# kmeans code
R = kmeans(Y', 2)

# ╔═╡ 7749c273-6427-4132-8183-de6f0f9a6707
scatter(Y[:,1],Y[:,2], marker_z=assignments(R), leg=false, ylim=(-3,2),xlim=(-2,4))

# ╔═╡ fbbc21ec-5dc6-4943-a9de-85d05709e369
nclusters(R) == 2 # verify the number of clusters

# ╔═╡ d186c97f-484d-48a6-b394-80effcaab62b
assignments(R) # get the assignments of points to clusters

# ╔═╡ 9e4f4e20-43c0-44c6-ac88-26ebee366a72
counts(R) # get the cluster sizes

# ╔═╡ 9b30d2e8-c16e-47db-89c7-e080586c5f51
c = R.centers # get the cluster centers

# ╔═╡ e5662894-c37a-4345-9e99-a28886a6580a
let # Compare package with our code
	plot = scatter(g1, ms=10, markershape=:star5, c=:black, leg=false)
	scatter!(plot, g2, ms=10, markershape=:star5, c=:black)
	scatter!(plot, (c[1,1],c[2,1]), ms=10, c=:black)
	scatter!(plot, (c[1,2],c[2,2]), ms=10, c=:black)
end

# ╔═╡ 581c79e6-def3-4b1f-a9d8-ffb3acf3ecc3
begin
	midx = (c[1,1]+c[1,2])/2
	midy = (c[2,1]+c[2,2])/2
	slope = (c[2,2]-c[2,1])/(c[1,2]-c[1,1]) # rise/run
	b = midy + (1/slope) * midx
	xsep = -1:0.1:2
	ysep = -(1/slope) * xsep .+ b
	
	# error on training data
	p1 = scatter(x[1:n1],y[1:n1], c=:red, 
		title="Training Data", leg=false, ylim=(-3,2),xlim=(-2,4))
	scatter!(x3[1:n1],y3[1:n1], c=:blue)
	plot!(xsep, ysep, leg=false, lw=2, c=:black)
	
	# error on test data
	p2 = scatter(x[n1+1:end],y[n1+1:end], c=:red, 
		title="Test Data", leg=false, ylim=(-3,2),xlim=(-2,4))
	scatter!(x3[n1+1:end],y3[n1+1:end], c=:blue)
	plot!(xsep, ysep, leg=false, lw=2, c=:black)
    
	plot(p1, p2, layout=(2,1))
end

# ╔═╡ 6bee228f-664b-4071-b933-3eebc7d7dbec
begin
	## Dendrograms
	
	Y3 = [X1[1:50,:]; X2[1:50,:]]
	distance_matrix = pairwise(Euclidean(1e-12), Y3', dims=2)
	Y2 = hclust(distance_matrix, linkage=:average)
end

# ╔═╡ 896c8981-2295-43a1-b9f6-2bae5f192298
maximum(Y2.heights)

# ╔═╡ 66419b3b-3b9b-4aa8-aa2a-43452cf94560
plot(Y2)

# ╔═╡ 161328b2-0940-47b9-a89c-65c3c0831bd4
begin
	bar(1:100,Y2.order, leg=false)
	plot!([0, 100],[50, 50],c=:red, ls=:dot, lw=2)
	plot!([50.5, 50.5],[0, 100],c=:red, ls=:dot, lw=2)
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
# ╠═9341861f-4ff3-4ceb-9197-dfa2c933ef8b
# ╠═4f5e9c55-7ec7-49cf-bc36-bba5a5e5789c
# ╠═2fd3952c-eb6e-4a9c-9aac-d1396ffcf810
# ╠═7749c273-6427-4132-8183-de6f0f9a6707
# ╠═fbbc21ec-5dc6-4943-a9de-85d05709e369
# ╠═d186c97f-484d-48a6-b394-80effcaab62b
# ╠═9e4f4e20-43c0-44c6-ac88-26ebee366a72
# ╠═9b30d2e8-c16e-47db-89c7-e080586c5f51
# ╠═e5662894-c37a-4345-9e99-a28886a6580a
# ╠═581c79e6-def3-4b1f-a9d8-ffb3acf3ecc3
# ╠═6bee228f-664b-4071-b933-3eebc7d7dbec
# ╠═896c8981-2295-43a1-b9f6-2bae5f192298
# ╠═66419b3b-3b9b-4aa8-aa2a-43452cf94560
# ╠═161328b2-0940-47b9-a89c-65c3c0831bd4
# ╟─3d560fb8-8f05-11eb-1603-87841aa9858a
