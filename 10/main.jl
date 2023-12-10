using DelimitedFiles

t = readdlm("10.txt", '\n')

function load()
    mat = Array{Char, 2}(undef, length(t), length(t[1]))
    i = 1
    for l in t
        mat[i,:] = collect(l)
        i += 1
    end
    return mat
end

mat = load()

north = ['L', 'J', '|']
south = ['7', 'F', '|']
west = ['J', '7', '-']
east = ['L', 'F', '-']

connections = [(CartesianIndex(0,-1), west, east), (CartesianIndex(-1,0), north, south), (CartesianIndex(0,1), east, west), (CartesianIndex(1,0), south, north)]

function f1()
    start = findall(x->x=='S', mat)[1]
    poslist = [start]
    distmat = Array{Int32, 2}(undef, size(mat))
    fill!(distmat, size(mat, 1)^3)
    distmat[start] = 0
    collectedindices = [start]
    i = 0
    while !isempty(poslist)
        newposlist = []
        for pos in poslist
            for conn in connections
                try
                    if (mat[pos] in conn[2] || mat[pos] =='S') && mat[pos+conn[1]] in conn[3] && i+1 < distmat[pos+conn[1]]
                        push!(newposlist, pos+conn[1])
                        push!(collectedindices, pos+conn[1])
                        distmat[pos+conn[1]] = i+1
                    end
                catch
                end
            end
        end
        poslist = newposlist
        i += 1
    end
    return (i-1, collectedindices)
end

(res1, loopindices) = f1()

println(res1)


push!(north, 'S')
push!(south, 'S')
push!(east, 'S')
push!(west, 'S')
blockades = [((0,-1), (1,3), south, north), ((-1,0), (1,2), east, west), ((0,1), (2,4), south, north), ((1,0), (3,4), east, west)]

function f2()
    for i in CartesianIndices(mat)
        if !(i in loopindices)
            mat[i] = '.'
        end
    end
    start = (1//2, 1//2)
    poslist = [start]
    visited = [start]
    while !isempty(poslist)
        newposlist = []
        for pos in poslist
            fourcells = [CartesianIndex(map(Int, floor.(pos))), CartesianIndex(map(Int, (floor(pos[1]), ceil(pos[2])))), CartesianIndex(map(Int, (ceil(pos[1]), floor(pos[2])))), CartesianIndex(map(Int, ceil.(pos)))]
            for ind in fourcells
                try
                    if mat[ind] == '.'
                        mat[ind] = '#'
                    end
                catch
                end
            end
            for block in blockades
                try
                    neighbours = [mat[fourcells[block[2][1]]], mat[fourcells[block[2][2]]]]
                    newpos = pos[1] + block[1][1], pos[2] + block[1][2]
                    if newpos in visited || neighbours[1] in block[3] && neighbours[2] in block[4]
                    else
                        push!(newposlist, newpos)
                        push!(visited, newpos)
                    end
                catch
                    newpos = pos[1] + block[1][1], pos[2] + block[1][2]
                    if newpos in visited || newpos[1] < 0 || newpos[2] < 0 || newpos[1] > size(mat, 1) + 1 || newpos[2] > size(mat, 2) + 1
                    else
                        push!(newposlist, newpos)
                        push!(visited, newpos)
                    end
                end
            end
        end
        poslist = newposlist
    end
    count(c->c=='.', mat)
end

println(f2())
