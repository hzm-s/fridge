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
          Team::Team.new([]),
          description
        )
      end

      sig {params(id: Id, name: String, team: Team::Team, description: T.nilable(String)).returns(T.attached_class)}
      def from_repository(id, name, team, description)
        new(id, name, team, description)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(String)}
    attr_reader :name

    sig {returns(Team::Team)}
    attr_reader :team

    sig {returns(T.nilable(String))}
    attr_reader :description

    sig {params(id: Id, name: String, team: Team::Team, description: T.nilable(String)).void}
    def initialize(id, name, team, description)
      @id = id
      @name = name
      @team = team
      @description = description
    end

    sig {params(member: Team::Member).void}
    def add_team_member(member)
      @team = @team.add_member(member)
    end

    sig {params(person_id: Person::Id).returns(T.nilable(Team::Member))}
    def team_member(person_id)
      @team.member(person_id)
    end
  end
end
