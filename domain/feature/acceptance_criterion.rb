# typed: strict
require 'sorbet-runtime'

module Feature
  class AcceptanceCriterion
    extend T::Sig

    sig {params(content: String).void}
    def initialize(content)
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
