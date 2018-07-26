require "json"

class Famille
    attr_accessor :nom, :age, :titre, :mail, :telephone

    def initialize (*args)
        @nom = args[0]
        @age = args[1]
        @titre = args[2]
        @mail = args[3]
        @telephone = args[4]
    end

    def sauvegarde
        membre_input = {
            nom: @nom,
            age: @age,
            titre: @titre,
            mail: @mail,
            telephone: @telephone
        }.to_json

        open("livret.json", "a") do |fichier|
            fichier.puts ";" + membre_input
        end
    end
end