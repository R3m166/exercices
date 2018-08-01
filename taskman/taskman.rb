###########################
#         TASKMAN         #
###########################

#Retourne les arguments d'appel du fichier dans un tableau 'ARGV'
#Utilisation de p plutôt que puts pour conserver la forme de tableau à l'affichage
#p ARGV

module Task
    OPTIONS_DEFAULT = {
        flags: [],
        date: nil
    }

    #Initialisation du tableau des taches
    @tableau_taches = [
        {id: 0, :content => "Ameliorer taskman", flags: %w(important urgent)}
    ]

    def self.supprimer id
        @tableau_taches = @tableau_taches.reject{|tache| tache[:id] == id.to_i}
        #ou @tableau_taches.reject!{|tache| tache[:id] == id.to_i}
    end
    
    def self.ajouter params
        commande = params.shift
    
        tache = {}
    
        tache[:id] = @tableau_taches.map{ |tache| tache[:id] }.max + 1
    
        
        tache.merge!(Task::OPTIONS_DEFAULT)
    
        tache[:content] = commande
    
        params.each do |argument|
            champ, valeur = argument.split(':')
            if champ == "flags"
                tache[champ.to_sym] = valeur.split(",")
            else
                tache[champ.to_sym] = valeur
            end
        end
    
        @tableau_taches << tache
    end

    def self.afficher
        puts "*****TASKMAN*****"
        puts "LISTE DES TACHES"
    
        @tableau_taches.each do |tache|
            puts "#{tache[:id]} - #{tache[:content]} (#{tache[:flags].join(" ")})"
        end
    end
end


module Commande
    @commandes = {}

    def self.register command, arguments, description, &block
        @commandes[command] = {
            keyword: command,
            arguments: arguments,
            description: description,
            block: block
        }
    end

    def self.afficher_aide
        puts "taskman [commande] [contenu] [options....]"
        puts "------------------------------------------"
        @commandes.each do |k, v|
            puts "#{v[:keyword]} #{v[:arguments]}\t * #{v[:description]}"
        end
    end

    def self.lancer!
        command = ARGV.shift
        commande_execute = false
        @commandes.each do |k, v|
            if k == command
                commande_execute = true
                v[:block].call(ARGV)
            end
        end
    
        if not commande_execute #or unless
            afficher_aide
        end
    end
end

Commande.register 'add', ':contenu (options...)', 'Crée une nouvelle tâche.' do |arguments|
    Task.ajouter arguments
end
Commande.register 'del', ':id', 'Supprimer une tache.' do |arguments|
    Task.supprimer arguments.shift.to_i
end
Commande.register 'mod', ':id (options...)', 'Modifie une tache.' do |arguments|
    puts "Commande MOD"
end
Commande.register 'list', ':filtre', 'Liste les taches.' do |arguments|
    Task.afficher
end
Commande.register 'clear', '', 'Supprimer toute les taches.' do |arguments|
    #A FAIRE : Supprimer toute les taches
end

Commande.lancer!

Task.afficher