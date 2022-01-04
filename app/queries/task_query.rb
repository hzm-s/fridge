# typed: false
module TaskQuery
  class << self
    def call(pbi_id, number)
      Dao::Task.joins(:work)
        .find_by(dao_works: { dao_pbi_id: pbi_id }, number: number)
        .then { |dao| TaskStruct.new(dao.work.dao_pbi_id, dao) }
    end
  end
end
