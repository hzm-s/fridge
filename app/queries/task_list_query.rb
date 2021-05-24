# typed: false
module TaskListQuery
  class << self
    def call(issue_id)
      Dao::Work.find_by(dao_issue_id: issue_id).tasks
    end
  end
end
