class AdminUser < ApplicationRecord
  strip_attributes

  self.primary_key = :uuid
  include HasUuid

  acts_as_authentic do |config|
    config.crypto_provider = ::Authlogic::CryptoProviders::SCrypt
    config.session_class = AdminSession
  end

  serialize :notifications_active, type: Array, coder: YAML

  has_many :authorizations, dependent: :destroy, class_name: "AdminAuthorization"

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: RubyRegex::Email }
  validates :password, presence: true, on: :create
  validates :password, confirmation: true, allow_blank: true

  validates_with PasswordValidator, unless: -> { password.blank? }

  scope :order_by_recent, -> { order("created_at desc") }

  validate :notifications_active_are_allowed, if: :notifications_active_changed?

  def send_reset_password_email
    reset_perishable_token!
    Notifier.admin_user_reset_password(self).deliver
  end

  private

  def notifications_active_are_allowed
    return if notifications_active.empty?

    notifications_active.each do |notification_active|
      if NotificationsRoles.for_role("admin").blank? || !NotificationsRoles.for_role("admin").include?(notification_active)
        errors.add(:notifications_active, "active notification not allowed: '#{notification_active}'")
      end
    end
  end

end
