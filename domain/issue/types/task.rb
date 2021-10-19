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
          Statuses::Preparation
        end

        sig {override.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(T::Boolean)}
        def prepared?(criteria, size)
          true
        end

        sig {override.returns(T::Boolean)}
        def must_have_acceptance_criteria?
          false
        end

        sig {override.returns(T::Array[Activity::Activity])}
        def acceptance_activities
          [
            Activity::Activity.from_string('update_task_acceptance'),
            Activity::Activity.from_string('accept_task'),
          ]
        end

        sig {override.returns(String)}
        def to_s
          'task'
        end
      end
    end
  end
end
