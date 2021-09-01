# typed: strict
module Shared
  class SentenceIsTooShort < ArgumentError; end
  class SentenceIsTooLong < ArgumentError; end

  autoload :Identifier, 'shared/identifier'
  autoload :ShortSentence, 'shared/short_sentence'
  autoload :LongSentence, 'shared/long_sentence'
end
