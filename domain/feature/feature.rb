# typed: strict
require 'sorbet-runtime'

module Feature
  class Feature
    extend T::Sig

    AcceptanceCriteria = T.type_alias {T::Array[AcceptanceCriterion]}

    class << self
      extend T::Sig

      sig {params(description: String).returns(T.attached_class)}
      def create(description)
        new(Id.create, description)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(String)}
    attr_reader :description

    sig {returns(AcceptanceCriteria)}
    attr_reader :acceptance_criteria

    sig {params(id: Id, description: String).void}
    def initialize(id, description)
      @id = id
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
