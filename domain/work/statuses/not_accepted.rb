# typed: strict
require 'sorbet-runtime'

module Work
  module Statuses
    class NotAccepted < Base
      extend T::Sig
      include Status

      sig {override.returns(String)}
      def to_s
        'not_accepted'
      end
    end
  end
end
