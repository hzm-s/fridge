# typed: strict
require 'sorbet-runtime'

module Pbi
  class Item
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::ProductId, content: Pbi::Content).returns(T.attached_class)}
      def create(product_id, content)
        new(
          Pbi::ItemId.create,
          product_id,
          content,
          Pbi::StoryPoint.unknown,
          AcceptanceCriteria.create
        )
      end

      sig {params(
        id: Pbi::ItemId,
        product_id: Product::ProductId,
        content: Pbi::Content,
        size: Pbi::StoryPoint,
        acceptance_criteria: AcceptanceCriteria
      ).returns(T.attached_class)}
      def from_repository(id, product_id, content, size, acceptance_criteria)
        new(id, product_id, content, size, acceptance_criteria)
      end
    end

    sig {returns(Pbi::ItemId)}
    attr_reader :id

    sig {returns(Product::ProductId)}
    attr_reader :product_id

    sig {returns(Pbi::Content)}
    attr_reader :content

    sig {returns(Pbi::StoryPoint)}
    attr_reader :size

    sig {returns(AcceptanceCriteria)}
    attr_reader :acceptance_criteria

    sig {params(
      id: Pbi::ItemId,
      product_id: Product::ProductId,
      content: Pbi::Content,
      point: Pbi::StoryPoint,
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

    sig {returns(Pbi::Status)}
    def status
      Pbi::Status::Preparation
    end

    sig {params(content: String).void}
    def add_acceptance_criterion(content)
      @acceptance_criteria.add(content)
    end

    sig {params(no: Integer).void}
    def remove_acceptance_criterion(no)
      @acceptance_criteria.remove(no)
    end

    sig {params(point: Pbi::StoryPoint).void}
    def estimate_size(point)
      @size = point
    end
  end
end
