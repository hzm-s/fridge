# typed: strict
require 'sorbet-runtime'

module Issue
  class AcceptanceCriterion
    extend T::Sig

    sig {returns(Integer)}
    attr_reader :number

    sig {returns(String)}
    attr_reader :content

    sig {params(number: Integer, content: String).void}
    def initialize(number, content)
      @number = number
      @content = content
    end

    sig {params(other: AcceptanceCriterion).returns(T::Boolean)}
    def ==(other)
      self.number == other.number &&
        self.content == other.content
    end
  end
end
