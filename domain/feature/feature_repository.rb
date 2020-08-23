# typed: strict
require 'sorbet-runtime'

module Feature
  module FeatureRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(id: Id).returns(Feature)}
    def find_by_id(id); end

    sig {abstract.params(feature: Feature).void}
    def add(feature); end

    sig {abstract.params(feature: Feature).void}
    def update(feature); end

    sig {abstract.params(id: Id).void}
    def delete(id); end
  end
end
