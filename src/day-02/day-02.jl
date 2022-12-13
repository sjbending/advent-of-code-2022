choice_map = Dict("A" => 1, "B" => 2, "C" => 3, "X" => 1, "Y" => 2, "Z" => 3)

outcome_map = Dict("X" => 0, "Y" => 3, "Z" => 6)

function calculate_score(line::String, have_outcome::Bool)
    choices = split(line, " ")
    their_choice = choice_map[choices[1]]

    #=
    For our choice:
    X = 1, Y = 2, Z = 3

    For the outcome of the round:
    loss (e.g. A(1) => Z(3)) = 0
    draw (e.g. A(1) => X(1)) = 3
    win  (e.g. A(1) => Y(2)) = 6
    =#
    if have_outcome
        outcome = outcome_map[choices[2]]
        score = outcome + mod(their_choice + 1 + (outcome / 3), 3) + 1
    else
        my_choice = choice_map[choices[2]]
        score = my_choice + 3 * mod(my_choice - their_choice + 1, 3)
    end

    return score
end

function calculate_total_score(filename::String; have_outcome::Bool=false)
    total_score = 0
    open(joinpath(@__DIR__, filename)) do file
        lines = readlines(file)
        for line in lines
            total_score += calculate_score(line, have_outcome)
        end
    end

    return total_score
end

total_score_part_one = calculate_total_score("strategies.txt")
println(total_score_part_one)

total_score_part_two = calculate_total_score("strategies.txt"; have_outcome=true)
println(total_score_part_two)
