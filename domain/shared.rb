# typed: strict
module Shared
  class InvalidShortSentence < ArgumentError; end
  class InvalidLongSentence < ArgumentError; end

  autoload :Identifier, 'shared/identifier'
  autoload :ShortSentence, 'shared/short_sentence'
  autoload :LongSentence, 'shared/long_sentence'
end
