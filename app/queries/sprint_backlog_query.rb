# typed: false
module SprintBacklogQuery
  class << self
    def call(sprint_id)
      assigned_issues =
        Dao::AssignedIssue
          .eager_load(issue: [:criteria, { work: :tasks }])
          .where(dao_sprint_id: sprint_id)
          .order('dao_assigned_issues.id, dao_acceptance_criteria.id')

      issues = assigned_issues.map do |ai|
        SprintBacklogItemStruct.new(
          IssueStruct.new(ai.issue),
          ai.issue.work.read_status,
          Array(ai.issue.work&.tasks),
        )
      end

      SprintBacklogStruct.new(issues: issues)
    end
  end

  class SprintBacklogItemStruct < SimpleDelegator
    attr_reader :work_status, :tasks

    def initialize(issue_struct, work_status, tasks)
      super(issue_struct)

      @work_status = work_status
      @tasks = tasks.map { |t| TaskStruct.new(issue_struct.id, t) }.sort_by(&:number)
    end

    def acceptance_activities
      type.acceptance_activities
    end
  end

  class SprintBacklogStruct < T::Struct
    prop :issues, T::Array[SprintBacklogItemStruct]
  end
end
