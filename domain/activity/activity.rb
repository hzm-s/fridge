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
      EstimateIssue = new('estimate_issue')
      RemoveIssue = new('remove_issue')
      UpdatePlan = new('update_plan')
      AssignIssueToSprint = new('assign_issue_to_sprint')
      RevertIssueFromSprint = new('revert_issue_from_sprint')
    end

    sig {params(set_providers: T::Array[SetProvider]).returns(T::Boolean)}
    def allow?(set_providers)
      sets = set_providers.map(&:available_activities)
      base = sets.shift
      sets.reduce(base) { |a, e| a & e }.include?(self)
    end
  end
end
