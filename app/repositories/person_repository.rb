# typed: false
require 'sorbet-runtime'

module PersonRepository
  module AR
    class << self
      extend T::Sig
      include Person::PersonRepository

      sig {override.params(id: Person::Id).returns(Person::Person)}
      def find_by_id(id)
        r = Dao::Person.find(id)
        Person::Person.from_repository(
          r.person_id_as_do,
          r.email,
          r.name
        )
      end

      sig {override.params(user: Person::Person).void}
      def add(user)
        Dao::Person.create!(
          id: user.id,
          email: user.email,
          name: user.name
        )
      rescue ActiveRecord::RecordNotUnique
        raise Person::EmailNotUnique
      end
    end
  end
end
