# typed: strict
require 'sorbet-runtime'

module Work
  module Statuses
    module Acceptable
      class << self
        extend T::Sig
        include Status

        sig {override.params(acceptance: Acceptance).returns(Status)}
        def update_by_acceptance(acceptance)
          return self if acceptance.all_satisfied?

          NotAccepted
        end

        sig {override.returns(Status)}
        def accept
          Accepted
        end

        sig {override.returns(Activity::Set)}
        def available_activities
          Activity::Set.from_symbols([:accept_feature, :accept_task])
        end

        sig {override.returns(T::Boolean)}
        def accepted?
          false
        end

        sig {override.returns(T::Boolean)}
        def can_accept?
          true
        end

        sig {override.returns(String)}
        def to_s
          'acceptable'
        end
      end
    end
  end
end
