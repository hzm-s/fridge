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
          Activity::Set.from_symbols([])
        end

        sig {override.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
        def update_by_preparation(criteria, size)
          self
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
          'accepted'
        end
      end
    end
  end
end
