# typed: strict
require 'sorbet-runtime'

module Plan
  class Plan
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id).returns(T.attached_class)}
      def create(product_id)
        new(product_id, ReleaseList.new, IssueList.new)
      end

      sig {params(product_id: Product::Id, scheduled: ReleaseList, pending: IssueList).returns(T.attached_class)}
      def from_repository(product_id, scheduled, pending)
        new(product_id, scheduled, pending)
      end
    end

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(ReleaseList)}
    attr_reader :scheduled

    sig {returns(IssueList)}
    attr_reader :pending

    sig {params(product_id: Product::Id, scheduled: ReleaseList, pending: IssueList).void}
    def initialize(product_id, scheduled, pending)
      @product_id = product_id
      @scheduled = scheduled
      @pending = pending
    end

    sig {params(roles: Team::RoleSet, issue_id: Issue::Id).void}
    def remove_issue(roles, issue_id)
      if @pending.include?(issue_id)
        update_pending(pending.remove(issue_id))
      else
        update_scheduled(roles, scheduled.remove_issue(issue_id))
      end
    end

    sig {params(roles: Team::RoleSet, scheduled: ReleaseList).void}
    def update_scheduled(roles, scheduled)
      raise PermissionDenied unless roles.can_change_issue_priority?
      raise DuplicatedIssue if scheduled.have_same_issue?(@pending)

      @scheduled = scheduled
    end

    sig {params(pending: IssueList).void}
    def update_pending(pending)
      raise DuplicatedIssue if @scheduled.have_same_issue?(pending)

      @pending = pending
    end
  end
end
