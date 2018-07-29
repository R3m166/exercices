def prime?(n)
    ("1" * n) !~ /^1?$|^(11+?)\1+$/
end

puts "Trouver le plus haut facteur de premier du nombre ... ?"
nombre = gets.chomp.to_i

find = false
facteur = 2

while find != true
    if prime?(facteur) && nombre % facteur == 0
        facteur_max = facteur
        nombre /= facteur  
    end
    facteur += 1
    if nombre < facteur 
        find = true
    end
end

puts facteur_max