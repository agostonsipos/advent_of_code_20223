using DelimitedFiles

t = readdlm("12.txt", '\n')

function load()
    inp = []
    for l in t
        r = split(l, ' ')
        push!(inp, (r[1], map(x->parse(Int, x), split(r[2], ','))))
    end
    return inp
end

inp = load()

function computefor井start(str, list)
    if isempty(list)
        return 0
    end
    list[1] -= 1
    if list[1] == 0
        if length(str) == 1
            if length(list) == 1
                return 1
            else
                return 0
            end
        elseif str[2] == '#'
            return 0
        else
            return arrangements(str[3:end], (list[2:end]), false)
        end
    else
        return arrangements(str[2:end], (list), true)
    end
end

cache = Dict{Tuple{String, Vector{Int}, Bool}, Int}([])

function arrangements(str, list, running)
    global cache
    res = 0
    if haskey(cache, (str, list, running))
        return cache[(str, list, running)]
    elseif isempty(str)
        if isempty(list)
            res = 1
        else
            res = 0
        end
    else
        ch = str[1]
        if running && ch == '.'
            res = 0
        elseif !running && ch == '.'
            res = arrangements(str[2:end], (list), false)
        elseif ch == '#'
            res = computefor井start(str, copy(list))
        elseif running && ch == '?'
            res = computefor井start(str, copy(list))
        elseif !running && ch == '?'
            opt1 = arrangements(str[2:end], (list), false)
            opt2 = computefor井start(str, copy(list))
            res = opt1 + opt2
        end
    end
    cache[(str, list, running)] = res
    return res
end


function f1()
    s = 0
    for l in inp
        global cache
        cache = Dict{Tuple{String, Vector{Int}, Bool}, Int}([])
        s += arrangements(l[1], l[2], false)
    end
    return s
end

println(f1())

function f2()
    s = 0
    for l in inp
        global cache
        cache = Dict{Tuple{String, Vector{Int}, Bool}, Int}([])
        str = join(fill(l[1], 5), '?')
        s += arrangements(str, reduce(vcat, fill(l[2], 5)), false)
    end
    return s
end

println(f2())
