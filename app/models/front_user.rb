class FrontUser < ApplicationRecord
  self.primary_key = :uuid
  include HasUuid

  acts_as_authentic do |config|
    config.crypto_provider = ::Authlogic::CryptoProviders::SCrypt
    config.session_class = FrontSession
  end

  has_many :authorizations, class_name: "FrontAuthorization", dependent: :destroy
  has_many :posts, dependent: :destroy
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: RubyRegex::Email }

  scope :order_by_recent, -> { order("created_at desc") }
end
