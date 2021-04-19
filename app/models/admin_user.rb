class AdminUser < ApplicationRecord
  self.primary_key = :uuid
  include HasUuid

  acts_as_authentic do |config|
    config.crypto_provider = ::Authlogic::CryptoProviders::SCrypt
    config.session_class = AdminSession
  end

  validates_with AdminPasswordValidator

  has_many :authorizations, dependent: :destroy, class_name: "AdminAuthorization"

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: RubyRegex::Email }
  validates :password, confirmation: true

  scope :order_by_recent, -> { order("created_at asc") }

  def send_reset_password_email
    reset_perishable_token!
    Notifier.admin_user_reset_password(self).deliver
  end
end
