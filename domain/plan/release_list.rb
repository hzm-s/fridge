# typed: strict
require 'sorbet-runtime'

module Plan
  class ReleaseList
    extend T::Sig

    sig {params(releases: T::Array[Release]).void}
    def initialize(releases = [])
      @releases = releases
    end

    sig {params(release: Release).returns(T.self_type)}
    def append(release)
      raise DuplicatedIssue if have_same_issue?(release.issues)

      self.class.new(@releases + [release])
    end

    sig {params(name: String).returns(T.self_type)}
    def remove(name)
      raise ReleaseIsNotEmpty unless get(name).empty?

      self.class.new(@releases.select { |r| r.name != name })
    end

    sig {params(name: String, from: Issue::Id, to: Issue::Id).returns(T.self_type)}
    def change_issue_priority(name, from, to)
      swapped = get(name).change_issue_priority(from, to)
      update(swapped)
    end

    sig {params(issue: Issue::Id, from: String, to: String).returns(T.self_type)}
    def reschedule_issue(issue, from, to)
      new_from = get(from).remove_issue(issue)
      new_to = get(to).append_issue(issue)

      update(new_from).update(new_to)
    end

    sig {params(release: Release).returns(T.self_type)}
    def update(release)
      index = @releases.find_index { |r| r.name == release.name }
      new_releases = @releases.dup.tap { |list| list[index] = Release.new(release.name) }
      raise DuplicatedIssue if have_same_issue_in_releases?(new_releases, release.issues)

      self.class.new(new_releases.tap { |list| list[index] = release })
    end

    sig {params(name: String).returns(Release)}
    def get(name)
      T.must(to_a.find { |r| r.name == name }).dup
    end

    sig {params(issue_id: Issue::Id).returns(T.self_type)}
    def remove_issue(issue_id)
      release = to_a.find { |r| r.include?(issue_id) }
      return self unless release

      update(release.remove_issue(issue_id))
    end

    sig {params(issues: IssueList).returns(T::Boolean)}
    def have_same_issue?(issues)
      have_same_issue_in_releases?(@releases, issues)
    end

    sig {returns(T::Array[Release])}
    def to_a
      @releases.dup
    end

    sig {params(other: ReleaseList).returns(T::Boolean)}
    def ==(other)
      self.to_a == other.to_a
    end

    private

    sig {params(releases: T::Array[Release], issues: IssueList).returns(T::Boolean)}
    def have_same_issue_in_releases?(releases, issues)
      releases.any? { |r| r.have_same_issue?(issues) }
    end
  end
end
