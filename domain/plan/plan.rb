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

    sig {params(roles: Team::RoleSet, description: T.nilable(String)).void}
    def append_release(roles, description = nil)
      raise PermissionDenied unless roles.can_update_release_plan?

      @releases << Release.create(next_release_number, description)
    end

    sig {params(roles: Team::RoleSet, release: Release).void}
    def update_release(roles, release)
      raise PermissionDenied unless roles.can_update_release_plan?

      index = T.must(@releases.find_index { |r| r.number == release.number })
      @releases[index] = release
    end

    sig {params(roles: Team::RoleSet, release_number: Integer).void}
    def remove_release(roles, release_number)
      raise PermissionDenied unless roles.can_update_release_plan?
      raise NeedAtLeastOneRelease unless can_remove_release?

      release = release_of(release_number)
      raise ReleaseIsNotEmpty unless release.can_remove?

      @releases.delete_if { |r| r.number == release.number }
    end

    sig {params(release_number: Integer).returns(Release)}
    def release_of(release_number)
      release = @releases.find { |r| r.number == release_number }
      raise ReleaseNotFound unless release

      release.dup
    end

    sig {params(issue: Issue::Id).returns(Release)}
    def release_by_issue(issue)
      release = @releases.find { |r| r.planned?(issue) }
      raise ReleaseNotFound unless release

      release.dup
    end

    sig {returns(Release)}
    def recent_release
      T.must(@releases.min)
    end

    sig {returns(T::Boolean)}
    def can_remove_release?
      @releases.size > 1
    end

    private

    sig {returns(Integer)}
    def next_release_number
      T.must(@releases.max).number + 1
    end
  end
end
