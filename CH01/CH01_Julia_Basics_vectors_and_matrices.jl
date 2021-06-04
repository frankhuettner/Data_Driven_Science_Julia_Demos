### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ ca25d5cf-0a8b-4ddb-bca5-f2180e0b2625
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add(["LinearAlgebra"])
end

# ╔═╡ 306e7996-47ec-44d7-85e5-08746a7e6152
using LinearAlgebra # needed for the following dot function

# ╔═╡ f14b8d97-43c3-4035-aac8-37282b519695
md"""
Nice to know about Julia before we continue:
There is a difference between 
* 1x3 Matrix, 
* 3x1 Matrix and 
* Vectors

Vectors feel like column vectors.
For a discussion see [https://discourse.julialang.org/t/vector-vs-column-vector/34699/5](https://discourse.julialang.org/t/vector-vs-column-vector/34699/5)
"""

# ╔═╡ b75da665-ba4f-422d-9159-d11b6cb9d88d
begin
	θ_1x3_matrix = [π/15  -π/9  -π/20]  # Gives a 2-dimensional 1x3 matrix
	θ_1x3_matrix = hcat(π/15, -π/9, -π/20)   # Gives a 2-dimensional 1x3 matrix
end

# ╔═╡ 0c96d071-9473-4bfd-a5e7-d5415662c07b
# It is a little more cumbersome to construct 2-dimensional 3x1 Matrices
begin
	θ_3x1_matrix = Array{Float64, 2}(undef, 3, 1)
	θ_3x1_matrix[1] = π/15  
	θ_3x1_matrix[2] = -π/9  
	θ_3x1_matrix[3] = -π/20
	θ_3x1_matrix
end

# ╔═╡ 6796c09c-ebab-4976-a6e9-fec16f317e9e
begin
	# The following definitions give 1-dimensional vectors
	# => VECTORS SEEM TO BE STANDARD
	θ_vector = [π/15;  -π/9;  -π/20] 
	θ_vector = [π/15; 
		-π/9;
		-π/20]
	θ_vector = vcat(π/15, -π/9, -π/20)
	θ_vector = [π/15, -π/9, -π/20]
end

# ╔═╡ 5512ac7d-ca5c-44f1-8107-fa0d04874faf
# It is usually fair to THINK OF VECTORS AS COLUMN VECTORS
[2, 2, 2]' * θ_vector

# ╔═╡ b69cf902-38d9-4aae-a61b-8bab2dfd8473
[2, 2, 2] * θ_vector'

# ╔═╡ fafc616d-04b2-47b6-8a7b-b90fc50d82a0
# The following gives an error (it would is kind a unclear what the result should be
θ_vector * [2, 2, 2]

# ╔═╡ 616f05a2-581d-4685-8bd8-f553ed002e98
# To avoid confusion, being explicit helps the reader a lot
dot([2, 2, 2], θ_vector)

# ╔═╡ 3d5790a9-c1a1-43c4-802c-a9f9707dc2ae
# x ⋅ y (tab-completing \cdot) is a synonym for dot(x, y).
[2, 2, 2] ⋅ θ_vector

# ╔═╡ 77cc1d8b-2c7e-4114-ba95-c240b166c7a9
# To avoid confusion, being explicit helps the reader a lot
[x * y   for x ∈ [2, 2, 2], y ∈ θ_vector]  # ∈ (tab-completing \in) reads like in

# ╔═╡ 01cc0c02-ce01-40f2-a04b-3d2610f8117b
m = [1 2 3; 4 5 6]

# ╔═╡ 9033b047-dbbc-4526-9bfa-aca341b93c83
m*θ_vector # Here we stay with the vector convention

# ╔═╡ 09a35ab8-bf3d-45f9-8b6b-104b9e9d5e39
m*θ_3x1_matrix  # Here we get a 2d matrix back

# ╔═╡ e1b186f9-9f05-43da-8100-2c1cba17a7f3
m*θ_1x3_matrix    # That does not work

# ╔═╡ 1d258d1f-af46-4e8b-852a-4029987e00a9
θ_1x3_matrix * m'

# ╔═╡ f98bf9b3-d518-4753-8580-78fd8cc3f509
θ_vector * m'    # Again, think of a vector as a column vector

# ╔═╡ f2a9522d-32d0-41cc-8489-a718e73d380e
# Finally, we see that rows are standard
m[1,:]

# ╔═╡ dd123f5c-9633-4306-89d2-3e83c7dd5301
# Even if we grab the column
m[:,1]

# ╔═╡ 24099073-c8e8-4ce5-9d76-904314e4dabc
# To get a 2d matrix, we have to extract a matrix
m[:,1:1]

# ╔═╡ 4a61ad12-487e-413d-a42d-0613c44961e7
md"
[Frank Huettner](https://frankhuettner.de) has created this Pluto notebook.
"

# ╔═╡ Cell order:
# ╟─f14b8d97-43c3-4035-aac8-37282b519695
# ╠═ca25d5cf-0a8b-4ddb-bca5-f2180e0b2625
# ╠═b75da665-ba4f-422d-9159-d11b6cb9d88d
# ╠═0c96d071-9473-4bfd-a5e7-d5415662c07b
# ╠═6796c09c-ebab-4976-a6e9-fec16f317e9e
# ╠═5512ac7d-ca5c-44f1-8107-fa0d04874faf
# ╠═b69cf902-38d9-4aae-a61b-8bab2dfd8473
# ╠═fafc616d-04b2-47b6-8a7b-b90fc50d82a0
# ╠═306e7996-47ec-44d7-85e5-08746a7e6152
# ╠═616f05a2-581d-4685-8bd8-f553ed002e98
# ╠═3d5790a9-c1a1-43c4-802c-a9f9707dc2ae
# ╠═77cc1d8b-2c7e-4114-ba95-c240b166c7a9
# ╠═01cc0c02-ce01-40f2-a04b-3d2610f8117b
# ╠═9033b047-dbbc-4526-9bfa-aca341b93c83
# ╠═09a35ab8-bf3d-45f9-8b6b-104b9e9d5e39
# ╠═e1b186f9-9f05-43da-8100-2c1cba17a7f3
# ╠═1d258d1f-af46-4e8b-852a-4029987e00a9
# ╠═f98bf9b3-d518-4753-8580-78fd8cc3f509
# ╠═f2a9522d-32d0-41cc-8489-a718e73d380e
# ╠═dd123f5c-9633-4306-89d2-3e83c7dd5301
# ╠═24099073-c8e8-4ce5-9d76-904314e4dabc
# ╟─4a61ad12-487e-413d-a42d-0613c44961e7
