# typed: strict
require 'sorbet-runtime'

module Team
  class Team
    extend T::Sig

    sig {params(members: T::Array[Member]).void}
    def initialize(members)
      @members = members
      check_member_role!
    end

    sig {params(member: Member).returns(Team)}
    def add_member(member)
      raise AlreadyJoined if self.member(member.user_id)
      self.class.new(@members + [member])
    end

    sig {params(user_id: User::Id).returns(T.nilable(Member))}
    def member(user_id)
      @members.find { |member| member.user_id == user_id }
    end

    sig {returns(T::Array[Member])}
    def to_a
      @members
    end

    private

    sig {void}
    def check_member_role!
      raise DuplicatedProductOwner if count_of_role(Role::ProductOwner) > 1
      raise DuplicatedScrumMaster if count_of_role(Role::ScrumMaster) > 1
      raise TooLargeDevelopmentTeam if count_of_role(Role::Developer) > 9
    end

    sig {params(role: Role).returns(Integer)}
    def count_of_role(role)
      @members.select { |member| member.role == role }.size
    end
  end
end
