class UserNotificationsConfig < ApplicationRecord
  self.primary_key = :uuid
  include HasUuid

  ALLOWED_USER_TYPES = ["FrontUser", "AdminUser"].freeze

  belongs_to :user, polymorphic: true
  serialize :active_notifications, Array

  validates :user, presence: true
  validate :user_class_is_allowed_class

  def user_class_is_allowed_class
    return if user.nil?

    if !ALLOWED_USER_TYPES.include? user.class.name
      errors.add(:user, "class not allowed for association. Class found: '#{user.class.name}', allowed classes: '#{ALLOWED_USER_TYPES.join(", ")}'")
    end
  end
end
