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

# ╔═╡ 0364b856-9507-11eb-0102-092ccb722167
using Images, FFTW, PlutoUI, LinearAlgebra

# ╔═╡ cf139145-90a8-4c0d-a484-3b6eadcd6354
@bind filter Slider(10:300, default=100, show_value=true)

# ╔═╡ 65ebdf08-fdee-4053-9e06-52682f1a33be
begin
	A = load("../../DATA/dog.jpg")	
	B = channelview( Gray.(A) )

	Bnoise = B + 0.8 * rand(Gray{N0f8}, size(B)) .- N0f8(.4)  # Add some noise

	Bt = fft(Bnoise)
	Bt_shift = fftshift(Bt)	
	
	F = log.(abs2.(Bt_shift).+1) # Put FFT on log scale
	
	nx,ny = size(B)
	R2  = [x^2+y^2 for x=-div(nx,2)+1:div(nx,2), y=-div(ny,2)+1:div(ny,2)]
	ind = R2 .< filter^2
	Bt_shift_filt = Bt_shift.*ind
	F_filt = log.(abs.(Bt_shift_filt).+1)  # Put FFT on log-scale
	
	Bt_filt = ifftshift(Bt_shift_filt)
	B_filt = real(ifft(Bt_filt))  # Filtered image	
	
	norm(B_filt-B)
end

# ╔═╡ 64b0cc6c-3bed-4e4f-83d5-ebe9f8dfbdfa
[Gray.(B) Gray.(Bnoise)   Gray.(B_filt)]

# ╔═╡ 58883fce-293e-406e-9d48-a7659b1f2b6f
[ Gray.(F)/20 Gray.(F_filt)/20  ]

# ╔═╡ b7b2a1b3-2242-4b07-b3e5-381ae5a63304
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
# ╠═0364b856-9507-11eb-0102-092ccb722167
# ╠═65ebdf08-fdee-4053-9e06-52682f1a33be
# ╟─cf139145-90a8-4c0d-a484-3b6eadcd6354
# ╠═64b0cc6c-3bed-4e4f-83d5-ebe9f8dfbdfa
# ╠═58883fce-293e-406e-9d48-a7659b1f2b6f
# ╟─b7b2a1b3-2242-4b07-b3e5-381ae5a63304
