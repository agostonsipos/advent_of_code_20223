using DelimitedFiles

t = readdlm("18.txt", '\n')

function load1()
    inp = []
    for l in t
        r = split(l, ' ')
        push!(inp, (r[1][1], parse(Int, r[2])))
    end
    return inp
end

mat = fill('.', (1000,1000))

dirs = [('R', (0,1)), ('D', (1,0)), ('L', (0,-1)), ('U', (-1,0))]

hexaToInp(s) = (dirs[parse(Int, s[8])+1][1], parse(Int, s[3:7], base=16))

function load2()
    inp = []
    for l in t
        r = split(l, ' ')
        push!(inp, hexaToInp(r[3]))
    end
    return inp
end

D(A) = A[1,1]*A[2,2] - A[1,2]*A[2,1]

function solve(data)
    dirdict = Dict(dirs)
    pos = (0,0)
    poly = [pos]
    s = 0
    for m in data
        pos = pos .+ m[2] .* dirdict[m[1]]
        push!(poly, pos)
        s += m[2]
    end
    poly
    for i in eachindex(poly)
        j = (i+1) > length(poly) ? 1 : i+1
        s -= D([poly[i][1] poly[i][2]; poly[j][1] poly[j][2]])
    end
    s÷2 + 1
end

println(solve(load1()))

println(solve(load2()))
