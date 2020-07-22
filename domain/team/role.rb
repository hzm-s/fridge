# typed: strict
require 'sorbet-runtime'

module Team
  class Role < T::Enum
    extend T::Sig

    enums do
      ProductOwner = new(:po)
      Developer = new(:dev)
      ScrumMaster = new(:sm)
    end

    sig {returns(T::Array[Symbol])}
    def available_actions_for_pbi
      case self
      when ProductOwner
        [:reorder, :add, :update, :remove, :add_acceptance_criteria, :remove_acceptance_criteria]
      when Developer
        [:add, :update, :add_acceptance_criteria, :remove_acceptance_criteria]
      when ScrumMaster
        [:reorder, :add, :update, :remove, :add_acceptance_criteria, :remove_acceptance_criteria]
      else
        T.absurd(self)
      end
    end
  end
end
