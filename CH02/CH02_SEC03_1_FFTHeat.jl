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

# ╔═╡ a37dca5c-9053-11eb-1bcd-d34615a93ead
using FFTW, Plots, DifferentialEquations, PlutoUI

# ╔═╡ b174e974-9053-11eb-0171-654ba5a604a4
begin
	α = 1        # Thermal diffusivity constant
	L = 100      # Length of domain
	N = 1000      # Number of discretization points
	dx = L/N
	x = range(-L/2,L/2-1,step=dx) # Define x domain
end

# ╔═╡ c9763186-9053-11eb-0957-c9130b1b0a45
begin
	# Define discrete wavenumbers
	κ = 2 * π * fftfreq(N,1/dx)
	# Alternatively	
	# κ = (2*π/L) .* range(-N/2, N/2-1, length=N)  |> fftshift
end

# ╔═╡ 1eabc4ea-9054-11eb-18e3-890f8f1b11c0
begin
	# Initial condition
	u₀ = zeros(N)
	u₀[Int.((L/2 - L/10)/dx:(L/2 + L/10)/dx)] .= 1
	û₀ = fft(u₀)
end

# ╔═╡ 46163372-9091-11eb-369d-1bcfaf75a5d7
#Simulate in Fourier frequency domain
Δt = 0.1;  t = 0:Δt:10

# ╔═╡ 91876a36-909b-11eb-3c93-ff78c91f96c5
function rhs_heat(û, p, t) 
	α, κ = p # unpack parameters
	dû = -α^2 .* κ.^2 .* û 
end

# ╔═╡ 68d35082-9091-11eb-0c5c-5f94313fa656
begin
	p = (α, κ)
	tspan = (t[1],t[end])
	prob = ODEProblem(rhs_heat, û₀, tspan, p)  # Define the ODE model
	
	sol = solve(prob, DP5(), saveat=t) # DP5() is the algorithm of ODE45
end

# ╔═╡ 385c865e-909f-11eb-1670-25b693412174
u = [real(ifft(sol[k])) for k = 1:length(t)]	 # iFFT to return to spatial domain

# ╔═╡ d3ccddb4-909f-11eb-36a6-0b112c8b7c53
@bind k Slider(1:length(t))

# ╔═╡ 3918993c-9425-11eb-1264-752f13fdddf2
begin
	gr()
	plot(u[k], lw=2, title="t = $(t[k])", legend=false)
end

# ╔═╡ 7d915736-9428-11eb-31df-5563bd5ed963
begin
	idx(value, range) = findfirst(isequal(value),range)
	z = Surface( (xᵢ,tⱼ)->u[idx(tⱼ,t)][idx(xᵢ,x)], x, t )
	plotly()   # allows for some change of perspective
	surface(x,t,z, xlabel="x", ylabel="t")
end

# ╔═╡ 969ec4ea-fe63-4843-b50a-36184f318ab7
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
# ╠═a37dca5c-9053-11eb-1bcd-d34615a93ead
# ╠═b174e974-9053-11eb-0171-654ba5a604a4
# ╠═c9763186-9053-11eb-0957-c9130b1b0a45
# ╠═1eabc4ea-9054-11eb-18e3-890f8f1b11c0
# ╠═46163372-9091-11eb-369d-1bcfaf75a5d7
# ╠═91876a36-909b-11eb-3c93-ff78c91f96c5
# ╠═68d35082-9091-11eb-0c5c-5f94313fa656
# ╠═385c865e-909f-11eb-1670-25b693412174
# ╠═d3ccddb4-909f-11eb-36a6-0b112c8b7c53
# ╠═3918993c-9425-11eb-1264-752f13fdddf2
# ╠═7d915736-9428-11eb-31df-5563bd5ed963
# ╠═969ec4ea-fe63-4843-b50a-36184f318ab7
