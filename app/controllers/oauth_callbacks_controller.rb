# typed: ignore
class OauthCallbacksController < ApplicationController

  def create
    result = RegisterUserUsecase.perform(auth_hash.name, auth_hash.email, auth_hash.account)

    if result[:is_registered]
      redirect_to root_path, flash: flash_success('signed_up')
    else
      redirect_to root_path
    end
  end

  private

  def auth_hash
    @__auth_hash ||= OmniauthAuthHash.new(request.env['omniauth.auth'])
  end
end
