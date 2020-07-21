# typed: strict
require 'sorbet-runtime'

module UserRepository
  module AR
    class << self
      extend T::Sig
      include User::UserRepository

      sig {override.params(id: User::Id).returns(User::User)}
      def find_by_id(id)
        r = Dao::User.find(id)

        avatar = User::Avatar.from_repository(r.initials, r.avatar_bg, r.avatar_fg)
        User::User.from_repository(
          User::Id.from_string(r.id),
          r.email,
          r.name,
          avatar
        )
      end

      sig {override.params(user: User::User).void}
      def add(user)
        Dao::User.create!(
          id: user.id,
          email: user.email,
          name: user.name,
          initials: user.avatar.initials,
          avatar_bg: user.avatar.bg,
          avatar_fg: user.avatar.fg
        )
      end
    end
  end
end
