# typed: strict
require 'sorbet-runtime'

module Shared
  module Sortable
    extend T::Sig
    extend T::Helpers
    interface!
  end
end
