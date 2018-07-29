suite = [1,2]
num = 0
x = 0
somme = 0

#Sequence de Fibonacci (nombre n'excèdant pas 4 000 000)
while num < 4000000
    num = suite[x] + suite[x + 1]
    if num < 4000000
        suite << num
    end
    x += 1
end

p suite

#Somme des nombre pairs
suite.each do |x|
    if x%2 == 0
        somme += x
    end
end
#Affichage
puts "----#{somme}----"