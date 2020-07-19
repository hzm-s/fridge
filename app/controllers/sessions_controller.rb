# typed: ignore
class SessionsController < ApplicationController
  before_action :require_guest, only: [:new]
  before_action :require_user, only: [:destroy]

  def destroy
    reset_session
    flush_current_user
  end
end
