# typed: strict
require 'sorbet-runtime'

module Plan
  class Plan
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id).returns(T.attached_class)}
      def create(product_id)
        new(product_id, [Release.create(1)])
      end

      sig {params(product_id: Product::Id, scheduled: ReleaseList).returns(T.attached_class)}
      def from_repository(product_id, scheduled)
        new(product_id, scheduled)
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

    sig {params(release_number: Integer).returns(Release)}
    def release(release_number)
      @releases.find { |r| r.number == release_number }
    end

    sig {params(issue_id: Issue::Id).void}
    def append_issue(issue_id)
    end
  end
end
