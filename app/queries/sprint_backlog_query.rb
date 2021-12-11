# typed: false
module SprintBacklogQuery
  class << self
    def call(sprint_id)
      pbi_ids = Dao::Sprint.find_by(id: sprint_id).items
      sbis = Dao::Sbi.where(dao_pbi_id: pbi_ids)

      pbi_ids
        .map { |pbi_id| sbis.find { |sbi| sbi.dao_pbi_id == pbi_id } }
        .map { |sbi| SprintBacklogItemStruct.new(sbi, PbiStruct.new(sbi.pbi)) }
        .then { |items| SprintBacklogStruct.new(items: items) }
    end
  end

  class SprintBacklogItemStruct < SimpleDelegator
    attr_reader :pbi

    delegate :accepted?, to: :status
    delegate :id, to: :pbi, prefix: true

    def initialize(dao_sbi, pbi)
      super(dao_sbi)

      @pbi = pbi
    end

    def status
      @__status ||= read_status
    end

    def tasks
      @__tasks ||= super.map { |t| TaskStruct.new(pbi.id, t) }.sort_by(&:number)
    end

    def acceptance_activities
      pbi.type.acceptance_activities
    end
  end

  class SprintBacklogStruct < T::Struct
    prop :items, T::Array[SprintBacklogItemStruct]
  end
end
