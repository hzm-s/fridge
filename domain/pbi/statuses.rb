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
        MAP[str]
      end
    end
  end
end
