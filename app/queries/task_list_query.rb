# typed: false
module TaskListQuery
  class << self
    def call(issue_id)
      work = Dao::Work.eager_load(:tasks).find_by(dao_issue_id: issue_id)
      work.tasks.map { |t| TaskStruct.new(work.dao_issue_id, t) }
    end
  end
end
