###########################
#         TASKMAN         #
###########################

#Retourne les arguments d'appel du fichier dans un tableau 'ARGV'
#Utilisation de p plutôt que puts pour conserver la forme de tableau à l'affichage
#p ARGV

class Task
    OPTIONS_DEFAULT = {
        flags: [],
        date: nil
    }

    attr_accessor :id, :content, :flags
    attr_reader :is_done

    def initialize id, content, opts = {}
        opts = OPTIONS_DEFAULT.merge(opts)

        @id = id
        @content = content
        @flags = opts[:flags]
        @is_done = false
    end

    def afficher
        puts "[#{@is_done ? "X" : " "}]#{@id} - #{@content} (#{@flags.join(" ")})"
    end

    def done
        @is_done = true
    end

    def self.ajouter params
        contenu = params.shift
        id = @tableau_taches.map(&:id).max + 1
        #id = @tableau_taches.map{ |tache| tache.id }.max + 1

        new_task = Task.new id, contenu
    
        params.each do |argument|
            champ, valeur = argument.split(':')
            if champ == "flags"
                new_task.flags = valeur.split(',')
            else
                raise "Parametre incorrect : #{champ}"
            end
        end
    
        @tableau_taches << new_task
    end
    
    def self.supprimer id
        @tableau_taches = @tableau_taches.reject{|tache| tache.id == id.to_i}
    end

    def self.afficher
        puts "*****TASKMAN*****"
        puts "LISTE DES TACHES"
        @tableau_taches.each(&:afficher)
    end

    #Initialisation du tableau des taches
    @tableau_taches = [
        Task.new(0, "Améliorer taskman", flags: %w(important urgent))
    ]
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