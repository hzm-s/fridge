# typed: true
class ApplicationController < ActionController::Base
  helper_method :current_user

  protected

  def flash_success(key)
    { success: I18n.t(key, scope: 'feedbacks') }
  end

  def current_user
    @__current_user ||= fetch_current_user
  end

  private

  def fetch_current_user
    return nil unless user_id = session[:user_id]
    UserRepository::AR.find_by_id(user_id)
  end
end
