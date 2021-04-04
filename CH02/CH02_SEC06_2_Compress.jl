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

# ╔═╡ 0214253a-9503-11eb-30ca-71410831ef86
using Images, FFTW, PlutoUI

# ╔═╡ 6c8f5493-dbaf-4e16-9514-bd6dc2b09e1c
begin
	A = load("../../DATA/dog.jpg")	
	B = channelview( Gray.(A) ) # Convert RGB to grayscale

	Bt = fft(B)
	Btsort = sort(abs.(reshape(Bt,1,:) ), dims=1) # sort by magnitude
end 

# ╔═╡ becfe50e-8fa5-4e97-82e1-4b2a770fe362
@bind k Slider(1:4)

# ╔═╡ 0937894c-b755-463a-86f6-1a7cb667b78a
begin
	# Zero out all small coefficients and inverse transform
	thresholds = (1., .9, .1, .05, .01, .002)
	keep = thresholds[k]
	if keep == 1
		Gray.(B)
	else
		thresh = Btsort[Int(floor((1-keep)*length(Btsort)))]
		ind = abs.(Bt).>thresh      # Find small indices
		Atlow = Bt.*ind          	# Threshold small indices
		Alow=real.(ifft(Atlow))
		Gray.(Alow)
	end
end

# ╔═╡ bad46b5d-4837-48bf-8198-5a9341982aca
md"Compressed image: keep = $keep"

# ╔═╡ fa2b002d-5d06-4f57-9823-a6bcab9e7df2
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
# ╠═0214253a-9503-11eb-30ca-71410831ef86
# ╠═6c8f5493-dbaf-4e16-9514-bd6dc2b09e1c
# ╟─becfe50e-8fa5-4e97-82e1-4b2a770fe362
# ╟─bad46b5d-4837-48bf-8198-5a9341982aca
# ╠═0937894c-b755-463a-86f6-1a7cb667b78a
# ╟─fa2b002d-5d06-4f57-9823-a6bcab9e7df2
