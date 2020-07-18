# typed: strict
require 'sorbet-runtime'

module User
  class Avatar
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(initials: String).returns(T.attached_class)}
      def create(initials)
        new(initials, '#ccc', '#555')
      end

      sig {params(initials: String, bg: String, fg: String).returns(T.attached_class)}
      def from_repository(initials, bg, fg)
        new(initials, bg, fg)
      end
    end

    sig {returns(String)}
    attr_reader :initials

    sig {returns(String)}
    attr_reader :bg

    sig {returns(String)}
    attr_reader :fg

    sig {params(initials: String, bg: String, fg: String).void}
    def initialize(initials, bg, fg)
      @initials = initials
      @bg = bg
      @fg = fg
    end
    private_class_method :new
  end
end
