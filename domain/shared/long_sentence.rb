# typed: strict
require 'sorbet-runtime'
require 'shared/length_limited_string'

module Shared
  class LongSentence < LengthLimitedString
    extend T::Sig

    private

    sig {params(content: String).void}
    def validate_content(content)
      raise InvalidLongSentence unless (3..500).include?(content.size)
    end
  end
end
