# typed: strict
require 'sorbet-runtime'

module Activity
  class Activity < T::Enum
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(sym: Symbol).returns(T.attached_class)}
      def from_symbol(sym)
        from_string(sym.to_s)
      end

      sig {params(str: String).returns(T.attached_class)}
      def from_string(str)
        deserialize(str)
      end
    end

    enums do
      PrepareAcceptanceCriteria = new('prepare_acceptance_criteria')
      EstimatePbi = new('estimate_pbi')
      RemovePbi = new('remove_pbi')
      UpdatePlan = new('update_plan')
      AssignPbiToSprint = new('assign_pbi_to_sprint')
      RevertPbiFromSprint = new('revert_pbi_from_sprint')
      UpdateSprintPbis = new('update_sprint_pbis')
      UpdataTask = new('update_task')
      StartTask = new('start_task')
      SuspendTask = new('suspend_task')
      ResumeTask = new('resume_task')
      CompleteTask = new('complete_task')
      UpdateFeatureAcceptance = new('update_feature_acceptance')
      UpdateTaskAcceptance = new('update_task_acceptance')
      AcceptFeature = new('accept_feature')
      AcceptTask = new('accept_task')
      MarkPbiAsDone = new('mark_pbi_as_done')
    end

    sig {params(set_providers: T::Array[SetProvider]).returns(T::Boolean)}
    def allow?(set_providers)
      sets = set_providers.map(&:available_activities)
      base = sets.shift
      sets.reduce(base) { |a, e| a & e }.include?(self)
    end

    sig {returns(String)}
    def to_s
      serialize
    end

    sig {returns(Symbol)}
    def to_sym
      to_s.to_sym
    end
  end
end
