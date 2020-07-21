# typed: strict
require 'sorbet-runtime'

module User
  module UserRepository
    extend T::Sig
    extend T::Helpers
    interface!

    sig {abstract.params(id: Id).returns(User)}
    def find_by_id(id); end

    sig {abstract.params(user: User).void}
    def add(user); end
  end
end
