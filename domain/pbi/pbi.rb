# typed: strict
require 'sorbet-runtime'

module Pbi
  class Pbi
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id, type: Types, description: Shared::LongSentence).returns(T.attached_class)}
      def draft(product_id, type, description)
        new(Id.create, product_id, type, description, StoryPoint.unknown, AcceptanceCriteria.new)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(Types)}
    attr_reader :type

    sig {returns(Shared::LongSentence)}
    attr_reader :description

    sig {returns(StoryPoint)}
    attr_reader :size

    sig {returns(AcceptanceCriteria)}
    attr_reader :acceptance_criteria

    sig {params(
      id: Id,
      product_id: Product::Id,
      type: Types,
      description: Shared::LongSentence,
      size: StoryPoint,
      acceptance_criteria: AcceptanceCriteria
    ).void}
    def initialize(id, product_id, type, description, size, acceptance_criteria)
      @id = id
      @product_id = product_id
      @type = type
      @description = description
      @size = size
      @acceptance_criteria = acceptance_criteria
    end
    private_class_method :new
  end
end