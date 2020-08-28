# typed: strict
require 'sorbet-runtime'

module Pbi
  class AcceptanceCriterion
    extend T::Sig

    sig {params(content: String).void}
    def initialize(content)
      raise InvalidAcceptanceCriterion unless content.size >= 3 && content.size < 100

      @content = content
    end

    sig {returns(String)}
    def to_s
      @content
    end

    sig {params(other: AcceptanceCriterion).returns(T::Boolean)}
    def ==(other)
      self.to_s == other.to_s
    end
  end
end
