total = 0

puts "Additionner tous les multiples de 3 et 5 de 0 à ... ?"
num_limit = gets.chomp.to_i

num_limit.times do |x|
    if x%3 == 0 || x%5 == 0
        total += x
        puts x
    end
end

puts total