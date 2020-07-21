# typed: strict
require 'sorbet-runtime'

module User
  class User
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(name: String, email: String).returns(T.attached_class)}
      def create(name, email)
        new(
          Id.create,
          email,
          name,
          Avatar.create(email)
        )
      end

      sig {params(id: Id, email: String, name: String, avatar: Avatar).returns(T.attached_class)}
      def from_repository(id, email, name, avatar)
        new(id, email, name, avatar)
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(String)}
    attr_reader :email

    sig {returns(String)}
    attr_reader :name

    sig {returns(Avatar)}
    attr_reader :avatar

    sig {params(id: Id, email: String, name: String, avatar: Avatar).void}
    def initialize(id, email, name, avatar)
      @id = id
      @email = email
      @name = name
      @avatar = avatar
    end
    private_class_method :new
  end
end
