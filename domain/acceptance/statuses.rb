# typed: strict
require 'sorbet-runtime'

module Acceptance
  class Statuses < T::Enum
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(str: String).returns(T.attached_class)}
      def from_string(str)
        deserialize(str)
      end
    end

    enums do
      NotAccepted = new('not_accepted')
      Accepted = new('accepted')
    end

    sig {params(criterion: Pbi::AcceptanceCriteria, satisfied_criterion_numbers: T::Set[Integer]).returns(T.self_type)}
    def update(criterion, satisfied_criterion_numbers)
      if criterion.size == satisfied_criterion_numbers.size
        Accepted
      else
        NotAccepted
      end
    end
  end
end
