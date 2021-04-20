namespace :docs do
  namespace :api do
    desc "Generate API docs"
    task generate: :environment do
      markdown_source_file = File.join(Rails.root, 'doc/API.apib')
      target_file = File.join(Rails.root, 'doc/api/index.html')

      puts "Generating API html file..."
      executed_correctly = system("aglio -i #{markdown_source_file} -o #{target_file} --theme-template triple --theme-variables streak")

      puts "Done, you can check it here: #{target_file}" if executed_correctly
    end
  end
end
