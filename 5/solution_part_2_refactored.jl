function solution(seeds, maps)
    seed_ranges = [seeds[i]:seeds[i]+seeds[i+1]-1 for i in 1:2:length(seeds)-1]
    min_val = typemax(Int)

    # iterate across each range of seeds as a chunk
    for seed_range in seed_ranges
        ranges = [seed_range]
        # go through each mapping 
        for map in maps
            remapped = [remap_range(range, map) for range in ranges]
            ranges = Iterators.flatten(remapped)
        end
        # assign/update the new minimum value based on the current seed range
        min_val = min(min_val, first(minimum(ranges)))
    end
    println(min_val)
end

function remap_range(start_range, map)
    ranges = [start_range]
    for (map_range, destination) in map
        range = ranges[end]
        # if there's an overlap between the map_range and the range
        overlap = range ∩ map_range
        if isempty(overlap)
            continue
        end

        mapped_first = first(overlap) - first(map_range) + destination
        mapped_last = last(overlap) - first(map_range) + destination
        ranges[end] = mapped_first:mapped_last

        # build out our overall range before/after the mapped range
        if first(range) < first(map_range)
            push!(ranges, first(range):first(map_range)-1)
        end
        if last(range) > last(map_range)
            push!(ranges, last(map_range)+1:last(range))
        else
            return ranges
        end
    end
    return ranges
end

function parse_file(file)
    lines = eachline(file)
    seeds = [parse(Int, x) for x in split(iterate(lines)[1])[2:end]]
    iterate(lines)
    maps = [getMap(lines) for _ in 1:7]
    return (seeds, maps)
end

function getMap(lines)
    iterate(lines) # ignore map name
    tuples = Tuple{UnitRange{Int},Int}[]
    while true
        line = iterate(lines, nothing)
        if line === nothing || isempty(line[1])
            break
        end
        s = [parse(Int, x) for x in split(line[1])]
        push!(tuples, (s[2]:s[2]+s[3]-1, s[1]))
    end
    return sort(tuples; by=x -> x[1])
end

seeds, maps = (nothing, nothing)
open("input.txt") do file
    global seeds, maps = parse_file(file)
end
solution(seeds, maps)