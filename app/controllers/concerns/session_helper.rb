# typed: false
module SessionHelper
  def sign_in(user_account_id)
    referer = session[:referer]
    reset_session

    session[:user_account_id] = user_account_id
    session[:referer] = referer if referer
  end

  def sign_out
    reset_session
    flush_current_user
  end

  def signed_in?
    !!current_user
  end

  def current_user
    @__current_user ||= fetch_current_user
  end

  private

  def fetch_current_user
    return nil unless user_account_id = session[:user_account_id]
    UserQuery.call(user_account_id)
  end

  def flush_current_user
    @__current_user = nil
  end
end
