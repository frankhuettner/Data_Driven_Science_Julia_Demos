### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 6bb10fa2-8fb2-11eb-352b-2fdd460536e8
begin
	using Interpolations
	using Plots
end

# ╔═╡ fd71482e-8fb1-11eb-2995-c7f4f38e993a
begin
	f = [0, 0, .1, .2, .25, .2, .25, .3, .35, .43, .45, .5, .55, .5, .4, .425, .45, 			.425, .4, .35, .3, .25, .225, .2, .1, 0, 0]
	g = [0, 0, .025, .1, .2, .175, .2, .25, .25, .3, .32, .35, .375, .325, .3, .275, 			.275, .25, .225, .225, .2, .175, .15, .15, .05, 0, 0] .- 0.025
	x = 0.1*(1:length(f))
end

# ╔═╡ 8d839344-8fb8-11eb-2aef-b31de77c782c
begin
	f_interp = CubicSplineInterpolation(x, f)
	g_interp = CubicSplineInterpolation(x, g)
end

# ╔═╡ 004c8424-8fb9-11eb-33f4-434461bb6831
begin
	xfine = 0.1:0.01:x[end]
	ffine = f_interp(xfine)
	gfine = g_interp(xfine)
end

# ╔═╡ 4d2379c6-8fb6-11eb-1802-1b97d84141e3
begin
	scatter(x, f, c=:blue, label="f data")
	scatter!(xfine,ffine, c=:black, ms=2, label="f interpolated")
	scatter!(x, g, c=:red, label="g data")
	scatter!(xfine,gfine, c=:gray, ms=2, label="g interpolated")
end

# ╔═╡ 5eb5c1db-c9f0-4041-89bb-d1d37710a611
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
# ╠═6bb10fa2-8fb2-11eb-352b-2fdd460536e8
# ╠═fd71482e-8fb1-11eb-2995-c7f4f38e993a
# ╠═8d839344-8fb8-11eb-2aef-b31de77c782c
# ╠═004c8424-8fb9-11eb-33f4-434461bb6831
# ╠═4d2379c6-8fb6-11eb-1802-1b97d84141e3
# ╟─5eb5c1db-c9f0-4041-89bb-d1d37710a611
