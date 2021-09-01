# typed: strict
require 'sorbet-runtime'
require 'shared/sentence'

module Shared
  class ShortSentence < Sentence
    extend T::Sig

    private

    sig {params(content: String).void}
    def validate_content(content)
      raise SentenceIsTooShort if content.size < 2
      raise SentenceIsTooLong if content.size > 100
    end
  end
end
