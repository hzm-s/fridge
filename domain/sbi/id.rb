# typed: strict
require 'sorbet-runtime'

module Sbi
  class Id < Shared::Identifier
    include Shared::Sortable
  end
end
