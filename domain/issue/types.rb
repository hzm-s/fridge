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
        T.must(TYPES[str])
      end
    end
  end
end
