# typed: false
module SprintBacklogQuery
  class << self
    def call(sprint_id)
      assigned_issues =
        Dao::AssignedIssue
          .eager_load(issue: :criteria)
          .where(dao_sprint_id: sprint_id)

      issues = assigned_issues.map do |ai|
        IssueStruct.new(ai.issue)
      end

      IssueListStruct.new(issues: issues)
    end
  end

  class IssueListStruct < T::Struct
    prop :issues, T::Array[::IssueStruct]
  end
end
