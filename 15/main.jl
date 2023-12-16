using DelimitedFiles

inp = read("15.txt", String)

function run(cmd)
    x = 0
    for c in cmd
        x += Int(c)
        x *= 17
        x %= 256
    end
    x
end

function f1()
    s = 0
    for cmd in split(inp, ',')
        s += run(cmd)
    end
    s
end

println(f1())

boxes = [[] for i=1:256]

function f2()
    for cmd in split(inp, ',')
        assign = split(cmd, '=')
        if length(assign) == 2
            ind = run(assign[1])
            i = findfirst(x->x[1]==assign[1], boxes[ind+1])
            data = (assign[1], parse(Int, assign[2]))
            if !isnothing(i)
                boxes[ind+1][i] = data
            else
                push!(boxes[ind+1], data)
            end
        else
            rem = split(cmd, '-')
            ind = run(rem[1])
            boxes[ind+1] = filter(x->x[1]!=rem[1], boxes[ind+1])
        end
    end

    s = 0
    for i in eachindex(boxes)
        box = boxes[i]
        for j in eachindex(box)
            lens = box[j]
            s += i * j * lens[2]
        end
    end
    s
end

println(f2())
