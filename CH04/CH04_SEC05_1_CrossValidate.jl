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
    ])
    using Plots, StatsPlots 
end

# ╔═╡ 923c0d5c-9dbf-4a98-af0f-9096f5dd3e48
begin
	n = 200 
	L = 8
	x = range(0, stop = L, length = n)
	x1 = x[1:100]
	x2 = x[101:200]
	n1 = length(x1) 
	n2 = length(x2) 
	ftrain = [x1ᵢ^2 for x1ᵢ in x1]          # train parabola x=[0,4]
	ftest = [x2ᵢ^2 for x2ᵢ in x2]  # test parbola x=[4,5]

	plot(x1,ftrain,c=:red, lw=2, leg=false)
	plot!(x2, ftest, c=:blue, lw=2)

end

# ╔═╡ 57ff3117-5920-4cff-85f8-53f325ee24a2
begin
	M = 30                      # polynomial degree, number of model terms
	Eni = zeros(100,M)
	Ene = zeros(100,M)
	
	
	phi_i = zeros(n1, M)
	phi_e = zeros(n2, M)
	
	for jj = 1:M
	    for j = 1:jj
	        phi_i[:,j] = (x1').^(j-1) # interpolation key
	        phi_e[:,j] = (x2').^(j-1) # extrapolation key
	    end
	    
	    f = (x.^2)'
	    for j = 1:100
	        fni = (x1.^2 + 0.1 * randn(n1)) # interpolation
	        fne = (x2.^2 + 0.1 * randn(n2)) # extrapolation
	        
	        ani = pinv(phi_i) * fni 
			fnai = phi_i * ani
	        Eni[j,jj] = norm(ftrain-fnai)/norm(ftrain)
	        
	        fnae = phi_e * ani;  # use loadings from x in [0,4]
	        Ene[j,jj] = norm(ftest-fnae)/norm(ftest)
	    end
	end
end

# ╔═╡ 9118652e-8d66-4cfa-b0a5-e5601d132df5
begin
	plot(boxplot(Eni, leg = false, ylim=(0.0,0.7), 
				title="Error interpolation", xticks=[1,5,10,15,20,25,30] ),
		boxplot(Eni, leg = false, ylim=(0.0,0.02), 
			title="Error interpolation zoomed in",xticks=[1,5,10,15,20,25,30]),
		boxplot(Ene, leg = false, 
			title="Error extrapolation", xticks=[1,5,10,15,20,25,30]),
		boxplot(log.(Ene.+1), leg = false, 
			title="Logged error extrapolation", xticks=[1,5,10,15,20,25,30]),
		layout=(2,2), size=(800,600))
	
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
# ╠═57ff3117-5920-4cff-85f8-53f325ee24a2
# ╠═9118652e-8d66-4cfa-b0a5-e5601d132df5
# ╟─d9d2aea4-3380-4bc9-b33b-978424014799
