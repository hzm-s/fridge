# typed: strict
require 'sorbet-runtime'
require 'shared/length_limited_string'

module Shared
  class Name < LengthLimitedString
    extend T::Sig

    private

    sig {params(content: String).void}
    def validate_content(content)
      raise InvalidName unless (1..50).include?(content.size)
    end
  end
end
