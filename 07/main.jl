using DelimitedFiles

t = readdlm("7.txt", '\n')

global with_jokers = false

function card_val(c)
    if c == 'A'
        return 14
    elseif c == 'K'
        return 13
    elseif c == 'Q'
        return 12
    elseif c == 'J'
        return with_jokers ? 1 : 11
    elseif c == 'T'
        return 10
    else
        return c-'0'
    end
end

function load()
    data = []
    for l in t
        r = split(l, " ")
        push!(data, (map(x->x[1], split(r[1], "")), parse(Int, r[2])))
    end
    return data
end

data = load()

function hand_category(h)
    h = sort(map(card_val, h), rev=true)
    for i=1:5
        filt = x->x==h[i] || x == 1
        if length(filter(filt, h)) == 5
            return 7
        elseif length(filter(filt, h)) == 4
            oth = filter(filt, h)
            return 6
        elseif length(filter(filt, h)) == 3
            oth = sort(filter(x->!filt(x), h), rev=true)
            if oth[1]==oth[2] || oth[1] == 1 || oth[2] == 1
                if length(filter(x->x==1, filter(filt, h))) >= 2
                    continue # too many jokers, there will be a better combo
                end
                return 5
            else
                return 4
            end
        elseif length(filter(filt, h)) == 2
            oth = sort(filter(x->!filt(x), h), rev=true)
            if oth[1] == oth[2] == oth[3] || oth[3] == 1 && oth[1] == oth[2] || oth[2] == 1 && oth[3] == 1
                if length(filter(x->x==1, filter(filt, h))) >= 1
                    continue # too many jokers, there will be a better combo
                end
                return 5
            elseif oth[1] == oth[2]
                if length(filter(x->x==1, filter(filt, h))) >= 1
                    continue # too many jokers, there will be a better combo
                end
                return 3
            elseif oth[2] == oth[3] || oth[3] == 1
                if length(filter(x->x==1, filter(filt, h))) >= 1
                    continue # too many jokers, there will be a better combo
                end
                return 3
            else
                return 2
            end
        end
    end
    return 1
end

function cmphands(h1, h2)
    a = hand_category(h1[1])
    b = hand_category(h2[1])
    if a < b
        return true
    elseif a > b
        return false
    else
        vals1 = map(card_val, h1[1])
        vals2 = map(card_val, h2[1])
        for i=1:5
            if vals1[i] < vals2[i]
                return true
            elseif vals1[i] > vals2[i]
                return false
            end
        end
        return false
    end
end

function f1(hands)
    sorted = sort(hands, lt=cmphands)
    x = 0
    for i = 1:length(sorted)
        x += sorted[i][2] * i
    end
    return x
end


println(f1(data))

function f2(hands)
    global with_jokers
    with_jokers = true
    return f1(hands)
end

println(f2(data))
