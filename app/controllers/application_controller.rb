# typed: false
class ApplicationController < ActionController::Base
  include SessionHelper

  helper_method :current_user, :signed_in?

  protected

  def flash_success(key)
    { success: I18n.t(key, scope: 'feedbacks') }
  end

  private

  def require_user
    unless signed_in?
      redirect_to root_path, flash: flash_success('require_sign_in')
    end
  end

  def require_guest
    if signed_in?
      redirect_to root_path, flash: flash_success('already_signed_in')
    end
  end
end
