# typed: strict
require 'sorbet-runtime'

module Plan
  class Plan
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id).returns(T.attached_class)}
      def create(product_id)
        new(product_id, ReleaseList.new)
      end

      sig {params(product_id: Product::Id, scheduled: ReleaseList).returns(T.attached_class)}
      def from_repository(product_id, scheduled)
        new(product_id, scheduled)
      end
    end

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(ReleaseList)}
    attr_reader :scheduled

    sig {params(product_id: Product::Id, scheduled: ReleaseList).void}
    def initialize(product_id, scheduled)
      @product_id = product_id
      @scheduled = scheduled
    end

    sig {params(roles: Team::RoleSet, issue_id: Issue::Id).void}
    def remove_issue(roles, issue_id)
      update_scheduled(roles, scheduled.remove_issue(issue_id))
    end

    sig {params(roles: Team::RoleSet, scheduled: ReleaseList).void}
    def update_scheduled(roles, scheduled)
      raise PermissionDenied unless roles.can_update_release_plan?

      @scheduled = scheduled
    end
  end
end
