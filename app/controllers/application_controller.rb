# typed: ignore
class ApplicationController < ActionController::Base
  include I18nHelper
  include SessionHelper

  helper_method :current_user, :signed_in?, :current_product

  def current_product
    nil
  end

  protected

  def flash_success(key)
    { success: feedback_message(key) }
  end

  def flash_error(key)
    { error: feedback_message(key) }
  end

  def feedback_message(key)
    I18n.t(key, scope: 'feedbacks')
  end

  private

  def require_user
    unless signed_in?
      redirect_to sign_in_path, flash: flash_success('require_sign_in')
    end
  end

  def require_guest
    if signed_in?
      redirect_to root_path, flash: flash_success('already_signed_in')
    end
  end
end
