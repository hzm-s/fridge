# typed: strict
require 'sorbet-runtime'

module Plan
  class Plan
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id).returns(T.attached_class)}
      def create(product_id)
        new(product_id, [Release.create('Minimum')])
      end
    end

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {params(product_id: Product::Id, releases: T::Array[Release]).void}
    def initialize(product_id, releases)
      @product_id = product_id
      @releases = releases.map { |r| [r.title, r] }.to_h
    end

    def release(title)
      @releases[title]
    end
  end
end
