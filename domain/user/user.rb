# typed: strict
require 'sorbet-runtime'

module User
  class User
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(name: String, initials: String).returns(T.attached_class)}
      def create(name, initials)
        new(
          SecureRandom.uuid,
          name,
          Avatar.create(initials)
        )
      end

      sig {params(id: String, name: String, avatar: Avatar).returns(T.attached_class)}
      def from_repository(id, name, avatar)
        new(id, name, avatar)
      end
    end

    sig {returns(String)}
    attr_reader :id

    sig {returns(String)}
    attr_reader :name

    sig {returns(Avatar)}
    attr_reader :avatar

    sig {params(id: String, name: String, avatar: Avatar).void}
    def initialize(id, name, avatar)
      @id = id
      @name = name
      @avatar = avatar
    end
    private_class_method :new
  end
end
