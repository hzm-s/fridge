# typed: ignore
class OauthCallbacksController < ApplicationController
  before_action :require_guest

  def create
    result = RegisterOrFindUserUsecase.perform(auth_hash.name, auth_hash.email, auth_hash.account)
    sign_in(result[:user_id])
    redirect(result[:is_register])
  end

  private

  def sign_in(user_id)
    reset_session
    session[:user_id] = user_id
  end

  def auth_hash
    @__auth_hash ||= OmniauthAuthHash.new(request.env['omniauth.auth'])
  end

  def redirect(is_register)
    message = is_register ? 'signed_up' : 'signed_in'
    redirect_to root_path, flash: flash_success(message)
  end
end
