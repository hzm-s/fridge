# typed: strict
require 'sorbet-runtime'

module Pbi
  module Status
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(pbi: Item).returns(Status)}
    def update_by(pbi); end

    sig {abstract.returns(String)}
    def to_s; end
  end
end
