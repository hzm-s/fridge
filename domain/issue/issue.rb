# typed: strict
require 'sorbet-runtime'

module Issue
  class Issue
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id, type: Type, description: Description).returns(T.attached_class)}
      def create(product_id, type, description)
        new(
          Id.create,
          product_id,
          type,
          Statuses::Preparation,
          description,
          StoryPoint.unknown,
          AcceptanceCriteria.new([]),
        )
      end

      sig {params(id: Id, product_id: Product::Id, type: Type, status: Status, description: Description, size: StoryPoint, acceptance_criteria: AcceptanceCriteria).returns(T.attached_class)}
      def from_repository(id, product_id, type, status, description, size, acceptance_criteria)
        new(id, product_id, type, status, description, size, acceptance_criteria)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(Type)}
    attr_reader :type

    sig {returns(Status)}
    attr_reader :status

    sig {returns(Description)}
    attr_reader :description

    sig {returns(StoryPoint)}
    attr_reader :size

    sig {returns(AcceptanceCriteria)}
    attr_reader :acceptance_criteria

    sig {params(
      id: Id,
      product_id: Product::Id,
      type: Type,
      status: Status,
      description: Description,
      size: StoryPoint,
      acceptance_criteria: AcceptanceCriteria
    ).void}
    def initialize(id, product_id, type, status, description, size, acceptance_criteria)
      @id = id
      @product_id = product_id
      @type = type
      @status = status
      @description = description
      @size = size
      @acceptance_criteria = acceptance_criteria
    end

    sig {params(description: Description).void}
    def modify_description(description)
      @description = description
    end

    sig {params(criteria: AcceptanceCriteria).void}
    def update_acceptance_criteria(criteria)
      @acceptance_criteria = criteria
      update_status_by_preparation
    end

    sig {params(size: StoryPoint).void}
    def estimate(size)
      return unless @status.can_estimate?

      @size = size
      update_status_by_preparation
    end

    private

    sig {returns(Status)}
    def update_status_by_preparation
      @status = @status.update_by_prepartion(acceptance_criteria, size)
    end
  end
end
