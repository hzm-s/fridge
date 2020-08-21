# typed: false
module ApplicationHelper
  WEB_FONT_URL = 'https://fonts.googleapis.com/earlyaccess/roundedmplus1c.css'.freeze

  def web_font_link_tag
    return if Rails.env.test?
    stylesheet_link_tag(WEB_FONT_URL, media: 'all', 'data-turbolinks-track': 'reload')
  end

  LOADING_ICON = '<i class="fas fa-spinner fa-spin"></i>'.freeze

  def with_loader
    { disable_with: LOADING_ICON.html_safe }
  end

  def user_avatar(initials:, fgcolor:, bgcolor:)
    content_tag(:span, initials, class: 'avatar', style: "background-color: #{bgcolor}; color: #{fgcolor}").html_safe
  end
end
