# typed: strict
require 'sorbet-runtime'

module Team
  class Member
    extend T::Sig
    
    sig {returns(User::Id)}
    attr_reader :user_id

    sig {returns(Team::Role)}
    attr_reader :role

    sig {params(user_id: User::Id, role: Role).void}
    def initialize(user_id, role)
      @user_id = user_id
      @role = role
    end

    sig {params(other: Member).returns(T::Boolean)}
    def ==(other)
      self.user_id == other.user_id &&
        self.role == other.role
    end
  end
end
