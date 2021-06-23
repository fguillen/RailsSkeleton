class ChangeTaggingsTaggableIdToString < ActiveRecord::Migration[6.1]
  def up
    change_column :taggings, :taggable_id, :string, limit: 36
  end
end
