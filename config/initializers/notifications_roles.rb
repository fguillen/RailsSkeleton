class NotificationsRoles
  NOTIFICATIONS_ROLES = YAML.safe_load(File.read("#{Rails.root}/config/notifications_roles.yml"))

  def self.for_role(role)
    NOTIFICATIONS_ROLES[role.to_s]
  end
end
