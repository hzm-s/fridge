# typed: false
module TaskListQuery
  class << self
    def call(issue_id)
      work = Dao::Work.find_by(dao_issue_id: issue_id)
      work.tasks.map { |t| TaskStruct.new(work, t) }
    end
  end
end
