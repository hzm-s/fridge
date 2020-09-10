# typed: strict
require 'sorbet-runtime'

module Requirement
  class Requirement
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(kind: Kind, description: String).returns(T.attached_class)}
      def create(kind, description)
        new(
          Id.create,
          kind,
          description
        )
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Kind)}
    attr_reader :kind

    sig {returns(String)}
    attr_reader :description

    def initialize(id, kind, description)
      @id = id
      @kind = kind
      @description = description
    end
    private_class_method :new
  end
end
