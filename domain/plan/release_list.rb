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
    def add(release)
      raise DuplicatedIssue if have_same_issue?(release.issues)

      self.class.new(@releases + [release])
    end

    sig {params(name: String).returns(T.self_type)}
    def remove(name)
      raise ReleaseIsNotEmpty unless get(name).empty?

      self.class.new(@releases.delete_if { |r| r.name == name })
    end

    sig {params(name: String).returns(Release)}
    def get(name)
      @releases.find { |r| r.name == name }
    end

    sig {params(issues: IssueList).returns(T::Boolean)}
    def have_same_issue?(issues)
      @releases.any? { |r| r.have_same_issue?(issues) }
    end

    sig {returns(T::Array[Release])}
    def to_a
      @releases
    end

    sig {params(other: ReleaseList).returns(T::Boolean)}
    def ==(other)
      self.to_a == other.to_a
    end
  end
end
