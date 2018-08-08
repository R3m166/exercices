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

    def self.define &block
        CommandDSL.new(&block)
    end

    class CommandDSL
        def initialize &block
            instance_eval(&block)
        end

        def args str
            @args = str
        end

        def desc str
            @desc = str
        end

        def action name, &block
            Commande::Action.new(name.to_s, @args, @desc, &block).register!
            @args = ""
            @desc = ""
        end

        def task_action name, &block
            Commande::TaskAction.new(name.to_s, @args, @desc, &block).register!
            @args = ""
            @desc = ""
        end
    end
end

