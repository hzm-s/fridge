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

      sig {returns(T::Array[Role])}
      def all
        [ProductOwner, ScrumMaster, Developer]
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
          [
            :prepare_acceptance_criteria,
            :remove_pbi,
            :update_plan,
            :assign_pbi_to_sprint,
            :revert_pbi_from_sprint,
            :update_sprint_pbis,
            :update_feature_acceptance,
            :update_task_acceptance,
            :accept_feature,
            :accept_task,
            :mark_pbi_as_done,
          ]
        when ScrumMaster
          [
            :prepare_acceptance_criteria,
            :remove_pbi,
            :update_plan,
            :assign_pbi_to_sprint,
            :revert_pbi_from_sprint,
            :update_sprint_pbis,
          ]
        when Developer
          [
            :prepare_acceptance_criteria,
            :estimate_pbi,
            :update_task_acceptance,
            :accept_task,
          ]
        end
      Activity::Set.from_symbols(activities)
    end

    sig {returns(String)}
    def to_s
      serialize
    end
  end
end
