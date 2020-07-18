# typed: strict
require 'sorbet-runtime'

class RegisterUserUsecase < UsecaseBase
  extend T::Sig

  sig {void}
  def initialize
    @repository = T.let(UserRepository::AR, User::UserRepository)
  end

  sig {params(name: String, initials: String).returns(String)}
  def perform(name, initials)
    user = User::User.create(name, initials)
    @repository.add(user)
    user.id
  end
end
