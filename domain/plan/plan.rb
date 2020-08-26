# typed: strict
require 'sorbet-runtime'

module Plan
  class Plan
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id).returns(T.attached_class)}
      def create(product_id)
        new(product_id, [])
      end
    end

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(T::Array[Release])}
    attr_reader :releases

    sig {params(product_id: Product::Id, releases: T::Array[Release]).void}
    def initialize(product_id, releases)
      @product_id = product_id
      @releases = releases
    end
    private_class_method :new

    sig {params(release: Release).void}
    def add_release(release)
      @releases << release
    end

    sig {params(no: Integer).void}
    def remove_release(no)
      @releases.delete_at(no - 1)
    end

    sig {params(no: Integer, release: Release).void}
    def replace_release(no, release)
      @releases[no - 1] = release
    end

    sig {params(no: Integer).returns(Release)}
    def release(no)
      @releases[no - 1]
    end
  end
end