# typed: strict
require 'sorbet-runtime'

module Product
  class Product
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(owner: Person::Id, name: String, description: T.nilable(String)).returns(T.attached_class)}
      def create(owner, name, description = nil)
        new(Id.create, name, owner, description)
      end

      sig {params(id: Id, name: String, owner: Person::Id, description: T.nilable(String)).returns(T.attached_class)}
      def from_repository(id, name, owner, description)
        new(id, name, owner, description)
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

    sig {params(id: Id, name: String, owner: Person::Id, description: T.nilable(String)).void}
    def initialize(id, name, owner, description)
      @id = id
      @name = name
      @owner = owner
      @description = description
    end
    private_class_method :new
  end
end
