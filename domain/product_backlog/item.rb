# typed: strict
require 'sorbet-runtime'

module ProductBacklog
  class Item
    extend T::Sig

    sig {returns(Feature::Id)}
    attr_reader :id

    sig {params(feature_id: Feature::Id).void}
    def initialize(feature_id)
      @id = feature_id
    end

    sig {params(other: Item).returns(T::Boolean)}
    def ==(other)
      self.id == other.id
    end
  end
end
