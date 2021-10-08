# typed: strict
require 'sorbet-runtime'

module Work
  module Statuses
    class Base
      extend T::Sig
      include Status

      sig {override.returns(Issue::Type)}
      attr_reader :issue_type

      sig {params(issue_type: Issue::Type).void}
      def initialize(issue_type)
        @issue_type = issue_type
      end

      sig {override.returns(Activity::Set)}
      def available_activities
        Activity::Set.new([@issue_type.acceptance_activity])
      end

      sig {params(other: Status).returns(T::Boolean)}
      def ==(other)
        self.to_s == other.to_s &&
          self.issue_type == other.issue_type
      end
    end
  end
end
