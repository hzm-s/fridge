# typed: strict
require 'sorbet-runtime'

module Product
  class Product
    extend T::Sig

    Teams = T.type_alias {T::Array[Team::Id]}

    class << self
      extend T::Sig

      sig {params(owner: Person::Id, name: String, description: T.nilable(String)).returns(T.attached_class)}
      def create(owner, name, description = nil)
        new(Id.create, name, owner, description, [])
      end

      sig {params(id: Id, name: String, description: T.nilable(String), team: Teams).returns(T.attached_class)}
      def from_repository(id, name, description, team)
        new(id, name, description, team)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(String)}
    attr_reader :name

    sig {returns(Person::Id)}
    attr_reader :owner

    sig {returns(T.nilable(String))}
    attr_reader :description

    sig {returns(Teams)}
    attr_reader :teams

    sig {params(id: Id, name: String, owner: Person::Id, description: T.nilable(String), teams: Teams).void}
    def initialize(id, name, owner, description, teams)
      @id = id
      @name = name
      @owner = owner
      @description = description
      @teams = teams
    end
    private_class_method :new

    sig {params(team: Team::Id).void}
    def assign_team(team)
      @teams << team
    end
  end
end
