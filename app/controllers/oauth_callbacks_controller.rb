# typed: ignore
class OauthCallbacksController < ApplicationController
  before_action :require_guest

  def create
    result = RegisterOrFindUserUsecase.perform(auth_hash.name, auth_hash.email, auth_hash.account)

    sign_in(result[:user_id])

    if result[:is_register]
      redirect_to root_path, flash: flash_success('signed_up')
    else
      redirect_to root_path, flash: flash_success('signed_in')
    end
  end

  private

  def sign_in(user_id)
    reset_session
    session[:user_id] = user_id
  end

  def auth_hash
    @__auth_hash ||= OmniauthAuthHash.new(request.env['omniauth.auth'])
  end
end
