### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ ce32e01c-9430-11eb-398b-11baa85aec63
using FFTW, Plots, DifferentialEquations, PlutoUI

# ╔═╡ 5e2a7b20-ed19-46c5-b989-a7ee495bc737
begin
	ν = 0.001;   # Diffusion constant

	# Define spatial domain
	L = 20             # Length of domain 
	N = 1000           # Number of discretization points
	Δx = L/N
	x = range(-L/2, step=Δx, length = N) # Define x domain
end

# ╔═╡ e1b674e1-2ef2-45cd-a777-80ba7f01f6bb
# Define discrete wavenumbers
κ = 2 * π * fftfreq(N, 1/Δx)

# ╔═╡ 32f20fdb-9bdf-4679-9e78-85ade344c858
# Initial condition
u₀ = sech.(x)

# ╔═╡ 8f525462-5d54-4d4e-b875-82ef9ab60016
# Simulate PDE in spatial domain
Δt = 0.025; t = range(-L/2, step=Δx, length = 101)

# ╔═╡ 93cb953c-b1e9-47ff-a561-a2daa82ccbd0
function rhs_Burgers(u, param, tspan) 
	ν, κ = param # unpack parameters
	û = fft(u)
	ûₓ = im .* κ .* û   	# Note that subscript ₓ is just a unicode character, 
							# which is part the variable name and is not a command
	ûₓₓ = - κ.^2 .* û 
	uₓ = real( ifft(ûₓ) )
	uₓₓ = ifft(ûₓₓ) |> real
	return -u .* uₓ .+ ν .* uₓₓ
end

# ╔═╡ 2d8bdeef-3c94-49ac-95e3-74d313185807
begin
	param = (ν, κ)
	tspan = (t[1],t[end])
	prob = ODEProblem(rhs_Burgers, u₀, tspan, param)  # Define the ODE model
	
	sol = solve(prob, reltol=1e-5, saveat=t) # DP5() is the algorithm of ODE45
end

# ╔═╡ 6844647a-78a1-4cae-9342-9b6b04472708
@bind i Slider(1:length(t))

# ╔═╡ 46b973b3-a22a-4367-8583-05431f6ebbf7
begin
	gr()
	plot(sol[i], lw=2, title="time step = $(i-1)", legend=false)
end

# ╔═╡ 71ab00b8-b032-4c59-96e3-6cca5b153fea
begin
	idx(value, range) = findfirst(isequal(value),range)
	z = Surface( (xᵢ,tⱼ)->sol[idx(tⱼ,t)][idx(xᵢ,x)], x, t )
	plotly()   # allows for some change of perspective
	surface(x,t,z, xlabel="x", ylabel="t")
end

# ╔═╡ 94bd1f24-983a-4a99-b64e-58ea6c0f8579
let 
	import JLD
	disclaimer = JLD.load("../disclaimer.jld", "disclaimer")
	Markdown.parse(disclaimer) 
	disclaimer
end

# ╔═╡ b68c0e18-58f3-45a1-b880-9067f22be234
disclaimer

# ╔═╡ a1977452-34c0-4494-8270-0755c4571057
function openfile(fileloc)
    datafile = open(fileloc,"r")
    lines = readlines(datafile)
    close(datafile)
    lines[1]
end


# ╔═╡ 0f9f7e64-fa05-417f-95a3-a19a279a20eb
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
# ╠═ce32e01c-9430-11eb-398b-11baa85aec63
# ╠═5e2a7b20-ed19-46c5-b989-a7ee495bc737
# ╠═e1b674e1-2ef2-45cd-a777-80ba7f01f6bb
# ╠═32f20fdb-9bdf-4679-9e78-85ade344c858
# ╠═8f525462-5d54-4d4e-b875-82ef9ab60016
# ╠═93cb953c-b1e9-47ff-a561-a2daa82ccbd0
# ╠═2d8bdeef-3c94-49ac-95e3-74d313185807
# ╠═6844647a-78a1-4cae-9342-9b6b04472708
# ╠═46b973b3-a22a-4367-8583-05431f6ebbf7
# ╠═71ab00b8-b032-4c59-96e3-6cca5b153fea
# ╠═94bd1f24-983a-4a99-b64e-58ea6c0f8579
# ╠═b68c0e18-58f3-45a1-b880-9067f22be234
# ╠═a1977452-34c0-4494-8270-0755c4571057
# ╟─0f9f7e64-fa05-417f-95a3-a19a279a20eb
