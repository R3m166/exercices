###########################
#         TASKMAN         #
###########################

#Retourne les arguments d'appel du fichier dans un tableau 'ARGV'
#Utilisation de p plutôt que puts pour conserver la forme de tableau à l'affichage
p ARGV

#Récupération du premier argument et mise en minuscule
command = ARGV.shift.downcase

case command
when "add"
    commande = ARGV.shift

    ARGV.each do |argument|
        champ, valeur = argument.split(':')

        case champ
        when "flags"
            puts "Ajouter Flags : #{valeur}"
        when "date"
            puts "Ajouter Date"
        else
            puts "Je ne comprend pas : #{argument}"
        end
    end

    puts "Commande ADD"
when "mod"
    puts "Commande MOD"
when "del"
    puts "Commande DEL"
else
    puts "Commande non reconnue"
end