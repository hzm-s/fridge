# typed: strict
require 'sorbet-runtime'

module Plan
  class Release
    extend T::Sig

    sig {returns(T::Array[Issue::Id])}
    attr_reader :issues

    sig {params(id: T.nilable(String), issues: T::Array[Issue::Id]).void}
    def initialize(id, issues)
      @id = id
      @issues = issues
    end

    sig {params(other: Release).returns(T::Boolean)}
    def ==(other)
      self.to_h == other.to_h
    end

    protected

    sig {returns(T::Hash[T.nilable(String), T::Array[Issue::Id]])}
    def to_h
      { @id => @issues }
    end
  end
end
