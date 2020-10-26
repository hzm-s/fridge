# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    sig {returns(String)}
    attr_reader :title

    sig {returns(T::Array[Issue::Id])}
    attr_reader :issues

    sig {params(title: String, issues: T::Array[Issue::Id]).void}
    def initialize(title, issues)
      @title = title
      @issues = issues
    end

    sig {params(other: Release).returns(T::Boolean)}
    def ==(other)
      self.title == other.title &&
        self.issues == other.issues
    end
  end
end
