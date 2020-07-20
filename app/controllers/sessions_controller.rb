# typed: ignore
class SessionsController < ApplicationController
  before_action :require_guest, only: [:new]
  before_action :require_user, only: [:destroy]

  def destroy
    sign_out
    redirect_to sign_in_path, flash: flash_success('signed_out')
  end
end
