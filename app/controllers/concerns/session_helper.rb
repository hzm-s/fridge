# typed: false
module SessionHelper
  def sign_in(user_id)
    reset_session
    session[:user_id] = user_id
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
    return nil unless user_id = session[:user_id]
    UserRepository::AR.find_by_id(User::Id.from_string(user_id))
  end

  def flush_current_user
    @__current_user = nil
  end
end
