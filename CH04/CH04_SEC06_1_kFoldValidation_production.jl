### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# ╔═╡ 47a5ec18-a8ff-11eb-320e-150284faee49
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="Plots"),
        Pkg.PackageSpec(name="StatsPlots"),
        Pkg.PackageSpec(name="GLMNet"),
        Pkg.PackageSpec(name="LinearAlgebra"),
        Pkg.PackageSpec(name="Statistics"),
    ])
    using Plots, StatsPlots,  GLMNet , LinearAlgebra, Statistics
end

# ╔═╡ 923c0d5c-9dbf-4a98-af0f-9096f5dd3e48
begin
	n = 100 
	L = 4
	x = range(0, stop=L, length=100)
	f = x.^2 # parabola with 100 data points
	
	M = 21 # polynomial degree
	
    phi = [xi^(j-1) for xi in x, j in 1:M] # build matrix A
end

# ╔═╡ cd0c774f-7d81-4f82-a5c8-ba8cc760a8b1
begin
	A1 = zeros(M, n)
	A2 = zeros(M, n)
	A3 = zeros(M, n)
	A1m = zeros(M)
	A2m = zeros(M)
	A3m = zeros(M)
	
	E1 = zeros(n)
	E2 = zeros(n)
	E3 = zeros(n)
	plots = []
	trials=[2 10 100]
	for j=1:3    
	    for jj=1:trials[j]
	       	f=(x.^2+0.2*randn(n))
			
	       	a1=pinv(phi)*f; f1=phi*a1; E1[jj]=norm(f-f1)/norm(f)
	       
			a2=phi\f; f2=phi*a2; E2[jj]=norm(f-f2)/norm(f)
			
			# Lasso with penalty λ‖a3‖₁ = 0.1‖a3‖₁ on the coefficients
			path = glmnet(phi, f, lambda=[0.1]); a3 = path.betas  
			f3 = phi * a3;  E3[jj] = norm(f - f3) / norm(f)
	       	
			A1[:,jj]=a1; A2[:,jj]=a2; A3[:,jj]=a3
	    end
	    A1m=mean(A1, dims=2); A2m=mean(A2, dims=2); A3m=mean(A3, dims=2)
	    
	    push!(plots, bar(A1m, leg=false, title="pinv k=$(trials[j])")) 
	    push!(plots, bar(A2m, leg=false, title="backslash k=$(trials[j])")) 
	    push!(plots, bar(A3m, leg=false, title="lasso k=$(trials[j])")) 
	end
	  
	plot((reshape(plots,3,3)|>permutedims)..., layout=(3,3))
end

# ╔═╡ 04e84ba3-e877-44ff-8988-2deca0e4ec15
begin
	Atot = [A1m A2m A3m]  # average loadings of three methods
	Atot2 = (abs.(Atot) .> 0.2) .* Atot # threshold
	Atot3 = [Atot  Atot2]  # combine both thresholded and not
end

# ╔═╡ 50781533-601f-4b8f-a985-6bf15c6c1d9d
begin
	cat = [ cat  for i = 1:21, cat in ["pinv", "backslash", "lasso"] ] |> vec
	gnam = repeat((0:20), outer = 3)
	groupedbar(gnam, Atot, group = cat, xlabel = "Degree", ylabel = "Loading",
	        title = "Not thresholded", bar_width = 0.67,
	        lw = 0, framestyle = :box)
end

# ╔═╡ a6d73bab-b0b4-430a-8c42-f1851b37e9e8
	groupedbar(gnam, Atot2, group = cat, xlabel = "Degree", ylabel = "Loading",
	        title = "Thresholded", bar_width = 0.67,
	        lw = 0, framestyle = :box)

# ╔═╡ 63bfb6a1-902d-49b8-81b4-6513b23f140a
let
	n = 200
	L = 8
	x = range(0,stop=L,length=n)
	x1 = x[1:100]    # Train
	x2 = x[101:200] # Test
	n1 = length(x1)
	n2 = length(x2)
	ftrain = x1.^2 # Train parabola x = [0,4]
	ftest = x2.^2  # Test parabola x = [4,8]
	
	phi_i = zeros(n1,M)
	phi_e = zeros(n2,M)
	
	for j in 1:M
	    phi_i[:,j] = x1.^j # interpolation key
	    phi_e[:,j] = x2.^j # extrapolation key
	end
	    
	Eni = zeros(6)
	Ene = zeros(6)
	for jj in 1:6 # compute inter/extra-polation scores
	    ani = Atot3[:,jj]
	    fnai = phi_i * ani
	    Eni[jj] = norm(ftrain-fnai) / norm(ftrain)
	    fnae = phi_e * ani
	    Ene[jj] = norm(ftest-fnae) / norm(ftest)
	end
	plot(bar(Eni, leg=false, title="Interpolation"), 
		bar(Ene, leg=false, title="Extrapolation"), 
		 bar(Eni, leg=false, ylim=(0,10) ), 
		bar(Ene, leg=false, ylim=(0,100))
		)
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
# ╠═923c0d5c-9dbf-4a98-af0f-9096f5dd3e48
# ╠═cd0c774f-7d81-4f82-a5c8-ba8cc760a8b1
# ╠═04e84ba3-e877-44ff-8988-2deca0e4ec15
# ╠═50781533-601f-4b8f-a985-6bf15c6c1d9d
# ╠═a6d73bab-b0b4-430a-8c42-f1851b37e9e8
# ╠═63bfb6a1-902d-49b8-81b4-6513b23f140a
# ╟─d9d2aea4-3380-4bc9-b33b-978424014799
