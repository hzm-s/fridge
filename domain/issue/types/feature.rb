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

        sig {override.params(roles: Team::RoleSet).returns(T::Boolean)}
        def can_update_acceptance?(roles)
          Activity.allow?(:update_feature_acceptance, [roles])
        end

        sig {override.params(roles: Team::RoleSet).returns(T::Boolean)}
        def can_accept?(roles)
          Activity.allow?(:accept_feature, [roles])
        end

        sig {override.params(criteria: AcceptanceCriteria).returns(T::Boolean)}
        def all_satisfied?(criteria)
          criteria.all_satisfied?
        end

        sig {override.returns(T::Boolean)}
        def must_have_acceptance_criteria?
          true
        end

        sig {override.returns(T::Boolean)}
        def update_by_preparation?
          true
        end

        sig {override.returns(String)}
        def to_s
          'feature'
        end
      end
    end
  end
end
