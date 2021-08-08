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

        sig {override.params(roles: Team::RoleSet).returns(T::Boolean)}
        def can_accept?(roles)
          Activity.allow?(:accept_task, [roles])
        end

        sig {override.params(criteria: AcceptanceCriteria).returns(T::Boolean)}
        def satisfied?(criteria)
          return true if criteria.empty?

          criteria.satisfied?
        end

        sig {override.returns(T::Boolean)}
        def must_have_acceptance_criteria?
          false
        end

        sig {override.returns(T::Boolean)}
        def update_by_preparation?
          false
        end

        sig {override.returns(Symbol)}
        def accept_issue_activity
          :accept_task
        end

        sig {override.returns(String)}
        def to_s
          'task'
        end
      end
    end
  end
end
