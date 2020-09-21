# typed: strict
require 'sorbet-runtime'
require 'issue/type'
require 'issue/types/feature'
require 'issue/types/task'

module Issue
  module Types
    class << self
      extend T::Sig

      TYPES = T.let({
        'feature' => Feature,
        'task' => Task,
      }, T::Hash[String, Type])

      sig {params(str: String).returns(Type)}
      def from_string(str)
        raise InvalidType unless TYPES.key?(str)
        T.must(TYPES[str])
      end

      sig {returns(T::Array[Type])}
      def all
        TYPES.values
      end
    end
  end
end
