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
      raise InvalidAcceptanceCriterion unless content.size >= 3 && content.size < 100

      @number = number
      @content = content
    end
  end
end
