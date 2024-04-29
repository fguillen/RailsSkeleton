class FrontAuthorization < ApplicationRecord
  belongs_to :front_user

  serialize :omniauth_data, JSON
  serialize :omniauth_params, JSON

  validates_presence_of :front_user_id, :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  before_validation :initialize_uid_and_provider, on: :create

  def self.find_from_omniauth_data(hash)
    find_by_provider_and_uid(hash[:provider], hash[:uid])
  end

  def self.create_user_from_omniauth_data(hash)
    password = SecureRandom.uuid
    name = hash[:info][:name].to_s
    email = hash[:info][:email].to_s.downcase

    FrontUser.create(name: name, email: email, password: password)
  end

  private

  def initialize_uid_and_provider
    self.provider ||= omniauth_data["provider"]
    self.uid ||= omniauth_data["uid"]
  end
end
