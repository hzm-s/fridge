# typed: strict
require 'sorbet-runtime'

module Team
  class Member
    extend T::Sig

    sig {returns(Person::Id)}
    attr_reader :person_id

    sig {returns(RoleSet)}
    attr_reader :roles

    sig {params(person_id: Person::Id, roles: RoleSet).void}
    def initialize(person_id, roles)
      @person_id = person_id
      @roles = roles
    end

    sig {params(person: Person::Id).returns(T::Boolean)}
    def same_person?(person)
      @person_id == person
    end

    sig {params(role: Role).returns(T::Boolean)}
    def have_role?(role)
      @roles.include?(role)
    end

    sig {params(other: Member).returns(T::Boolean)}
    def ==(other)
      self.person_id == other.person_id &&
        self.roles == other.roles
    end
  end
end
