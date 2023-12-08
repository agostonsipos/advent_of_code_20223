using DelimitedFiles

t = readdlm("8.txt", '\n')

function load()
    steps = t[1]

    rules = Dict([])
    for i=2:length(t)
        l = split(t[i], '=')
        l2 = split(l[2], ',')
        rules[strip(l[1])] = (strip(l2[1], ['(', ' ']), strip(l2[2], [')', ' ']))
    end
    return (steps, rules)
end

(steps, rules) = load()

function f1()
    p = "AAA"
    i = 0
    while p != "ZZZ"
        d = steps[i % length(steps) + 1]
        p = d == 'R' ? rules[p][2] : rules[p][1]
        i += 1
    end
    return i
end

println(f1())

function f2()
    starts = []
    for k in keys(rules)
        if k[3] == 'A'
            push!(starts, k)
        end
    end
    i = 0
    cycles = []
    for s in starts
        push!(cycles, [])
    end
    while !all(k->k[3] == 'Z', starts) && i < 100000
        d = steps[i % length(steps) + 1]
        for j=1:length(starts)
            p = starts[j]
            starts[j] = d == 'R' ? rules[p][2] : rules[p][1]
            if starts[j][3] == 'Z'
                push!(cycles[j], i+1)
            end
        end
        i += 1
    end
    quot = map(t->t[2]-t[1], cycles)
    rem = map(t->t[1], cycles)
    if quot != rem
        throw("this is tough")
    end
    x = lcm(quot...)
    return x
end

println(f2())
