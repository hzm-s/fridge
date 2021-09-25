# typed: false
class IssueStruct < SimpleDelegator
  attr_reader :product_id, :type, :status

  def initialize(dao)
    super(dao)

    @product_id = dao.dao_product_id
    @criteria = dao.criteria.map.with_index(1) { |c, n| AcceptanceCriterionStruct.new(c, n) }.sort_by(&:number)
    @type = Issue::Types.from_string(dao.issue_type)
    @status = Issue::Statuses.from_string(dao.status)
  end

  def criteria
    @criteria
  end

  def must_have_acceptance_criteria?
    type.must_have_acceptance_criteria?
  end

  class AcceptanceCriterionStruct < SimpleDelegator
    attr_reader :number

    def initialize(criterion, number)
      super(criterion)

      @number = number
    end

    def issue_id
      dao_issue_id
    end
  end
end
