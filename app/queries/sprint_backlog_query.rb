# typed: false
module SprintBacklogQuery
  class << self
    def call(sprint_id)
      assigned_issues =
        Dao::AssignedIssue
          .eager_load(issue: [:criteria, { work: :tasks }])
          .where(dao_sprint_id: sprint_id)

      issues = assigned_issues.map do |ai|
        SprintBacklogItemStruct.new(ai.issue)
      end

      SprintBacklogStruct.new(issues: issues)
    end
  end

  class SprintBacklogItemStruct < SimpleDelegator
    attr_reader :tasks

    def initialize(issue)
      super(issue)
      @tasks = build_tasks.sort_by(&:number)
    end

    private

    def build_tasks
      Array(work&.tasks).map { |t| TaskStruct.new(work.dao_issue_id, t) }
    end
  end

  class SprintBacklogStruct < T::Struct
    prop :issues, T::Array[SprintBacklogItemStruct]
  end
end
