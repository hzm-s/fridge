# typed: false
module SprintBacklogQuery
  class << self
    def call(sprint_id)
      pbi_ids = Dao::Sprint.find_by(id: sprint_id).items
      pbis = Dao::Pbi.preload(:criteria, { work: :tasks }).where(id: pbi_ids)

      pbi_ids
        .map { |pbi_id| pbis.find { |pbi| pbi.id == pbi_id } }
        .map { |pbi| SprintBacklogItemStruct.new(PbiStruct.new(pbi), pbi.work || Dao::Work.new) }
        .then { |items| SprintBacklogStruct.new(items: items) }
    end
  end

  class SprintBacklogItemStruct < SimpleDelegator
    attr_reader :pbi

    delegate :accepted?, to: :status, allow_nil: true
    delegate :id, to: :pbi, prefix: true

    def initialize(pbi, dao_work)
      super(dao_work)

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
