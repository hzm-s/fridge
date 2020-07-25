# typed: strict
require 'sorbet-runtime'

module Product
  class Product
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(name: String, description: T.nilable(String)).returns(T.attached_class)}
      def create(name, description = nil)
        new(
          Id.create,
          name,
          [],
          description
        )
      end

      sig {params(id: Id, name: String, members: T::Array[Team::Member], description: T.nilable(String)).returns(T.attached_class)}
      def from_repository(id, name, members, description)
        new(id, name, members, description)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(String)}
    attr_reader :name

    sig {returns(T.nilable(String))}
    attr_reader :description

    sig {returns(T::Array[Team::Member])}
    attr_reader :members

    sig {params(id: Id, name: String, members: T::Array[Team::Member], description: T.nilable(String)).void}
    def initialize(id, name, members, description)
      @id = id
      @name = name
      @members = members
      @description = description
    end

    sig {params(member: Team::Member).void}
    def add_team_member(member)
      raise Team::DuplicateProductOwnerError if member.role == Team::Role::ProductOwner && @members.detect { |m| m.role == Team::Role::ProductOwner }
      raise Team::DuplicateScrumMasterError if member.role == Team::Role::ScrumMaster && @members.detect { |m| m.role == Team::Role::ScrumMaster }
      raise Team::LargeDevelopmentTeamError if member.role == Team::Role::Developer && @members.select { |m| m.role == Team::Role::Developer }.size >= 9
      @members << member
    end

    sig {params(user_id: User::Id).returns(T.nilable(Team::Member))}
    def team_member(user_id)
      @members.find { |member| member.user_id == user_id }
    end
  end
end
