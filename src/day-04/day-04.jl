function get_range(sections::AbstractString)::AbstractRange
    section_range = map(x -> parse(Int, x), split(sections, "-"))
    return range(section_range...)
end

function get_num_overlaps(filepath::String; full_overlap::Bool=true)::Int
    num_overlaps = 0

    open(joinpath(@__DIR__, filepath)) do file
        lines = readlines(file)
        for line in lines
            isnothing(line) && continue
            pairs = split(line, ",")
            section_ranges = map(get_range, pairs)
            if (
                full_overlap &&
                (issubset(section_ranges...) || issubset(reverse(section_ranges)...))
            ) || (!full_overlap && !isempty(intersect(section_ranges...)))
                num_overlaps += 1
            end
        end
    end

    return num_overlaps
end

println("Number of elf pairs with full overlaps:")
println(get_num_overlaps("elf_section_assignments.txt"))

println("Number of elf pairs with some overlap:")
println(get_num_overlaps("elf_section_assignments.txt"; full_overlap=false))
