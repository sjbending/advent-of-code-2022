using DataStructures

function parse_initial_crate_order(initial_order_str::AbstractString)::Array{Stack}
    initial_order = split(initial_order_str, "\n")
    crates = initial_order[begin:(end - 1)]
    num_stacks = length(split(initial_order[end]))

    crate_stacks = [Stack{Char}() for _ = 1:num_stacks]

    for line in reverse(crates)
        for stack_idx = 1:num_stacks
            char_idx = 2 + (stack_idx - 1) * 4
            current_crate = line[char_idx]
            if !isspace(current_crate)
                push!(crate_stacks[stack_idx], current_crate)
            end
        end
    end

    return crate_stacks
end

function parse_stacking_instruction(instruction::AbstractString)::Tuple
    stack_numbers = eachmatch(r"[0-9]+", instruction)
    num_crates, from_stack, to_stack = map(x -> parse(Int, x.match), stack_numbers)

    return (num_crates, from_stack, to_stack)
end

function move_stack!(
    crate_stacks::Array{Stack},
    move_instruction::Tuple,
    preserve_order::Bool,
)
    num_crates, from_stack_idx, to_stack_idx = move_instruction
    from_stack = crate_stacks[from_stack_idx]
    to_stack = crate_stacks[to_stack_idx]

    crates_to_move = Deque{Char}()
    for _ = 1:num_crates
        push!(crates_to_move, pop!(from_stack))
    end

    for _ = 1:num_crates
        # NB: we've reversed the order by popping to a separate Deque
        crate = preserve_order ? pop!(crates_to_move) : popfirst!(crates_to_move)
        push!(to_stack, crate)
    end
end

function get_top_of_stacks(filepath::String; preserve_order::Bool=false)
    open(joinpath(@__DIR__, filepath)) do file
        initial_order, instructions = split(read(file, String), "\n\n")
        crate_stacks = parse_initial_crate_order(initial_order)
        for instruction in split(instructions, "\n")
            isempty(instruction) && continue
            move_instruction = parse_stacking_instruction(instruction)
            move_stack!(crate_stacks, move_instruction, preserve_order)
        end

        println("\n== Top crate in each stack ==")
        preserve_order &&
            println("NB: CRATE ORDER HAS BEEN PRESERVED FOR EACH INSTRUCTION.")
        for (i, stack) in enumerate(crate_stacks)
            println("Stack $(i): $(first(stack))")
        end
    end
end

get_top_of_stacks("crate_instructions.txt")
get_top_of_stacks("crate_instructions.txt"; preserve_order=true)
