###########################
#         TASKMAN         #
###########################

#Retourne les arguments d'appel du fichier dans un tableau 'ARGV'
#Utilisation de p plutôt que puts pour conserver la forme de tableau à l'affichage
#p ARGV
require 'bundler'

Bundler.require

TM_PATH = File.expand_path(File.join(__FILE__, ".."))

require_relative "#{TM_PATH}/lib/ext"
require_relative "#{TM_PATH}/lib/commande"
require_relative "#{TM_PATH}/lib/task"
require_relative "#{TM_PATH}/lib/error"

Task.load("#{TM_PATH}/conf/tasks.json")

Commande.define do

    args ":contenu (options..)"
    desc "Créer une nouvelle tache"
    action :add do |arguments|
        Task.ajouter arguments
    end

    args ""
    desc "Supprime une tache"
    task_action :del do |task, arguments|
        Task.supprimer task.id
    end

    args ":filtres"
    desc "Liste les taches"
    action :list do |arguments|
        filters = arguments.inject({}) do |h, x|
            k,v = x.split(':')

            if v.nil?
                h[:content] = k
            else
               h[k.to_sym] = v
            end

            h
        end

        Task.afficher filters
    end

    args ""
    desc "Supprime toutes les taches"
    action :clear do |arguments|
        Task.clear
    end
end

Commande.lancer!

Task.save("#{TM_PATH}/conf/tasks.json")
