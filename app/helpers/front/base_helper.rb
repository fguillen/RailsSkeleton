module Front::BaseHelper
  include ApplicationHelper

  def front_menu_class(actual_menu_name)
    menus = {
      appreciations: ["/front/appreciations.*"]
    }

    menu_class(menus, actual_menu_name)
  end

  def appreciation_custom_style(appreciation)
    return "style_no_saved" if appreciation.uuid.nil?

    styles = ["style_fish", "style_snell", "style_waterfly"]
    index = appreciation.uuid.each_byte.inject(&:+)

    styles[index % styles.length]
  end

  def render_markdown(text)
    options = {
      filter_html: true,
      no_images: true,
      no_links: true,
      no_styles: true,
      hard_wrap: true
    }
    renderer = Redcarpet::Render::HTML.new(options)
    Redcarpet::Markdown.new(renderer).render(text).html_safe
  end
end
