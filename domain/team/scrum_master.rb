# typed: strict
require 'sorbet-runtime'

module Team
  class ScrumMaster
    extend T::Sig
    include Role

    sig {override.returns(T::Array[Symbol])}
    def available_actions_for_pbi
      [:reorder, :add, :update, :remove, :add_acceptance_criteria, :remove_acceptance_criteria]
    end
  end
end
