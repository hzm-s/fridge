# typed: strict
require 'sorbet-runtime'

module Work
  module Statuses
    class Acceptable < Base
      extend T::Sig

      sig {override.params(acceptance: Acceptance).returns(Status)}
      def update_by_acceptance(acceptance)
        return self if acceptance.all_satisfied?

        NotAccepted.new(issue_type)
      end

      sig {override.returns(String)}
      def to_s
        'acceptable'
      end
    end
  end
end
