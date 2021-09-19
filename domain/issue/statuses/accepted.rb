# typed: strict
require 'sorbet-runtime'

module Issue
  module Statuses
    class Accepted
      class << self
        extend T::Sig
        include Status

        sig {override.returns(Activity::Set)}
        def available_activities
          Activity::Set.from_symbols([:revert_issue_from_sprint])
        end

        sig {override.params(type: Type, criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
        def update_by_preparation(type, criteria, size)
          raise CanNotPrepare
        end

        sig {override.returns(Status)}
        def assign_to_sprint
          raise CanNotAssignToSprint
        end

        sig {override.returns(Status)}
        def revert_from_sprint
          Ready
        end

        sig {override.params(type: Type, criteria: AcceptanceCriteria).returns(Status)}
        def update_by_acceptance(type, criteria)
          self
        end

        sig {override.returns(String)}
        def to_s
          'accepted'
        end
      end
    end
  end
end
