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
          Pbi::StoryPoint.unknown
        )
      end

      sig {params(id: Pbi::ItemId, product_id: Product::ProductId, content: Pbi::Content, size: Pbi::StoryPoint).returns(T.attached_class)}
      def from_repository(id, product_id, content, size)
        new(id, product_id, content, size)
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

    sig {params(id: Pbi::ItemId, product_id: Product::ProductId, content: Pbi::Content, point: Pbi::StoryPoint).void}
    def initialize(id, product_id, content, point)
      @id = id
      @product_id = product_id
      @content = content
      @size = point
    end
    private_class_method :new

    sig {params(point: Pbi::StoryPoint).void}
    def estimate_size(point)
      @size = point
    end

    sig {returns(Pbi::Status)}
    def status
      Pbi::Status::Preparation
    end
  end
end
