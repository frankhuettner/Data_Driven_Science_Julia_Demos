### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# ╔═╡ 47a5ec18-a8ff-11eb-320e-150284faee49
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="Polynomials"),
        Pkg.PackageSpec(name="Plots"),
        Pkg.PackageSpec(name="Optim"),
		Pkg.PackageSpec(name="Interpolations"),
        Pkg.PackageSpec(name="LaTeXStrings"),
        Pkg.PackageSpec(name="ForwardDiff"),
    ])
    using Polynomials, Plots, Optim, LaTeXStrings, ForwardDiff, Interpolations
end

# ╔═╡ dfae2def-c051-44a0-852c-155a9e5d4ec5
begin
	h=0.5
	
	f(x, y) = 3 * x^2 + y^2
	f0(x, y) = 1.5 - exp( -0.03 * f(x, y) )
	# f1(x, y) = 1.5 - 1.6 * exp( -0.05 * f(x+3, y+3) ) 
	f2(x, y) = 1.0 - 1.6 * exp( -0.05 * f(x+3, y+3) ) - exp( -0.1 * f(x-3, y-3) ) 

end

# ╔═╡ e9a64285-c3eb-448a-b8eb-96b2209c4369
begin
	# Let us define a different method for our functions
	# They are almost the same and differ only in how they pass around arguments
	# Julia identifies the correct method by looking into its signature:
	# E.g., if we call f(.1,.3), it takes the methods defined in the beginning
	# E.g., if we call f([.1,.3]), it takes the methods defined below 
	# (which refer to the methods in the beginning)
	f( (x, y) ) = f(x, y)
	f0( (x, y) ) = f0(x, y)
	f2( (x, y) ) = f2(x, y)
	
	# We use ForwardDiff for automatic differentiation/differentiable programming
	# https://computationalthinking.mit.edu/Spring21/optimization/ for more info
	
	∇f(x, y) = ForwardDiff.gradient( f, [x, y])
end

# ╔═╡ 6f4284b7-a267-493d-a441-46f4f8e429f8
begin
	p11 = surface(-6:h:6, -6:h:6, f, legend=false, 
		title=L"f(x, y) = 3  x^2 + y^2")
	p21 = contour(-6:h:6, -6:h:6, f)
	
	p12 = surface(-6:h:6, -6:h:6, f2, legend=false, 
		title=L"\qquad\qquad\qquad\qquad\qquad f_2(x, y) =  1.0 - 1.6  e^{ -0.05  f(x+3, y+3) } - e^{ -0.1  f(x-3, y-3)}")
	p22 = contour(-6:h:6, -6:h:6, f2)
	
	plot(p11,p21,p12,p22, layout=(2,2))
end

# ╔═╡ 7ebddd62-331c-44ed-9387-a0ba45b18ad3
let
	X = zeros(10)
	Y = zeros(10)
	F = zeros(10)
	
	X[1] = 3  # Initial guess
	Y[1] = 2 
	F[1] = f(X[1],  Y[1])
	δ(x, y) = (x^2 + 9 * y^2) / (2 * x^2 + 54 * y^2)
	
	for j=1:9
    δj = δ(X[j],  Y[j])
    X[j+1]=(1 - 2 * δj) * X[j] # update values 
    Y[j+1]=(1 - 6 * δj) * Y[j]
    F[j+1]=X[j+1]^2 + 3 * Y[j+1]^2
    
		if abs(F[j+1]-F[j]) < 10^(-6) # check convergence 
			break
		end
	end	
	
	
	p11 = surface(-6:h:6, -6:h:6, f, legend=false, alpha=.3)
	plot!(p11, X,Y,F, label=nothing, marker=2, ls=:dash)
	
	p21 = contour(-6:h:6,-6:h:6,f)
	plot!(p21, X,Y, label=nothing, marker=2, ls=:dash)

	
	
	plot(p11,p21, 
		title=L"f(x, y) = 3  x^2 + y^2")	
end

# ╔═╡ bd9a9800-b82a-41ae-87ba-1145b206593c
let
	∂f∂x(x,y) = ∇f(x,y)[1]
	∂f∂y(x,y) = ∇f(x,y)[2]
	p11 = surface(-6:h:6, -6:h:6, f, legend=false)
	
	p12 = surface(-6:h:6, -6:h:6, ∂f∂x,  legend=false)
	p13 = surface(-6:h:6, -6:h:6, ∂f∂y,  legend=false)
		
	plot(p11, p12, p13, layout=(1,3), 
		title=[L"f(x, y) = 3  x^2 + y^2"  L"\partial f/\partial x" L"\partial f/\partial y"])	
end

