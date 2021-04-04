### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ f3315280-94f4-11eb-22f2-f97cd508bd84
using Plots

# ╔═╡ 7ce035dc-d134-4550-afdc-0afc34d87bea
begin
	x = 0:.001:1
	
	n = length(x)
	n2 = floor(n/2) |> Int
	n4 = floor(n/4) |> Int
	
	f10 = zeros(n)
	f10[1:n2-1] .= 1
	f10[n2:end] .= -1
	
	f21 = zeros(n)
	f21[1:n4-1] .= 1
	f21[n4:n2-1] .= -1
	f21 = f21*sqrt(2)
	
	f22 = zeros(n)
	f22[n2:n2+n4-1] .= 1
	f22[n2+n4:end] .= -1
	f22 = f22*sqrt(2)
	
	x = vcat(-1, 0, x, 1, 2)
	f10 = vcat(0, 0, f10, 0, 0)
	f21 = vcat(0, 0, f21, 0, 0)
	f22 = vcat(0, 0, f22, 0, 0)	
	
end

# ╔═╡ 8a057aee-1d71-4a4a-88c3-27612fd1a275
begin
	xlim = (-0.2,1.2)
	ylim = (-1.75,1.75)
	p10 = plot(x,f10, c=:black, lw=2, xlim=xlim, ylim=ylim, label="f10")
	p21 = plot(x,f21, c=:black, lw=2, xlim=xlim, ylim=ylim, label="f21")
	p22 = plot(x,f22, c=:black, lw=2, xlim=xlim, ylim=ylim, label="f22")
	plot(p10, p21, p22, layout=(3,1))
end

# ╔═╡ 00c98264-c06f-4372-85db-6556bcebc574
begin
	xs = range(-5,5,step=0.001)
	fMexHat = (1 .- xs.^2) .* exp.(-xs.^2 ./2)
	plot(xs,fMexHat, c=:black, lw=2, label="Mexican Hat")
end

# ╔═╡ ba0080ff-6f83-4f08-9df7-1cea45ac3091
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
# ╠═f3315280-94f4-11eb-22f2-f97cd508bd84
# ╠═7ce035dc-d134-4550-afdc-0afc34d87bea
# ╠═8a057aee-1d71-4a4a-88c3-27612fd1a275
# ╠═00c98264-c06f-4372-85db-6556bcebc574
# ╟─ba0080ff-6f83-4f08-9df7-1cea45ac3091
