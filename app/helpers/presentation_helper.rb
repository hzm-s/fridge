# typed: false
module PresentationHelper
  WEB_FONT_URL = 'https://fonts.googleapis.com/earlyaccess/roundedmplus1c.css'.freeze

  def web_font_link_tag
    return if Rails.env.test?
    stylesheet_link_tag(WEB_FONT_URL, media: 'all', 'data-turbolinks-track': 'reload')
  end

  LOADING_ICON = '<i class="fas fa-spinner fa-spin"></i>'.freeze

  def with_loader(base = {})
    base.merge(disable_with: LOADING_ICON.html_safe)
  end

  def user_avatar(initials:, fgcolor:, bgcolor:, size: nil)
    css_class = size ? "avatar-#{size}" : 'avatar'
    content_tag(:span, initials, class: css_class, style: "background-color: #{bgcolor}; color: #{fgcolor}").html_safe
  end

  def team_member_roles_label
    current_team_member_roles
      .to_a
      .then { |rs| translate_team_member_roles(rs) }
  end

  def translate_team_member_roles(roles)
    roles.map { |role| t(role, scope: 'domain.team.role_short') }.join('/')
  end

  def dropdown_item_classes(additional = '')
    classes = ['dropdown-item']

    if block_given? && !yield
      classes << 'disabled'
    end

    (classes + [additional]).join(' ')
  end
end
