using DelimitedFiles

inp = read("17.txt", String)

function load(inp)
    t = split(inp, '\n')
    mat = Array{Int, 2}(undef, length(t), length(t[1]))
    i = 1
    for l in t
        mat[i,:] = map(x->parse(Int, x), collect(l))
        i += 1
    end
    return mat
end

mat = load(inp)

neighbours = [CartesianIndex(-1,0), CartesianIndex(1,0), CartesianIndex(0,1), CartesianIndex(0,-1)]

cost(costs, ind) = checkbounds(Bool, costs, ind) ? costs[ind] : Dict([])

function update(costs)
    for ind = CartesianIndices(costs)
        x = map(n->cost(costs, ind+n), neighbours)
        for i in eachindex(neighbours)
            for (k,v) in x[i]
                key = min(abs.(Tuple(ind - k))...) == 0 ? k : ind+neighbours[i]
                backward = ind == k || ind - neighbours[i] == k || ind - 2*neighbours[i] == k
                if !backward && max(abs.(Tuple(ind - k))...) < 4 && (!haskey(costs[ind], key) || costs[ind][key] > v + mat[ind])
                    costs[ind][key] = v + mat[ind]
                end
            end
        end
    end
    costs
end

function f1()
    costs :: Array{Dict{CartesianIndex, Int}, 2} = fill(Dict([]), size(mat))
    costs[1,1][CartesianIndex(1,1)] = 0
    for i = 1:size(costs,1)*size(costs,2)
        old = deepcopy(costs)
        costs = update(costs)
        if costs == old
            break
        end
        #println(minimum(values(costs[end,end]), init=100000000))
    end
    minimum(values(costs[end,end]))
end

println("Part1: ", f1())


function update2(costs)
    for ind = CartesianIndices(costs)
        x = map(n->cost(costs, ind+n), neighbours)
        for i in eachindex(neighbours)
            for (k,v) in x[i]
                key = min(abs.(Tuple(ind - k))...) == 0 ? k : ind+neighbours[i]
                backward = k in map(n->ind - n*neighbours[i], 1:10)
                ok = (min(abs.(Tuple(ind - k))...) == 0 || 4 <= max(abs.(Tuple(ind - k))...)) && max(abs.(Tuple(ind - k))...) <= 10
                if !backward && ok && (!haskey(costs[ind], key) || costs[ind][key] > v + mat[ind]) && key != ind
                    costs[ind][key] = v + mat[ind]
                end
            end
        end
    end
    costs
end

function f2()
    costs :: Array{Dict{CartesianIndex, Int}, 2} = fill(Dict([]), size(mat))
    costs[1,1][CartesianIndex(1,1)] = 0
    for i = 1:size(costs,1)*size(costs,2)
        old = deepcopy(costs)
        costs = update2(costs)
        if costs == old
            break
        end
        #println(minimum(values(filter(((k,v),) -> max(abs.(size(mat) .- Tuple(k))...) >= 4, costs[end,end])), init=100000000))
    end
    minimum(values(filter(((k,v),) -> max(abs.(size(mat) .- Tuple(k))...) >= 4, costs[end,end])))
end

println("Part2: ", f2())
