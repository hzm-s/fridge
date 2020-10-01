# typed: strict
require 'sorbet-runtime'

module Order
  class Order
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id).returns(T.attached_class)}
      def create(product_id)
        new(product_id, IssueList.new([]))
      end
    end

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(IssueList)}
    attr_reader :issues

    sig {params(product_id: Product::Id, issues: IssueList).void}
    def initialize(product_id, issues)
      @product_id = product_id
      @issues = issues
    end

    sig {params(issue_id: Issue::Id).void}
    def append_issue(issue_id)
      @issues = @issues.append(issue_id)
    end

    sig {params(issue_id: Issue::Id).void}
    def remove_issue(issue_id)
      @issues = @issues.remove(issue_id)
    end

    sig {params(from: Issue::Id, to: Issue::Id).void}
    def swap_issues(from, to)
      @issues = @issues.swap(from, to)
    end
  end
end
