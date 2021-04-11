### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# ╔═╡ 05bcf896-968f-11eb-3c61-f30007a3e8df
using Images, FFTW, LinearAlgebra, Statistics, Plots

# ╔═╡ 98e5bf29-030e-4557-816b-b47561621b31
html"""
<iframe width="100%" height="300" src="https://www.youtube.com/embed/SbU1pahbbkc" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ f280d3b0-87f6-409b-9514-e050c77aabf6
begin
	A = load("../../DATA/jelly.jpg")	
	A_bw = channelview( Gray.(A) ) # Convert RGB to grayscale and as Array
end

# ╔═╡ a5347277-3dc6-4560-bde9-5362b5546eed
Gray.(A)

# ╔═╡ 5dc1dc8d-5759-4402-9f43-50d9fa0a59d2
md"Above: original image. Below left: Fourier transform. Below right: Sparsified Fourier transform (95% of entries set to zero)"

# ╔═╡ 2f4bb5f9-423f-4451-82fa-c240c0fa8f00
begin
	A_t = A_bw |> fft |> fftshift   ## Compute FFT and shift of image 
	F = log.(abs.(A_t)) # Put FFT on log scale
	
	
	## Zero out all small coefficients and inverse transform
	
	# A little helper function that sets all entries smaller than threshold to zero
	sparsify(x, thresh) = abs(x) < thresh ? zero(eltype(x)) : x

	keep = 0.05
	thresh = quantile(abs.(vec(A_t)), keep)
	A_t_low = sparsify.(A_t, thresh)    
	F_low = log.(abs.(A_t_low) ) # Put FFT on log scale
	
	[Gray.(F ./ maximum(F))   Gray.(F_low ./ maximum(F_low))]
	
	
end

# ╔═╡ bbf8bb57-958a-41be-8e74-570150467cf5
begin
	## Plot Reconstruction
	A_low = ifft(A_t_low) |> real
	Gray.(A_low ./ maximum(A_low) )
end

# ╔═╡ 44bfa65c-6a6c-4c98-b4f6-904a4f8b72bc
begin
	A_new = A_bw[1:5:end,1:5:end]
	nx,ny = size(A_new')
end

# ╔═╡ 144d937f-9a3e-47e1-a80b-c3e027a6980e
heatmap(A_new)

# ╔═╡ 50c2e5bd-ea38-4036-92bf-b2160b576f7b
begin
	plotly()
	surface(1:nx, 1:ny, A_new, axis=false, legend=false)
end

# ╔═╡ 94302676-acca-425c-8b94-1e832e4893db
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
# ╟─98e5bf29-030e-4557-816b-b47561621b31
# ╠═05bcf896-968f-11eb-3c61-f30007a3e8df
# ╠═f280d3b0-87f6-409b-9514-e050c77aabf6
# ╠═a5347277-3dc6-4560-bde9-5362b5546eed
# ╟─5dc1dc8d-5759-4402-9f43-50d9fa0a59d2
# ╠═2f4bb5f9-423f-4451-82fa-c240c0fa8f00
# ╠═bbf8bb57-958a-41be-8e74-570150467cf5
# ╠═44bfa65c-6a6c-4c98-b4f6-904a4f8b72bc
# ╠═144d937f-9a3e-47e1-a80b-c3e027a6980e
# ╠═50c2e5bd-ea38-4036-92bf-b2160b576f7b
# ╟─94302676-acca-425c-8b94-1e832e4893db
