# typed: strict
require 'sorbet-runtime'

module Issue
  module Statuses
    module Ready
      class << self
        extend T::Sig
        include Status

        sig {override.returns(T::Boolean)}
        def can_remove?
          true
        end

        sig {override.returns(T::Boolean)}
        def can_estimate?
          true
        end

        sig {override.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
        def update_by_preparation(criteria, size)
          if Preparation.update_by_preparation(criteria, size) == self
            self
          else
            Preparation
          end
        end

        sig {override.returns(Status)}
        def assign_to_sprint
          Wip
        end

        sig {override.returns(String)}
        def to_s
          'ready'
        end
      end
    end
  end
end
