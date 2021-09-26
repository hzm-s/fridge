# typed: strict
require 'sorbet-runtime'

module Issue
  module Types
    module Task
      class << self
        extend T::Sig
        include Type

        sig {override.returns(Status)}
        def initial_status
          Statuses::Ready
        end

        sig {override.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(T::Boolean)}
        def prepared?(criteria, size)
          true
        end

        sig {override.returns(T::Boolean)}
        def must_have_acceptance_criteria?
          false
        end

        sig {override.returns(Activity::Set)}
        def acceptance_activities
          Activity::Set.from_symbols([:accept_task])
        end

        sig {override.returns(String)}
        def to_s
          'task'
        end
      end
    end
  end
end
