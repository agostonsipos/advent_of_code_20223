using DelimitedFiles

t = readdlm("1.txt")

function update(n1, n2, nc)
    if n1 == -1
        n1 = nc
    end
    n2 = nc
    return (n1, n2)
end

function f()
    x = 0
    for s in t
        if typeof(s) <: Number
            s = string(s)
        end
        n1 = -1
        n2 = 0
        for c in s
            if '0' <= c <= '9'
                (n1, n2) = update(n1, n2, c - '0')
            end
        end
        x += 10*n1 + n2
    end
    println(x)
end

f()

pattern = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]


function g()
    x = 0
    for s in t
        if typeof(s) <: Number
            s = string(s)
        end
        n1 = -1
        n2 = 0
        i = 0
        for c in s
            if '0' <= c <= '9'
                (n1, n2) = update(n1, n2, c - '0')
            else
                try
                    y = -1
                    if s[i:i+2] in pattern
                        y = findfirst(t -> t == s[i:i+2], pattern)
                    elseif s[i:i+3] in pattern
                        y = findfirst(t -> t == s[i:i+3], pattern)
                    elseif s[i:i+4] in pattern
                        y = findfirst(t -> t == s[i:i+4], pattern)
                    end
                    if y != -1
                        (n1, n2) = update(n1, n2, y)
                    end
                catch
                    # index error, we don't care
                end
            end
            i += 1
        end
        x += 10*n1 + n2
    end
    println(x)
end

g()
