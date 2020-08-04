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
        User::User.from_repository(
          r.user_id_as_do,
          r.email,
          r.name,
          r.initials
        )
      end

      sig {override.params(user: User::User).void}
      def add(user)
        Dao::User.create!(
          id: user.id,
          email: user.email,
          name: user.name,
          initials: user.initials
        )
      end
    end
  end
end
