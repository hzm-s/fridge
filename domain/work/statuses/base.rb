# typed: strict
require 'sorbet-runtime'

module Work
  module Statuses
    class Base
      extend T::Sig
      include Status

      sig {params(issue_type: Issue::Type).void}
      def initialize(issue_type)
        @issue_type = issue_type
      end

      sig {override.returns(Activity::Set)}
      def available_activities
        Activity::Set.new([@issue_type.acceptance_activity])
      end
    end
  end
end
