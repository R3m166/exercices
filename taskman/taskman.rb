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

end

Commande.lancer!

Task.afficher

Task.save("#{TM_PATH}/conf/tasks.json")
