export forestfire!, plot_lifetime

"""


1: empty space,  
0: green(alive tree),  
2: fire
"""
mutable struct Forest
    nrow::Int
    ncol::Int
    p::Float64
    forest::Matrix{Int8}

    function Forest(N::Int, p::Float64)
        if N > 10^3
            error("Too large site size. Reduce the number of sites under or equal 1000 of linear size.\n")
        end
        forest = ( rand(N, N) .< 1-p ) * Int8(1)
        for i in 1:N
            if forest[i] == 0
                forest[i] = 2
            end
        end

        return new(N, N, p, forest)
    end

    function Forest(nrow::Int, ncol::Int, p::Float64)
        if nrow > 10^3 || ncol > 10^3
            error("Too large site size. Reduce the number of sites under or equal 1000 of linear size.\n")
        end
        forest = ( rand(nrow, ncol) .< 1-p ) * Int8(1)
        for i in 1:nrow
            if forest[i] == 0
                forest[i] = 2
            end
        end

        return new(nrow, ncol, p, forest)
    end
end

"""
forestfire!(forest::Forest; gifanime::Bool=false, giffps::Int=10, maxiter=1000)

simulation for forest fire\n
return: lifetime, filename\n
"""
function forestfire!(forest::Forest; gifanime::Bool=false, giffps::Int=10, maxiter=1000)
    row, col = size(forest.forest)
    lifetime = 0
    previous_forest = forest.forest[:,:]
    filename = ""

    function checksite!(i::Int, j::Int)
        if j < col && forest.forest[i, j+1] == 0; forest.forest[i, j+1] = 2; end
        if 1 < j && forest.forest[i, j-1] == 0; forest.forest[i, j-1] = 2; end
        if i < row && forest.forest[i+1, j] == 0; forest.forest[i+1, j] = 2; end
        if 1 < i && forest.forest[i-1, j] == 0; forest.forest[i-1, j] = 2; end
    end

    function spreadfire!(forest::Forest)
        @simd for j in 1:col
            @simd for i in 1:row
                if forest.forest[i,j] == 2
                    @inbounds checksite!(i, j)
                end
            end
        end
    end

    if gifanime
        anim = @animate for i in 1:maxiter
            heatmap(forest.forest, c=:RdYlGn_r, colorbar=false, aspect_ratio=:equal)
            spreadfire!(forest)
            if previous_forest == forest.forest
                break
            end
            lifetime += 1
            previous_forest = copy(forest.forest)
        end
        filename = "/tmp/juliaforestfiregif.gif"
        gif(anim, filename, fps=giffps)

    else
        spreadfire!(forest)
        while previous_forest != forest.forest
            previous_forest = forest.forest[:,:]
            spreadfire!(forest)
            lifetime += 1
        end
    end

    return lifetime, filename
end

"""
plot life time of forest fire.
"""
function plot_lifetime(linsize, ps, pinc, pf, nsample)
    prob = ps:pinc:pf
    lifetime_list = zeros(length(prob))
    for (i, p) in enumerate(prob)
        lifetime = 0
        for iter in 1:nsample
            forest = Forest(linsize, p)
            lifetime += forestfire!(forest)[1]
        end

        lifetime_list[i] = lifetime / nsample
    end
    plot(prob, lifetime_list,
         xlabel="Occupation probability",
         ylabel="Lifetime",
         title="Lifetime of forest fire",
         legend=false,
         marker=:circle)

end
