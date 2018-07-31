###########################
#         TASKMAN         #
###########################

#Retourne les arguments d'appel du fichier dans un tableau 'ARGV'
#Utilisation de p plutôt que puts pour conserver la forme de tableau à l'affichage
#p ARGV

#Initialisation du tableau des taches
$tableau_taches = [
    {id: 0, :content => "Ameliorer taskman", flags: %w(important urgent)}
    #[0, "Ameliorer taskman", "flags", "important urgent"]
]

OPTIONS_DEFAULT = {
    flags: [],
    date: nil
}

def parser_command command
    case command
    when "add"
        $tableau_taches << ajouter(ARGV)
    when "mod"
        puts "Commande MOD"
    when "del"
        supprimer(ARGV.shift.to_i)
    else
        puts "Commande non reconnue"
    end
end

def afficher
    puts "*****TASKMAN*****"
    puts "LISTE DES TACHES"

    $tableau_taches.each do |tache|
        puts "#{tache[:id]} - #{tache[:content]} (#{tache[:flags].join(" ")})"
    end
end

def supprimer id
    $tableau_taches = $tableau_taches.reject{|tache| tache[:id] == id.to_i}
end

def ajouter params
    commande = params.shift

    tache = {}

    tache[:id] = $tableau_taches.map{ |tache| tache[:id] }.max + 1

    
    tache.merge!(OPTIONS_DEFAULT)

    tache[:content] = commande

    params.each do |argument|
        champ, valeur = argument.split(':')
        if champ == "flags"
            tache[champ.to_sym] = valeur.split(",")
        else
            tache[champ.to_sym] = valeur
        end
    end

    tache
end

#Récupération du premier argument et mise en minuscule
command = ARGV.shift.downcase

parser_command(command)
afficher