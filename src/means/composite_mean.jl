abstract type CompositeMean <: Mean end

components(m::CompositeMean) = m.means

include("sum_mean.jl")       # Sum mean functions
include("prod_mean.jl")      # Product of mean functions
