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
	c = 2    # Wave speed
	L = 20   # Length of domain
	N = 1000 # Number of discretization points
	dx = L/N
	x = range(-L/2, step=dx, length = N) # Define x domain
end

# ╔═╡ e1b674e1-2ef2-45cd-a777-80ba7f01f6bb
# Define discrete wavenumbers
kappa = 2 * pi * fftfreq(N, 1/dx)

# ╔═╡ 32f20fdb-9bdf-4679-9e78-85ade344c858
begin
	# Initial condition
	u0 = 1 ./ cosh.(x)
	u0hat = fft(u0)
end

# ╔═╡ 8f525462-5d54-4d4e-b875-82ef9ab60016
begin
	# Simulate in Fourier frequency domain
	dt = 0.025
	t = range(0, step=dt, length=100)
end

# ╔═╡ d831e598-20e7-4ab8-8d29-079332c703e8
function rhsWave(uhat, p, t)
	c, kappa = p
    return duhat_dt = - c .* im .* kappa .* uhat
end

# ╔═╡ c01bc0c3-534e-47a0-ab59-c5cc8ed78425
# Alternatively, simulate in spatial domain
function rhsWaveSpatial(u,p,t)
	c, kappa = p
    uhat = fft(u)
    d_uhat = im .* kappa .* uhat
    d_u = real(ifft(d_uhat))
    du_dt = -c * d_u
    return du_dt
end

# ╔═╡ 2d8bdeef-3c94-49ac-95e3-74d313185807
begin
	p = (c, kappa)
	tspan = (t[1],t[end])
	prob = ODEProblem(rhsWave, u0hat, tspan, p)  # Define the ODE model
	# prob = ODEProblem(rhsWaveSpatial, u0, tspan, p)  # ODE model in spatial domain
	sol = solve(prob, DP5(), saveat=t) # DP5() is the algorithm of ODE45
end

# ╔═╡ df780b6f-eeb2-4309-976e-bc6503864bb8
u = [real(ifft(sol[k])) for k = 1:length(t)]	 # iFFT to return to spatial domain
# u = sol  # When solved in spatial domain

# ╔═╡ 81f3a529-856b-4441-a1e8-3de1cb590af6
@bind k Slider(1:length(t))

# ╔═╡ 2df382fa-6ba3-43ad-8b7a-20765ef41fcc
begin
	gr()
	plot(u[k], lw=2, title="t = $(t[k])", legend=false)
end

# ╔═╡ 11167998-6728-4bfc-bb30-58fb5a5ca051
begin
	idx(value, range) = findfirst(isequal(value),range)
	z = Surface( (xᵢ,tⱼ)->u[idx(tⱼ,t)][idx(xᵢ,x)], x, t )
	plotly()   # allows for some change of perspective
	surface(x,t,z, xlabel="x", ylabel="t")
end

# ╔═╡ 103944e8-5583-42c8-8692-56c71c9537af
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
# ╠═d831e598-20e7-4ab8-8d29-079332c703e8
# ╠═c01bc0c3-534e-47a0-ab59-c5cc8ed78425
# ╠═2d8bdeef-3c94-49ac-95e3-74d313185807
# ╠═df780b6f-eeb2-4309-976e-bc6503864bb8
# ╠═81f3a529-856b-4441-a1e8-3de1cb590af6
# ╠═2df382fa-6ba3-43ad-8b7a-20765ef41fcc
# ╠═11167998-6728-4bfc-bb30-58fb5a5ca051
# ╟─103944e8-5583-42c8-8692-56c71c9537af
