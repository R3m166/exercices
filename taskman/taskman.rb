###########################
#         TASKMAN         #
###########################

#Retourne les arguments d'appel du fichier dans un tableau 'ARGV'
#Utilisation de p plutôt que puts pour conserver la forme de tableau à l'affichage
#p ARGV

#Récupération du premier argument et mise en minuscule
command = ARGV.shift.downcase

#Initialisation du tableau des taches
tableau_taches = [
    {id: 0, :content => "Ameliorer taskman", flags: %w(important urgent)}
    #[0, "Ameliorer taskman", "flags", "important urgent"]
]

case command
when "add"
    commande = ARGV.shift

    tache = {}

    tache[:id] = tableau_taches.map{ |tache| tache[:id] }.max + 1

    OPTIONS_DEFAULT = {
        flags: [],
        date: nil
    }
    tache.merge!(OPTIONS_DEFAULT)

    tache[:content] = commande

    ARGV.each do |argument|
        champ, valeur = argument.split(':')

        tache[champ.to_sym] = valeur

        #case champ
        #when "flags"
        #    puts "Ajouter Flags : #{valeur}"
        #when "date"
        #    puts "Ajouter Date"
        #else
        #    puts "Je ne comprend pas : #{argument}"
        #end
    end

    tableau_taches << tache
when "mod"
    puts "Commande MOD"
when "del"
    id = ARGV.shift
      tableau_taches = tableau_taches.reject{|tache| tache[:id] == id.to_i}
else
    puts "Commande non reconnue"
end

puts "*****TASKMAN*****"
puts "LISTE DES TACHES"

tableau_taches.each do |tache|
    puts "#{tache[:id]} - #{tache[:content]} (#{tache[:flags].join(" ")})"
end