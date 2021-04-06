### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 9b913b7e-9672-11eb-0bdc-7b9a28bebca2
using Images, PyCall, LinearAlgebra

# ╔═╡ 99a9dcc7-d6cf-40c9-8870-bf4bc797528d
begin
	A = load("../../DATA/dog.jpg")	
	B = channelview( Gray.(A) ) * 255
end

# ╔═╡ e85b8bda-c847-4ca9-a4e2-d6a24e1655fa
begin
	## Wavelet decomposition (2 level) using PyCall and the PyWavelets module
	n = 2
	w = "db1"	
	
	pywt = pyimport("pywt")
	coeffs = pywt.wavedec2(B,wavelet=w,level=n)
	
	# normalize each coefficient array
	
	normalize!(coeffs[1], Inf)
	
	for detail_level in 2:n
		for mat in coeffs[detail_level]
			normalize!(mat, Inf)
		end
	end
	
	arr, coeff_slices = pywt.coeffs_to_array(coeffs)	
end

# ╔═╡ fc397efe-b98e-45d8-965b-63a3eb43e164
begin
	import PyPlot; const plt = PyPlot 
	rcParams = PyCall.PyDict(plt.matplotlib["rcParams"])
	rcParams["font.size"] = 15
	rcParams["figure.figsize"] = [8, 8]
	
	plt.imshow(arr,cmap="gray",vmin=-0.25,vmax=0.75)
	plt.gcf()
end

# ╔═╡ Cell order:
# ╠═9b913b7e-9672-11eb-0bdc-7b9a28bebca2
# ╠═99a9dcc7-d6cf-40c9-8870-bf4bc797528d
# ╠═e85b8bda-c847-4ca9-a4e2-d6a24e1655fa
# ╠═fc397efe-b98e-45d8-965b-63a3eb43e164
