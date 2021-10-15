# typed: strict
require 'sorbet-runtime'

module Work
  module Statuses
    class Accepted
      class << self
        extend T::Sig
        include Status

        sig {override.params(acceptance: Acceptance).returns(Status)}
        def update_by_acceptance(acceptance)
          self
        end

        sig {returns(Status)}
        def accept
          self
        end

        sig {override.returns(Activity::Set)}
        def available_activities
          Activity::Set.new([])
        end

        def accepted?
          true
        end

        sig {override.returns(T::Boolean)}
        def can_accept?
          false
        end

        sig {override.returns(String)}
        def to_s
          'accepted'
        end
      end
    end
  end
end
