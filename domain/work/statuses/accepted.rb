# typed: strict
require 'sorbet-runtime'

module Work
  module Statuses
    class Accepted < Base
      extend T::Sig

      sig {override.returns(String)}
      def to_s
        'acceptable'
      end
    end
  end
end
