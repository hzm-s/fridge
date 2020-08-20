# typed: strict
require 'sorbet-runtime'

module Team
  class Member
    extend T::Sig

    sig {returns(Person::Id)}
    attr_reader :person_id

    sig {returns(Role)}
    attr_reader :role

    sig {params(person_id: Person::Id, role: Role).void}
    def initialize(person_id, role)
      @person_id = person_id
      @role = role
    end

    sig {params(other: Member).returns(T::Boolean)}
    def ==(other)
      self.person_id == other.person_id &&
        self.role == other.role
    end
  end
end
