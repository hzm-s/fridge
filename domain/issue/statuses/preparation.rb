# typed: strict
require 'sorbet-runtime'

module Issue
  module Statuses
    module Preparation
      class << self
        extend T::Sig
        include Status

        sig {override.returns(Activity::Set)}
        def available_activities
          Activity::Set.from_symbols([:prepare_acceptance_criteria, :remove_issue, :estimate_issue])
        end

        sig {override.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
        def update_by_preparation(criteria, size)
          if criteria.size > 0 && size != StoryPoint.unknown
            Ready
          else
            self
          end
        end

        sig {override.returns(Status)}
        def assign_to_sprint
          raise CanNotAssignToSprint
        end

        sig {override.returns(Status)}
        def revert_from_sprint
          raise CanNotRevertFromSprint
        end

        sig {override.params(criteria: AcceptanceCriteria).returns(Status)}
        def accept(criteria)
          self
        end

        sig {override.returns(String)}
        def to_s
          'preparation'
        end
      end
    end
  end
end
