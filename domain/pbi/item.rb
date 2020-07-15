# typed: strict
require 'sorbet-runtime'

module Pbi
  class Item
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::ProductId, content: Content).returns(T.attached_class)}
      def create(product_id, content)
        new(
          Pbi::Id.create,
          product_id,
          content,
          Pbi::StoryPoint.unknown,
          AcceptanceCriteria.create
        )
      end

      sig {params(
        id: Id,
        product_id: Product::ProductId,
        content: Content,
        size: StoryPoint,
        acceptance_criteria: AcceptanceCriteria
      ).returns(T.attached_class)}
      def from_repository(id, product_id, content, size, acceptance_criteria)
        new(id, product_id, content, size, acceptance_criteria)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Product::ProductId)}
    attr_reader :product_id

    sig {returns(Content)}
    attr_reader :content

    sig {returns(StoryPoint)}
    attr_reader :size

    sig {returns(AcceptanceCriteria)}
    attr_reader :acceptance_criteria

    sig {params(
      id: Id,
      product_id: Product::ProductId,
      content: Content,
      point: StoryPoint,
      acceptance_criteria: AcceptanceCriteria
    ).void}
    def initialize(id, product_id, content, point, acceptance_criteria)
      @id = id
      @product_id = product_id
      @content = content
      @size = point
      @acceptance_criteria = acceptance_criteria
    end
    private_class_method :new

    sig {returns(Status)}
    def status
      Status::Preparation
    end

    sig {params(content: String).void}
    def add_acceptance_criterion(content)
      @acceptance_criteria.add(content)
    end

    sig {params(no: Integer).void}
    def remove_acceptance_criterion(no)
      @acceptance_criteria.remove(no)
    end

    sig {params(point: StoryPoint).void}
    def estimate_size(point)
      @size = point
    end

    sig {params(content: Content).void}
    def update_content(content)
      @content = content
    end
  end
end
