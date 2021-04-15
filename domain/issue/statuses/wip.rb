# typed: strict
require 'sorbet-runtime'

module Issue
  module Statuses
    module Wip
      class << self
        extend T::Sig
        include Status

        sig {override.returns(T::Boolean)}
        def can_remove?
          false
        end

        sig {override.returns(T::Boolean)}
        def can_estimate?
          false
        end

        sig {override.returns(T::Boolean)}
        def can_sprint_assign?
          false
        end

        sig {override.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
        def update_by_preparation(criteria, size)
          self
        end

        sig {override.returns(Status)}
        def assign_to_sprint
          raise CanNotAssignToSprint
        end

        sig {override.returns(String)}
        def to_s
          'wip'
        end
      end
    end
  end
end
