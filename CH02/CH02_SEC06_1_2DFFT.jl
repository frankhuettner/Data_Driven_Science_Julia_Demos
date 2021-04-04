### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 6cb02e7c-94f7-11eb-0b58-0d09fc2b319c
using Images, FFTW

# ╔═╡ 6d7ca87f-8078-4817-b27f-6d34316217b5
begin
	A = load("../../DATA/dog.jpg")	
	B = channelview( Gray.(A) )

	# Compute row-wise FFT
	C = fft(B,2)
	
	
	D = fft(C,1) # Compute column-wise FFT
	
	# or just 
	# D = fft(B)
end

# ╔═╡ c167ef9c-d03c-4548-9f73-8fd5321e075f
[Gray.(B)  Gray.(log.(abs.(fftshift(fft(B,2),2))))/2  Gray.(log.(abs.(fftshift(D))))/ℯ/2 ]

# ╔═╡ fd4090cf-b57b-4b62-b920-ab91d664e2b4
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
# ╠═6cb02e7c-94f7-11eb-0b58-0d09fc2b319c
# ╠═6d7ca87f-8078-4817-b27f-6d34316217b5
# ╠═c167ef9c-d03c-4548-9f73-8fd5321e075f
# ╟─fd4090cf-b57b-4b62-b920-ab91d664e2b4
