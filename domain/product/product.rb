# typed: strict
require 'sorbet-runtime'

module Product
  class Product
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(name: Shared::Name, description: T.nilable(String)).returns(T.attached_class)}
      def create(name, description = nil)
        new(Id.create, name, description)
      end

      sig {params(id: Id, name: Shared::Name, description: T.nilable(String)).returns(T.attached_class)}
      def from_repository(id, name, description)
        new(id, name, description)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Shared::Name)}
    attr_reader :name

    sig {returns(T.nilable(String))}
    attr_reader :description

    sig {params(id: Id, name: Shared::Name, description: T.nilable(String)).void}
    def initialize(id, name, description)
      @id = id
      @name = name
      @description = description
    end
    private_class_method :new
  end
end
