# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    sig {returns(String)}
    attr_reader :id

    sig {returns(T::Array[Issue::Id])}
    attr_reader :issues

    sig {params(id: String, issues: T::Array[Issue::Id]).void}
    def initialize(id, issues)
      @id = id
      @issues = issues
    end

    sig {params(other: Release).returns(T::Boolean)}
    def ==(other)
      self.id == other.id &&
        self.issues == other.issues
    end
  end
end
