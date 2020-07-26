# typed: false
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
          extract_initials(email).upcase
        )
      end

      sig {params(id: Id, email: String, name: String, initials: String).returns(T.attached_class)}
      def from_repository(id, email, name, initials)
        new(id, email, name, initials)
      end

      private

      sig {params(email: String).returns(String)}
      def extract_initials(email)
        account = email.split('@').first
        raise ArgumentError unless account && account.size > 0

        return account[0, 2] if account.size >= 2
        T.must(account[0]) * 2
      end
    end

    sig {returns(Id)}
    attr_reader :id

    sig {returns(String)}
    attr_reader :email

    sig {returns(String)}
    attr_reader :name

    sig {returns(String)}
    attr_reader :initials

    sig {params(id: Id, email: String, name: String, initials: String).void}
    def initialize(id, email, name, initials)
      @id = id
      @email = email
      @name = name
      @initials = initials
    end
    private_class_method :new
  end
end
