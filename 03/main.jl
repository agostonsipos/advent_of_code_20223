using DelimitedFiles

in = readdlm("3.txt", '\n')

t = vec(map(collect, in))

function parseNum(i, j)
    a = parse(Int, t[i][j])
    k = j
    while k < size(t[i], 1)
        k += 1
        if '0' <= t[i][k] <= '9'
            b = parse(Int, t[i][k])
            a = 10*a+b
        else
            break
        end
    end
    for u in (i-1):(i+1)
        for v in (j-1):k
            try
                if !(('0' <= t[u][v] <= '9') || t[u][v] == '.')
                    return (a, k)
                end
            catch
            end
        end
    end
    return (0, k)
end

function f1()
    s = 0
    for i in 1:size(t,1)
        j = 1
        while j < size(t[i], 1)
            try
                (x, k) = parseNum(i, j)
                s += x
                j = k
            catch
                j += 1
            end
        end
    end
    return s
end


function parseStar(i, j)
    if t[i][j] != '*'
        return 0
    end
    c = 0
    n = 1
    for u in (i-1):(i+1)
        v = j-1
        while v <= j+1
            if ('0' <= t[u][v] <= '9')
                w = v
                while w > 1 && ('0' <= t[u][w-1] <= '9')
                    w -= 1
                end
                v = w
                (x, w) = parseNum(u, v)
                c += 1
                n *= x
                v = w
            end
            v += 1
        end
    end
    if (c == 2)
        return n
    else
        return 0
    end
end

function f2()
    s = 0
    for i in 1:size(t,1)
        j = 1
        while j < size(t[i], 1)
            try
                x = parseStar(i, j)
                s += x
            catch
            end
            j += 1
        end
    end
    return s
end


println(f1())

println(f2())
