puts "Premier multiple des nombres de 1 à ... (attention à partir de 20 très long)?"
nombre = gets.chomp.to_i

tour = nombre

while true
    test = 0
    nombre.times do |x|
        if tour % (x + 1) == 0
            test += 1
        end
    end
    if test == nombre
        result = tour
        break
    end
    tour += 1
end

puts "Trouvé : #{result}"