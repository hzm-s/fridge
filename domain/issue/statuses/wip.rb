# typed: strict
require 'sorbet-runtime'

module Issue
  module Statuses
    module Wip
      class << self
        extend T::Sig
        include Status

        sig {override.returns(Activity::Set)}
        def available_activities
          Activity::Set.from_symbols([
            :prepare_acceptance_criteria,
            :revert_issue_from_sprint,
            :accept_feature,
            :accept_task,
          ])
        end

        sig {override.params(type: Type, criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
        def update_by_preparation(type, criteria, size)
          self
        end

        sig {override.returns(Status)}
        def assign_to_sprint
          raise CanNotAssignToSprint
        end

        sig {override.returns(Status)}
        def revert_from_sprint
          Ready
        end

        sig {override.returns(String)}
        def to_s
          'wip'
        end
      end
    end
  end
end
