class FrontUser < ApplicationRecord
  strip_attributes
  log_book ignore: [:password]

  self.primary_key = :uuid
  include HasUuid

  acts_as_authentic do |config|
    config.crypto_provider = ::Authlogic::CryptoProviders::SCrypt
    config.session_class = FrontSession
  end

  has_many :authorizations, class_name: "FrontAuthorization", dependent: :destroy
  has_one :user_notifications_config, as: :user, dependent: :destroy

  has_many :articles, dependent: :destroy
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: RubyRegex::Email }
  validates :password, presence: true, on: :create
  validates :password, confirmation: true, allow_blank: true
  validates :user_notifications_config, presence: true

  validates_with PasswordValidator, unless: -> { password.blank? }

  scope :order_by_recent, -> { order("created_at desc") }

  before_validation :create_user_notifications_config, on: :create

  def send_reset_password_email
    reset_perishable_token!
    Notifier.front_user_reset_password(self).deliver
  end

  def create_user_notifications_config
    if !user_notifications_config.present?
      build_user_notifications_config
    end
  end
end
