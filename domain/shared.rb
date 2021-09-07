# typed: strict
module Shared
  class InvalidName < ArgumentError; end
  class InvalidShortSentence < ArgumentError; end
  class InvalidLongSentence < ArgumentError; end

  autoload :Identifier, 'shared/identifier'
  autoload :Name, 'shared/name'
  autoload :ShortSentence, 'shared/short_sentence'
  autoload :LongSentence, 'shared/long_sentence'
end
