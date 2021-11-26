# typed: strict
require 'active_support'
require 'active_support/core_ext/object/deep_dup'

module Shared
  class InvalidName < ArgumentError; end
  class InvalidShortSentence < ArgumentError; end
  class InvalidLongSentence < ArgumentError; end

  autoload :Identifier, 'shared/identifier'

  autoload :Sortable, 'shared/sortable'
  autoload :SortableList, 'shared/sortable_list'

  autoload :Name, 'shared/name'
  autoload :ShortSentence, 'shared/short_sentence'
  autoload :LongSentence, 'shared/long_sentence'
end
