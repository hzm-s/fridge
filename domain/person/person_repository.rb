# typed: strict
require 'sorbet-runtime'

module Person
  module PersonRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(id: Id).returns(Person)}
    def find_by_id(id); end

    sig {abstract.params(person: Person).void}
    def add(person); end
  end
end
