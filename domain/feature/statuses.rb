# typed: strict
require 'sorbet-runtime'

module Feature
  module Statuses
    autoload :Preparation, 'feature/statuses/preparation'
    autoload :Ready, 'feature/statuses/ready'
    autoload :Wip, 'feature/statuses/wip'

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
