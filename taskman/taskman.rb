###########################
#         TASKMAN         #
###########################

#Retourne les arguments d'appel du fichier dans un tableau 'ARGV'
#Utilisation de p plutôt que puts pour conserver la forme de tableau à l'affichage
#p ARGV

#Récupération du premier argument et mise en minuscule
command = ARGV.shift.downcase

#Initialisation du tableau des taches
tableau_taches = [[0, "TEste"]]

case command
when "add"
    commande = ARGV.shift

    tache = []

    tache << tableau_taches.map{ |tache| tache[0] }.max + 1
    tache << commande

    ARGV.each do |argument|
        champ, valeur = argument.split(':')

        tache << champ
        tache << valeur

        case champ
        when "flags"
            puts "Ajouter Flags : #{valeur}"
        when "date"
            puts "Ajouter Date"
        else
            puts "Je ne comprend pas : #{argument}"
        end
    end

    tableau_taches << tache
when "mod"
    puts "Commande MOD"
when "del"
    id = ARGV.shift
      tableau_taches = tableau_taches.reject{|tache| tache[0] == id.to_i}
else
    puts "Commande non reconnue"
end

tableau_taches.each do |tache|
    p tache
end