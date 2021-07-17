# typed: strict
require 'sorbet-runtime'

module Issue
  class AcceptanceCriterion
    extend T::Sig

    class << self
      extend T::Sig 

      sig {params(number: Integer, content: String).returns(T.attached_class)}
      def create(number, content)
        new(number, content)
      end

      sig {params(number: Integer, content: String).returns(T.attached_class)}
      def from_repository(number, content)
        new(number, content)
      end
    end

    sig {returns(Integer)}
    attr_reader :number

    sig {returns(String)}
    attr_reader :content

    sig {params(number: Integer, content: String).void}
    def initialize(number, content)
      @number = number
      @content = content
    end
    private_class_method :new

    sig {params(content: String).void}
    def modify_content(content)
      @content = content
    end

    sig {params(other: AcceptanceCriterion).returns(T::Boolean)}
    def ==(other)
      self.number == other.number &&
        self.content == other.content
    end
  end
end
