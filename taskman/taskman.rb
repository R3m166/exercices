###########################
#         TASKMAN         #
###########################

#Retourne les arguments d'appel du fichier dans un tableau 'ARGV'
#Utilisation de p plutôt que puts pour conserver la forme de tableau à l'affichage
#p ARGV
require 'bundler'

Bundler.require

TM_PATH = File.expand_path(File.join(__FILE__, ".."))

require_relative "#{TM_PATH}/lib/commande"
require_relative "#{TM_PATH}/lib/task"

Task.load("#{TM_PATH}/conf/tasks.json")

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

Task.save("#{TM_PATH}/conf/tasks.json")
