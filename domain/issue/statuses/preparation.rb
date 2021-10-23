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

        sig {override.params(type: Type, criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
        def update_by_preparation(type, criteria, size)
          return self unless type.prepared?(criteria, size)

          Ready
        end

        sig {override.returns(Status)}
        def assign_to_sprint
          raise CanNotAssignToSprint
        end

        sig {override.returns(Status)}
        def revert_from_sprint
          raise CanNotRevertFromSprint
        end

        sig {override.returns(Status)}
        def accept
          raise CanNotAccept
        end

        sig {override.returns(String)}
        def to_s
          'preparation'
        end
      end
    end
  end
end
