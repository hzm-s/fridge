# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    sig {returns(String)}
    attr_reader :name

    sig {returns(IssueList)}
    attr_reader :issues

    sig {params(name: String, issues: IssueList).void}
    def initialize(name, issues)
      @name = name
      @issues = issues
    end

    sig {params(issue: Issue::Id).returns(T.self_type)}
    def append_issue(issue)
      self.class.new(@name, @issues.append(issue))
    end

    sig {params(issue: Issue::Id).returns(T.self_type)}
    def remove_issue(issue)
      self.class.new(@name, @issues.remove(issue))
    end

    sig {params(from: Issue::Id, to: Issue::Id).returns(T.self_type)}
    def swap_issues(from, to)
      self.class.new(@name, @issues.swap(from, to))
    end

    sig {params(other: Release).returns(T::Boolean)}
    def ==(other)
      self.name == other.name &&
        self.issues == other.issues
    end
  end
end
