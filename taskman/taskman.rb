###########################
#         TASKMAN         #
###########################

#Retourne les arguments d'appel du fichier dans un tableau 'ARGV'
#Utilisation de p plutôt que puts pour conserver la forme de tableau à l'affichage
#p ARGV

require 'json'

class Task
    OPTIONS_DEFAULT = {
        flags: [],
        date: nil
    }

    attr_accessor :id, :content, :flags
    attr_reader :is_done

    def initialize id, content, opts = {}, is_done = false
        opts = OPTIONS_DEFAULT.merge(opts)

        @id = id
        @content = content
        @flags = opts[:flags]
        @is_done = is_done 
    end

    def to_json opts={}
       {
           id: @id,
           content: @content,
           flags: @flags,
           is_done: @is_done
       }.to_json(opts)
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

    def self.get_task id
        @tableau_taches.select{ |tache| tache.id == id }.first
    end
    
    def self.supprimer id
        @tableau_taches = @tableau_taches.reject{|tache| tache.id == id.to_i}
    end

    #Charge les taches depuis un fichier JSON
    def self.load file
        str = File.read(file)
        tableau = JSON.parse(str)

        @tableau_taches =  tableau.map do |tache|
            Task.new(tache["id"], tache["content"], { flags: tache["flags"] }, true)
        end
    end

    #Charge les taches depuis un fichier JSON
    def self.save file
        File.open(file, "w") do |file|
            file.write(@tableau_taches.to_json)
        end
    end

    def self.afficher
        puts "*****TASKMAN*****"
        puts "LISTE DES TACHES"
        @tableau_taches.each(&:afficher)
    end

    #Initialisation du tableau des taches
    @tableau_taches = []
end

module Commande
    @commandes = {}

    def self.register action
        @commandes[action.command] = action
    end

    def self.afficher_aide
        puts "taskman [commande] [contenu] [options....]"
        puts "------------------------------------------"
        @commandes.each do |k, action|
            puts action.to_s
        end
    end

    def self.lancer!
        command = ARGV.shift
        commande_execute = false
        @commandes.each do |k, action|
            if k == command
                commande_execute = true
                action.apply(ARGV)
            end
        end
    
        if not commande_execute #or unless
            afficher_aide
        end
    end

    class Action
        attr_accessor :command, :arguments, :description, :block

        def initialize command, arguments, description, &block
            @command = command
            @arguments = arguments
            @description = description
            @block = block
        end

        def apply arguments
            block.call(arguments)
        end

        def register!
            Commande.register(self)
        end

        def to_s
            puts "#{@command} #{@arguments}\t * #{@description}"
        end
    end

    class TaskAction < Action
        def initialize command, arguments, description, &block
            super command, arguments, description, &block
        end 

        def apply arguments
            id = arguments.shift.to_i
            task = Task.get_task id

            if task.nil?
                puts "La tache #{id} n'existe pas!"
                exit
            end

            block.call(task, arguments)
        end

        def to_s
            puts "#{@command} :id #{@arguments}\t * #{@description}"
        end
    end
end

Task.load("tasks.json")

Commande::Action.new('add', ':contenu (options...)', 'Crée une nouvelle tâche.') do |arguments|
    Task.ajouter(arguments)
end.register!

Commande::TaskAction.new('del', '', 'Supprimer une tache.') do |task, args|
    Task.supprimer task.id
end.register!


#Commande.register 'mod', ':id (options...)', 'Modifie une tache.' do |arguments|
#    puts "Commande MOD"
#end
#Commande.register 'list', ':filtre', 'Liste les taches.' do |arguments|
#    Task.afficher
#end
#Commande.register 'clear', '', 'Supprimer toute les taches.' do |arguments|
#    #A FAIRE : Supprimer toute les taches
#end

Commande.lancer!

Task.afficher

Task.save("tasks.json")
