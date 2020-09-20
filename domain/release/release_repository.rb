# typed: strict
require 'sorbet-runtime'

module Release
  module ReleaseRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(id: Id).returns(Release)}
    def find_by_id(id); end

    sig {abstract.params(release: Release).void}
    def store(release); end

    sig {abstract.params(id: Id).void}
    def remove(id); end
  end
end
