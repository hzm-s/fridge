# typed: strict
require 'sorbet-runtime'

module Issue
  module Statuses
    autoload :Preparation, 'issue/statuses/preparation'
    autoload :Ready, 'issue/statuses/ready'
    autoload :Wip, 'issue/statuses/wip'

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
        T.cast(MAP[str], Status)
      end

      sig {returns(T::Array[Status])}
      def all
        MAP.values
      end
    end
  end
end
