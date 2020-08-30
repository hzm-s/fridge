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

      sig {params(product_id: Product::Id, releases: T::Array[Release]).returns(T.attached_class)}
      def from_repository(product_id, releases)
        new(product_id, releases)
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
      raise CanNotRemoveRelease unless can_remove_release?
      raise CanNotRemoveRelease if release(no).items.any?
      @releases.delete_at(no - 1)
    end

    sig {params(no: Integer, release: Release).void}
    def replace_release(no, release)
      @releases[no - 1] = release
    end

    sig {params(no: Integer).returns(Release)}
    def release(no)
      @releases[no - 1] or raise ReleaseNotFound
    end

    sig {returns(T::Boolean)}
    def can_remove_release?
      @releases.size > 1
    end

    sig {params(item: Release::Item).returns(Integer)}
    def find_release_no_by_item(item)
      T.must(@releases.find_index { |release| release.include?(item) }) + 1
    end
  end
end
