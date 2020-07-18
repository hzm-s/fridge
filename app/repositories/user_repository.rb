# typed: strict
require 'sorbet-runtime'

module UserRepository
  module AR
    class << self
      extend T::Sig
      include User::UserRepository

      sig {override.params(id: String).returns(User::User)}
      def find_by_id(id)
        r = Dao::User.find(id)

        avatar = User::Avatar.from_repository(r.initials, r.avatar_bg, r.avatar_fg)
        User::User.from_repository(r.id, r.name, avatar)
      end

      sig {override.params(user: User::User).void}
      def add(user)
        Dao::User.create!(
          id: user.id,
          name: user.name,
          initials: user.avatar.initials,
          avatar_bg: user.avatar.bg,
          avatar_fg: user.avatar.fg
        )
      end
    end
  end
end
