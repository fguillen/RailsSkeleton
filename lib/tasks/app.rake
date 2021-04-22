namespace :railsskeleton do
  namespace :utils do
    desc "Renaming project to a new name"
    task :renaming_project, [:new_project_name] => :environment do |_t, args|
      RenamingProject.perform(args.new_project_name)
    end
  end

  desc "This is a task for testing"
  task test: :environment do
    Rails.logger.info("[#{Time.now}] This is the test task")
  end
end
