# typed: strict
require 'sorbet-runtime'

module Team
  class Role < T::Enum
    extend T::Sig

    include Activity::SetProvider

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
    
    sig {override.returns(Activity::Set)}
    def available_activities
      activities =
        case self
        when ProductOwner
          [:remove_issue, :update_plan, :assign_issue_to_sprint, :revert_issue_from_sprint]
        when ScrumMaster
          [:remove_issue, :update_plan, :assign_issue_to_sprint, :revert_issue_from_sprint]
        when Developer
          [:estimate_issue]
        end
      Activity::Set.from_symbols(T.must(activities))
    end

    sig {returns(String)}
    def to_s
      serialize
    end
  end
end
