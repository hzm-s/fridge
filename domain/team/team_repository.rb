# typed: strict
require 'sorbet-runtime'

module Team
  module TeamRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(team: Team).void}
    def add(team); end

    sig {abstract.params(team: Team).void}
    def update(team); end
  end
end
