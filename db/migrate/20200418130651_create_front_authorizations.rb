class CreateFrontAuthorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :front_authorizations do |t|
      t.string :provider
      t.string :uid
      t.string :front_user_id, index: true
    end
  end
end
