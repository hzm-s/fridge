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

        sig {override.params(type: Type, criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
        def update_by_prepartion(type, criteria, size)
          self
        end

        sig {override.returns(String)}
        def to_s
          'wip'
        end
      end
    end
  end
end
