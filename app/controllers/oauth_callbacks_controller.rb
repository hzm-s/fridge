# typed: ignore
class OauthCallbacksController < ApplicationController
  before_action :require_guest

  def create
    result = RegisterOrFindPersonUsecase.perform(auth_hash.name, auth_hash.email, auth_hash.account)
    sign_in(result[:user_account_id])
    redirect(result[:is_register])
  end

  private

  def auth_hash
    @__auth_hash ||= OmniauthAuthHash.new(request.env['omniauth.auth'])
  end

  def redirect(is_register)
    message = is_register ? :signed_up : :signed_in
    redirect_to redirect_path, flash: flash_success(message)
  end

  def redirect_path
    return root_path unless session[:referer]
    session.delete(:referer)
  end
end
