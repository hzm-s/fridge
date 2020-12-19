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

      sig {params(product_id: Product::Id, scoped: ReleaseList, pending: IssueList).returns(T.attached_class)}
      def from_repository(product_id, scoped, pending)
        new(product_id, scoped, pending)
      end
    end

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(ReleaseList)}
    attr_reader :scoped

    sig {returns(IssueList)}
    attr_reader :pending

    sig {params(product_id: Product::Id, scoped: ReleaseList, pending: IssueList).void}
    def initialize(product_id, scoped, pending)
      @product_id = product_id
      @scoped = scoped
      @pending = pending
    end

    sig {params(issue_id: Issue::Id).void}
    def remove_issue(issue_id)
      if @pending.include?(issue_id)
        update_pending(pending.remove(issue_id))
      else
        update_scoped(scoped.remove_issue(issue_id))
      end
    end

    sig {params(scoped: ReleaseList).void}
    def update_scoped(scoped)
      raise DuplicatedIssue if scoped.have_same_issue?(@pending)

      @scoped = scoped
    end

    sig {params(pending: IssueList).void}
    def update_pending(pending)
      raise DuplicatedIssue if @scoped.have_same_issue?(pending)

      @pending = pending
    end
  end
end
