using DelimitedFiles

inp = read("16.txt", String)

function load(inp)
    t = split(inp, '\n')
    mat = Array{Char, 2}(undef, length(t), length(t[1]))
    i = 1
    for l in t
        mat[i,:] = collect(l)
        i += 1
    end
    return mat
end

mat = load(inp)

function newdir(dir, obj)
    if obj == '.'
        return [dir]
    elseif obj == '-'
        if dir[1] == 0
            return [dir]
        else
            return [(0,1), (0,-1)]
        end
    elseif obj == '|'
        if dir[2] == 0
            return [dir]
        else
            return [(1,0), (-1,0)]
        end
    elseif obj == '\\'
        return [(dir[2], dir[1])]
    elseif obj == '/'
        return [(-dir[2], -dir[1])]
    end
end

function compute(start)
    state = [start]
    history = Set([])
    ener = Set([])
    while !isempty(state)
        newstate = []
        for st in state
            pos = st[1] .+ st[2]
            if checkbounds(Bool, mat, CartesianIndex(pos))
                push!(ener, pos)
                obj = mat[pos...]
                newdirs = newdir(st[2], obj)
                for newdir in newdirs
                    if !((pos, newdir) in history)
                        push!(newstate, (pos, newdir))
                        push!(history, (pos, newdir))
                    end
                end
            end
        end
        state = newstate
    end
    length(ener)
end

function f1()
    compute(((1,0), (0,1)))
end

println(f1())

function f2()
    N = size(mat, 1)
    x = 0
    for i in 1:N
        x = max(x, compute(((i, 0), (0, 1))))
        x = max(x, compute(((i, N+1), (0, -1))))
        x = max(x, compute(((0, i), (1, 0))))
        x = max(x, compute(((N+1, i), (-1, 0))))
    end
    x
end

println(f2())
