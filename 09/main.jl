using DelimitedFiles

t = readdlm("9.txt", '\n')

function load()
    seq = []
    for l in t
        push!(seq, map(s->parse(Int, s), split(l, " ")))
    end
    return seq
end

seq = load()

function f1(seq)
    x = 0
    for s in seq
        diffs = [s]
        i = 0
        while !isempty(filter(x->x!=0, diffs[i+1]))
            i += 1
            push!(diffs, map(j->diffs[i][j+1] - diffs[i][j], 1:length(diffs[i])-1))
        end
        push!(diffs[i+1], 0)
        while i > 0
            push!(diffs[i], diffs[i][end] + diffs[i+1][end])
            i -= 1
        end
        x += s[end]
    end
    return x
end

println(f1(seq))

function f2(seq)
    return f1(map(s->reverse(s), seq))
end

println(f2(seq))
