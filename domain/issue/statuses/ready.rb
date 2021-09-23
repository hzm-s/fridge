# typed: strict
require 'sorbet-runtime'

module Issue
  module Statuses
    module Ready
      class << self
        extend T::Sig
        include Status

        sig {override.returns(Activity::Set)}
        def available_activities
          Activity::Set.from_symbols([:prepare_acceptance_criteria, :remove_issue, :estimate_issue, :assign_issue_to_sprint])
        end

        sig {override.params(type: Type, criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
        def update_by_preparation(type, criteria, size)
          return Preparation unless type.prepared?(criteria, size)

          self
        end

        sig {override.returns(Status)}
        def assign_to_sprint
          Wip.new
        end

        sig {override.returns(Status)}
        def revert_from_sprint
          raise CanNotRevertFromSprint
        end

        sig {override.returns(String)}
        def to_s
          'ready'
        end
      end
    end
  end
end
