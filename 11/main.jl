using DelimitedFiles

t = readdlm("11.txt", '\n')

function load()
    mat = Array{Char, 2}(undef, length(t), length(t[1]))
    i = 1
    for l in t
        mat[i,:] = collect(l)
        i += 1
    end
    return mat
end

mat = load()

function expand()
    er = []
    ec = []
    for i in axes(mat)[1]
        if length(filter(x->x=='#', mat[i,:])) == 0
            push!(er, i)
        end
    end
    for i in axes(mat)[2]
        if length(filter(x->x=='#', mat[:,i])) == 0
            push!(ec, i)
        end
    end
    return (er, ec)
end

(er, ec) = expand()

function f(part)
    galaxies = []
    for ind in CartesianIndices(mat)
        if mat[ind] == '#'
            push!(galaxies, ind)
        end
    end
    s = 0
    for i in eachindex(galaxies)
        j = i + 1
        while j <= length(galaxies)
            posx = Tuple(galaxies[i])[1]
            posy = Tuple(galaxies[i])[2]
            dx = sign(Tuple(galaxies[j] - galaxies[i])[1])
            dy = sign(Tuple(galaxies[j] - galaxies[i])[2])
            dist = 0
            while posx != Tuple(galaxies[j])[1]
                if posx in er
                    dist += part == 2 ? 1_000_000 : 2
                else
                    dist += 1
                end
                posx += dx
            end
            while posy != Tuple(galaxies[j])[2]
                if posy in ec
                    dist += part == 2 ? 1_000_000 : 2
                else
                    dist += 1
                end
                posy += dy
            end
            s += dist
            j += 1
        end
    end
    return s
end

println(f(1))
println(f(2))
