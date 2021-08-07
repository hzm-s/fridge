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
      EstimateIssue = new('estimate_issue')
      RemoveIssue = new('remove_issue')
      UpdatePlan = new('update_plan')
      AssignIssueToSprint = new('assign_issue_to_sprint')
      RevertIssueFromSprint = new('revert_issue_from_sprint')
      UpdateSprintIssues = new('update_sprint_issues')
      StartTask = new('start_task')
      SuspendTask = new('suspend_task')
      ResumeTask = new('resume_task')
      CompleteTask = new('complete_task')
      UpdateFeatureAcceptance = new('update_feature_acceptance')
      UpdateTaskAcceptance = new('update_task_acceptance')
      AcceptFeature = new('accept_feature')
      AcceptTask = new('accept_task')
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
  end
end
