# typed: strict
module Plan
  class Plan
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id).returns(T.attached_class)}
      def create(product_id)
        new(product_id, [Release.create(1)])
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

    sig {void}
    def append_release
      @releases << Release.create(@releases.max.number + 1)
    end

    sig {params(release: Release).void}
    def update_release(release)
      index = @releases.find_index { |r| r.number == release.number }
      @releases[index] = release
    end

    sig {params(release_number: Integer).void}
    def remove_release(release_number)
      release = release_of(release_number)
      raise ReleaseIsNotEmpty unless release.can_remove?

      @releases.delete_if { |r| r.number == release.number }
    end

    sig {params(release_number: Integer).returns(Release)}
    def release_of(release_number)
      @releases.find { |r| r.number == release_number }.dup
    end
  end
end
