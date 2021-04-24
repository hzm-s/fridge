# typed: strict
require 'sorbet-runtime'

module Activity
  class Activity < T::Enum
    extend T::Sig

    class << self
      extend T::Sig

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
    end

    sig {params(sets: T::Array[Set]).returns(T::Boolean)}
    def allow?(sets)
      base = sets.shift
      sets.reduce(base) { |a, e| a & e }.include?(self)
    end
  end
end
