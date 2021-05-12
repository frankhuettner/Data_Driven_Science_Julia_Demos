### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# ╔═╡ 47a5ec18-a8ff-11eb-320e-150284faee49
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="Convex"),
        Pkg.PackageSpec(name="Plots"),
		Pkg.PackageSpec(name="ECOS"),
        Pkg.PackageSpec(name="LaTeXStrings"),
        Pkg.PackageSpec(name="LinearAlgebra"),
        Pkg.PackageSpec(name="Lasso"),
        Pkg.PackageSpec(name="GLMNet"),
        Pkg.PackageSpec(name="DataFrames"),
        Pkg.PackageSpec(name="StatsPlots"),
    ])
    using Convex, Plots, LaTeXStrings, ECOS, LinearAlgebra, Lasso, DataFrames, GLM, GLMNet, StatsPlots 
end

# ╔═╡ 923c0d5c-9dbf-4a98-af0f-9096f5dd3e48
begin
	n = 100; L = 4;
	x = range(0, stop = L, length = n)
	f = [xᵢ^2 for xᵢ in x]                # parabola with 100 data points
	
	M = 20                      # polynomial degree
	Φ = [ xᵢ^(j-1) for xᵢ in x, j in 1:M ]        # build matrix
	
	pltf = plot(x, f, legend=false, 
	title=L"f(x) =x^2 \textrm{ with small noise }\epsilon \sim \mathcal{N}(0.1,0)")  
	plots = [pltf]
	
	for j = 1:4
		fn = f + 0.1 * randn(n)
		plot!(pltf, x, fn, label=nothing)
		an = pinv(Φ) * fn;  fna= Φ * an;    # least-square fit
    	En = norm(f-fna)/norm(f)
		push!(plots, bar(an, legend=false, title="L2 coefficients run #$j"))
	end
	l = @layout([a; [ b c]; [d e ]])
	plot(plots..., layout = l)
end

# ╔═╡ 8b22c9b9-7f33-4b4c-8da2-1217e20a85ba
begin
	## Different regressions
	
	λ = 0.1
	# Φ2 = Φ[:,2:end]
	E1 = zeros(100)
	E2 = zeros(100)
	E3 = zeros(100)
	E4 = zeros(100)
	E5 = zeros(100)
	E6 = zeros(100)
	
	A1 = zeros(M,100)
	A2 = zeros(M,100)
	A3 = zeros(M,100)
	A4 = zeros(M,100)
	A5 = zeros(M,100)
	A6 = zeros(M,100)
	
	for jj = 1:100
	  	f = [ xᵢ^2 + 0.2 * randn()   for xᵢ in x ]   
		

		# pinv
		a1 = pinv(Φ) * f;  f1 = Φ * a1;  E1[jj] = norm(f - f1) / norm(f)
		
  		# Backslash
		a2 = Φ\f;  f2 = Φ * a2;  E2[jj] = norm(f - f2) / norm(f)
		
		# Lasso with penalty λ‖a3‖₁ = 0.1‖a3‖₁ on the coefficients
		path = glmnet(Φ, f, lambda=[λ]); a3 = path.betas;  
		f3 = Φ * a3;  E3[jj] = norm(f - f3) / norm(f)
		
		# Elastic net: penalty λ((1-α)‖a3‖₂²/2 + α‖a3‖₁), λ=0.1, α=0.8 on the coeffs
		path = glmnet(Φ, f, lambda=[λ], alpha=0.0); a4 = path.betas;  
		f4 = Φ * a4;  E4[jj] = norm(f - f4) / norm(f)
		
		# Robust fit: minimize huber() instead of l2 norm
		# Its a bit unclear what MATLAB's robustfit does
		a5 = Variable(M);
		solve!(minimize(sum(huber(Φ * a5 - f, 1))), () -> ECOS.Optimizer(verbose=0)) 
		a5 = evaluate(a5)
		f5 = Φ * a5;  E5[jj] = norm(f - f5) / norm(f)
		
		# Ridge with penalty λ‖a3‖₂²/2, λ=0.5 and α=0 on the coeffs
		path = glmnet(Φ, f, lambda=[0.5], alpha=0.0); a6 = path.betas;  
		f6 = Φ * a6;  E6[jj] = norm(f - f6) / norm(f)
		
		
		A1[:,jj] = a1
		A2[:,jj] = a2
		A3[:,jj] = a3
		A4[:,jj] = a4
		A5[:,jj] = a5
		A6[:,jj] = a6		
		
	end
	Err = [E1 E2 E3 E4 E5 E6]
	
