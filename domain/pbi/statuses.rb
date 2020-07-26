# typed: strict
require 'sorbet-runtime'

module Pbi
  module Statuses
    class << self
      extend T::Sig

      MAP = T.let({
        'draft' => Draft,
        'preparation' => Preparation
      }, T::Hash[String, Status])

      sig {params(str: String).returns(Status)}
      def from_string(str)
        raise ArgumentError unless MAP.key?(str)
        T.cast(MAP[str], Status)
      end
    end
  end
end
