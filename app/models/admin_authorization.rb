class AdminAuthorization < ApplicationRecord
  belongs_to :admin_user

  serialize :omniauth_data, JSON
  serialize :omniauth_params, JSON

  validates_presence_of :admin_user_id, :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  before_validation :initialize_uid_and_provider, on: :create

  def self.find_from_omniauth_data(hash)
    find_by_provider_and_uid(hash[:provider], hash[:uid])
  end

  private

  def initialize_uid_and_provider
    self.provider ||= omniauth_data["provider"]
    self.uid ||= omniauth_data["uid"]
  end
end
