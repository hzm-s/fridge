# typed: true
class App::UserProfile < ApplicationRecord
  BG_COLORS = %w(
    slateblue
    steelblue
    royalblue
    dodgerblue
    deepskyblue
    mediumturquoise
    lightseagreen
    limegreen
    darkorange
    goldenrod
    tomato
    orangered
    palevioletred
    blueviolet
    mediumpurple
    darkcyan
    cadetblue
    teal
    forestgreen
    mediumvioletred
    dimgray
    olive
    darkolivegreen
    saddlebrown
    maroon
    darkred
    indigo
  )

  class << self
    def create_from_email(user_account_id, email)
      initials = email[0, 2]
      new(
        app_user_account_id: user_account_id,
        initials: initials,
        bgcolor: BG_COLORS.shuffle.sample,
        fgcolor: 'snow',
      )
    end
  end
end
