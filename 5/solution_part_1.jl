#import Pkg; Pkg.add("OrderedCollections")
using OrderedCollections

function return_mappings_name(str::AbstractString)
    matcher = match(r"([A-z\-]+)", str)
    return matcher !== nothing ? matcher.match : ""
end

function create_mappings_dict(file_path)
    lines = String[]
    maps = OrderedDict()
    dict_key = ""
    
    try
        open(file_path, "r") do file
            for line in eachline(file)
                # Skip whitespace-only lines
                if strip(line) ≠ ""
                    # return map keys
                    if occursin(r"[A-z]", line)
                        dict_key = return_mappings_name(line)
                        #initialise dict structure
                        maps[dict_key] = String[]
                    end

                    if all(c -> isdigit(c) || isspace(c), line)
                        push!(maps[dict_key], line)
                    end
                end
            end
        end
    catch e
        println("Error: $e")
    end
    return maps
end


function extract_transform_rules(transformation_str)
    transformation = split(transformation_str)
    transformation = parse.(Int, transformation)
    destination_start = transformation[1]
    source_start = transformation[2]
    source_end = transformation[2]+transformation[3]-1
    range = source_start:1:source_end
    return range, destination_start
end

function propagate_number_through_map(number, transformation)
    range, destination_start = extract_transform_rules(transformation)
    if number in range
        index_position = findfirst(x -> x == number, range)
        final_position = destination_start + (index_position-1)
        #println("Starts at: $(number)")
        #println("Moves: $(index_position)")
        #println("Ends up at: $(final_position)")
        changed = true
    else 
        final_position = number
        changed = false
    end
    return final_position, changed
end


# Replace "path/to/your/file.txt" with the actual file path
file_path = "demo.txt"
file_path = "input.txt"
mappings = create_mappings_dict(file_path)
processed_seeds = Int[]
global counter = 0
input_numbers = [950527520 85181200 546703948 123777711 63627802 279111951 1141059215 246466925 1655973293 98210926 3948361820 92804510 2424412143 247735408 4140139679 82572647 2009732824 325159757 3575518161 370114248]
for number in input_numbers
    for (key, maps) in mappings
        # Print the lines or use them as needed
        change_count = 0
        for map in maps
            range, _ = extract_transform_rules(map)
            new, changed = propagate_number_through_map(number, map)
            if changed
                change_count +=1
            end
            # we don't want to process the same kind of transformation more than once
            if change_count <= 1
                println(key)
                println("$(number) -> $(new)")
                number=new
            end
        end
   end
    push!(processed_seeds, number)
end
println("All seeds processed!")
println("Nearest locaton number is: $(minimum(processed_seeds))")

