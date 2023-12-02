using DelimitedFiles

t = readdlm("2.txt", '\n')

inp = Dict([("red", 12), ("green", 13), ("blue", 14)])

function check(l)
    r = split(l, ':')
    a = split(r[2], ';')
    for g in a
        c = split(g, ',')
        for p in c
            p = strip(p, ' ')
            ncol = split(p, ' ')
            n = parse(Int, ncol[1])
            col = ncol[2]
            if inp[col] < n
                return false
            end
        end
    end
    return true
end

function f1()
    s = 0
    i = 0
    for l in t
        i += 1
        if check(l)
            s += i
        end
    end
    return s
end

println(f1())

function min(l)
    inp = Dict([("red", 0), ("green", 0), ("blue", 0)])
    r = split(l, ':')
    a = split(r[2], ';')
    for g in a
        c = split(g, ',')
        for p in c
            p = strip(p, ' ')
            ncol = split(p, ' ')
            n = parse(Int, ncol[1])
            col = ncol[2]
            if inp[col] < n
                inp[col] = n
            end
        end
    end
    return inp["red"] * inp["green"] * inp["blue"]
end

function f2()
    s = 0
    for l in t
        s += min(l)
    end
    return s
end

println(f2())
