# typed: strict
require 'sorbet-runtime'
require 'shared/sentence'

module Shared
  class LongSentence < Sentence
    extend T::Sig

    private

    sig {params(content: String).void}
    def validate_content(content)
      raise InvalidLongSentence unless (3..500).include?(content.size)
    end
  end
end
