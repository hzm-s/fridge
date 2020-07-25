# typed: true
class App::Avatar < ApplicationRecord
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
    def create_for_user(user_id)
      bg = BG_COLORS.sample
      create!(dao_user_id: user_id, bg: bg, fg: 'snow')
    end
  end
end
