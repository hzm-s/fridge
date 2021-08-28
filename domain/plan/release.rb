# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(number: Integer, title: T.nilable(String)).returns(T.attached_class)}
      def create(number, title = nil)
        title ||= "Release##{number}"
        new(number, title, Issue::List.new)
      end

      sig {params(number: Integer, title: T.nilable(String), issues: Issue::List).returns(T.attached_class)}
      def from_repository(number, title, issues)
        new(number, title, issues)
      end
    end

    sig {returns(Integer)}
    attr_reader :number

    sig {returns(T.nilable(String))}
    attr_reader :title

    sig {returns(Issue::List)}
    attr_reader :issues

    sig {params(number: Integer, title: T.nilable(String), issues: Issue::List).void}
    def initialize(number, title, issues)
      @number= number
      @title = title
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
    def change_issue_priority(from, to)
      @issues = @issues.swap(from, to)
    end

    sig {params(title: T.nilable(String)).void}
    def modify_title(title)
      @title = title
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
