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

# ╔═╡ d85696a8-94d8-11eb-1ff1-8b942ac803d0
begin
	using Plots, PlutoUI
	using DSP
end

# ╔═╡ 05818d56-1873-4268-9ee6-e94062ab4178
begin
	dt = 0.001
	t = range(0,2,step=dt)
	f0 = 50
	#f1 = 250
	t1 = 2
	
end

# ╔═╡ 91cff872-06bb-48cf-9980-cee217efbc57
@bind f1 Slider(100:500, default=250)

# ╔═╡ 4cd87ee8-11c2-4f27-a504-bfd62f52d113
x = cos.(  2*π* t .* (f0 .+ (f1-f0).* t.^2 ./(3*t1^2))  )

# ╔═╡ cd54d19b-6e5f-4100-9476-e4408727e834
begin
	S = DSP.Periodograms.spectrogram(x, 128, 120; 
						fs=1/dt, window=DSP.Windows.hanning)
end

# ╔═╡ 3fdbb35a-8399-4d2c-aa7e-65272b79fe0b
md"Below we explore the output of DSP."

# ╔═╡ 51411393-a706-4be5-a0ec-f705d81f08ee
begin
	t_axis = time(S)
	f_axis = DSP.Periodograms.freq(S)
end

# ╔═╡ 9bdb8044-485e-4105-a4b6-025492fec0bf
begin
	spec = DSP.Periodograms.power(S)  # Get the matrix
	
	# heatmap(xaxisvalues, yaxisvalues, matrix)
	heatmap(t_axis, f_axis, spec, c=:jet ) 
end

# ╔═╡ 2e0f6529-a8ff-4534-bab5-dbc8dac6d5d9
begin
	log_spec = (log10.(spec))
	
	heatmap(t_axis, f_axis, log_spec, c=:jet, legend=false )
end

# ╔═╡ 54640b0c-4355-4720-a4e1-2ccb5db25b8a
md"Further source of inspiration: [seaandsailor.com/audiosp_julia.html](https://www.seaandsailor.com/audiosp_julia.html)"

# ╔═╡ 56a1d602-1c32-4478-bfa9-4c08341d8ee0
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
# ╠═d85696a8-94d8-11eb-1ff1-8b942ac803d0
# ╠═05818d56-1873-4268-9ee6-e94062ab4178
# ╠═91cff872-06bb-48cf-9980-cee217efbc57
# ╠═4cd87ee8-11c2-4f27-a504-bfd62f52d113
# ╠═cd54d19b-6e5f-4100-9476-e4408727e834
# ╟─3fdbb35a-8399-4d2c-aa7e-65272b79fe0b
# ╠═51411393-a706-4be5-a0ec-f705d81f08ee
# ╠═9bdb8044-485e-4105-a4b6-025492fec0bf
# ╠═2e0f6529-a8ff-4534-bab5-dbc8dac6d5d9
# ╟─54640b0c-4355-4720-a4e1-2ccb5db25b8a
# ╟─56a1d602-1c32-4478-bfa9-4c08341d8ee0
