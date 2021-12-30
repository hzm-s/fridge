# typed: strict
require 'sorbet-runtime'

module Acceptance
  class Acceptance
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(pbi_id: Pbi::Id, criteria: Pbi::AcceptanceCriteria).returns(T.attached_class)}
      def prepare(pbi_id, criteria)
        new(pbi_id, Statuses::NotAccepted, criteria, Set.new)
      end
    end

    sig {returns(Pbi::Id)}
    attr_reader :pbi_id

    sig {returns(Statuses)}
    attr_reader :status

    sig {returns(Pbi::AcceptanceCriteria)}
    attr_reader :criteria

    sig {params(pbi_id: Pbi::Id, status: Statuses, criteria: Pbi::AcceptanceCriteria, satisfied_criterion_numbers: T::Set[Integer]).void}
    def initialize(pbi_id, status, criteria, satisfied_criterion_numbers)
      @pbi_id = pbi_id
      @status = status
      @criteria = criteria
      @satisfied_criterion_numbers = satisfied_criterion_numbers
    end

    sig {params(criterion_number: Integer).void}
    def satisfy(criterion_number)
      @satisfied_criterion_numbers << criterion_number
      @status = @status.update(@criteria, @satisfied_criterion_numbers)
    end

    sig {params(criterion_number: Integer).void}
    def dissatisfy(criterion_number)
    end
  end
end
