# typed: strict
require 'sorbet-runtime'

module Work
  module Statuses
    class NotAccepted < Base
      extend T::Sig

      sig {override.params(acceptance: Acceptance).returns(Status)}
      def update_by_acceptance(acceptance)
        return self unless acceptance.all_satisfied?

        Acceptable.new(issue_type)
      end

      sig {override.returns(T::Boolean)}
      def can_accept?
        false
      end

      sig {override.returns(String)}
      def to_s
        'not_accepted'
      end
    end
  end
end
