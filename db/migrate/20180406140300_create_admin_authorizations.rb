class CreateAdminAuthorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_authorizations do |t|
      t.string :provider
      t.string :uid
      t.string :admin_user_id, index: true
    end
  end
end
