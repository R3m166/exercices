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