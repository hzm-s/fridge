# typed: strict
require 'sorbet-runtime'

module Work
  class Task
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

    sig {params(new_content: String).returns(T.self_type)}
    def modify(new_content)
      self.class.new(number, new_content)
    end
  end
end
