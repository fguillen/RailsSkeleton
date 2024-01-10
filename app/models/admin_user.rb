class AdminUser < ApplicationRecord
  strip_attributes

  self.primary_key = :uuid
  include HasUuid

  acts_as_authentic do |config|
    config.crypto_provider = ::Authlogic::CryptoProviders::SCrypt
    config.session_class = AdminSession
  end

  serialize :notifications_active, Array

  has_many :authorizations, dependent: :destroy, class_name: "AdminAuthorization"

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: RubyRegex::Email }
  validates :password, presence: true, on: :create
  validates :password, confirmation: true, allow_blank: true

  validates_with PasswordValidator, unless: -> { password.blank? }

  scope :order_by_recent, -> { order("created_at desc") }

  validate :notifications_active_are_allowed

  def send_reset_password_email
    reset_perishable_token!
    Notifier.admin_user_reset_password(self).deliver
  end

  private

  def notifications_active_are_allowed
    return if notifications_active.empty?

    notifications_active.each do |notification_active|
      if !USER_NOTIFICATIONS_ROLES["admin"].include?(notification_active)
        errors.add(:notifications_active, "active notification not allowed: '#{notification_active}'")
      end
    end
  end

end
