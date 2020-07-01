# typed: strict
require 'sorbet-runtime'

module Pbi
  class Status < T::Enum
    enums do
      Preparation = new
    end
  end
end
