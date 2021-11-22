# typed: strict
require 'sorbet-runtime'

module Pbi
  class Statuses < T::Enum
    extend T::Sig
    include Activity::SetProvider

    class << self
      extend T::Sig

      sig {params(str: String).returns(T.attached_class)}
      def from_string(str)
        deserialize(str)
      end
    end

    enums do
      Preparation = new('preparation')
      Ready = new('ready')
      Wip = new('wip')
      Accepted = new('accepted')
      Done = new('done')
    end

    sig {params(type: Types, acceptance_criteria: AcceptanceCriteria, size: StoryPoint).returns(T.self_type)}
    def update_by_preparation(type, acceptance_criteria, size)
      case self
      when Preparation
        type.prepared?(acceptance_criteria, size) ? Ready : self
      when Ready
        type.prepared?(acceptance_criteria, size) ? self : Preparation
      when Wip
        self
      end
    end

    sig {override.returns(Activity::Set)}
    def available_activities
      activities =
        case self
        when Preparation
          [:prepare_acceptance_criteria, :remove_pbi, :estimate_pbi]
        when Ready
          [:prepare_acceptance_criteria, :remove_pbi, :estimate_pbi, :assign_pbi_to_sprint]
        when Wip
          [:revert_pbi_from_sprint]
        end
      Activity::Set.from_symbols(activities)
    end

    sig {returns(String)}
    def to_s
      serialize
    end
  end
end
