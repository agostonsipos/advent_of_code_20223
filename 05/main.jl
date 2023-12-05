using DelimitedFiles

t = readdlm("5.txt", '\n')

function preprocess()
    l = t[1]
    parseint = x->parse(Int, x)
    start = map(parseint, split(strip(split(t[1], ':')[2]), ' '))
    transforms = []
    for l in t[2:end]
        if isempty(l)
            continue
        elseif occursin(":", l)
            push!(transforms, [])
        else
            push!(transforms[end], map(parseint, split(l, ' ')))
        end
    end
    return (start, transforms)
end

(start, transforms) = preprocess()


function simulate(start, transforms)
    data = copy(start)
    for tr in transforms
        for i in 1:length(data)
            for range in tr
                if range[2] <= data[i] < range[2] + range[3]
                    data[i] += range[1] - range[2]
                    break
                end
            end
        end
    end
    return minimum(data)
end

println(simulate(start, transforms))


function simulate2(start, transforms)
    data = copy(start)
    for tr in transforms
        newdata = []
        for i in 1:(length(data)÷2)
            n = data[2*i-1]
            l = data[2*i]
            j = 1
            while j <= length(tr)
                range = tr[j]
                if range[2] <= n < range[2] + range[3]
                    if n + l < range[2] + range[3]
                        push!(newdata, n + range[1] - range[2])
                        push!(newdata, l)
                        l = 0
                        break
                    else
                        rangelen = range[2] + range[3] - n
                        push!(newdata, n + range[1] - range[2])
                        push!(newdata, rangelen)
                        n += rangelen
                        l -= rangelen
                        j = 0
                    end
                end
                if j == length(tr) && l > 0
                    m = minimum(filter(x -> n <= x < n+l, map(r->r[2], tr)), init=n+l)
                    if m == n + l
                        push!(newdata, n)
                        push!(newdata, l)
                        break
                    else
                        push!(newdata, n)
                        push!(newdata, m - n)
                        n = m
                        j = 0
                    end
                end
                j += 1
            end
        end
        data = newdata
    end
    m = minimum(data[1:2:end])
    println(data[1:2:end])
    return m
end

println(simulate2(start, transforms))
