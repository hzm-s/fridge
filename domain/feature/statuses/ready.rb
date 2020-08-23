# typed: strict
require 'sorbet-runtime'

module Feature
  module Statuses
    module Ready
      class << self
        extend T::Sig
        include Status

        sig {override.returns(T::Boolean)}
        def can_assign?
          true
        end

        sig {override.returns(T::Boolean)}
        def can_cancel_assignment?
          false
        end

        sig {override.returns(T::Boolean)}
        def can_remove?
          true
        end

        sig {override.returns(T::Boolean)}
        def can_estimate_size?
          true
        end

        sig {override.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
        def update_by_prepartion(criteria, size)
          if Preparation.update_by_prepartion(criteria, size) == self
            self
          else
            Preparation
          end
        end

        sig {override.returns(Status)}
        def update_to_wip
          Wip
        end

        sig {override.returns(Status)}
        def update_by_cancel_assignment
          raise ProductBacklogItemIsNotAssigned
        end

        sig {override.returns(String)}
        def to_s
          'ready'
        end
      end
    end
  end
end