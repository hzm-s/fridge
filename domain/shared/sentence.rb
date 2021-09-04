# typed: strict
require 'sorbet-runtime'

module Shared
  class Sentence
    extend T::Sig

    sig {params(content: String).void}
    def initialize(content)
      validate_content(content)

      @content = content
    end

    sig {returns(String)}
    def to_s
      @content
    end

    sig {returns(Integer)}
    def hash
      @content.hash
    end

    sig {params(other: T.nilable(Sentence)).returns(T::Boolean)}
    def eql?(other)
      self == other
    end

    sig {params(other: T.nilable(Sentence)).returns(T::Boolean)}
    def ==(other)
      return false unless other

      self.instance_of?(other.class) &&
        self.to_s == other.to_s
    end

    private

    sig {params(content: String).void}
    def validate_content(content)
      raise 'not implemented'
    end
  end
end
