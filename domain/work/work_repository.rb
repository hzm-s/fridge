# typed: strict
require 'sorbet-runtime'

module Work
  module WorkRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(pbi_id: Pbi::Id).returns(Work)}
    def find_by_pbi_id(pbi_id); end

    sig {abstract.params(work: Work).void}
    def store(work); end
  end
end
