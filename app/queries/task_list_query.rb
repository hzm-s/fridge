# typed: false
module TaskListQuery
  class << self
    def call(pbi_id)
      sbi = Dao::Sbi.eager_load(:tasks).find_by(dao_pbi_id: pbi_id)
      sbi.tasks.map { |t| TaskStruct.new(sbi.dao_pbi_id, t) }
    end
  end
end
