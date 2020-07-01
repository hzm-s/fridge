# typed: strict
require 'sorbet-runtime'

module Product
  class BacklogItemStatus < T::Enum
    enums do
      Preparation = new
    end
  end
end
