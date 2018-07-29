def is_palindrome?(n)
    n == n.to_s.split("").reverse.join.to_i
end

a = 999
b = 999
result = 0

while true
    product = a * b
    if is_palindrome?(product)
        if product > result
            result = product
        end
    end
    if a == 100
        if b > 100
            a = 999
            b -= 1
        else
            break
        end
    end
    a -= 1
end

puts "Trouvé : #{result}"