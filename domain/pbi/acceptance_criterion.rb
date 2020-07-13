# typed: strict
require 'sorbet-runtime'

module Pbi
  class AcceptanceCriterion
    extend T::Sig

    Serialized = T.type_alias {T::Hash[Symbol, T.any(Integer, String)]}

    class << self
      extend T::Sig

      sig {params(no: Integer, content: String).returns(T.attached_class)}
      def create(no, content)
        new(no, content)
      end
      alias_method :from_repository, :create
    end

    sig {returns(Integer)}
    attr_reader :no

    sig {returns(String)}
    attr_reader :content

    sig {params(no: Integer, content: String).void}
    def initialize(no, content)
      @no = no
      @content = content
    end
    private_class_method :new

    sig {returns(Serialized)}
    def to_h
      { no: @no, content: @content }
    end
  end
end
