# typed: strict
require 'sorbet-runtime'

module Pbi
  class Content
    extend T::Sig

    sig {params(value: String).void}
    def initialize(value)
      raise InvalidContent unless (3..500).include?(value.size)
      @value = value
    end

    sig {returns(String)}
    def to_s
      @value
    end
  end
end
