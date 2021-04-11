### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# ╔═╡ a0f79b2d-b209-4476-a5cc-f45a28f42d39
using Plots, LinearAlgebra, FFTW, Convex, ECOS

# ╔═╡ 12b111af-1b86-461e-ab19-cda18b9a3e6a
html"""
<iframe width="100%" height="300" src="https://www.youtube.com/embed/A8W1I3mtjp8" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ c1e12537-41c1-4ed6-9e5a-2bacb4f81c0c
begin
	## Generate signal, DCT of signal
	n = 4096 # points in high resolution signal
	t = LinRange(0, 1, n)
	x = cos.(2 * 97 * π * t) + cos.(2 * 777 * π * t)
	xt = fft(x) # Fourier transformed signal
	PSD = abs2.(xt) ./ n # Power spectral density
end

# ╔═╡ 2f6a9a34-448b-4960-9976-20e6714af4d6
begin
	## Randomly sample signal
	p = 128 # num. random samples, p = n/32
	perm = rand(range(1,length=n), p)
	y = x[perm]
end

# ╔═╡ 047c3e26-d9be-4065-869d-9b279c4edfd2
begin
	# Solve compressed sensing problem
	Ψ = dct(I(n), 2)  # build Ψ
	Θ = Ψ[perm, :]  # Measure rows of Ψ
end

# ╔═╡ e506d4f9-4ab7-4575-8adf-7d75ad6e8bde
begin
	# L1 Minimum norm solution s_L1
	# Create a (column vector) variable of size n x 1.
	var_s = Variable(n, 1)
	
	# The problem is to minimize ‖y‖₁ subject to Θs = y
	# This can be done by: minimize(objective, constraints)
	problem = minimize(norm(var_s, 1), [Θ * var_s == y])
	
	# Solve the problem by calling solve!
	solve!(problem, () -> ECOS.Optimizer(verbose=false))	
	
	# Get the optimum variables
	s = evaluate(var_s)
end

# ╔═╡ 42197865-53d2-4c44-b104-d4439ea7cfef
begin
	x_recon = idct(s)    # reconstruct full signal
	xt_recon = fft(x_recon) # computes the (fast) discrete fourier transform
	PSD_recon = abs2.(xt_recon) ./ n  # Power spectrum (how much power in each freq)
end

# ╔═╡ 4a20c398-b119-445d-b2cd-a4236430ade5
begin
	plotly()
	time_window = [1024,1280]./4096
	freq = range(0,stop=n)  # create the x-axis of frequencies in Hz
	L = 1:Int(floor(n/2))  # only plot the first half of freqs
	
	subplt12 = plot(freq[L],PSD[L], c=:"black", lw=2, label=false, xlim=(0, 1024))
	subplt11 = plot(t, x, c=:"black", lw=2, label=false, 		
					xlim=(time_window[1],time_window[2]) )
	scatter!(subplt11, perm/n, y, 
		mscolour=:"red", 
		malpha=0.2,
		msalpha=1, 
		markerstrokewidth=2,
		markersize=6, 
		label=false)
	
	subplt22 = plot(freq[L],PSD_recon[L], c=:"red", lw=2, label=false, xlim=(0, 1024))
	subplt21 = plot(t, x_recon, c=:"red", lw=2, label=false, 		
					xlim=(time_window[1],time_window[2]) )
	
	plot(subplt11, subplt12, subplt21, subplt22, layout=(2,2))
end

# ╔═╡ db158da2-6960-46ab-b105-1200a4b27c90
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
# ╟─12b111af-1b86-461e-ab19-cda18b9a3e6a
# ╠═a0f79b2d-b209-4476-a5cc-f45a28f42d39
# ╠═c1e12537-41c1-4ed6-9e5a-2bacb4f81c0c
# ╠═2f6a9a34-448b-4960-9976-20e6714af4d6
# ╠═047c3e26-d9be-4065-869d-9b279c4edfd2
# ╠═e506d4f9-4ab7-4575-8adf-7d75ad6e8bde
# ╠═42197865-53d2-4c44-b104-d4439ea7cfef
# ╠═4a20c398-b119-445d-b2cd-a4236430ade5
# ╟─db158da2-6960-46ab-b105-1200a4b27c90
