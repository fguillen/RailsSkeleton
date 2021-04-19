namespace :scrapstats do
  namespace :utils do
    desc "Renaming project to a new name"
    task :renaming_project, [:new_project_name] => :environment do |t, args|
      RenamingProject.perform(args.new_project_name)
    end
  end
end
