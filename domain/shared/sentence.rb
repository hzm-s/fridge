# typed: strict
require 'sorbet-runtime'

module Shared
  class Sentence
    extend T::Sig

    sig {params(content: String).void}
    def initialize(content)
      validate_content(content)

      @content = content
    end

    sig {returns(String)}
    def to_s
      @content
    end

    private

    sig {params(content: String).void}
    def validate_content(content)
      raise 'not implemented'
    end
  end
end
