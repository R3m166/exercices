require 'time'

class Task
    OPTIONS_DEFAULT = {
        flags: []
    }

    attr_accessor :id, :content, :flags, :date
    attr_reader :is_done

    def flags= x
        if x
            if x.is_a?(Array)
                @flags = x
            elsif x.is_a?(String)
                @flags = x.split(',')
            else
                raise "flags= #{x.class} impossible"
            end
        else
            @flags = x
        end
    end

    def date= x
        if x
            if x.is_a?(Date)
                @date = x
            elsif x.is_a?(String)
                @date = Time.parse(x)
            else
                raise "date= #{x.class} impossible"
            end
        else
            @date = x
        end
    end

    def initialize id, content, opts = {}, is_done = false
        opts = OPTIONS_DEFAULT.merge(opts)

        @id = id
        @content = content

        opts.each do |k, v|
            if respond_to?("#{k}=")
                send("#{k}=", v)
            else
                raise "Je ne connait pas ce champ : #{k}."
            end
        end

        @is_done = is_done 
    end

    def to_json opts={}
       {
           id: @id,
           content: @content,
           flags: @flags,
           is_done: @is_done,
           date: @date
       }.to_json(opts)
    end

    def afficher
        puts "[#{@is_done ? "X".green : ".".red}]#{@id.to_s.light_blue} - #{@content.bold.white} (#{@flags.join(" ")}) #{@date.nil? ? "" : @date.strftime("%Y-%m-%d")}"
    end

    def done
        @is_done = true
    end

    def self.ajouter params
        contenu = params.shift
        id = @tableau_taches.map(&:id).max + 1
        #id = @tableau_taches.map{ |tache| tache.id }.max + 1

        hash = {}
        params.each do |param|
            k, v = param.split(':')
            hash[k.to_sym] = v
        end

        new_task = Task.new id, contenu, hash
    
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
            opts = tache.reject{|k,v|["id", "content", "is_done"].include?(k) }
            Task.new(tache["id"], tache["content"], opts, tache["is_done"])
        end
    end

    #Charge les taches depuis un fichier JSON
    def self.save file
        File.open(file, "w") do |file|
            file.write(@tableau_taches.to_json)
        end
    end

    def self.afficher
        puts "*****TASKMAN*****".bold.white
        puts "LISTE DES TACHES".bold.white
        @tableau_taches.each(&:afficher)
    end

    #Initialisation du tableau des taches
    @tableau_taches = []
end