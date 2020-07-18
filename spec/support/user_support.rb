module UserSupport
  def sign_up_with_auth_auth(auth_hash)
    RegisterUserUsecase.perform(
      auth_hash['info']['name'],
      auth_hash['info']['email'],
      {
        provider: auth_hash['provider'],
        uid: auth_hash['uid'],
      }
    )
  end
end

RSpec.configure do |c|
  c.include UserSupport
end
