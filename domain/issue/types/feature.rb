# typed: strict
require 'sorbet-runtime'

module Issue
  module Types
    module Feature
      class << self
        extend T::Sig
        include Type

        sig {override.returns(Status)}
        def initial_status
          Statuses::Preparation
        end

        sig {override.params(criteria: AcceptanceCriteria, size: StoryPoint).returns(T::Boolean)}
        def prepared?(criteria, size)
          !criteria.empty? && size != StoryPoint.unknown
        end

        sig {override.params(accepted: T::Boolean, criteria: AcceptanceCriteria).returns(T::Boolean)}
        def can_accept?(accepted, criteria)
          return false if accepted

          criteria.satisfied?
        end

        sig {override.returns(T::Boolean)}
        def must_have_acceptance_criteria?
          true
        end

        sig {override.returns(Symbol)}
        def accept_issue_activity
          :accept_feature
        end

        sig {override.returns(String)}
        def to_s
          'feature'
        end
      end
    end
  end
end
