# typed: strict
require 'sorbet-runtime'

module Work
  module Statuses
    class NotAccepted
      class << self
        extend T::Sig
        include Status

        sig {override.params(acceptance: Acceptance).returns(Status)}
        def update_by_acceptance(acceptance)
          return self unless acceptance.all_satisfied?

          Acceptable
        end

        sig {override.returns(Status)}
        def accept
          self
        end

        sig {override.returns(Activity::Set)}
        def available_activities
          Activity::Set.from_symbols([:update_feature_acceptance, :update_task_acceptance])
        end

        sig {override.returns(T::Boolean)}
        def can_accept?
          false
        end

        sig {override.returns(String)}
        def to_s
          'not_accepted'
        end
      end
    end
  end
end
