### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ e938d6f0-9050-11eb-1b6c-1bbf53b6c132
using FFTW, Plots; plotly()

# ╔═╡ f24be11e-9050-11eb-00e2-e5d454365ece
begin
	n = 128
	L = 30
	dx = L/(n)
	x = -L/2:dx:L/2-dx
	f = [cos(xₖ)*exp(-xₖ^2/25) for xₖ in x]       # Function
	df =[-(sin(x[k])*exp(-x[k]^2/25)+(2/25)*x[k]*f[k]) for k in 1:length(x)]  # Derivative
end

# ╔═╡ 2ffd306a-9051-11eb-1a45-f9976a9c9d08
begin
	# Approximate derivative using finite Difference...
	dfFD = Float64[]
	for kappa=1:length(df)-1
	    push!(dfFD, (f[kappa+1]-f[kappa])/dx)
	end
	push!(dfFD, dfFD[end])
end

# ╔═╡ 00ad521c-9052-11eb-0214-c9bb0d32c805
begin
	# Derivative using FFT (spectral derivative)
	fhat = fft(f)
	kappa = (2*π/L) .* (-n/2:n/2-1)
	kappa = fftshift(kappa)  # Re-order fft frequencies
	dfhat = im*kappa.*fhat
	dfFFT = real(ifft(dfhat))
end

# ╔═╡ e55c16a2-9050-11eb-0199-9104c83873ad
begin
	# Plotting commands
	plot(x,df, c=:black, lw=2.5, label="True Derivative")
	plot!(x,dfFD,c=:blue, lw=1.2, ls=:dot, label="Finite Diff.")
	plot!(x,dfFFT, c=:red, lw=1.2,ls=:dash, label="FFT Derivative")
	scatter!(x,dfFFT, c=:red, ms=2, label="FFT Derivative")
end

# ╔═╡ 158f9e5f-1aae-4c72-9a50-43d0cf5983b8
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
# ╠═e938d6f0-9050-11eb-1b6c-1bbf53b6c132
# ╠═f24be11e-9050-11eb-00e2-e5d454365ece
# ╠═2ffd306a-9051-11eb-1a45-f9976a9c9d08
# ╠═00ad521c-9052-11eb-0214-c9bb0d32c805
# ╠═e55c16a2-9050-11eb-0199-9104c83873ad
# ╟─158f9e5f-1aae-4c72-9a50-43d0cf5983b8
