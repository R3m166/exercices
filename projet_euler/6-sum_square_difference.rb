def sum_of_squares(n)
    result = 0
    n.times do |x|
        result += (x + 1) * (x + 1)
    end
    return result
end

def squares_of_sum(n)
    result = 0
    n.times do |x|
        result += (x + 1)
    end
    return result * result
end

puts "Entrez le nombre voulu"
num = gets.chomp.to_i

puts "Resultat : #{squares_of_sum(num) - sum_of_squares(num)}"
