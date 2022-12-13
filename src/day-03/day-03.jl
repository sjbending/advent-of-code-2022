function calculate_priority(item::Char)::Int
    if islowercase(item)
        return item - 'a' + 1
    elseif isuppercase(item)
        return item - 'A' + 27
    else
        error("Unexpected item type $(item).")
    end
end

function get_duplicates_priority(line::String)::Int
    compartment_boundary = length(line) ÷ 2  # Integer divide function!
    first_compartment = line[begin:compartment_boundary]
    second_compartment = line[(compartment_boundary + 1):end]

    duplicates = intersect(first_compartment, second_compartment)

    priority = 0
    for duplicate in duplicates
        priority += calculate_priority(duplicate)
    end

    return priority
end

function get_sum_duplicates_priority(filepath::String)::Int
    sum_priority_duplicates = 0

    open(joinpath(@__DIR__, filepath)) do file
        lines = readlines(file)
        for line in lines
            if !isempty(line)
                priority = get_duplicates_priority(line)
                sum_priority_duplicates += priority
            end
        end
    end

    return sum_priority_duplicates
end

function get_sum_group_priorities(filepath::String)::Int
    sum_badge_priorities = 0

    open(joinpath(@__DIR__, filepath)) do file
        lines = readlines(file)
        group_size = 3
        for group_idx = 1:group_size:length(lines)
            group = lines[group_idx:(group_idx + 2)]
            badge = intersect(group...)
            if length(badge) == 1
                sum_badge_priorities += calculate_priority(badge[1])
            else
                error("Found more than one badge in group $(group).")
            end
        end
    end

    return sum_badge_priorities
end

println("Sum of priorities of items in both compartments of each rucksack:")
println(get_sum_duplicates_priority("rucksack_contents.txt"))

println("\nSum of priorities of badges in groups:")
println(get_sum_group_priorities("rucksack_contents.txt"))
