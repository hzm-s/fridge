# typed: strict
require 'sorbet-runtime'

module Shared
  class ShortSentence
    extend T::Sig

    sig {params(content: String).void}
    def initialize(content)
      raise SentenceIsTooShort if content.size < 2
      raise SentenceIsTooLong if content.size > 100

      @content = content
    end

    sig {returns(String)}
    def to_s
      @content
    end
  end
end
