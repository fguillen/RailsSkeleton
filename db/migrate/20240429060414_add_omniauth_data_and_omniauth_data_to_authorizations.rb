class AddOmniauthDataAndOmniauthDataToAuthorizations < ActiveRecord::Migration[6.1]
  def change
    add_column :admin_authorizations, :omniauth_data, :text
    add_column :admin_authorizations, :omniauth_params, :text

    add_column :front_authorizations, :omniauth_data, :text
    add_column :front_authorizations, :omniauth_params, :text
  end
end
