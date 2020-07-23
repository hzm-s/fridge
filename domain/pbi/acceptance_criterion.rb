# typed: strict
require 'sorbet-runtime'

module Pbi
  class AcceptanceCriterion
    extend T::Sig

    Serialized = T.type_alias {T::Hash[Symbol, T.any(Integer, String)]}

    sig {returns(Integer)}
    attr_reader :no

    sig {returns(String)}
    attr_reader :content

    sig {params(no: Integer, content: String).void}
    def initialize(no, content)
      @no = no
      @content = content
    end

    sig {returns(Serialized)}
    def to_h
      { no: @no, content: @content }
    end
  end
end
