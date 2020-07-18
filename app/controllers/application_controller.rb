# typed: true
class ApplicationController < ActionController::Base
  def flash_success(key)
    { success: I18n.t(key, scope: 'feedbacks') }
  end
end
