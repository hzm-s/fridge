# typed: false
module SprintBacklogQuery
  class << self
    def call(sprint_id)
      assigned_issues =
        Dao::AssignedIssue
          .eager_load(issue: [:criteria, { work: :tasks }])
          .where(dao_sprint_id: sprint_id)
          .order('dao_assigned_issues.id, dao_acceptance_criteria.id')

      items = assigned_issues.map do |ai|
        SprintBacklogItemStruct.new(
          ai.issue.work,
          IssueStruct.new(ai.issue),
        )
      end

      SprintBacklogStruct.new(items: items)
    end
  end

  class SprintBacklogItemStruct < SimpleDelegator
    attr_reader :issue

    delegate :accepted?, to: :status
    delegate :id, to: :issue, prefix: true

    def initialize(dao_work, issue)
      super(dao_work)

      @issue = issue
    end

    def status
      @__status ||= read_status
    end

    def tasks
      @__tasks ||= super.map { |t| TaskStruct.new(issue.id, t) }.sort_by(&:number)
    end

    def acceptance_activities
      issue.type.acceptance_activities
    end
  end

  class SprintBacklogStruct < T::Struct
    prop :items, T::Array[SprintBacklogItemStruct]
  end
end
