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

# ╔═╡ 2427f844-967b-11eb-0d7c-cd1adf6c7ade
using Images, PyCall, LinearAlgebra, Plots, PlutoUI

# ╔═╡ b41bbd9e-a843-4012-97ee-a778f3200ec7
begin
	A = load("../../DATA/dog.jpg")	
	B = channelview( Gray.(A) ) * 255
	
	## Wavelet decomposition (4 level) using PyCall and the PyWavelets module
	n = 4
	w = "db1"	
	
	pywt = pyimport("pywt")
	coeffs = pywt.wavedec2(B,wavelet=w,level=n)
	
	coeff_arr, coeff_slices = pywt.coeffs_to_array(coeffs)	
	
	Csort = coeff_arr  |>  vec  .|>  abs  |>  sort	
end

# ╔═╡ 7a5c542a-4c39-45f4-96b0-eb752fdc80e9
@bind keep_idx Slider(1:5)

# ╔═╡ 987e6e09-114c-4d74-9bdb-b88af68e110e
begin
	keep = (0.99, 0.1, 0.05, 0.01, 0.005)[keep_idx]
	
	thresh = Csort[Int(floor((1-keep)*length(Csort)))]
	ind = abs.(coeff_arr) .> thresh
	Cfilt = coeff_arr .* ind # Threshold small indices
	
	coeffs_filt = pywt.array_to_coeffs(Cfilt,coeff_slices,output_format="wavedec2")
	
	# Plot reconstruction
	Arecon = pywt.waverec2(coeffs_filt,wavelet=w)
	Gray.(Arecon ) ./ 255
	
end

# ╔═╡ 6f05d3e2-5e98-42f4-8434-b8a8e0958d62
md"### keep = $(keep)%"

# ╔═╡ Cell order:
# ╠═2427f844-967b-11eb-0d7c-cd1adf6c7ade
# ╠═b41bbd9e-a843-4012-97ee-a778f3200ec7
# ╟─7a5c542a-4c39-45f4-96b0-eb752fdc80e9
# ╟─6f05d3e2-5e98-42f4-8434-b8a8e0958d62
# ╠═987e6e09-114c-4d74-9bdb-b88af68e110e
