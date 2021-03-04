# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(number: Integer).returns(T.attached_class)}
      def create(number)
        new(number, IssueList.new)
      end
    end

    sig {returns(Integer)}
    attr_reader :number

    sig {returns(IssueList)}
    attr_reader :issues

    sig {params(number: Integer, issues: IssueList).void}
    def initialize(number, issues)
      @number= number
      @issues = issues
    end

    sig {params(issue: Issue::Id).void}
    def append_issue(issue)
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

    sig {params(other: Release).returns(T::Boolean)}
    def ==(other)
      self.number == other.number
    end
  end
end
