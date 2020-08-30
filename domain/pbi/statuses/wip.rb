# typed: strict
require 'sorbet-runtime'

module Pbi
  module Statuses
    module Wip
      class << self
        extend T::Sig
        include Status

        sig {override.returns(T::Boolean)}
        def can_start_development?
          false
        end

        sig {override.returns(T::Boolean)}
        def can_abort_development?
          true
        end

        sig {override.returns(T::Boolean)}
        def can_remove?
          false
        end

        sig {override.returns(T::Boolean)}
        def can_estimate?
          false
        end

        sig {override.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
        def update_by_prepartion(criteria, size)
          self
        end

        sig {override.returns(Status)}
        def update_to_wip
          raise CanNotStartDevelopment
        end

        sig {override.returns(Status)}
        def update_by_abort_development
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