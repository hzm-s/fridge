# typed: false
module TaskQuery
  class << self
    def call(pbi_id, number)
      Dao::Task.joins(:sbi)
        .find_by(dao_sbis: { dao_pbi_id: pbi_id }, number: number)
        .then { |dao| TaskStruct.new(dao.sbi.dao_pbi_id, dao) }
    end
  end
end
