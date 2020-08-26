# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(title: String).returns(T.attached_class)}
      def create(title)
        new(title, [])
      end
    end

    sig {returns(String)}
    attr_reader :title

    sig {returns(T::Array[Feature::Id])}
    attr_reader :items

    sig {params(title: String, items: T::Array[Feature::Id]).void}
    def initialize(title, items)
      @title = title
      @items = items
    end
  end
end
