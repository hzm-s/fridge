# typed: strict
require 'sorbet-runtime'
require 'issue/type'
require 'issue/types/feature'

module Issue
  module Types
    class << self
      extend T::Sig

      TYPES = {
        'feature' => Feature,
      }

      sig {params(str: String).returns(Type)}
      def from_string(str)
        TYPES[str]
      end
    end
  end
end
