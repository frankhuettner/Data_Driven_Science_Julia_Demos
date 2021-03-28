### A Pluto.jl notebook ###
# v0.12.21

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

# ╔═╡ 118db8de-84b2-11eb-05f7-b97dfcbc5b75
begin
	using LinearAlgebra
	using PlutoUI 
	using Plots
	using Images
end

# ╔═╡ 134cbbe8-8e85-11eb-1fa3-81a5884e37c9
begin
	A = load("../DATA/dog.jpg") 	
	X = Gray.(A) # convert each element of the picture into Gray
end

# ╔═╡ 46dc963e-84b2-11eb-3fe2-9dbbba3d33ff
U, Σ, V = svd(X) # to create the unicode letter Σ: type \Sigma and then hit TAB-key

# ╔═╡ d49d9840-84bb-11eb-192c-c9a845c21f36
@bind r Slider(1:100, show_value=true, default=6)

# ╔═╡ b78a38aa-84b4-11eb-0125-79816c46b982
begin
	xapprox = U[:,1:r] * Diagonal(Σ[1:r]) * V'[1:r,:]  # Note: V is first transposed
	colorview(Gray, xapprox)
end

# ╔═╡ 99f45ad4-84c1-11eb-2fc1-d551392a3bff
plot(Σ, yaxis=:log, label="Singular Values")

# ╔═╡ c3e21962-84c1-11eb-1a44-e7bf975f694d
plot(cumsum(Σ)./sum(Σ),  label="Singular Values: Cumulative Sum", legend=:right)

# ╔═╡ b2fbc85c-8f05-11eb-289e-69b7ee5cf383
md"[Frank Huettner](https://frankhuettner.de) has created this Pluto notebook with Julia code and all errors are on him. It mimics the [Matlab code here](https://github.com/dylewsky/Data_Driven_Science_Python_Demos), and it is intended as a companion to chapter 1 of the book:  
[Data Driven Science & Engineering: Machine Learning, Dynamical Systems, and Control  
by S. L. Brunton and J. N. Kutz, Cambridge Textbook, 2019, Copyright 2019, All Rights Reserved]
(http://databookuw.com/). 
Please cite this book when using this code/data. 
No guarantee can be given for the functionality of this code."

# ╔═╡ Cell order:
# ╠═118db8de-84b2-11eb-05f7-b97dfcbc5b75
# ╠═134cbbe8-8e85-11eb-1fa3-81a5884e37c9
# ╠═46dc963e-84b2-11eb-3fe2-9dbbba3d33ff
# ╠═d49d9840-84bb-11eb-192c-c9a845c21f36
# ╠═b78a38aa-84b4-11eb-0125-79816c46b982
# ╠═99f45ad4-84c1-11eb-2fc1-d551392a3bff
# ╠═c3e21962-84c1-11eb-1a44-e7bf975f694d
# ╟─b2fbc85c-8f05-11eb-289e-69b7ee5cf383
