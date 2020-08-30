# typed: strict
require 'sorbet-runtime'

module Person
  class Person
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(name: String, email: String).returns(T.attached_class)}
      def create(name, email)
        new(Id.create, email, name)
      end

      sig {params(id: Id, email: String, name: String).returns(T.attached_class)}
      def from_repository(id, email, name)
        new(id, email, name)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(String)}
    attr_reader :email

    sig {returns(String)}
    attr_reader :name

    sig {params(id: Id, email: String, name: String).void}
    def initialize(id, email, name)
      @id = id
      @email = email
      @name = name
    end
    private_class_method :new
  end
end
