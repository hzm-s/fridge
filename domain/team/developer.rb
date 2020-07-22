# typed: strict
require 'sorbet-runtime'

module Team
  class Developer
    extend T::Sig
    include Role

    sig {override.returns(T::Array[Symbol])}
    def available_actions_for_pbi
      [:add, :update, :add_acceptance_criteria, :remove_acceptance_criteria]
    end
  end
end
