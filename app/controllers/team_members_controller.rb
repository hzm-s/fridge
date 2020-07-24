class TeamMembersController < ApplicationController
  include ProductHelper

  def index
    @invitation = App::TeamMemberInvitation.create_for_product(current_product_id)
  end

  def create
    user_id = User::Id.from_string(permitted_params[:user_id])
    role = Team::Role.from_string(permitted_params[:role])
    product_id = Product::Id.from_string(current_product_id)
    AddTeamMemberUsecase.perform(product_id, user_id, role)
  end

  private

  def permitted_params
    params.require(:form).permit(:user_id, :role)
  end

  def current_product_id
    params[:product_id]
  end
end
