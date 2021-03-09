# typed: strict
require 'sorbet-runtime'

module Release
  class Release
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(product_id: Product::Id, number: Integer).returns(T.attached_class)}
      def create(product_id, number)
        new(product_id, number, IssueList.new)
      end
    end

    sig {returns(Product::Id)}
    attr_reader :product_id

    sig {returns(Integer)}
    attr_reader :number

    sig {returns(IssueList)}
    attr_reader :issues

    sig {params(product_id: Product::Id, number: Integer, issues: IssueList).void}
    def initialize(product_id, number, issues)
      @product_id = product_id
      @number= number
      @issues = issues
    end

    sig {params(issue: Issue::Id).void}
    def append_issue(issue)
      raise DuplicatedIssue if @issues.include?(issue)

      @issues = @issues.append(issue)
    end

    sig {params(issue: Issue::Id).void}
    def remove_issue(issue)
      @issues = @issues.remove(issue)
    end

    sig {params(from: Issue::Id, to: Issue::Id).void}
    def sort_issue_priority(from, to)
      @issues = @issues.swap(from, to)
    end

    sig {returns(T::Boolean)}
    def can_remove?
      @issues.empty?
    end

    sig {params(other: Release).returns(T::Boolean)}
    def ==(other)
      self.number == other.number
    end

    sig {params(other: Release).returns(Integer)}
    def <=>(other)
      self.number <=> other.number
    end
  end
end
