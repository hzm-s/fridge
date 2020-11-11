# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    sig {returns(String)}
    attr_reader :name

    sig {returns(T::Array[Issue::Id])}
    attr_reader :issues

    sig {params(name: String, issues: T::Array[Issue::Id]).void}
    def initialize(name, issues)
      @name = name
      @issues = issues
    end

    sig {params(other: Release).returns(T::Boolean)}
    def ==(other)
      self.name == other.name &&
        self.issues == other.issues
    end
  end
end
