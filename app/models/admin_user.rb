class AdminUser < ApplicationRecord
  strip_attributes

  self.primary_key = :uuid
  include HasUuid

  acts_as_authentic do |config|
    config.crypto_provider = ::Authlogic::CryptoProviders::SCrypt
    config.session_class = AdminSession
  end


  has_many :authorizations, dependent: :destroy, class_name: "AdminAuthorization"
  has_one :user_notifications_pref, as: :user

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: RubyRegex::Email }
  validates :password, presence: true, on: :create
  validates :password, confirmation: true, allow_blank: true
  validates :user_notifications_pref, presence: true

  validates_with PasswordValidator, unless: -> { password.blank? }

  scope :order_by_recent, -> { order("created_at desc") }

  before_validation :create_user_notifications_pref, on: :create

  def send_reset_password_email
    reset_perishable_token!
    Notifier.admin_user_reset_password(self).deliver
  end

  def create_user_notifications_pref
    if !user_notifications_pref.present?
      build_user_notifications_pref
    end
  end

end