# ╔═╡ e0f02c41-abe3-4e72-8e82-c41830989c74
begin
	function δ_search(δ, x, y, ∂f∂x, ∂f∂y, interp)
		x0 = x - δ[1] * ∂f∂x
		y0 = y - δ[1] * ∂f∂y
		return interp(x0, y0)
	end
	
	
	xs = -6:0.1:6
	ys = -6:0.1:6 
	f2s = [f2(x, y) for x in xs, y in ys]
	# creating interpolation object
	interp = LinearInterpolation((xs, ys), f2s, extrapolation_bc=Line() )
	
	# gradients
	∇f2(x,y) = ForwardDiff.gradient( f2, [x, y])
	∂f2∂x(x,y) = ForwardDiff.gradient( f2, [x, y])[1]
	∂f2∂y(x,y) = ForwardDiff.gradient( f2, [x, y])[2]
	
	plt11 = surface(-6:h:6, -6:h:6, f2, legend=false, alpha=.3, c=:gray)
	plt21 = contour(-6:h:6, -6:h:6,f2, c=:gray)
	
	X0 = [4, 0, -5]
	Y0 = [0, -5, 2]
	Jmax = zeros(Int, 3)	
	
	for i = 1:3
		X = zeros(10)
		Y = zeros(10)
		F = zeros(10)

		X[1] = X0[i]  # Initial guess
		Y[1] = Y0[i] 
		F[1] = f2(X[1],  Y[1])

		for j=1:9

		∂f2∂x_j, ∂f2∂y_j = ∇f2(X[j],  Y[j])
		δ_opt_res = optimize(δ -> δ_search(δ, X[j],  Y[j], ∂f2∂x_j, ∂f2∂y_j, interp), 							[0.2], LBFGS() ) 
		δj = δ_opt_res.minimizer[1]
			
		X[j+1]= X[j] - δj * ∂f2∂x_j   # update values 
		Y[j+1]= Y[j] - δj * ∂f2∂y_j
		F[j+1]= interp(X[j+1], Y[j+1])
	
		Jmax[i] = j+1
			
			if abs(F[j+1]-F[j]) < 10^(-6) # check convergence 
				break
			end
		end	


		plot!(plt11, X[1:Jmax[i]],Y[1:Jmax[i]],F[1:Jmax[i]], label=nothing, marker=2, ls=:dash)

		plot!(plt21, X[1:Jmax[i]],Y[1:Jmax[i]], label=nothing, marker=2, ls=:dash)

	end
	
	plot(plt11,plt21, #layout=(2,1),
		title=L"f(x, y) = 3  x^2 + y^2")	

end

# ╔═╡ a489754d-629b-434c-8e95-316ef8081bbf
let	
	∂f2∂x(x,y) = ForwardDiff.gradient( f2, [x, y])[1]
	∂f2∂y(x,y) = ForwardDiff.gradient( f2, [x, y])[2]
	p11 = surface(-6:h:6, -6:h:6, f2, legend=false)
	
	p12 = surface(-6:h:6, -6:h:6, ∂f2∂x,  legend=false)
	p13 = surface(-6:h:6, -6:h:6, ∂f2∂y,  legend=false)
		
	plot(p11, p12, p13, layout=(1,3), 
		title=[L"f_2"  L"\partial f_2/\partial x" L"\partial f_2/\partial y"])	
end

# ╔═╡ 728c6984-1cc4-4fa3-94d3-0a13c347191b
let
	## Alternating Descent
	h = 0.1
	x = range(-6, stop=6+h, step=h)
	y = range(-6, stop=6+h, step=h)
	f2s = [f2(x, y) for x in xs, y in ys]
	
	plt1 = surface(-6:h:6, -6:h:6, f2, legend=false, alpha=.3, c=:gray)
	plt2 = contour(-6:h:6, -6:h:6,f2, c=:gray)
	
	# creating interpolation object
	interp_f2 = LinearInterpolation((xs, ys), f2s, extrapolation_bc=Line() )
	
	x0=[4  0 -5]
	y0=[0 -5  2]
	xa = zeros(5)
	ya = zeros(5)
	y1 = zeros(5)
	f  = zeros(5)

	for jj = 1:3

		xa[1] = x0[jj]
		ya[1] = y0[jj]
		f[1] = interp_f2(xa[1], ya[1])

		fx = interp_f2(xa[1], y)
		xa[2] = xa[1]
		ya[2] = y[findmin(fx)[2]]

		fy = interp_f2(x,ya[2])
		ya[3] = ya[2]
		xa[3] = x[findmin(fx)[2]]
		
		fx = interp_f2(xa[3], y)
		xa[4] = xa[3]
		ya[4] = y[findmin(fx)[2]]

		fy = interp_f2(x,ya[4])
		ya[5] = ya[4]
		xa[5] = x[findmin(fx)[2]]
		
		f = [interp_f2(xa[i], ya[i]) for i in 1:5]

		plot!(plt1, xa, ya, f2.(xa, ya), marker=2, ls=:dash, 
			label="start = ($(x0[jj]), $(y0[jj]))")		
		plot!(plt2, xa, ya, marker=2, ls=:dash, 
			label="start = ($(x0[jj]), $(y0[jj]))")
	
	end
	
	plot(plt1, plt2,	title="ADM")	
end

# ╔═╡ Cell order:
# ╠═47a5ec18-a8ff-11eb-320e-150284faee49
# ╠═dfae2def-c051-44a0-852c-155a9e5d4ec5
# ╠═6f4284b7-a267-493d-a441-46f4f8e429f8
# ╠═7ebddd62-331c-44ed-9387-a0ba45b18ad3
# ╠═e9a64285-c3eb-448a-b8eb-96b2209c4369
# ╠═bd9a9800-b82a-41ae-87ba-1145b206593c
# ╠═a489754d-629b-434c-8e95-316ef8081bbf
# ╠═e0f02c41-abe3-4e72-8e82-c41830989c74
# ╠═728c6984-1cc4-4fa3-94d3-0a13c347191b
