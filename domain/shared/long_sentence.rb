# typed: strict
require 'sorbet-runtime'
require 'shared/sentence'

module Shared
  class LongSentence < Sentence
    extend T::Sig

    private

    sig {params(content: String).void}
    def validate_content(content)
      raise SentenceIsTooShort if content.size < 3
      raise SentenceIsTooLong if content.size > 500
    end
  end
end
