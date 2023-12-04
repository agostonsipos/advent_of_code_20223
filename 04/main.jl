using DelimitedFiles

t = readdlm("4.txt", '\n')

function process(l)
    d = split(l, ':')[2]
    w = filter(x -> x != "", split(strip(split(d, '|')[1]), ' '))
    m = split(strip(split(d, '|')[2]), ' ')
    c = 0
    for it in m
        if it in w
            c += 1
        end
    end
    return c
end

function f1()
    x = 0
    for l in t
        c = process(l)
        v = c == 0 ? 0 : 2^(c-1)
        x += v
    end
    return x
end

println(f1())

function f2()
    x = 0
    arr = ones(Int64, size(t,1))
    i = 1
    for l in t
        c = process(l)
        for j in 1:c
            arr[i+j] += arr[i]
        end
        i += 1
    end
    return sum(arr)
end

println(f2())
