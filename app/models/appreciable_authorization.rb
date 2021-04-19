class AppreciableAuthorization < ApplicationRecord
  belongs_to :appreciable_user

  validates_presence_of :appreciable_user_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_from_omniauth_data(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end
end
