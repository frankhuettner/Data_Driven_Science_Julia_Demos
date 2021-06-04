### A Pluto.jl notebook ###
# v0.14.7

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

# ╔═╡ 1a19d079-b768-4360-bae6-b8e860a5d86b
# If multiple code lines are in one cell, then Pluto requires us to wrap them in begin ... end
begin
	# Importing the package manager
    import Pkg
	# Creating a temporary environment
    Pkg.activate(mktempdir())
	# Adding packages to the temporary environment
    Pkg.add(["Plots", "PlutoUI", "LinearAlgebra", "Images"])
	# Loading the packages into the name space
    using Plots, PlutoUI, LinearAlgebra, Images
end

# ╔═╡ b0969a21-beb4-49c8-9cb7-0a752ca36317
# Load the file
A = load("dog.jpg"); # The semicolon prevents us from seeing the outcome

# ╔═╡ 857f116a-733a-44bb-87ee-a068d8fc5bdb
# The picture is an Array of RGB elements
typeof(A)

# ╔═╡ 134cbbe8-8e85-11eb-1fa3-81a5884e37c9
# Convert each element of the picture into Gray
X = Gray.(A)  # The . means that the function is applied to each element of A

# ╔═╡ 4959a958-5261-4ddd-9f9f-ddd416ce0743
typeof(X)

# ╔═╡ abf6a04f-ef02-4edf-a5c7-896e3b7a0d71
# Each element of X has the data type Gray{N0f8}
typeof(X[1,1])

# ╔═╡ 46dc963e-84b2-11eb-3fe2-9dbbba3d33ff
# to create the unicode letter Σ: type \Sigma and then hit TAB-key
U, Σ, V = svd(X) 
# Note that Σ is stored as a Vector and V is NOT the transposed

# ╔═╡ d49d9840-84bb-11eb-192c-c9a845c21f36
# We bind the value of the variable r∈{1,...,100} to the slider
@bind r Slider(1:100, show_value=true, default=6)

# ╔═╡ e99f2f40-4e42-4f54-82cf-60055545c6fd
xapprox = U[:,1:r] * Diagonal(Σ[1:r]) * V'[1:r,:];
# Note that V is first transposed

# ╔═╡ c2360998-43c2-4f0e-a785-85c76b815b5a
# Let's convert xapprox to an Array of Gray dots to have a nice visualization
Gray.(xapprox)

# ╔═╡ 99f45ad4-84c1-11eb-2fc1-d551392a3bff
plot(Σ, yaxis=:log, label="Singular Values")  

# ╔═╡ c3e21962-84c1-11eb-1a44-e7bf975f694d
plot(cumsum(Σ)./sum(Σ),  label="Singular Values: Cumulative Sum", legend=:right)

# ╔═╡ b2fbc85c-8f05-11eb-289e-69b7ee5cf383
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
# ╠═1a19d079-b768-4360-bae6-b8e860a5d86b
# ╠═b0969a21-beb4-49c8-9cb7-0a752ca36317
# ╠═857f116a-733a-44bb-87ee-a068d8fc5bdb
# ╠═134cbbe8-8e85-11eb-1fa3-81a5884e37c9
# ╠═4959a958-5261-4ddd-9f9f-ddd416ce0743
# ╠═abf6a04f-ef02-4edf-a5c7-896e3b7a0d71
# ╠═46dc963e-84b2-11eb-3fe2-9dbbba3d33ff
# ╠═d49d9840-84bb-11eb-192c-c9a845c21f36
# ╠═e99f2f40-4e42-4f54-82cf-60055545c6fd
# ╠═c2360998-43c2-4f0e-a785-85c76b815b5a
# ╠═99f45ad4-84c1-11eb-2fc1-d551392a3bff
# ╠═c3e21962-84c1-11eb-1a44-e7bf975f694d
# ╟─b2fbc85c-8f05-11eb-289e-69b7ee5cf383
