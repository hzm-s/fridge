# typed: strict
require 'sorbet-runtime'

module Issue
  module Statuses
    module Preparation
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

        sig {override.params(type: Type, criteria: AcceptanceCriteria, size: StoryPoint).returns(Status)}
        def update_by_prepartion(type, criteria, size)
          if criteria.size > 0 && size != StoryPoint.unknown
            Ready
          else
            self
          end
        end

        sig {override.returns(String)}
        def to_s
          'preparation'
        end
      end
    end
  end
end
