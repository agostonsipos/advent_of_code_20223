using DelimitedFiles

t = readdlm("14.txt", '\n')

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

dirs = Dict([(:north, CartesianIndex(-1,0)), (:west, CartesianIndex(0,-1)), (:south, CartesianIndex(1,0)), (:east, CartesianIndex(0,1))])

function move(dir)
    order = CartesianIndices(mat)
    if dir in [:south, :east]
        order = reverse(order)
    end
    for i in order
        if mat[i] == 'O'
            j = i
            while checkbounds(Bool, mat, j+dirs[dir]) && !(mat[j+dirs[dir]] in ['#', 'O'])
                j += dirs[dir]
            end
            mat[i] = '.'
            mat[j] = 'O'
        end
    end
end

function computeload()
    s = 0
    for i in CartesianIndices(mat)
        if mat[i] == 'O'
            s += size(mat, 1) + 1 - Tuple(i)[1]
        end
    end
    s
end

function f1()
    move(:north)
    computeload()
end

println(f1())

function f2()
    history = []
    for i in 1:1000000000
        move(:north)
        move(:west)
        move(:south)
        move(:east)
        lastind = findlast(h->h[1]==mat, history)
        if !isnothing(lastind)
            cycle = i - lastind
            modulo = mod(1000000000, cycle)
            realind = (i ÷ cycle)*cycle + modulo
            return history[realind][2]
        end
        push!(history, (copy(mat), computeload()))
    end
    computeload()
end

println(f2())
