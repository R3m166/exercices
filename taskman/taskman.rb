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

def afficher_aide
    puts "taskman [commande] [contenu] [options....]"
    puts "------------------------------------------"
    $commandes.each do |k, v|
        puts "#{v[:keyword]} #{v[:arguments]}\t * #{v[:description]}"
    end
end

$commandes = {}

def register_command command, arguments, description, &block
    $commandes[command] = {
        keyword: command,
        arguments: arguments,
        description: description,
        block: block
    }
end

def lancer_commande!
    $command = ARGV.shift
    commande_execute = false
    $commandes.each do |k, v|
        if k == $command
            commande_execute = true
            v[:block].call(ARGV)
        end
    end

    if not commande_execute #or unless
        afficher_aide
    end
end

register_command 'add', ':contenu (options...)', 'Crée une nouvelle tâche.' do |arguments|
    $tableau_taches << ajouter(arguments)
end
register_command 'del', ':id', 'Supprimer une tache.' do |arguments|
    supprimer arguments.shift.to_i
end
register_command 'mod', ':id (options...)', 'Modifie une tache.' do |arguments|
    puts "Commande MOD"
end
register_command 'list', ':filtre', 'Liste les taches.' do |arguments|
    afficher
end
register_command 'clear', '', 'Supprimer toute les taches.' do |arguments|
    #A FAIRE : Supprimer toute les taches
end

lancer_commande!

afficher