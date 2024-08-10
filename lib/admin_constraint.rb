class AdminConstraint
  def matches?(request)
    return false unless request.session.fetch(:admin_user_credentials)

    admin_user = AdminUser.find_by_persistence_token(request.session.fetch(:admin_user_credentials))

    admin_user.present?
  end
end
