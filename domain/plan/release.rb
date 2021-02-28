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

    sig {params(issue: Issue::Id).returns(T.self_type)}
    def append_issue(issue)
      self.class.new(@name, @issues.append(issue))
    end

    sig {params(issue: Issue::Id).returns(T.self_type)}
    def remove_issue(issue)
      self.class.new(@name, @issues.remove(issue))
    end

    sig {params(from: Issue::Id, to: Issue::Id).returns(T.self_type)}
    def change_issue_priority(from, to)
      self.class.new(@name, @issues.swap(from, to))
    end

    sig {params(name: String).returns(T.self_type)}
    def change_name(name)
      self.class.new(name, @issues)
    end

    sig {params(issue_id: Issue::Id).returns(T::Boolean)}
    def include?(issue_id)
      @issues.include?(issue_id)
    end

    sig {params(issues: IssueList).returns(T::Boolean)}
    def have_same_issue?(issues)
      self.issues.have_same_issue?(issues)
    end

    sig {returns(T::Boolean)}
    def can_remove?
      @issues.empty?
    end

    sig {params(other: Release).returns(T::Boolean)}
    def ==(other)
      self.name == other.name &&
        self.issues == other.issues
    end
  end
end