end

# ╔═╡ 9118652e-8d66-4cfa-b0a5-e5601d132df5
begin
	plot(boxplot(A1', leg = false, title="pinv"),
			boxplot(A2', leg = false, title="backslash"),
			boxplot(A3', leg = false, title="lasso (elastic with α=1)"),
			boxplot(A4', leg = false, title="elastic with α=0.8"),
			boxplot(A5', leg = false, title="huber"),
			boxplot(A6', leg = false, title="ridge (elastic with α=0)"),
		layout=(3,2), size=(1600,1400))
	
end

# ╔═╡ 2e717ad4-d040-4021-8a68-e995c6ff183d
boxplot(["pinv" "backslash" "lasso" "elastic (α=0.8)" "huber" "ridge"], Err, leg=false, ylabel="Error")

# ╔═╡ 024b4854-c02d-4bbb-926f-0f4aa70e3789
let	
	M = 10    
	En = zeros(100, M)
	
	for jj in 1:M
		
		Φ = [ xᵢ^(j-1) for xᵢ in x, j in 1:jj ]
		
		for j = 1:100
			fn = f + 0.1 * randn(n)   

			# pinv
			fna = Φ * pinv(Φ) * fn
			En[j, jj] = norm(f - fna) / norm(f)
		end
		
	end
	
	boxplot(En, leg=false, ylabel="Error", xlabel="polgynomial degree xᵖ⁻¹")
end

# ╔═╡ c61a90eb-e3d3-48a3-8572-70a287117510
let	
	M = 10    
	En = zeros(100, M)
	
	for jj in 3:M
		
		Φ = [ xᵢ^(j-1) for xᵢ in x, j in 1:jj ]
		
		for j = 1:100
			fn = f + 0.1 * randn(n)   

			# pinv
			fna = Φ * pinv(Φ) * fn
			En[j, jj] = norm(f - fna) / norm(f)
		end
		
	end
	
	boxplot(En, leg=false, ylabel="Error", xlabel="polgynomial degree xᵖ⁻¹")
end

# ╔═╡ d9d2aea4-3380-4bc9-b33b-978424014799
let # Loading the disclaimer
	url = "https://github.com/frankhuettner/Data_Driven_Science_Julia_Demos/raw/main/disclaimer.md"
	datafile = url |> download 
    datafile = open(datafile,"r")
    lines = readlines(datafile)
    close(datafile)
    lines[1]
	Markdown.parse(lines[1]) 
end

# ╔═╡ 14f16849-87d9-4885-bdba-7c79ba498924
#=Towards Using Julia libaries. To be completed Put the data into a dataframe
# 
df = hcat( DataFrame(Φ, :auto), DataFrame(Y = f)  )

# OLS
formula = @formula(Y ~ 0 + x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9 + x10 + 
				x11 + x12 + x13 + x14 + x15 + x16 + x17 + x18 + x19 + x20)

## formula = Term(:Y) ~ ConstantTerm(0) + sum(Term.(Symbol.(names(df[:, Not(:Y)]))))  # creates the same formula
ols = lm(formula, df)
coef(ols)
=#

# ╔═╡ Cell order:
# ╠═47a5ec18-a8ff-11eb-320e-150284faee49
# ╠═923c0d5c-9dbf-4a98-af0f-9096f5dd3e48
# ╠═8b22c9b9-7f33-4b4c-8da2-1217e20a85ba
# ╠═9118652e-8d66-4cfa-b0a5-e5601d132df5
# ╠═2e717ad4-d040-4021-8a68-e995c6ff183d
# ╠═024b4854-c02d-4bbb-926f-0f4aa70e3789
# ╠═c61a90eb-e3d3-48a3-8572-70a287117510
# ╟─d9d2aea4-3380-4bc9-b33b-978424014799
# ╠═14f16849-87d9-4885-bdba-7c79ba498924
