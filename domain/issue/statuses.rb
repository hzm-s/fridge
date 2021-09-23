# typed: strict
require 'sorbet-runtime'
require 'issue/status'
require 'issue/statuses/preparation'
require 'issue/statuses/ready'
require 'issue/statuses/wip'

module Issue
  module Statuses
    class << self
      extend T::Sig

      MAP = T.let({
        'preparation' => Preparation,
        'ready' => Ready,
        'wip' => Wip,
      }, T::Hash[String, Status])

      sig {params(str: String).returns(Status)}
      def from_string(str)
        raise ArgumentError unless MAP.key?(str)

        if str == 'wip'
          MAP[str].new
        else
          T.cast(MAP[str], Status)
        end
      end

      sig {returns(T::Array[Status])}
      def all
        MAP.values
      end
    end
  end
end
