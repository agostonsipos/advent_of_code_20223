using DelimitedFiles

t = readdlm("6.txt", '\n')


parseint = x->parse(Int, x)
times = map(parseint, filter(x->x!="", split(strip(split(t[1], ':')[2]), ' ')))
dists = map(parseint, filter(x->x!="", split(strip(split(t[2], ':')[2]), ' ')))

function f1()
    x = 1
    for i in 1:length(times)
        time = times[i]
        dist = dists[i]
        c = 0
        for j in 1:time
            if j * (time - j) > dist
                c += 1
            end
        end
        x *= c
    end
    return x
end

println(f1())

time2 = parseint(join(filter(x->x!="", split(strip(split(t[1], ':')[2]), ' ')), ""))
dist2 = parseint(join(filter(x->x!="", split(strip(split(t[2], ':')[2]), ' ')), ""))

function f2()
    time = time2
    dist = dist2
    c = 0
    # -j^2 + time * j - dist > 0
    # j_1 => floor(-time/(-2) + (sqrt(time^2-4*(-1)*(-dist))/(-2)))
    # j_2 => ceil(-time/(-2) - (sqrt(time^2-4*(-1)*(-dist))/(-2)))
    # |[j_1, j_2]| = j_2 - j_1 + 1
    d = sqrt(time^2-4*dist)/2
    c = Int(floor(time/2 + d)) - Int(ceil(time/2 - d)) + 1
    return c
end

println(f2())

