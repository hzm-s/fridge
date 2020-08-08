# typed: strict
require 'sorbet-runtime'

module Pbi
  class Item
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id, content: Content).returns(T.attached_class)}
      def create(product_id, content)
        new(
          Id.create,
          product_id,
          Statuses::Preparation,
          content,
          StoryPoint.unknown,
          AcceptanceCriteria.new([])
        )
      end

      sig {params(
        id: Id,
        product_id: Product::Id,
        status: Status,
        content: Content,
        size: StoryPoint,
        acceptance_criteria: AcceptanceCriteria
      ).returns(T.attached_class)}
      def from_repository(id, product_id, status, content, size, acceptance_criteria)
        new(id, product_id, status, content, size, acceptance_criteria)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(Status)}
    attr_reader :status

    sig {returns(Content)}
    attr_reader :content

    sig {returns(StoryPoint)}
    attr_reader :size

    sig {returns(AcceptanceCriteria)}
    attr_reader :acceptance_criteria

    sig {params(
      id: Id,
      product_id: Product::Id,
      status: Status,
      content: Content,
      point: StoryPoint,
      acceptance_criteria: AcceptanceCriteria
    ).void}
    def initialize(id, product_id, status, content, point, acceptance_criteria)
      @id = id
      @product_id = product_id
      @status = status
      @content = content
      @size = point
      @acceptance_criteria = acceptance_criteria
    end
    private_class_method :new

    sig {params(content: Content).void}
    def update_content(content)
      @content = content
    end

    sig {params(criteria: AcceptanceCriteria).void}
    def update_acceptance_criteria(criteria)
      @acceptance_criteria = criteria
      update_status_by_prepartion
    end

    sig {params(point: StoryPoint).void}
    def estimate_size(point)
      return unless @status.can_estimate_size?

      @size = point
      update_status_by_prepartion
    end

    sig {void}
    def assign
      @status = @status.update_to_todo
    end

    sig {void}
    def cancel_assignment
      @status = @status.update_by_cancel_assignment
    end

    private

    sig {returns(Status)}
    def update_status_by_prepartion
      @status = @status.update_by_prepartion(acceptance_criteria, size)
    end
  end
end
