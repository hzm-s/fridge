# typed: false
module UserQuery
  class User < Struct.new(:name, :initials, :avatar)
    def avatar_bg
      avatar.bg
    end

    def avatar_fg
      avatar.fg
    end
  end

  class << self
    def call(user_id)
      u = Dao::User.eager_load(:avatar).find_by(id: user_id)
      User.new(u.name, u.initials, u.avatar)
    end
  end
end
