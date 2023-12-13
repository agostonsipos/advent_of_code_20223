using DelimitedFiles

inp = read("13.txt", String)

function load(inp)
    t = split(inp, '\n')
    mat = Array{Char, 2}(undef, length(t), length(t[1]))
    i = 1
    for l in t
        mat[i,:] = collect(l)
        i += 1
    end
    return mat
end

mats = []
for pt in split(inp, "\n\n")
    push!(mats, load(pt))
end

function isline1(mat, i)
    for j = 1:i
        if (i+i-j+1) <= size(mat, 1) && mat[j,:] != mat[i+i-j+1,:]
            return false
        end
    end
    return true
end

function isline2(mat, i)
    for j = 1:i
        if (i+i-j+1) <= size(mat, 2) && mat[:,j] != mat[:,i+i-j+1]
            return false
        end
    end
    return true
end

function f1(mats)
    s = 0
    for mat in mats
        for i = 1:size(mat,1)-1
            if isline1(mat, i)
                s += 100*i
            end
        end
        for i = 1:size(mat,2)-1
            if isline2(mat, i)
                s += i
            end
        end
    end
    return s
end

println(f1(mats))


function f2(mats)
    s = 0
    for mat in mats
        for ind in eachindex(mat)
            x = 0
            newmat = copy(mat)
            if mat[ind] == '.'
                newmat[ind] = '#'
            else
                newmat[ind] = '.'
            end
            c = 0
            for i = 1:size(newmat,1)-1
                if isline1(newmat, i) && !isline1(mat, i)
                    c += 1
                    x = 100*i
                end
            end
            for i = 1:size(newmat,2)-1
                if isline2(newmat, i) && !isline2(mat, i)
                    c += 1
                    x = i
                end
            end
            if c == 1
                s += x
                break
            end
        end
    end
    return s
end

println(f2(mats))

