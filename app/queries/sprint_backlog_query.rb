# typed: false
module SprintBacklogQuery
  class << self
    def call(sprint_id)
      assigned_pbis =
        Dao::AssignedPbi
          .eager_load(pbi: [:criteria, { sbi: :tasks }])
          .where(dao_sprint_id: sprint_id)
          .order('dao_assigned_pbis.id, dao_acceptance_criteria.id')

      items = assigned_pbis.map do |ai|
        SprintBacklogItemStruct.new(
          ai.pbi.sbi,
          PbiStruct.new(ai.pbi),
        )
      end

      SprintBacklogStruct.new(items: items)
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
