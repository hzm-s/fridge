# typed: false
module SprintBacklogQuery
  class << self
    def call(sprint_id)
      assigned_issues =
        Dao::AssignedIssue
          .eager_load(issue: [:criteria, { work: :tasks }])
          .where(dao_sprint_id: sprint_id)
          .order(:id)

      issues = assigned_issues.map do |ai|
        SprintBacklogItemStruct.new(
          IssueStruct.new(ai.issue),
          Array(ai.issue.work&.tasks),
        )
      end

      SprintBacklogStruct.new(issues: issues)
    end
  end

  class SprintBacklogItemStruct < SimpleDelegator
    attr_reader :tasks

    def initialize(issue_struct, tasks)
      super(issue_struct)
      @tasks = tasks.map { |t| TaskStruct.new(issue_struct.id, t) }.sort_by(&:number)
    end
  end

  class SprintBacklogStruct < T::Struct
    prop :issues, T::Array[SprintBacklogItemStruct]
  end
end
