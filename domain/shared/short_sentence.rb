# typed: strict
require 'sorbet-runtime'
require 'shared/sentence'

module Shared
  class ShortSentence < Sentence
    extend T::Sig

    private

    sig {params(content: String).void}
    def validate_content(content)
      raise InvalidShortSentence unless (2..100).include?(content.size)
    end
  end
end
