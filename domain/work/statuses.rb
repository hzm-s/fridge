# typed: strict
require 'sorbet-runtime'
require 'work/status'
require 'work/statuses/not_accepted'
require 'work/statuses/acceptable'
require 'work/statuses/accepted'

module Work
  module Statuses
    class << self
      extend T::Sig

      MAP = T.let({
        'not_accepted' => NotAccepted,
        'acceptable' => Acceptable,
        'accepted' => Accepted,
      }, T::Hash[String, Status])

      sig {params(str: String).returns(Status)}
      def from_string(str)
        raise ArgumentError unless MAP.key?(str)

        T.cast(MAP[str], Status)
      end

      sig {params(criteria: Issue::AcceptanceCriteria).returns(Status)}
      def initial(criteria)
        return Acceptable if criteria.empty?

        NotAccepted
      end
    end
  end
end
