# typed: strict
require 'sorbet-runtime'

module Pbi
  class Status < T::Enum
    extend T::Sig

    class << self
      alias_method :from_string, :deserialize
    end

    enums do
      Preparation = new
    end

    alias_method :to_s, :serialize
  end
end
