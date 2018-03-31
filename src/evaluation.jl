export evaluate, gradient, gradient!

function evaluate_impl(f::Type{Polynomial{T, NVars, E}}) where {T, NVars, E<:SExponents}
    generate_evaluate(exponents(E, NVars), T)
end

@generated function evaluate(f::Polynomial{T, NVars, E}, x::AbstractVector) where {T, NVars, E}
    quote
        @boundscheck length(x) ≥ NVars
        c = coefficients(f)
        @inbounds out = begin
            $(evaluate_impl(f))
        end
        out
    end
end

function gradient_impl(f::Type{Polynomial{T, NVars, E}}) where {T, NVars, E<:SExponents}
    generate_gradient(exponents(E, NVars), T)
end


function gradient(f::Polynomial{T, NVars}, x::SVector{S, NVars}) where {T, S, NVars}
    evaluate_gradient(f, x)
end

function gradient(f::Polynomial, x::AbstractVector)
    Vector(evaluate_gradient(f, x))
end

function gradient!(u::AbstractVector, f::Polynomial, x::AbstractVector)
    u .= evaluate_gradient(f, x)
    u
end

@generated function evaluate_gradient(f::Polynomial{T, NVars, E}, x::AbstractVector) where {T, NVars, E}
    quote
        @boundscheck length(x) ≥ NVars
        c = coefficients(f)
        @inbounds out = begin
            $(gradient_impl(f))
        end
        out
    end
end
