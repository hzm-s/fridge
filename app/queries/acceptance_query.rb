# typed: false
module AcceptanceQuery
  class << self
    def call(issue_id)
      issue = Dao::Issue.eager_load(:criteria, :work).find(issue_id)

      AcceptanceStruct.new(issue, issue.work.read_acceptance)
    end
  end

  class AcceptanceStruct < SimpleDelegator
    attr_reader :detail, :criteria

    def initialize(issue, detail)
      super(issue)

      @type = read_type
      @detail = detail
      @criteria = CriterionStruct.create_list(read_acceptance_criteria, detail)
    end

    def issue_id
      id
    end

    def issue_description
      description
    end

    def activity_name
      @type.acceptance_activity.to_s.to_sym
    end

    def can_accept?
      detail.status == Work::Status::Acceptable
    end
  end

  class CriterionStruct < T::Struct
    prop :number, Integer
    prop :content, String
    prop :is_satisfied, T::Boolean

    class << self
      def create_list(criteria, acceptance)
        criteria.to_a_with_number.map do |n, c|
          create(n, c, acceptance)
        end
      end

      def create(number, content, acceptance)
        new(
          number: number,
          content: content,
          is_satisfied: acceptance.satisfied?(number),
        )
      end
    end

    def satisfied?
      is_satisfied
    end
  end
end
