elf_calories = []

open(joinpath(@__DIR__, "calories.txt")) do file
    lines = readlines(file)
    sum_calories = 0
    for line in lines
        if line == ""
            append!(elf_calories, sum_calories)
            sum_calories = 0
        else
            sum_calories += parse(Int, line)
        end
    end
end

greediest_elf = findmax(elf_calories)
println(greediest_elf)

three_greediest_elves = partialsortperm(elf_calories, 1:3; rev=true)
greedy_elf_sum = sum(elf_calories[three_greediest_elves])
print(greedy_elf_sum)
