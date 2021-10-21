# typed: false
class IssueStruct < SimpleDelegator
  attr_reader :product_id, :type, :status

  def initialize(dao)
    super(dao)

    @product_id = dao.dao_product_id
    @criteria = AcceptanceCriterionStruct.create_list(id, dao.read_acceptance_criteria)
    @type = Issue::Types.from_string(dao.issue_type)
    @status = Issue::Statuses.from_string(dao.status)
  end

  def criteria
    @criteria
  end

  class AcceptanceCriterionStruct < T::Struct
    prop :issue_id, String
    prop :number, Integer
    prop :content, String

    class << self
      def create_list(issue_id, criteria)
        criteria.to_a_with_number.map do |n, c|
          new(
            issue_id: issue_id,
            number: n,
            content: c,
          )
        end
      end
    end
  end
end
