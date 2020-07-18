# typed: ignore
module UserSupport
  def sign_up_with_auth_auth(auth_hash)
    register_user(
      auth_hash['info']['name'],
      auth_hash['info']['email'],
      { provider: auth_hash['provider'], uid: auth_hash['uid'] }
    )
  end

  def register_user(name, email, oauth_account)
    RegisterUserUsecase.perform(name, email, oauth_account)
      .yield_self { |r| r[:user_id] }
      .yield_self { |user_id| UserRepository::AR.find_by_id(user_id) }
  end
end

RSpec.configure do |c|
  c.include UserSupport
end
