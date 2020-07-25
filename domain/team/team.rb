# typed: strict
require 'sorbet-runtime'

module Team
  class Team
    extend T::Sig

    sig {params(members: T::Array[Member]).void}
    def initialize(members)
      @members = members
    end

    sig {params(member: Member).returns(Team)}
    def add_member(member)
      raise DuplicateProductOwnerError if member.role == Role::ProductOwner && @members.detect { |m| m.role == Role::ProductOwner }
      raise DuplicateScrumMasterError if member.role == Role::ScrumMaster && @members.detect { |m| m.role == Role::ScrumMaster }
      raise LargeDevelopmentTeamError if member.role == Role::Developer && @members.select { |m| m.role == Role::Developer }.size >= 9
      self.class.new(@members + [member])
    end

    sig {params(user_id: User::Id).returns(T.nilable(Member))}
    def member(user_id)
      @members.find { |member| member.user_id == user_id }
    end
  end
end
