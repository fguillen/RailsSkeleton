class RenamingProject
  def self.perform(new_name)
    Dir.glob("#{Rails.root}/**/*.*").each do |filepath|
      next unless File.file? filepath

      new_filepath = if filepath =~ /rails_skeleton/
                       filepath.gsub("rails_skeleton", new_name.underscore)
                     else
                       filepath
                     end

      file_content = File.read(filepath)
      file_content = file_content.gsub("ScrapStats", new_name)
      file_content = file_content.gsub("scrapstats", new_name.downcase)

      FileUtils.mkdir(File.dirname(new_filepath)) unless Dir.exists?(File.dirname(new_filepath))
      File.write(new_filepath, file_content)

      if new_filepath != filepath
        `git rm "#{filepath}"`
      end

    end
  end
end
