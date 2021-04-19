module Admin::BaseHelper
  include ApplicationHelper

  def admin_menu_class(actual_menu_name)
    menus = {
      :admin_users => ["/admin/admin_users.*"],
      :appreciable_users => ["/admin/appreciable_users.*"],
      :appreciations => ["/admin/appreciations.*"],
      :admin_users_index => ["/admin/admin_users"],
      :admin_users_new => ["/admin/admin_users/new"],
      :widgets => ["/admin/widgets.*"],
      :widgets_index => ["/admin/widgets"],
      :widgets_new => ["/admin/widgets/new"],
      :generate_quotas => ["/admin/generate_quotas.*"],
    }

    menu_class(menus, actual_menu_name)
  end
end

