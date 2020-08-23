# typed: strict
require 'sorbet-runtime'

module Feature
  class Feature
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id, description: String).returns(T.attached_class)}
      def create(product_id, description)
        new(
          Id.create,
          product_id,
          description
        )
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(String)}
    attr_reader :description

    sig {returns(AcceptanceCriteria)}
    attr_reader :acceptance_criteria

    sig {params(id: Id, product_id: Product::Id, description: String).void}
    def initialize(id, product_id, description)
      @id = id
      @product_id = product_id
      @description = description
      @acceptance_criteria = T.let([], AcceptanceCriteria)
    end

    sig {params(criterion: AcceptanceCriterion).void}
    def add_acceptance_criterion(criterion)
      @acceptance_criteria << criterion
    end

    sig {params(criterion: AcceptanceCriterion).void}
    def remove_acceptance_criterion(criterion)
      @acceptance_criteria.delete(criterion)
    end
  end
end
