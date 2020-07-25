# typed: false
module UserQuery
  class User < Struct.new(:id, :name, :initials, :avatar)
    def id_as_domain
      ::User::Id.from_string(id)
    end

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
      User.new(u.id, u.name, u.initials, u.avatar)
    end
  end
end
