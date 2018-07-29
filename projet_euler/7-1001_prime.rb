def prime?(n)
    ("1" * n) !~ /^1?$|^(11+?)\1+$/
end

num_test = 2
num_th = 0
result = 0

puts "Vous voulez afficher le nombre premier numéro ?"
num_saisie = gets.chomp.to_i

while num_th != num_saisie + 1
    if prime?(num_test)
        num_th += 1
        result = num_test
        puts num_th
    end
    num_test += 1
end

puts "Resultat : #{result}"