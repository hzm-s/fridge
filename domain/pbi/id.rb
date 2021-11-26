# typed: strict
require 'sorbet-runtime'

module Pbi
  class Id < Shared::Identifier
    include Shared::Sortable
  end
end
