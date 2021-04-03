# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(number: Integer, description: T.nilable(String)).returns(T.attached_class)}
      def create(number, description = nil)
        new(number, description, IssueList.new)
      end

      sig {params(number: Integer, description: T.nilable(String), issues: IssueList).returns(T.attached_class)}
      def from_repository(number, description, issues)
        new(number, description, issues)
      end
    end

    sig {returns(Integer)}
    attr_reader :number

    sig {returns(T.nilable(String))}
    attr_reader :description

    sig {returns(IssueList)}
    attr_reader :issues

    sig {params(number: Integer, description: T.nilable(String), issues: IssueList).void}
    def initialize(number, description, issues)
      @number= number
      @description = description
      @issues = issues
    end

    sig {params(issue: Issue::Id).void}
    def plan_issue(issue)
      raise DuplicatedIssue if @issues.include?(issue)

      @issues = @issues.append(issue)
    end

    sig {params(issue: Issue::Id).void}
    def drop_issue(issue)
      @issues = @issues.remove(issue)
    end

    sig {params(from: Issue::Id, to: Issue::Id).void}
    def sort_issue_priority(from, to)
      @issues = @issues.swap(from, to)
    end

    sig {params(description: T.nilable(String)).void}
    def modify_description(description)
      @description = description
    end

    sig {returns(T::Boolean)}
    def can_remove?
      @issues.empty?
    end

    sig {params(issue: Issue::Id).returns(T::Boolean)}
    def planned?(issue)
      @issues.include?(issue)
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
