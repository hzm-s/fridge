# typed: strict
require 'sorbet-runtime'

module Work
  module Statuses
    class Accepted < Base
      extend T::Sig

      sig {override.returns(Activity::Set)}
      def available_activities
        Activity::Set.new([])
      end

      sig {override.returns(T::Boolean)}
      def can_accept?
        false
      end

      sig {override.returns(String)}
      def to_s
        'accepted'
      end
    end
  end
end
