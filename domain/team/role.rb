# typed: strict
require 'sorbet-runtime'

module Team
  class Role < T::Enum
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(str: String).returns(T.attached_class)}
      def from_string(str)
        deserialize(str)
      rescue KeyError => e
        raise InvalidRole
      end
    end

    enums do
      ProductOwner = new('product_owner')
      Developer = new('developer')
      ScrumMaster = new('scrum_master')
    end
    
    sig {returns(Activity::Set)}
    def available_activities
      Activity::Set.from_symbols([:remove_issue, :update_plan, :assign_issue_to_sprint])
    end

    sig {returns(T::Boolean)}
    def can_estimate_issue?
      self == Developer
    end

    sig {returns(T::Boolean)}
    def can_update_release_plan?
      [ProductOwner, ScrumMaster].include?(self)
    end

    sig {returns(String)}
    def to_s
      serialize
    end
  end
end
