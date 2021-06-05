# typed: false
module TaskQuery
  class << self
    def call(issue_id, number)
      Dao::Task.joins(:work)
        .find_by(dao_works: { dao_issue_id: issue_id }, number: number)
        .then { |dao| TaskStruct.new(dao.work.dao_issue_id, dao) }
    end
  end
end
