require_relative "./app/famille"

def liste
    file = File.read("livret.json")
    membres = file.split(';')
    membres.each do |membre|
        data_membre = JSON.parse(membre)
        puts "#{data_membre["titre"]} : #{data_membre["nom"]} (#{data_membre["age"]} an(s))"
    end
end

#Affichage de la liste existante
liste

puts "Désirez-vous ajouter un nouveau membre au livret de famille ? (y/n)"
answer = gets.chomp.upcase

while answer == "Y"
    puts "Veuillez saisir le nom du membre a ajouter :"
    nom = gets.chomp.capitalize
    
    puts "Veuillez saisir l'age du membre a ajouter :"
    age = gets.chomp.to_i
    
    puts "Veuillez saisir le titre du membre a ajouter :"
    titre = gets.chomp

    puts "Veuillez saisir le mail du membre a ajouter :"
    mail = gets.chomp

    puts "Veuillez saisir le téléphone du membre a ajouter :"
    telephone = gets.chomp

    nouveau_membre = Famille.new(nom, age, titre, mail, telephone)
    nouveau_membre.sauvegarde

    #Affichage de la liste existante
    liste

    puts "Désirez-vous ajouter un autre membre ? (y/n)"
    again = gets.chomp.upcase
    if again != "Y"
        break
    end
end