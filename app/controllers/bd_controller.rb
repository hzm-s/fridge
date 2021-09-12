# typed: ignore
class BdController < ApplicationController
  before_action :require_guest
  
  def index
    @accounts = App::UserAccount.all
  end

  def create
    sign_in(params[:ua_id])
    redirect_to root_path
  end
end
